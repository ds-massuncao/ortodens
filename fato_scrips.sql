-- ============================================
-- FATO CONSULTA
-- Grão: Uma linha por consulta realizada
-- (Origem: tb_consulta)
-- ============================================
CREATE TABLE FATO_CONSULTA (
    SK_Tempo_Consulta INTEGER NOT NULL,
    SK_Paciente INTEGER NOT NULL,
    SK_Dentista INTEGER NOT NULL,
    SK_Procedimento INTEGER NOT NULL,
    SK_Unidade INTEGER NOT NULL, -- (Inferida via Dentista ou Paciente no ETL)
    
    -- Métricas
    Qtd_Consultas SMALLINT NOT NULL DEFAULT 1,
    
    -- Chaves Estrangeiras
    FOREIGN KEY (SK_Tempo_Consulta) REFERENCES DIM_TEMPO(SK_Tempo),
    FOREIGN KEY (SK_Paciente) REFERENCES DIM_PACIENTE(SK_Paciente),
    FOREIGN KEY (SK_Dentista) REFERENCES DIM_DENTISTA(SK_Dentista),
    FOREIGN KEY (SK_Procedimento) REFERENCES DIM_PROCEDIMENTO(SK_Procedimento),
    FOREIGN KEY (SK_Unidade) REFERENCES DIM_UNIDADE(SK_Unidade)
);

-- ============================================
-- FATO PAGAMENTO
-- Grão: Uma linha por pagamento efetuado
-- (Origem: tb_pagamento)
-- ============================================
CREATE TABLE FATO_PAGAMENTO (
    SK_Tempo_Pagamento INTEGER NOT NULL,
    SK_Paciente INTEGER NOT NULL,
    SK_Procedimento INTEGER NOT NULL,
    SK_Unidade INTEGER NOT NULL, -- (Inferida via Paciente no ETL)
    
    -- Métricas
    Valor_Pagamento DECIMAL(10,2) NOT NULL,
    Qtd_Pagamentos SMALLINT NOT NULL DEFAULT 1,
    
    -- Chaves Estrangeiras
    FOREIGN KEY (SK_Tempo_Pagamento) REFERENCES DIM_TEMPO(SK_Tempo),
    FOREIGN KEY (SK_Paciente) REFERENCES DIM_PACIENTE(SK_Paciente),
    FOREIGN KEY (SK_Procedimento) REFERENCES DIM_PROCEDIMENTO(SK_Procedimento),
    FOREIGN KEY (SK_Unidade) REFERENCES DIM_UNIDADE(SK_Unidade)
);

-- ============================================
-- FATO SATISFACAO
-- Grão: Uma linha por pesquisa respondida
-- (Origem: Sua 2ª fonte de dados - Pesquisas)
-- ============================================
CREATE TABLE FATO_SATISFACAO (
    SK_Tempo_Resposta INTEGER NOT NULL,
    SK_Paciente INTEGER NOT NULL,
    SK_Dentista INTEGER NOT NULL,
    SK_Unidade INTEGER NOT NULL,
    SK_Procedimento INTEGER NOT NULL,
    
    -- Métricas de Satisfação
    Nota_Satisfacao_Geral SMALLINT, -- (ex: 1 a 5)
    Nota_Atendimento SMALLINT,
    Nota_Dentista SMALLINT,
    Nota_Clinica SMALLINT,
    Qtd_Respostas SMALLINT NOT NULL DEFAULT 1,
    
    -- Dimensão Degenerada (o texto da análise)
    -- Chaves Estrangeiras
    FOREIGN KEY (SK_Tempo_Resposta) REFERENCES DIM_TEMPO(SK_Tempo),
    FOREIGN KEY (SK_Paciente) REFERENCES DIM_PACIENTE(SK_Paciente),
    FOREIGN KEY (SK_Dentista) REFERENCES DIM_DENTISTA(SK_Dentista),
    FOREIGN KEY (SK_Procedimento) REFERENCES DIM_PROCEDIMENTO(SK_Procedimento),
    FOREIGN KEY (SK_Unidade) REFERENCES DIM_UNIDADE(SK_Unidade)
);



-- ============================================
-- FATO PACIENTE SNAPSHOT MENSAL (Para Churn)
-- Grão: Uma linha por paciente, por mês
-- (Origem: Calculada pelo ETL)
-- ============================================
CREATE TABLE FATO_PACIENTE_SNAPSHOT_MENSAL (
    SK_Tempo_Mes INTEGER NOT NULL, -- (FK p/ o último dia do mês na DIM_TEMPO)
    SK_Paciente INTEGER NOT NULL,
    SK_Unidade INTEGER NOT NULL, -- (Unidade de cadastro do paciente)
    
    -- Métricas do "retrato" (snapshot)
    Dias_Desde_Ultima_Consulta INTEGER,
    Qtd_Consultas_no_Mes SMALLINT,
    Valor_Pago_no_Mes DECIMAL(10,2),
    Flag_Churn BOOLEAN, -- (ex: 1 se Dias_Desde_Ultima_Consulta > 180)
    
    -- Chave Primária Composta
    PRIMARY KEY (SK_Tempo_Mes, SK_Paciente),
    
    -- Chaves Estrangeiras
    FOREIGN KEY (SK_Tempo_Mes) REFERENCES DIM_TEMPO(SK_Tempo),
    FOREIGN KEY (SK_Paciente) REFERENCES DIM_PACIENTE(SK_Paciente),
    FOREIGN KEY (SK_Unidade) REFERENCES DIM_UNIDADE(SK_Unidade)
);

ANO_SNAPSHOT    2025
DATA_SNAPSHOT   2025-09-30
MES_SNAPSHOT    9
SK_TEMPO_SNAPSHOT   15423