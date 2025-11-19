-- Active: 1756490077951@@127.0.0.1@5432@dw_churn_sorriso_metalico
ALTER TABLE DIM_PACIENTE
ADD COLUMN Probabilidade_Churn DECIMAL(5, 4); 
CREATE OR REPLACE VIEW vw_paciente_satisfacao_media AS
SELECT
    SK_Paciente,
    AVG(Nota_Satisfacao_Geral) as avg_nota_geral,
    AVG(Nota_Atendimento) as avg_nota_atendimento,
    AVG(Nota_Dentista) as avg_nota_dentista
FROM
    FATO_SATISFACAO
GROUP BY
    SK_Paciente;	


CREATE VIEW vw_paciente_ultima_consulta_info AS
WITH RankedConsultas AS (
    SELECT
        fc.SK_Paciente,
        fc.SK_Procedimento,
        -- Ordena as consultas de cada paciente, da mais recente para a mais antiga
        ROW_NUMBER() OVER (
            PARTITION BY fc.SK_Paciente 
            ORDER BY fc.SK_Tempo_Consulta DESC
        ) as rn
    FROM
        FATO_CONSULTA fc
)
-- Pega apenas a consulta mais recente (rn = 1)
SELECT
    rc.SK_Paciente,
    rc.SK_Procedimento
FROM
    RankedConsultas rc
WHERE
    rc.rn = 1;



WITH UltimoSnapshot AS (
    SELECT
        SK_Paciente,
        MAX(SK_Tempo_Mes) as Ultimo_SK_Tempo_Mes
    FROM FATO_PACIENTE_SNAPSHOT_MENSAL
    GROUP BY SK_Paciente
)
SELECT
    -- Features Comportamentais
    snap.SK_Paciente,--se for treinar o modelo remova sk_paciente ---------------------------------------
    snap.Qtd_Consultas_no_Mes,
    snap.Valor_Pago_no_Mes,
    -- Features Demográficas
    pac.Faixa_Etaria,
    pac.Cidade_Paciente,
    pac.Estado_Paciente,
    pac.Nome_Convenio,
    -- Features de Satisfação
    COALESCE(sat.avg_nota_geral, 3.0) as avg_nota_geral,
    COALESCE(sat.avg_nota_atendimento, 3.0) as avg_nota_atendimento,
    COALESCE(sat.avg_nota_dentista, 3.0) as avg_nota_dentista,    
    -- Feature de Unidade
    unid.Cidade_Unidade,    
    -- === NOVAS FEATURES (ÚLTIMO PROCEDIMENTO) ===
    -- Usamos COALESCE para pacientes que talvez nunca tiveram um procedimento
    COALESCE(proc.Nome_Procedimento, 'Nenhum') as Nome_Procedimento,
    COALESCE(proc.Preco_Procedimento, 0.0) as Valor_do_ultimo_Procedimento,    
    -- Alvo (y)
    snap.Flag_Churn
FROM
    FATO_PACIENTE_SNAPSHOT_MENSAL snap
-- Junta com o último snapshot
JOIN
    UltimoSnapshot us ON snap.SK_Paciente = us.SK_Paciente 
                     AND snap.SK_Tempo_Mes = us.Ultimo_SK_Tempo_Mes
-- Junta com o paciente
JOIN
    DIM_PACIENTE pac ON snap.SK_Paciente = pac.SK_Paciente 
                   AND pac.Flag_Versao_Atual = TRUE
-- Junta com as notas de satisfação
LEFT JOIN
    vw_paciente_satisfacao_media sat ON pac.SK_Paciente = sat.SK_Paciente
-- Junta com a unidade
JOIN
    DIM_UNIDADE unid ON snap.SK_Unidade = unid.SK_Unidade
-- === NOVOS JOINS ===
-- Junta com a nossa nova VIEW da última consulta
LEFT JOIN
    vw_paciente_ultima_consulta_info ulc ON pac.SK_Paciente = ulc.SK_Paciente
-- Junta com a dimensão procedimento para pegar os nomes e preços
LEFT JOIN
    DIM_PROCEDIMENTO proc ON ulc.SK_Procedimento = proc.SK_Procedimento;    