from __future__ import annotations

import argparse
import math
from pathlib import Path

import pandas as pd


BASE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = BASE_DIR / "data"
OUTPUT_PATH = DATA_DIR / "ml_audit_flags.csv"


def parse_money(value: object) -> float:
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return 0.0

    text = str(value).strip().replace('"', "")
    if not text or text == "{}":
        return 0.0

    # Os arquivos atuais usam ponto como decimal
    # valores no formato brasileiro, caso a origem mude futuramente.
    if "," in text and "." in text:
        text = text.replace(".", "").replace(",", ".")
    elif "," in text:
        text = text.replace(",", ".")

    try:
        return float(text)
    except ValueError:
        return 0.0


def robust_zscore(series: pd.Series) -> pd.Series:
    median = series.median()
    mad = (series - median).abs().median()

    if mad == 0 or pd.isna(mad):
        std = series.std(ddof=0)
        if std == 0 or pd.isna(std):
            return pd.Series(0.0, index=series.index)
        return ((series - series.mean()) / std).abs()

    return (0.6745 * (series - median) / mad).abs()


def read_creditor_files(data_dir: Path) -> pd.DataFrame:
    files = sorted(data_dir.glob("credor_empenho_*.csv"))
    if not files:
        raise FileNotFoundError(f"Nenhum arquivo credor_empenho_*.csv encontrado em {data_dir}")

    frames: list[pd.DataFrame] = []
    for file_path in files:
        raw = pd.read_csv(
            file_path,
            sep=";",
            dtype=str,
            encoding="utf-8",
            engine="python",
        )

        # Selecao por posicao para nao depender de acentos nos cabecalhos.
        frame = pd.DataFrame(
            {
                "ano": raw.iloc[:, 0],
                "mes": raw.iloc[:, 1],
                "codigo_unidade": raw.iloc[:, 2],
                "unidade": raw.iloc[:, 3],
                "cpf_cnpj": raw.iloc[:, 4],
                "nome_credor": raw.iloc[:, 5],
                "tipo_licitacao": raw.iloc[:, 7],
                "orgao": raw.iloc[:, 14],
                "modalidade": raw.iloc[:, 17],
                "empenhado": raw.iloc[:, 18],
                "liquidacao": raw.iloc[:, 19],
                "pagamento": raw.iloc[:, 20],
                "anulacao_empenho": raw.iloc[:, 21],
                "anulacao_liquidacao": raw.iloc[:, 22],
                "anulacao_pagamento": raw.iloc[:, 23],
            }
        )
        frames.append(frame)

    data = pd.concat(frames, ignore_index=True)

    for column in ["ano", "mes"]:
        data[column] = pd.to_numeric(data[column], errors="coerce").fillna(0).astype(int)

    text_columns = [
        "codigo_unidade",
        "unidade",
        "cpf_cnpj",
        "nome_credor",
        "tipo_licitacao",
        "orgao",
        "modalidade",
    ]
    for column in text_columns:
        data[column] = data[column].fillna("").astype(str).str.strip()

    money_columns = [
        "empenhado",
        "liquidacao",
        "pagamento",
        "anulacao_empenho",
        "anulacao_liquidacao",
        "anulacao_pagamento",
    ]
    for column in money_columns:
        data[column] = data[column].map(parse_money)

    return data


def build_features(data: pd.DataFrame) -> pd.DataFrame:
    grouped = (
        data.groupby(["ano", "orgao", "cpf_cnpj", "nome_credor"], dropna=False)
        .agg(
            total_empenhado=("empenhado", "sum"),
            total_liquidado=("liquidacao", "sum"),
            total_pago=("pagamento", "sum"),
            anulacao_empenho=("anulacao_empenho", "sum"),
            anulacao_liquidacao=("anulacao_liquidacao", "sum"),
            anulacao_pagamento=("anulacao_pagamento", "sum"),
            quantidade_registros=("pagamento", "size"),
            meses_com_movimento=("mes", "nunique"),
            tipos_licitacao=("tipo_licitacao", "nunique"),
            modalidades=("modalidade", "nunique"),
        )
        .reset_index()
    )

    grouped["saldo_empenhado_nao_pago"] = grouped["total_empenhado"] - grouped["total_pago"]
    grouped["total_anulacoes"] = (
        grouped["anulacao_empenho"]
        + grouped["anulacao_liquidacao"]
        + grouped["anulacao_pagamento"]
    )
    grouped["percentual_pago_do_empenhado"] = (
        grouped["total_pago"] / grouped["total_empenhado"].replace(0, pd.NA)
    ).fillna(0)

    total_por_ano = grouped.groupby("ano")["total_pago"].transform("sum").replace(0, pd.NA)
    grouped["participacao_no_ano"] = (grouped["total_pago"] / total_por_ano).fillna(0)

    total_por_orgao = (
        grouped.groupby(["ano", "orgao"])["total_pago"].transform("sum").replace(0, pd.NA)
    )
    grouped["participacao_no_orgao"] = (grouped["total_pago"] / total_por_orgao).fillna(0)

    return grouped


