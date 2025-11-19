-- Active: 1756490077951@@127.0.0.1@5432@dw_sorriso_metalico
-- ============================================
-- DIMENSÃO TEMPO
-- (Deve ser pré-populada com todos os dias,
-- cobrindo vários anos)
-- ============================================
CREATE TABLE DIM_TEMPO (
    SK_Tempo SERIAL PRIMARY KEY, -- Chave Surpresa (Surrogate Key)
    Data_Completa DATE NOT NULL UNIQUE,
    Dia SMALLINT NOT NULL,
    Mes SMALLINT NOT NULL,
    Nome_Mes VARCHAR(20) NOT NULL,
    Ano SMALLINT NOT NULL,
    Trimestre CHAR(2) NOT NULL,
    Semana_do_Ano SMALLINT NOT NULL,
    Dia_da_Semana VARCHAR(20) NOT NULL,
    Flag_Fim_de_Semana BOOLEAN NOT NULL
);

-- ============================================
-- DIMENSÃO UNIDADE
-- (Origem: tb_unidade)
-- ============================================
CREATE TABLE DIM_UNIDADE (
    SK_Unidade SERIAL PRIMARY KEY,
    BK_ID_Unidade VARCHAR(15) NOT NULL, -- Chave de Negócio (Business Key)
    Nome_Unidade VARCHAR(200) NOT NULL,
    Cidade_Unidade VARCHAR(50) NOT NULL,
    UF_Unidade VARCHAR(2) NOT NULL
);

-- ============================================
-- DIMENSÃO PROCEDIMENTO
-- (Origem: tb_procedimento)
-- ============================================
CREATE TABLE DIM_PROCEDIMENTO (
    SK_Procedimento SERIAL PRIMARY KEY,
    BK_ID_Procedimento INTEGER NOT NULL, -- Chave de Negócio
    Nome_Procedimento VARCHAR(200) NOT NULL,
    Preco_Procedimento DECIMAL(10,2) NOT NULL
);

-- ============================================
-- DIMENSÃO DENTISTA
-- (Origem: tb_dentista)
-- ============================================
CREATE TABLE DIM_DENTISTA (
    SK_Dentista SERIAL PRIMARY KEY,
    BK_CRO_Dentista VARCHAR(11) NOT NULL, -- Chave de Negócio
    Nome_Dentista VARCHAR(200) NOT NULL,
    Email_Dentista VARCHAR(200) NOT NULL,
    -- Chave Estrangeira para a unidade principal do dentista
    SK_Unidade_Alocacao INTEGER, 
    FOREIGN KEY (SK_Unidade_Alocacao) REFERENCES DIM_UNIDADE(SK_Unidade)
);

-- ============================================
-- DIMENSÃO PACIENTE
-- (Origem: tb_paciente, tb_status_paciente, tb_convenio)
-- ============================================
CREATE TABLE DIM_PACIENTE (
    SK_Paciente SERIAL PRIMARY KEY,
    BK_ID_Paciente VARCHAR(20) NOT NULL, -- Chave de Negócio
    Nome_Paciente VARCHAR(200) NOT NULL,
    Data_Nascimento DATE NOT NULL,
    Faixa_Etaria VARCHAR(20), -- (Calculado no ETL)
    Cidade_Paciente VARCHAR(50) NOT NULL,
    Estado_Paciente VARCHAR(2) NOT NULL,
    Data_Inicio_Tratamento DATE NOT NULL,
    Status_Paciente VARCHAR(50) NOT NULL, -- (JOIN com tb_status_paciente)
    Nome_Convenio VARCHAR(200) NOT NULL, -- (JOIN com tb_convenio)
    SK_Unidade INTEGER NOT NULL, --(fk_dim_unidade)
    -- Campos para Slowly Changing Dimension (SCD Tipo 2)
    -- Isso rastreia o *histórico* de mudanças do paciente
    Data_Inicio_Validade DATE NOT NULL,
    Data_Fim_Validade DATE,
    Flag_Versao_Atual BOOLEAN NOT NULL,
    SK_Unidade INTEGER NOT NULL
    FOREIGN KEY (SK_Unidade) REFERENCES DIM_UNIDADE(SK_Unidade)
);
