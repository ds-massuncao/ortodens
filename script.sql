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