def score_with_isolation_forest(features: pd.DataFrame) -> tuple[pd.Series, str]:
    try:
        from sklearn.ensemble import IsolationForest
        from sklearn.preprocessing import StandardScaler
    except ImportError:
        return score_with_robust_statistics(features), "robust_statistics"

    model_columns = [
        "total_empenhado",
        "total_liquidado",
        "total_pago",
        "total_anulacoes",
        "quantidade_registros",
        "meses_com_movimento",
        "tipos_licitacao",
        "modalidades",
        "saldo_empenhado_nao_pago",
        "percentual_pago_do_empenhado",
        "participacao_no_ano",
        "participacao_no_orgao",
    ]

    matrix = features[model_columns].fillna(0)
    scaled = StandardScaler().fit_transform(matrix)
    model = IsolationForest(n_estimators=200, contamination=0.05, random_state=42)
    model.fit(scaled)

    raw_score = -model.decision_function(scaled)
    score = pd.Series(raw_score, index=features.index)
    normalized = (score - score.min()) / (score.max() - score.min())
    return (normalized.fillna(0) * 100).round(2), "isolation_forest"


def score_with_robust_statistics(features: pd.DataFrame) -> pd.Series:
    score_parts = pd.DataFrame(index=features.index)
    score_parts["valor_pago"] = robust_zscore(features["total_pago"])
    score_parts["participacao_ano"] = robust_zscore(features["participacao_no_ano"])
    score_parts["participacao_orgao"] = robust_zscore(features["participacao_no_orgao"])
    score_parts["saldo_nao_pago"] = robust_zscore(features["saldo_empenhado_nao_pago"])
    score_parts["recorrencia"] = robust_zscore(features["meses_com_movimento"])
    score_parts["anulacoes"] = robust_zscore(features["total_anulacoes"])

    raw_score = score_parts.sum(axis=1)
    if raw_score.max() == raw_score.min():
        return pd.Series(0.0, index=features.index)

    normalized = (raw_score - raw_score.min()) / (raw_score.max() - raw_score.min())
    return (normalized * 100).round(2)


def classify_risk(score: float) -> str:
    if score >= 80:
        return "alto"
    if score >= 50:
        return "medio"
    return "baixo"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Gera flags de anomalia para auditoria orcamentaria."
    )
    parser.add_argument("--data-dir", type=Path, default=DATA_DIR)
    parser.add_argument("--output", type=Path, default=OUTPUT_PATH)
    args = parser.parse_args()

    data = read_creditor_files(args.data_dir)
    features = build_features(data)
    scores, method = score_with_isolation_forest(features)

    features["score_anomalia"] = scores
    features["risco_anomalia"] = features["score_anomalia"].map(classify_risk)
    features["metodo"] = method

    output_columns = [
        "ano",
        "orgao",
        "cpf_cnpj",
        "nome_credor",
        "total_empenhado",
        "total_liquidado",
        "total_pago",
        "total_anulacoes",
        "saldo_empenhado_nao_pago",
        "percentual_pago_do_empenhado",
        "participacao_no_ano",
        "participacao_no_orgao",
        "quantidade_registros",
        "meses_com_movimento",
        "tipos_licitacao",
        "modalidades",
        "score_anomalia",
        "risco_anomalia",
        "metodo",
    ]

    args.output.parent.mkdir(parents=True, exist_ok=True)
    result = features.sort_values("score_anomalia", ascending=False)[output_columns]
    result.to_csv(args.output, index=False, sep=";", encoding="utf-8-sig")

    print(f"Arquivo gerado: {args.output}")
    print(f"Metodo usado: {method}")
    print(f"Linhas analisadas: {len(data)}")
    print(f"Credores/orgaos pontuados: {len(result)}")
    print("Top 10 sinais de anomalia:")
    print(
        result[
            [
                "ano",
                "orgao",
                "nome_credor",
                "total_pago",
                "score_anomalia",
                "risco_anomalia",
            ]
        ]
        .head(10)
        .to_string(index=False)
    )


if __name__ == "__main__":
    main()
