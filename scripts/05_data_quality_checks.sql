USE recife_auditoria;

-- 1. Contagem de registros por tabela e ano
-- Objetivo: confirmar se todos os arquivos esperados foram carregados.
SELECT
    'dim_orgaos' AS tabela,
    ano,
    COUNT(*) AS total_registros
FROM dim_orgaos
GROUP BY ano
UNION ALL
SELECT
    'dim_funcional' AS tabela,
    ano,
    COUNT(*) AS total_registros
FROM dim_funcional
GROUP BY ano
UNION ALL
SELECT
    'fato_credor_empenho' AS tabela,
    ano,
    COUNT(*) AS total_registros
FROM fato_credor_empenho
GROUP BY ano
ORDER BY tabela, ano;


-- 2. Verificacao de anos fora do periodo esperado
-- Objetivo: detectar registros carregados com ano incorreto.
SELECT 'dim_orgaos' AS tabela, ano, COUNT(*) AS total_registros
FROM dim_orgaos
WHERE ano NOT IN (2024, 2025, 2026)
GROUP BY ano
UNION ALL
SELECT 'dim_funcional' AS tabela, ano, COUNT(*) AS total_registros
FROM dim_funcional
WHERE ano NOT IN (2024, 2025, 2026)
GROUP BY ano
UNION ALL
SELECT 'fato_credor_empenho' AS tabela, ano, COUNT(*) AS total_registros
FROM fato_credor_empenho
WHERE ano NOT IN (2024, 2025, 2026)
GROUP BY ano;


-- 3. Verificacao de meses fora do intervalo valido
-- Objetivo: encontrar registros com mes menor que 0 ou maior que 12.
SELECT 'dim_orgaos' AS tabela, ano, mes, COUNT(*) AS total_registros
FROM dim_orgaos
WHERE mes < 0 OR mes > 12
GROUP BY ano, mes
UNION ALL
SELECT 'dim_funcional' AS tabela, ano, mes, COUNT(*) AS total_registros
FROM dim_funcional
WHERE mes < 0 OR mes > 12
GROUP BY ano, mes
UNION ALL
SELECT 'fato_credor_empenho' AS tabela, ano, mes, COUNT(*) AS total_registros
FROM fato_credor_empenho
WHERE mes < 0 OR mes > 12
GROUP BY ano, mes;


-- 4. Valores monetarios negativos nas views
-- Objetivo: listar totais negativos que podem representar anulacoes, ajustes ou dados a investigar.
SELECT
    ano,
    orgao_setorial,
    SUM(dotacao_atualizada) AS dotacao_atualizada,
    SUM(empenhado) AS total_empenhado,
    SUM(liquidado) AS total_liquidado,
    SUM(pago) AS total_pago
FROM v_despesas_orgao
GROUP BY ano, orgao_setorial
HAVING dotacao_atualizada < 0
    OR total_empenhado < 0
    OR total_liquidado < 0
    OR total_pago < 0
ORDER BY ano, orgao_setorial;


-- 5. Credores sem CPF/CNPJ ou nome informado
-- Objetivo: identificar registros de pagamento com credor incompleto.
SELECT
    ano,
    mes,
    orgao,
    cpf_cnpj,
    nome_credor,
    pagamento
FROM v_fato_credor_empenho
WHERE pagamento > 0
  AND (
      cpf_cnpj IS NULL
      OR cpf_cnpj = ''
      OR nome_credor IS NULL
      OR nome_credor = ''
  )
ORDER BY pagamento DESC
LIMIT 50;


-- 6. Campos de classificacao sem descricao
-- Objetivo: localizar registros com classificacao orcamentaria incompleta.
SELECT
    ano,
    mes,
    codigo_funcao,
    funcao,
    subfuncao,
    programa,
    acao
FROM v_despesas_funcional
WHERE funcao IS NULL
   OR funcao = ''
   OR programa IS NULL
   OR programa = ''
   OR acao IS NULL
   OR acao = ''
LIMIT 50;
