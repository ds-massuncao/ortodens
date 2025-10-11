SET DATESTYLE TO POSTGRES, DMY ;

----------------------------------------
-- TABELA UNIDADE
----------------------------------------
DROP TABLE if EXISTS tb_unidade CASCADE;
DROP SEQUENCE tb_unidade_seq;
CREATE SEQUENCE tb_unidade_seq;
CREATE TABLE tb_unidade (
    id_unidade VARCHAR(15) NOT NULL DEFAULT 
        'SORRISO - ' || TO_CHAR(nextval('tb_unidade_seq'::regclass), 'FM0000'),
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

----------------------------------------
-- TABELA DENTISTAS
----------------------------------------
DROP TABLE if EXISTS tb_dentista CASCADE;
DROP SEQUENCE tb_dentista_seq;
CREATE SEQUENCE tb_dentista_seq;
CREATE TABLE tb_dentista (
    cro_dentista VARCHAR(11) NOT NULL,
    nome_dentista VARCHAR(200) NOT NULL,
    CONSTRAINT tb_dentista_pk PRIMARY KEY (cro_dentista)
);


----------------------------------------
-- TABELA STATUS DO PACIENTE
----------------------------------------
DROP TABLE if EXISTS tb_status_paciente CASCADE;
DROP SEQUENCE tb_status_paciente_seq;
CREATE SEQUENCE tb_status_paciente_seq;
CREATE TABLE tb_status_paciente (
    id_status_paciente SERIAL NOT NULL,
    nome_status VARCHAR(50) NOT NULL,
    CONSTRAINT tb_status_paciente_pk PRIMARY KEY (id_status_paciente)
);


----------------------------------------
-- TABELA CONVENIOS
----------------------------------------

DROP TABLE if EXISTS tb_convenio CASCADE;
DROP SEQUENCE tb_convenio_seq;
CREATE SEQUENCE tb_convenio_seq;
CREATE TABLE tb_convenio (
    id_convenio SERIAL NOT NULL,
    nome_convenio VARCHAR NOT NULL,
    CONSTRAINT tb_convenio_pk PRIMARY KEY (id_convenio)
);

----------------------------------------
-- TABELA PACIENTES
----------------------------------------
DROP TABLE if EXISTS tb_paciente CASCADE;
DROP SEQUENCE tb_paciente_seq;
CREATE SEQUENCE tb_paciente_seq;
CREATE TABLE tb_paciente (
    id_paciente VARCHAR(20) NOT NULL DEFAULT
        'SMO-' || TO_CHAR(nextval('tb_paciente_seq'::regclass), 'FM00000'),
    nome_paciente VARCHAR(200) NOT NULL,
    data_nascimento_paciente DATE NOT NULL,
    cpf_paciente VARCHAR(11) NOT NULL,
    rg_paciente VARCHAR(15) NOT NULL,
    responsavel_paciente VARCHAR(200) NOT NULL,
    cpf_resp_paciente VARCHAR(11) NOT NULL,
    endereco_paciente VARCHAR(200) NOT NULL,
    bairro_paciente VARCHAR(100) NOT NULL,
    cidade_paciente VARCHAR(50) NOT NULL,
    estado_paciente VARCHAR(2) NOT NULL,
    cep_paciente VARCHAR(90) NOT NULL,
    telefone_principal_paciente VARCHAR(11) NOT NULL,
    whatsapp_paciente VARCHAR(11) NOT NULL,
    data_inicio_tratamento DATE NOT NULL,
    id_status_paciente SMALLINT NOT NULL,
    id_convenio SMALLINT NOT NULL,
    id_unidade VARCHAR(15) NOT NULL,
    CONSTRAINT tb_paciente_pk PRIMARY KEY (id_paciente), 
    CONSTRAINT id_status_paciente_fk FOREIGN KEY (id_status_paciente) REFERENCES tb_status_paciente (id_status_paciente),
    CONSTRAINT id_unidade_fk FOREIGN KEY (id_unidade) REFERENCES tb_unidade (id_unidade),
    CONSTRAINT id_convenio_fk FOREIGN KEY (id_convenio) REFERENCES tb_convenio (id_convenio)
);

----------------------------------------
-- TABELA AGENDA
----------------------------------------

DROP TABLE if EXISTS tb_agenda CASCADE;
DROP SEQUENCE tb_agenda_seq;
CREATE SEQUENCE tb_agenda_seq;

CREATE TABLE tb_agenda (
    id_agenda SERIAL NOT NULL,
    id_paciente VARCHAR(20) NOT NULL,
    cro_dentista VARCHAR(11) NOT NULL,
    id_unidade VARCHAR(15) NOT NULL,
    data_agenda DATE NOT NULL,
    hora_agenda TIME NOT NULL,
    CONSTRAINT id_paciente_fk FOREIGN KEY (id_paciente) REFERENCES tb_paciente (id_paciente),
    CONSTRAINT cro_dentista_fk FOREIGN KEY (cro_dentista) REFERENCES tb_dentista (cro_dentista),
    CONSTRAINT id_unidade_fk FOREIGN KEY (id_unidade) REFERENCES tb_unidade (id_unidade),
    CONSTRAINT tb_agenda_pk PRIMARY KEY (id_agenda)
);

----------------------------------------
-- TABELA PAGAMENTOS
----------------------------------------

DROP TABLE if EXISTS tb_pagamento CASCADE;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE tb_pagamento (
    id_pagamento UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_paciente VARCHAR(20) NOT NULL,
    id_convenio SMALLINT NOT NULL,
    data_pagamento DATE NOT NULL,
    valor_pagamento DECIMAL(10,2) NOT NULL,
    CONSTRAINT id_paciente_fk FOREIGN KEY (id_paciente) REFERENCES tb_paciente (id_paciente),
    CONSTRAINT id_convenio_fk FOREIGN KEY (id_convenio) REFERENCES tb_convenio (id_convenio)
);

----------------------------------------
-- TABELA FORNECEDORES
----------------------------------------
DROP TABLE if EXISTS tb_fornecedor CASCADE;

DROP SEQUENCE tb_fornecedor_seq;
CREATE SEQUENCE tb_fornecedor_seq;

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


----------------------------------------
-- TABELA PRODUTOS
----------------------------------------

DROP TABLE if EXISTS tb_produtos CASCADE;
DROP SEQUENCE tb_produtos_seq;
CREATE SEQUENCE tb_produtos_seq;

CREATE TABLE tb_produtos (
    id_produto SERIAL NOT NULL,
    nome_produto VARCHAR(200) NOT NULL,
    descricao_produto VARCHAR(500) NOT NULL,
    preco_produto DECIMAL(10,2) NOT NULL,
    CONSTRAINT tb_produtos_pk PRIMARY KEY (id_produto)
);

----------------------------------------
-- TABELA COMPRAS
----------------------------------------

DROP TABLE if EXISTS tb_compras CASCADE;
DROP SEQUENCE tb_compras_seq;
CREATE SEQUENCE tb_compras_seq;
CREATE TABLE tb_compras (
    id_compra SERIAL NOT NULL,
    id_fornecedor SMALLINT NOT NULL,
    id_produto SMALLINT NOT NULL,
    quantidade_compra SMALLINT NOT NULL,
    data_compra DATE NOT NULL,
    valor_compra DECIMAL(10,2) NOT NULL,
    CONSTRAINT tb_compras_pk PRIMARY KEY (id_compra),
    CONSTRAINT id_fornecedor_fk FOREIGN KEY (id_fornecedor) REFERENCES tb_fornecedor (id_fornecedor),
    CONSTRAINT id_produto_fk FOREIGN KEY (id_produto) REFERENCES tb_produtos (id_produto)
);

----------------------------------------
-- TABELA LABORATORIO
----------------------------------------

DROP TABLE if EXISTS tb_laboratorio CASCADE;
DROP SEQUENCE tb_laboratorio_seq;
CREATE SEQUENCE tb_laboratorio_seq;
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
