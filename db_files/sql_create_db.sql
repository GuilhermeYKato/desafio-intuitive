-- psql (PostgreSQL) 17.4, compiled on terminal Windows 10
-- Criar banco de dados e tabelas para armazenar dados de operadoras de saúde e seus dados financeiros

-- Criar banco de dados operadora
CREATE DATABASE operadora;

-- Conectar ao banco de dados
\c operadora;

-- Criar tabela operadoras
CREATE TABLE IF NOT EXISTS operadoras (
    registro_ans VARCHAR(6) PRIMARY KEY,
    cnpj VARCHAR(14),
    razao_social TEXT,
    nome_fantasia TEXT,
    modalidade TEXT,
    logradouro TEXT,
    numero TEXT,
    complemento TEXT,
    bairro TEXT,
    cidade TEXT,
    uf CHAR(2),
    cep VARCHAR(10),
    ddd VARCHAR(2),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico TEXT,
    representante TEXT,
    cargo_representante TEXT,
    regiao_comercializacao TEXT,
    data_registro_ans DATE
);

-- Criar tabela dados_financeiros
CREATE TABLE IF NOT EXISTS dados_financeiros (
    data DATE,
    reg_ans VARCHAR(6),
    cd_conta_contabil VARCHAR(20),
    descricao TEXT,
    vl_saldo_inicial TEXT,
    vl_saldo_final TEXT,
    FOREIGN KEY (reg_ans) REFERENCES operadoras(registro_ans)
);

-- Importando dados para operadoras (Relatorio_cadop.csv)
\copy operadoras FROM 'files_path\db_files\Relatorio_cadop.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';

-- Para facilitar a inserção dos dados, desabilitar a verificação de chaves estrangeiras temporariamente
SET session_replication_role = replica;

-- Importando dados_financeiros de múltiplos arquivos (1T2023.csv, 2T2023.csv, 3T2023.csv, 4T2023.csv, 1T2024.csv, 2T2024.csv, 3T2024.csv, 4T2024.csv)
\copy dados_financeiros FROM 'files_path\db_files\2023\1T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2023\2T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2023\3T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2023\4T2023.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2024\1T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2024\2T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2024\3T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy dados_financeiros FROM 'files_path\db_files\2024\4T2024.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';

-- Verificar quais valores de reg_ans em dados_financeiros não existem em operadoras
SELECT DISTINCT reg_ans
FROM dados_financeiros
WHERE reg_ans NOT IN (SELECT registro_ans FROM operadoras)
LIMIT 10;

-- Como não sabemos as operados dos reg_ans encontrados, excluiremos os dados financeiros onde reg_ans não tem correspondência em operadoras
DELETE FROM dados_financeiros
WHERE reg_ans NOT IN (SELECT registro_ans FROM operadoras);

-- Reabilitar a verificação de chaves estrangeiras
SET session_replication_role = origin;

-- Alterar o tipo de dado das colunas vl_saldo_inicial e vl_saldo_final para NUMERIC
ALTER TABLE dados_financeiros
ALTER COLUMN vl_saldo_inicial TYPE NUMERIC USING REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC,
ALTER COLUMN vl_saldo_final TYPE NUMERIC USING REPLACE(vl_saldo_final, ',', '.')::NUMERIC;

-- Verificar os tipos de dados das colunas
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'dados_financeiros' AND column_name IN ('vl_saldo_inicial', 'vl_saldo_final');

SELECT vl_saldo_inicial
FROM dados_financeiros
ORDER BY vl_saldo_inicial desc
LIMIT 10;

select vl_saldo_final
from dados_financeiros
ORDER BY vl_saldo_final desc
LIMIT 10;