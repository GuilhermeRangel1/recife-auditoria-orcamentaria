# 📊 Auditoria Orçamentária - Prefeitura do Recife (2024-2026)

## 🎯 Sobre o Projeto
Este projeto de Análise de Dados foca na auditoria e visualização da execução orçamentária da cidade do Recife. O objetivo é rastrear o dinheiro público de ponta a ponta: desde o orçamento aprovado em lei (dotação) até o pagamento real aos fornecedores na ponta, respondendo a perguntas como: *Onde a prefeitura mais investe? Quais empresas recebem os maiores volumes de recursos? O planejamento orçamentário está sendo cumprido?*

A arquitetura do projeto consistiu em extrair microdados públicos, modelar um banco de dados relacional para tratamento (ETL) e criar visões analíticas consumidas por um dashboard interativo.

## 🛠️ Tecnologias e Ferramentas
* **MySQL:** Criação de tabelas Fato e Dimensão, higienização de dados (TRIM, CAST) e criação de Views para otimização de consultas.
* **Power BI:** Conexão direta com o banco de dados, modelagem visual, cálculos e construção do dashboard interativo.
* **Dados Públicos:** Portal da Transparência da Prefeitura do Recife.


## 📸 Dashboards e Principais Insights

![Visão Geral - Execução e Credores](img/parte1.jpeg)

### 💡 Insights da Execução Financeira:
* **Concentração de Fornecedores:** Observou-se que o Top 10 de fornecedores concentra a maior fatia do orçamento líquido pago, evidenciando quais empresas e consórcios possuem os maiores contratos com o município.
* **Sazonalidade de Gastos:** A análise da curva de evolução mensal permite identificar os períodos de maior pico de pagamentos e liquidações ao longo do ano, auxiliando na compreensão do fluxo de caixa governamental.

![Análise Orçamentária e Eficiência](img/parte2.jpeg)

### 💡 Insights do Planejamento Orçamentária:
* **Eficiência Orçamentária (Dotação vs. Gasto Real):** Ao cruzar o orçamento autorizado (Dotação Atualizada) com o valor efetivamente pago, nota-se que grandes secretarias operam dentro do limite planejado, apresentando uma margem de segurança e controle sobre o teto de gastos.
* **Foco Funcional:** O gráfico de categorias e funções destaca visualmente as áreas prioritárias de alocação de recursos (como Saúde, Educação ou Urbanismo), mapeando a distribuição estratégica dos impostos arrecadados em Recife.


## ⚙️ Como Executar Este Projeto

1. Faça o clone do repositório.
2. Baixe os arquivos CSV do Portal da Transparência (ou utilize os da pasta `/data`).
3. No MySQL, execute os scripts na ordem:
   - `01_create_tables.sql` (Cria a estrutura Fato/Dimensão).
   - `02_import_data.sql` (Realiza a carga dos dados. **Nota:** Lembre-se de alterar o caminho `'caminho/do/diretorio/data/...'` no script para o seu diretório local).
   - `03_transform_data.sql` (Cria as Views limpas e tipadas).
4. Abra o arquivo `dashboard_auditoria_recife.pbix` no Power BI e atualize a fonte de dados com suas credenciais locais do MySQL.
