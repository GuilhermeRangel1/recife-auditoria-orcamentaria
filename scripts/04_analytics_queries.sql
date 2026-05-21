USE recife_auditoria;

-- 1. Análise de eficiência orçamentária do ano
-- Objetivo: Descobrir quanto do orçamento atualizado foi realmente empenhado e pago
SELECT 
    ano,
    SUM(dotacao_inicial) AS total_dotacao_inicial,
    SUM(dotacao_atualizada) AS total_dotacao_atualizada,
    SUM(empenhado) AS total_empenhado,
    SUM(pago) AS total_pago,
    ROUND((SUM(empenhado) / SUM(dotacao_atualizada)) * 100, 2) AS percentual_empenhado_vs_atualizado
FROM v_despesas_orgao
GROUP BY ano
ORDER BY ano;


-- 2. Os 5 órgãos que mais recebem pagamento no ano
-- Objetivo: Identificar para onde está indo o maior volume de dinheiro público da cidade.
(SELECT ano, orgao_setorial, SUM(pago) AS total_pago FROM v_despesas_orgao WHERE ano = 2024 GROUP BY orgao_setorial ORDER BY total_pago DESC LIMIT 5)
UNION ALL
(SELECT ano, orgao_setorial, SUM(pago) AS total_pago FROM v_despesas_orgao WHERE ano = 2025 GROUP BY orgao_setorial ORDER BY total_pago DESC LIMIT 5)
UNION ALL
(SELECT ano, orgao_setorial, SUM(pago) AS total_pago FROM v_despesas_orgao WHERE ano = 2026 GROUP BY orgao_setorial ORDER BY total_pago DESC LIMIT 5);


-- 3. Ranking de maiores emissões de empenho por função (saúde, educação, etc)
-- Objetivo: Avaliar quais áreas de governo receberam o maior investimento durante o período
SELECT 
    funcao,
    SUM(empenhado) AS total_empenhado,
    SUM(pago) AS total_pago
FROM v_despesas_funcional
GROUP BY funcao
ORDER BY total_empenhado DESC
LIMIT 10;


-- 4. Investigação de maiores credores (empresas/CPFs) da prefeitura
-- Objetivo: Identificar quais prestadores de serviço concentram os maiores pagamentos.
SELECT 
    nome_credor,
    cpf_cnpj,
    SUM(pagamento) AS total_recebido_pago
FROM v_fato_credor_empenho
GROUP BY nome_credor, cpf_cnpj
ORDER BY total_recebido_pago DESC
LIMIT 10;