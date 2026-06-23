# Dicionario de Dados

Este documento descreve os principais arquivos, tabelas, views e indicadores usados no projeto.

## Arquivos CSV

| Arquivo | Conteudo |
|---|---|
| `despesas_orgao_2024.csv` | Execucao orcamentaria por orgao em 2024. |
| `despesas_orgao_2025.csv` | Execucao orcamentaria por orgao em 2025. |
| `despesas_orgao_2026.csv` | Execucao orcamentaria por orgao em 2026. |
| `despesa_funcional_2024.csv` | Execucao por funcao, subfuncao, programa e acao em 2024. |
| `despesa_funcional_2025.csv` | Execucao por funcao, subfuncao, programa e acao em 2025. |
| `despesa_funcional_2026.csv` | Execucao por funcao, subfuncao, programa e acao em 2026. |
| `credor_empenho_2024.csv` | Despesas por credor e empenho em 2024. |
| `credor_empenho_2025.csv` | Despesas por credor e empenho em 2025. |
| `credor_empenho_2026.csv` | Despesas por credor e empenho em 2026. |

## Tabelas

### `dim_orgaos`

Tabela com dados de execucao por orgao, unidade gestora, categoria, grupo e modalidade de despesa.

Campos principais:

- `ano`, `mes`: periodo do registro.
- `poder`: poder responsavel pela despesa.
- `codigo_orgao`, `orgao_setorial`: identificacao do orgao.
- `codigo_unidade`, `unidade_gestora`: identificacao da unidade gestora.
- `categoria_despesa`, `grupo_despesa`, `modalidade`: classificacoes da despesa.
- `dotacao_inicial`: valor previsto inicialmente.
- `dotacao_atualizada`: valor atualizado apos alteracoes orcamentarias.
- `empenhado`: valor reservado para uma obrigacao.
- `liquidado`: valor reconhecido apos verificacao da entrega ou servico.
- `pago`: valor efetivamente pago.

### `dim_funcional`

Tabela com a classificacao funcional-programatica da despesa.

Campos principais:

- `codigo_funcao`, `funcao`: area de atuacao do governo.
- `codigo_subfuncao`, `subfuncao`: detalhamento da funcao.
- `codigo_programa`, `programa`: programa orcamentario.
- `codigo_acao`, `acao`: acao orcamentaria.
- `codigo_fonte`, `fonte`: fonte do recurso.
- `dotacao_inicial`, `dotacao_atualizada`, `empenhado`, `liquidado`, `pago`: valores de execucao.

### `fato_credor_empenho`

Tabela com os registros detalhados por credor e empenho.

Campos principais:

- `cpf_cnpj`, `nome_credor`: identificacao do recebedor.
- `tipo_licitacao`: tipo de licitacao informado.
- `data_empenho`, `data_pagamento`: datas associadas ao empenho e pagamento.
- `orgao`, `codigo_orgao`: orgao responsavel.
- `modalidade`, `modalidade_empenho`: modalidades associadas ao gasto.
- `empenhado`, `liquidacao`, `pagamento`: valores financeiros.
- `anulacao_empenho`, `anulacao_liquidacao`, `anulacao_pagamento`: valores anulados.

## Views

| View | Origem | Finalidade |
|---|---|---|
| `v_despesas_orgao` | `dim_orgaos` | Analises por orgao, unidade e modalidade. |
| `v_despesas_funcional` | `dim_funcional` | Analises por funcao, programa, acao e fonte. |
| `v_fato_credor_empenho` | `fato_credor_empenho` | Analises por credor, empenho, licitacao e pagamento. |

## Indicadores

| Indicador | Formula | Leitura |
|---|---|---|
| Percentual empenhado | `SUM(empenhado) / SUM(dotacao_atualizada)` | Mede quanto do orcamento atualizado foi comprometido. |
| Percentual pago | `SUM(pago) / SUM(dotacao_atualizada)` | Mede quanto do orcamento atualizado virou pagamento. |
| Saldo empenhado nao pago | `SUM(empenhado) - SUM(pago)` | Aponta compromissos ainda nao pagos. |
| Concentracao por credor | `pagamento do credor / pagamento total` | Mede dependencia ou concentracao em poucos recebedores. |
| Evolucao mensal | `SUM(pagamento)` por `ano` e `mes` | Mostra sazonalidade e picos de pagamento. |
