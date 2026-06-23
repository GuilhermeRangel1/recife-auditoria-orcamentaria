# Insights e Linhas de Auditoria

Este documento complementa o dashboard e os scripts SQL com uma leitura analitica dos principais pontos observados no projeto.

## 1. Execucao Orcamentaria

A comparacao entre dotacao inicial, dotacao atualizada, empenhado, liquidado e pago permite avaliar se o planejamento orcamentario esta se transformando em execucao real.

Pontos de atencao:

- Orgaos com dotacao atualizada alta e baixo percentual pago podem indicar atraso, replanejamento ou dificuldade operacional.
- Diferencas grandes entre empenhado e pago mostram compromissos assumidos que ainda nao chegaram ao pagamento.
- Variacoes relevantes entre dotacao inicial e atualizada podem indicar remanejamentos importantes.

## 2. Concentracao de Credores

O ranking de credores permite identificar empresas, consorcios ou pessoas fisicas que concentram pagamentos relevantes.

Pontos de atencao:

- Alta concentracao em poucos credores nao significa irregularidade automaticamente, mas merece analise contextual.
- Credores com pagamentos relevantes em um unico orgao podem indicar contratos de grande porte.
- Credores recorrentes em varios anos podem ser analisados quanto a continuidade dos pagamentos.

## 3. Analise por Orgao

A leitura por orgao setorial ajuda a entender quais areas administrativas concentram maior volume financeiro.

Pontos de atencao:

- Orgaos essenciais tendem a concentrar recursos, mas valores inesperados podem justificar detalhamento.
- Baixa execucao em orgaos com dotacao expressiva pode sinalizar gargalos de execucao.
- Comparar os anos de 2024, 2025 e 2026 ajuda a observar mudancas de prioridade.

## 4. Analise Funcional

A classificacao funcional mostra a distribuicao dos gastos por area de politica publica, como saude, educacao, urbanismo, assistencia social e administracao.

Pontos de atencao:

- Funcoes com grande dotacao e baixo pagamento podem indicar programas ainda pouco executados.
- Mudancas bruscas entre anos podem refletir novas prioridades ou alteracoes de programas.
- A analise por subfuncao, programa e acao permite detalhar melhor cada area.

## 5. Qualidade dos Dados

O script `05_data_quality_checks.sql` adiciona uma camada de verificacao antes da interpretacao dos resultados.

Ele ajuda a identificar:

- anos fora do periodo esperado;
- meses invalidos;
- registros sem credor informado;
- classificacoes incompletas;
- valores negativos agregados;
- possiveis problemas de carga dos CSVs.

## 6. Machine Learning para Auditoria

O script `ml_anomaly_detection.py` gera uma pontuacao de anomalia para cada combinacao de ano, orgao e credor. A ideia e priorizar casos que merecem revisao, especialmente quando ha valores muito altos, concentracao relevante, recorrencia mensal ou saldo empenhado ainda nao pago.

O resultado fica em `data/ml_audit_flags.csv` e pode ser importado no Power BI.

Pontos de atencao:

- Um score alto nao significa irregularidade.
- O modelo ajuda a ordenar prioridades de analise.
- A interpretacao deve ser cruzada com contratos, licitacoes e documentos oficiais.
- Quando `scikit-learn` estiver instalado, o script usa Isolation Forest; caso contrario, usa uma pontuacao estatistica robusta como alternativa.

## 7. Limitacoes

Os resultados devem ser interpretados como sinais analiticos. Para concluir irregularidade, seria necessario cruzar os achados com contratos, licitacoes, notas de empenho, documentos fiscais e justificativas administrativas.

Tambem existem limitacoes tecnicas:

- o ano de 2026 pode estar incompleto;
- os arquivos dependem da atualizacao do portal;
- campos textuais podem variar conforme encoding e formato original dos CSVs;
- datas vazias ou campos representados de forma incomum precisam ser avaliados com cautela.
- anomalias estatisticas podem representar situacoes normais, como grandes contratos, bancos ou despesas centralizadas.

## 8. Possiveis Evolucoes

- Comparar variacoes percentuais entre anos.
- Cruzar despesas com dados de contratos e licitacoes.
- Criar indicadores de recorrencia de credores.
- Separar pagamentos por modalidade de licitacao e orgao.
- Automatizar uma rotina de carga e validacao dos dados.
- Exibir o score de anomalia em uma pagina dedicada no Power BI.
