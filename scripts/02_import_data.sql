USE recife_auditoria;
SET GLOBAL local_infile = 1;

-- 1. ÓRGÃOS SETORIAIS

-- Dados de 2024
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/despesas_orgao_2024.csv'
INTO TABLE dim_orgaos
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, poder, codigo_orgao, orgao_setorial, codigo_unidade, unidade_gestora, codigo_despesa, categoria_despesa, codigo_grupo_despesa, grupo_despesa, codigo_modalidade, modalidade, dotacao_atualizada, dotacao_inicial, empenhado, liquidado, pago);

-- Dados de 2025
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/despesas_orgao_2025.csv'
INTO TABLE dim_orgaos
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, poder, codigo_orgao, orgao_setorial, codigo_unidade, unidade_gestora, codigo_despesa, categoria_despesa, codigo_grupo_despesa, grupo_despesa, codigo_modalidade, modalidade, dotacao_atualizada, dotacao_inicial, empenhado, liquidado, pago);

-- Dados de 2026
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/despesas_orgao_2026.csv'
INTO TABLE dim_orgaos
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, poder, codigo_orgao, orgao_setorial, codigo_unidade, unidade_gestora, codigo_despesa, categoria_despesa, codigo_grupo_despesa, grupo_despesa, codigo_modalidade, modalidade, dotacao_atualizada, dotacao_inicial, empenhado, liquidado, pago);


-- 2. FUNCIONAL PROGRAMÁTICA

-- Dados de 2024
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/despesa_funcional_2024.csv'
INTO TABLE dim_funcional
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, codigo_funcao, funcao, codigo_subfuncao, subfuncao, codigo_programa, programa, codigo_acao, acao, codigo_fonte, fonte, dotacao_inicial, dotacao_atualizada, empenhado, liquidado, pago, @dummy);

-- Dados de 2025
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/despesa_funcional_2025.csv'
INTO TABLE dim_funcional
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, codigo_funcao, funcao, codigo_subfuncao, subfuncao, codigo_programa, programa, codigo_acao, acao, codigo_fonte, fonte, dotacao_inicial, dotacao_atualizada, empenhado, liquidado, pago, @dummy);

-- Dados de 2026
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/despesa_funcional_2026.csv'
INTO TABLE dim_funcional
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, codigo_funcao, funcao, codigo_subfuncao, subfuncao, codigo_programa, programa, codigo_acao, acao, codigo_fonte, fonte, dotacao_inicial, dotacao_atualizada, empenhado, liquidado, pago, @dummy);


-- 3. TABELA FATO: DESPESA POR CREDOR E EMPENHO

-- Dados de 2024
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/credor_empenho_2024.csv'
INTO TABLE fato_credor_empenho
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, codigo_unidade, unidade, cpf_cnpj, nome_credor, codigo_tipo_licitacao, tipo_licitacao, data_empenho, data_pagamento, codigo_modalidade_empenho, modalidade_empenho, poder, codigo_orgao, orgao, grupo_despesa, codigo_modalidade, modalidade, empenhado, liquidacao, pagamento, anulacao_empenho, anulacao_liquidacao, anulacao_pagamento, dotacao_inicial, dotacao_atualizada, @dummy);

-- Dados de 2025
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/credor_empenho_2025.csv'
INTO TABLE fato_credor_empenho
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, codigo_unidade, unidade, cpf_cnpj, nome_credor, codigo_tipo_licitacao, tipo_licitacao, data_empenho, data_pagamento, codigo_modalidade_empenho, modalidade_empenho, poder, codigo_orgao, orgao, grupo_despesa, codigo_modalidade, modalidade, empenhado, liquidacao, pagamento, anulacao_empenho, anulacao_liquidacao, anulacao_pagamento, dotacao_inicial, dotacao_atualizada, @dummy);

-- Dados de 2026
LOAD DATA LOCAL INFILE 'caminho/do/diretorio/data/credor_empenho_2026.csv'
INTO TABLE fato_credor_empenho
CHARACTER SET latin1
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano, mes, codigo_unidade, unidade, cpf_cnpj, nome_credor, codigo_tipo_licitacao, tipo_licitacao, data_empenho, data_pagamento, codigo_modalidade_empenho, modalidade_empenho, poder, codigo_orgao, orgao, grupo_despesa, codigo_modalidade, modalidade, empenhado, liquidacao, pagamento, anulacao_empenho, anulacao_liquidacao, anulacao_pagamento, dotacao_inicial, dotacao_atualizada, @dummy);