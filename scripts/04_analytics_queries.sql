USE recife_auditoria;

-- 1. Analise de eficiencia orcamentaria por ano
-- Objetivo: descobrir quanto do orcamento atualizado foi empenhado, liquidado e pago.
SELECT
    ano,
    SUM(dotacao_inicial) AS total_dotacao_inicial,
    SUM(dotacao_atualizada) AS total_dotacao_atualizada,
    SUM(empenhado) AS total_empenhado,
    SUM(liquidado) AS total_liquidado,
    SUM(pago) AS total_pago,
    ROUND((SUM(empenhado) / NULLIF(SUM(dotacao_atualizada), 0)) * 100, 2) AS percentual_empenhado_vs_atualizado,
    ROUND((SUM(pago) / NULLIF(SUM(dotacao_atualizada), 0)) * 100, 2) AS percentual_pago_vs_atualizado
FROM v_despesas_orgao
GROUP BY ano
ORDER BY ano;


-- 2. Os 5 orgaos que mais recebem pagamento por ano
-- Objetivo: identificar para onde vai o maior volume de dinheiro publico da cidade.
(SELECT ano, orgao_setorial, SUM(pago) AS total_pago
 FROM v_despesas_orgao
 WHERE ano = 2024
 GROUP BY ano, orgao_setorial
 ORDER BY total_pago DESC
 LIMIT 5)
UNION ALL
(SELECT ano, orgao_setorial, SUM(pago) AS total_pago
 FROM v_despesas_orgao
 WHERE ano = 2025
 GROUP BY ano, orgao_setorial
 ORDER BY total_pago DESC
 LIMIT 5)
UNION ALL
(SELECT ano, orgao_setorial, SUM(pago) AS total_pago
 FROM v_despesas_orgao
 WHERE ano = 2026
 GROUP BY ano, orgao_setorial
 ORDER BY total_pago DESC
 LIMIT 5);


-- 3. Ranking de maiores emissoes de empenho por funcao
-- Objetivo: avaliar quais areas de governo receberam o maior investimento no periodo.
SELECT
    funcao,
    SUM(empenhado) AS total_empenhado,
    SUM(liquidado) AS total_liquidado,
    SUM(pago) AS total_pago
FROM v_despesas_funcional
GROUP BY funcao
ORDER BY total_empenhado DESC
LIMIT 10;


-- 4. Investigacao de maiores credores da prefeitura
-- Objetivo: identificar quais prestadores de servico concentram os maiores pagamentos.
SELECT
    nome_credor,
    cpf_cnpj,
    SUM(pagamento) AS total_recebido_pago
FROM v_fato_credor_empenho
GROUP BY nome_credor, cpf_cnpj
ORDER BY total_recebido_pago DESC
LIMIT 10;


-- 5. Concentracao de pagamentos por credor
-- Objetivo: medir quanto cada credor representa no total pago pela prefeitura.
SELECT
    nome_credor,
    cpf_cnpj,
    SUM(pagamento) AS total_pago_credor,
    ROUND(
        (SUM(pagamento) / NULLIF((SELECT SUM(pagamento) FROM v_fato_credor_empenho), 0)) * 100,
        2
    ) AS percentual_sobre_total
FROM v_fato_credor_empenho
GROUP BY nome_credor, cpf_cnpj
HAVING total_pago_credor > 0
ORDER BY total_pago_credor DESC
LIMIT 20;


-- 6. Orgaos com baixa execucao de pagamento
-- Objetivo: localizar orgaos com dotacao relevante e baixo percentual de pagamento.
SELECT
    ano,
    orgao_setorial,
    SUM(dotacao_atualizada) AS dotacao_atualizada,
    SUM(pago) AS total_pago,
    ROUND((SUM(pago) / NULLIF(SUM(dotacao_atualizada), 0)) * 100, 2) AS percentual_pago
FROM v_despesas_orgao
GROUP BY ano, orgao_setorial
HAVING dotacao_atualizada > 0
   AND percentual_pago < 30
ORDER BY ano, dotacao_atualizada DESC;


-- 7. Diferenca entre empenhado e pago por orgao
-- Objetivo: localizar compromissos assumidos que ainda nao viraram pagamento.
SELECT
    ano,
    orgao_setorial,
    SUM(empenhado) AS total_empenhado,
    SUM(pago) AS total_pago,
    SUM(empenhado) - SUM(pago) AS saldo_empenhado_nao_pago
FROM v_despesas_orgao
GROUP BY ano, orgao_setorial
HAVING saldo_empenhado_nao_pago > 0
ORDER BY saldo_empenhado_nao_pago DESC
LIMIT 20;


-- 8. Evolucao mensal dos pagamentos
-- Objetivo: detectar sazonalidade e picos de desembolso ao longo do periodo.
SELECT
    ano,
    mes,
    SUM(pagamento) AS total_pago
FROM v_fato_credor_empenho
GROUP BY ano, mes
ORDER BY ano, mes;
