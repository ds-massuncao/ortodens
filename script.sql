CREATE DATABASE 'sorriso_metalico'
-- configurando data para o padrão brasileiro
SET DATESTYLE TO POSTGRES, DMY ;

-- ============================================
-- TABELA UNIDADE 
-- ============================================
DROP TABLE if EXISTS tb_unidade CASCADE;
DROP SEQUENCE tb_unidade_seq;
CREATE SEQUENCE tb_unidade_seq;
CREATE TABLE tb_unidade (
    id_unidade VARCHAR(15) NOT NULL DEFAULT 
        'SORRISO-' || TO_CHAR(nextval('tb_unidade_seq'::regclass), 'FM0000'),
    nome_unidade VARCHAR NOT NULL,
    endereco_unidade VARCHAR(200) NOT NULL,
    bairro_unidade VARCHAR(50) NOT NULL,
    cidade_unidade VARCHAR(50) NOT NULL,
    uf_unidade VARCHAR(2) NOT NULL,
    cep_unidade VARCHAR(9) NOT NULL,
    telefone_unidade VARCHAR(11) NOT NULL,
    email_unidade VARCHAR(200) NOT NULL,
    CONSTRAINT tb_unidade_pk PRIMARY KEY (id_unidade)
);


-- ============================================
-- TABELA DENTISTA
-- ============================================
DROP TABLE if EXISTS tb_dentista CASCADE;
CREATE TABLE tb_dentista (
    cro_dentista VARCHAR(11) NOT NULL,
    nome_dentista VARCHAR(200) NOT NULL,
    id_unidade VARCHAR(15) NOT NULL,
    telefone_dentista VARCHAR(11) NOT NULL,
    email_dentista VARCHAR(200) NOT NULL,
    CONSTRAINT tb_dentista_pk PRIMARY KEY (cro_dentista)
    CONSTRAINT id_unidade_fk FOREIGN KEY (id_unidade) REFERENCES tb_unidade (id_unidade) 
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- ============================================
-- TABELA STATUS DO PACIENTE
-- ============================================
DROP TABLE if EXISTS tb_status_paciente CASCADE;
CREATE TABLE tb_status_paciente (
    id_status_paciente SERIAL NOT NULL,
    nome_status VARCHAR(50) NOT NULL,
    CONSTRAINT tb_status_paciente_pk PRIMARY KEY (id_status_paciente)
);

-- ============================================
-- TABELA CONVENIOS
-- ============================================

DROP TABLE if EXISTS tb_convenio CASCADE;
CREATE TABLE tb_convenio (
    id_convenio SERIAL NOT NULL,
    nome_convenio VARCHAR NOT NULL,
    telefone_convenio VARCHAR(11) NOT NULL,
    email_convenio VARCHAR(200) NOT NULL,
    cnpj_convenio VARCHAR(14) NOT NULL,
    endereco_convenio VARCHAR(200) NOT NULL,
    bairro_convenio VARCHAR(50) NOT NULL,
    cidade_convenio VARCHAR(50) NOT NULL,
    uf_convenio VARCHAR(2) NOT NULL,
    cep_convenio VARCHAR(9) NOT NULL,
    CONSTRAINT tb_convenio_pk PRIMARY KEY (id_convenio)
);

-- ============================================
-- TABELA PACIENTES
-- ============================================
DROP TABLE if EXISTS tb_paciente CASCADE;
DROP SEQUENCE tb_paciente_seq;
CREATE SEQUENCE tb_paciente_seq;
CREATE TABLE tb_paciente (
    id_paciente VARCHAR(20) NOT NULL DEFAULT
        'SMO-' || TO_CHAR(nextval('tb_paciente_seq'::regclass), 'FM00000'),
    nome_paciente VARCHAR(200) NOT NULL,
    data_nascimento_paciente DATE NOT NULL,
    cpf_paciente VARCHAR(20) NOT NULL,
    rg_paciente VARCHAR(20) NOT NULL,
    responsavel_paciente VARCHAR(200) NOT NULL,
    cpf_resp_paciente VARCHAR(20) NOT NULL,
    endereco_paciente VARCHAR(200) NOT NULL,
    bairro_paciente VARCHAR(100) NOT NULL,
    cidade_paciente VARCHAR(50) NOT NULL,
    estado_paciente VARCHAR(2) NOT NULL,
    cep_paciente VARCHAR(90) NOT NULL,
    telefone_principal_paciente VARCHAR(20) NOT NULL,
    whatsapp_paciente VARCHAR(20) NOT NULL,
    data_inicio_tratamento DATE NOT NULL,
    id_status_paciente SMALLINT NOT NULL,
    id_convenio SMALLINT NOT NULL,
    id_unidade VARCHAR(15) NOT NULL,
    CONSTRAINT tb_paciente_pk PRIMARY KEY (id_paciente), 
    CONSTRAINT id_status_paciente_fk FOREIGN KEY (id_status_paciente) REFERENCES tb_status_paciente (id_status_paciente)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_unidade_fk FOREIGN KEY (id_unidade) REFERENCES tb_unidade (id_unidade)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_convenio_fk FOREIGN KEY (id_convenio) REFERENCES tb_convenio (id_convenio)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

----------------------------------------
-- TABELA AGENDA
----------------------------------------

DROP TABLE if EXISTS tb_agenda CASCADE;
CREATE TABLE tb_agenda (
    id_agenda SERIAL NOT NULL,
    id_paciente VARCHAR(20) NOT NULL,
    cro_dentista VARCHAR(11) NOT NULL,
    id_unidade VARCHAR(15) NOT NULL,
    data_agenda DATE NOT NULL,
    hora_agenda TIME NOT NULL,
    CONSTRAINT tb_agenda_pk PRIMARY KEY (id_agenda),
    CONSTRAINT id_paciente_fk FOREIGN KEY (id_paciente) REFERENCES tb_paciente (id_paciente)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT cro_dentista_fk FOREIGN KEY (cro_dentista) REFERENCES tb_dentista (cro_dentista)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_unidade_fk FOREIGN KEY (id_unidade) REFERENCES tb_unidade (id_unidade)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
   
);

-- ============================================
-- TABELA PAGAMENTO
-- ============================================

DROP TABLE if EXISTS tb_pagamento CASCADE;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TABLE tb_pagamento (
    id_pagamento UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_paciente VARCHAR(20) NOT NULL,
    id_procedimento INTEGER NOT NULL,
    data_pagamento DATE NOT NULL,
    valor_pagamento DECIMAL(10,2) NOT NULL,
    CONSTRAINT id_paciente_fk FOREIGN KEY (id_paciente) REFERENCES tb_paciente (id_paciente),
    CONSTRAINT id_procedimento_fk FOREIGN KEY  (id_procedimento) REFERENCES tb_procedimento (id_procedimento)
    ON DELETE RESTRICT
    ON UPDATE CASCADE 
);

-- ============================================
-- TABELA FORNECEDORES
-- ============================================
DROP TABLE if EXISTS tb_fornecedor CASCADE;
CREATE TABLE tb_fornecedor (
    id_fornecedor SERIAL NOT NULL,
    nome_fornecedor VARCHAR(200) NOT NULL,
    endereco_fornecedor VARCHAR(200) NOT NULL,
    bairro_fornecedor VARCHAR(50) NOT NULL,
    cidade_fornecedor VARCHAR(50) NOT NULL,
    uf_fornecedor VARCHAR(2) NOT NULL,
    cep_fornecedor VARCHAR(9) NOT NULL,
    telefone_fornecedor VARCHAR(11) NOT NULL,
    email_fornecedor VARCHAR(200) NOT NULL,
    cnpj_fornecedor VARCHAR(14) NOT NULL,
    CONSTRAINT tb_fornecedor_pk PRIMARY KEY (id_fornecedor)
);

-- ============================================
-- TABELA PRODUTOS
-- ============================================

DROP TABLE if EXISTS tb_produtos CASCADE;
CREATE TABLE tb_produtos (
    id_produto SERIAL NOT NULL,
    nome_produto VARCHAR(200) NOT NULL,
    descricao_produto VARCHAR(500) NOT NULL,
    preco_produto DECIMAL(10,2) NOT NULL,
    CONSTRAINT tb_produtos_pk PRIMARY KEY (id_produto)
);


-- ============================================
-- TABELA COMPRAS
-- ============================================

DROP TABLE if EXISTS tb_compras CASCADE;
CREATE TABLE tb_compras (
    id_compra SERIAL NOT NULL,
    id_fornecedor SMALLINT NOT NULL,
    id_produto SMALLINT NOT NULL,
    quantidade_compra SMALLINT NOT NULL,
    data_compra DATE NOT NULL,
    valor_compra DECIMAL(10,2) NOT NULL,
    CONSTRAINT tb_compras_pk PRIMARY KEY (id_compra),
    CONSTRAINT id_fornecedor_fk FOREIGN KEY (id_fornecedor) REFERENCES tb_fornecedor (id_fornecedor)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_produto_fk FOREIGN KEY (id_produto) REFERENCES tb_produtos (id_produto)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


-- ============================================
-- TABELA LABORATORIO
-- ============================================

DROP TABLE if EXISTS tb_laboratorio CASCADE;
CREATE TABLE tb_laboratorio (
    id_laboratorio SERIAL NOT NULL,
    nome_laboratorio VARCHAR(200) NOT NULL,
    endereco_laboratorio VARCHAR(200) NOT NULL,
    bairro_laboratorio VARCHAR(50) NOT NULL,
    cidade_laboratorio VARCHAR(50) NOT NULL,
    uf_laboratorio VARCHAR(2) NOT NULL,
    cep_laboratorio VARCHAR(9) NOT NULL,
    telefone_laboratorio VARCHAR(11) NOT NULL,
    email_laboratorio VARCHAR(200) NOT NULL,
    cnpj_laboratorio VARCHAR(14) NOT NULL,
    CONSTRAINT tb_laboratorio_pk PRIMARY KEY (id_laboratorio)
);

-- ============================================
-- TABELA PROCEDIMENTOS
-- ============================================

DROP TABLE if EXISTS tb_procedimento CASCADE;
CREATE TABLE tb_procedimento (
    id_procedimento SERIAL NOT NULL,
    nome_procedimento VARCHAR(200) NOT NULL,
    descricao_procedimento VARCHAR(500) NOT NULL,
    preco_procedimento DECIMAL(10,2) NOT NULL,
    CONSTRAINT tb_procedimento_pk PRIMARY KEY (id_procedimento)
);

-- ============================================
-- TABELA iNTRUMENTAL
-- ============================================

DROP TABLE if EXISTS tb_instrumental CASCADE;
CREATE TABLE tb_instrumental (
    id_instrumental SERIAL NOT NULL,
    id_produto SMALLINT NOT NULL,
    id_procedimento SMALLINT NOT NULL,
    quantidade_produto SMALLINT NOT NULL,
    CONSTRAINT tb_instrumental_pk PRIMARY KEY (id_instrumental),
    CONSTRAINT id_produto_fk FOREIGN KEY (id_produto) REFERENCES tb_produtos (id_produto)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_procedimento_fk FOREIGN KEY (id_procedimento) REFERENCES tb_procedimento (id_procedimento)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- ============================================
-- TABELA SERVIÇOS EXTERNOS
-- ============================================

DROP TABLE if EXISTS tb_servico_externo CASCADE; 
CREATE TABLE tb_servico_externo (
    id_servico_externo SERIAL NOT NULL,
    id_laboratorio SMALLINT NOT NULL,
    id_procedimento SMALLINT NOT NULL,
    nome_servico_externo VARCHAR(200) NOT NULL,
    descricao_servico_externo VARCHAR(500) NOT NULL,
    preco_servico_externo DECIMAL(10,2) NOT NULL,
    quantidade_servico_externo SMALLINT NOT NULL,
    CONSTRAINT tb_servico_externo_pk PRIMARY KEY (id_servico_externo),
    CONSTRAINT id_laboratorio_fk FOREIGN KEY (id_laboratorio) REFERENCES tb_laboratorio (id_laboratorio)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_procedimento_fk FOREIGN KEY (id_procedimento) REFERENCES tb_procedimento (id_procedimento)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- ============================================
-- TABELA CONSULTA
-- ============================================

DROP TABLE if EXISTS tb_consulta CASCADE;
CREATE TABLE tb_consulta (
    id_consulta SERIAL NOT NULL,
    cro_dentista VARCHAR(11) NOT NULL,
    id_paciente VARCHAR(20) NOT NULL,
    id_procedimento SMALLINT NOT NULL,
    data_consulta DATE NOT NULL,
    hora_consulta TIME NOT NULL,
    descricao_consulta VARCHAR(500) NOT NULL,
    CONSTRAINT tb_consulta_pk PRIMARY KEY (id_consulta),
    CONSTRAINT cro_dentista_fk FOREIGN KEY (cro_dentista) REFERENCES tb_dentista (cro_dentista)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_procedimento_fk FOREIGN KEY (id_procedimento) REFERENCES tb_procedimento (id_procedimento)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    CONSTRAINT id_paciente_fk FOREIGN KEY (id_paciente) REFERENCES tb_paciente (id_paciente)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);



-- ============================================
-- CATÁLOGO DE EXAMES
-- ============================================

-- Tabela de Categorias de Exames
DROP TABLE if EXISTS tb_categoria_exame CASCADE;
CREATE TABLE tb_categoria_exame (
    id_categoria_exame SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    descricao_categoria TEXT
);

-- Tabela de Catálogo de Exames
DROP TABLE if EXISTS tb_catalogo_exame CASCADE;
CREATE TABLE tb_catalogo_exame (
    id_cat_exame SERIAL PRIMARY KEY,
    id_categoria_exame INTEGER NOT NULL,
    tipo_exame VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    finalidade TEXT NOT NULL,
    CONSTRAINT fk_tb_categoria_exame FOREIGN KEY (id_categoria_exame) 
        REFERENCES tb_categoria_exame(id_categoria_exame)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Tabela de Solicitação de Exames
DROP TABLE if EXISTS tb_solicitacao_exame CASCADE;
CREATE TABLE  tb_solicitacao_exame (
    id_solicitacao SERIAL PRIMARY KEY,
    id_consulta INTEGER NOT NULL,
    cro_dentista VARCHAR(11) NOT NULL,
    id_paciente VARCHAR(20) NOT NULL,
    id_cat_exame INTEGER NOT NULL,
    data_solicitacao DATE NOT NULL DEFAULT CURRENT_DATE,
    hora_solicitacao TIME NOT NULL DEFAULT CURRENT_TIME,
    urgencia VARCHAR(20) DEFAULT 'NORMAL' CHECK (urgencia IN ('URGENTE', 'NORMAL', 'ROTINA')),
    status_solicitacao VARCHAR(30) DEFAULT 'PENDENTE' 
        CHECK (status_solicitacao IN ('PENDENTE', 'AGENDADO', 'REALIZADO', 'CANCELADO')),
    id_exame_realizado INTEGER, -- FK para tb_exame quando realizado
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_consulta_solicitacao 
        FOREIGN KEY (id_consulta) 
        REFERENCES tb_consulta(id_consulta)
        ON DELETE RESTRICT,
    CONSTRAINT fk_dentista_solicitacao 
        FOREIGN KEY (cro_dentista) 
        REFERENCES tb_dentista(cro_dentista)
        ON DELETE RESTRICT,
    CONSTRAINT fk_paciente_solicitacao 
        FOREIGN KEY (id_paciente) 
        REFERENCES tb_paciente(id_paciente)
        ON DELETE RESTRICT,
    CONSTRAINT fk_cat_exame_solicitacao 
        FOREIGN KEY (id_cat_exame) 
        REFERENCES tb_catalogo_exame (id_cat_exame)       
        ON DELETE RESTRICT
);
-- ============================================
-- Chatbot
-- ============================================
-- Tabela feedback

CREATE TABLE IF NOT EXISTS tb_feedback (
    id SERIAL PRIMARY KEY,
    id_consulta INTEGER NOT NULL,
    dentista_atendimento INTEGER NOT NULL CHECK (dentista_atendimento BETWEEN 1 AND 10),
    dentista_tecnica INTEGER NOT NULL CHECK (dentista_tecnica BETWEEN 1 AND 10),
    dentista_empatia INTEGER NOT NULL CHECK (dentista_empatia BETWEEN 1 AND 10),
    recepcionista_cordialidade INTEGER NOT NULL CHECK (recepcionista_cordialidade BETWEEN 1 AND 10),
    recepcionista_eficiencia INTEGER NOT NULL CHECK (recepcionista_eficiencia BETWEEN 1 AND 10),
    assistente_suporte INTEGER NOT NULL CHECK (assistente_suporte BETWEEN 1 AND 10),
    clinica_limpeza INTEGER NOT NULL CHECK (clinica_limpeza BETWEEN 1 AND 10),
    clinica_equipamentos INTEGER NOT NULL CHECK (clinica_equipamentos BETWEEN 1 AND 10),
    clinica_ambiente INTEGER NOT NULL CHECK (clinica_ambiente BETWEEN 1 AND 10),
    CONSTRAINT fk_consulta FOREIGN KEY (id_consulta) REFERENCES tb_consulta(id_consulta)
);