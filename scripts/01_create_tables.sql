CREATE DATABASE IF NOT EXISTS recife_auditoria;
USE recife_auditoria;

DROP TABLE IF EXISTS fato_credor_empenho;
DROP TABLE IF EXISTS dim_funcional;
DROP TABLE IF EXISTS dim_orgaos;

-- Tabela de Órgãos
CREATE TABLE dim_orgaos (
    ano INT,
    mes INT,
    poder VARCHAR(100),
    codigo_orgao VARCHAR(50),
    orgao_setorial VARCHAR(255),
    codigo_unidade VARCHAR(50),
    unidade_gestora VARCHAR(255),
    codigo_despesa VARCHAR(50),
    categoria_despesa VARCHAR(255),
    codigo_grupo_despesa VARCHAR(50),
    grupo_despesa VARCHAR(255),
    codigo_modalidade VARCHAR(50),
    modalidade VARCHAR(255),
    dotacao_atualizada VARCHAR(50),
    dotacao_inicial VARCHAR(50),
    empenhado VARCHAR(50),
    liquidado VARCHAR(50),
    pago VARCHAR(50)
);

-- Tabela Funcional Programática
CREATE TABLE dim_funcional (
    ano INT,
    mes INT,
    codigo_funcao VARCHAR(50),
    funcao VARCHAR(255),
    codigo_subfuncao VARCHAR(50),
    subfuncao VARCHAR(255),
    codigo_programa VARCHAR(50),
    programa VARCHAR(255),
    codigo_acao VARCHAR(50),
    acao VARCHAR(255),
    codigo_fonte VARCHAR(50),
    fonte VARCHAR(255),
    dotacao_inicial VARCHAR(50),
    dotacao_atualizada VARCHAR(50),
    empenhado VARCHAR(50),
    liquidado VARCHAR(50),
    pago VARCHAR(50)
);

-- Tabela Fato (Credor e Empenho)
CREATE TABLE fato_credor_empenho (
    ano INT,
    mes INT,
    codigo_unidade VARCHAR(50),
    unidade VARCHAR(255),
    cpf_cnpj VARCHAR(100),
    nome_credor VARCHAR(255),
    codigo_tipo_licitacao VARCHAR(50),
    tipo_licitacao VARCHAR(255),
    data_empenho VARCHAR(100),
    data_pagamento VARCHAR(255),
    codigo_modalidade_empenho VARCHAR(50),
    modalidade_empenho VARCHAR(255),
    poder VARCHAR(100),
    codigo_orgao VARCHAR(50),
    orgao VARCHAR(255),
    grupo_despesa VARCHAR(255),
    codigo_modalidade VARCHAR(50),
    modalidade VARCHAR(255),
    empenhado VARCHAR(50),
    liquidacao VARCHAR(50),
    pagamento VARCHAR(50),
    anulacao_empenho VARCHAR(50),
    anulacao_liquidacao VARCHAR(50),
    anulacao_pagamento VARCHAR(50),
    dotacao_inicial VARCHAR(50),
    dotacao_atualizada VARCHAR(50)
);