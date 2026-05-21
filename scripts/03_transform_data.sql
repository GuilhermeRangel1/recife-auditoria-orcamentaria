USE recife_auditoria;

-- 1. VIEW ANALÍTICA DE ÓRGÃOS (com limpeza e correção)
CREATE OR REPLACE VIEW v_despesas_orgao AS
SELECT 
    ano,
    mes,
    TRIM(poder) AS poder,
    TRIM(codigo_orgao) AS codigo_orgao,
    TRIM(orgao_setorial) AS orgao_setorial,
    TRIM(unidade_gestora) AS unidade_gestora,
    TRIM(categoria_despesa) AS categoria_despesa,
    TRIM(grupo_despesa) AS grupo_despesa,
    TRIM(modalidade) AS modalidade,
    CAST(NULLIF(TRIM(dotacao_atualizada), '') AS DECIMAL(15,2)) AS dotacao_atualizada,
    CAST(NULLIF(TRIM(dotacao_inicial), '') AS DECIMAL(15,2)) AS dotacao_inicial,
    CAST(NULLIF(TRIM(empenhado), '') AS DECIMAL(15,2)) AS empenhado,
    CAST(NULLIF(TRIM(liquidado), '') AS DECIMAL(15,2)) AS liquidado,
    CAST(NULLIF(TRIM(pago), '') AS DECIMAL(15,2)) AS pago
FROM dim_orgaos;

-- 2. VIEW ANALÍTICA DA FUNCIONAL PROGRAMÁTICA (com limpeza e correção)
CREATE OR REPLACE VIEW v_despesas_funcional AS
SELECT 
    ano,
    mes,
    TRIM(codigo_funcao) AS codigo_funcao,
    TRIM(funcao) AS funcao,
    TRIM(subfuncao) AS subfuncao,
    TRIM(programa) AS programa,
    TRIM(acao) AS acao,
    TRIM(fonte) AS fonte,
    CAST(NULLIF(TRIM(dotacao_inicial), '') AS DECIMAL(15,2)) AS dotacao_inicial,
    CAST(NULLIF(TRIM(dotacao_atualizada), '') AS DECIMAL(15,2)) AS dotacao_atualizada,
    CAST(NULLIF(TRIM(empenhado), '') AS DECIMAL(15,2)) AS empenhado,
    CAST(NULLIF(TRIM(liquidado), '') AS DECIMAL(15,2)) AS liquidado,
    CAST(NULLIF(TRIM(pago), '') AS DECIMAL(15,2)) AS pago
FROM dim_funcional;

-- 3. VIEW ANALÍTICA DA TABELA FATO (com limpeza e correção)
CREATE OR REPLACE VIEW v_fato_credor_empenho AS
SELECT 
    ano,
    mes,
    TRIM(codigo_unidade) AS codigo_unidade,
    TRIM(unidade) AS unidade,
    TRIM(cpf_cnpj) AS cpf_cnpj,
    TRIM(nome_credor) AS nome_credor,
    TRIM(tipo_licitacao) AS tipo_licitacao,
    TRIM(modalidade_empenho) AS modalidade_empenho,
    TRIM(codigo_orgao) AS codigo_orgao,
    TRIM(orgao) AS orgao,
    TRIM(modalidade) AS modalidade,
    CAST(NULLIF(TRIM(empenhado), '') AS DECIMAL(15,2)) AS empenhado,
    CAST(NULLIF(TRIM(liquidacao), '') AS DECIMAL(15,2)) AS liquidacao,
    CAST(NULLIF(TRIM(pagamento), '') AS DECIMAL(15,2)) AS pagamento,
    CAST(NULLIF(TRIM(anulacao_empenho), '') AS DECIMAL(15,2)) AS Dynamic_anulacao_empenho,
    CAST(NULLIF(TRIM(anulacao_liquidacao), '') AS DECIMAL(15,2)) AS anulacao_liquidacao,
    CAST(NULLIF(TRIM(anulacao_pagamento), '') AS DECIMAL(15,2)) AS流通_anulacao_pagamento
FROM fato_credor_empenho;