-- Active: 1756490077951@@127.0.0.1@5432@dw_sorriso_metalico
CREATE OR REPLACE FUNCTION fn_atualiza_faixa_etaria()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcula a idade e atribui a faixa etaria ao campo da *nova* linha (NEW)
    NEW.Faixa_Etaria = 
        CASE
            WHEN EXTRACT(YEAR FROM AGE(NEW.Data_Nascimento)) <= 12 THEN '0-12 (Criança)'
            WHEN EXTRACT(YEAR FROM AGE(NEW.Data_Nascimento)) <= 17 THEN '13-17 (Adolescente)'
            WHEN EXTRACT(YEAR FROM AGE(NEW.Data_Nascimento)) <= 29 THEN '18-29 (Jovem Adulto)'
            WHEN EXTRACT(YEAR FROM AGE(NEW.Data_Nascimento)) <= 49 THEN '30-49 (Adulto)'
            WHEN EXTRACT(YEAR FROM AGE(NEW.Data_Nascimento)) <= 64 THEN '50-64 (Meia-idade)'
            ELSE '65+ (Idoso)'
        END;
    
    -- Retorna a linha modificada para ser inserida/atualizada
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_dim_paciente_faixa_etaria
-- O trigger dispara ANTES de um INSERT ou UPDATE...
BEFORE INSERT OR UPDATE OF Data_Nascimento
-- ...na sua tabela de paciente...
ON DIM_PACIENTE
-- ...para cada linha afetada.
FOR EACH ROW
-- ...ele executa a função que criamos.
EXECUTE FUNCTION fn_atualiza_faixa_etaria();

CREATE OR REPLACE FUNCTION sp_contar_pacientes_por_faixa_etaria()
-- Retorna uma tabela com os resultados
RETURNS TABLE(faixa_etaria_out VARCHAR, contagem_out BIGINT) AS $$
DECLARE
    -- 1. Variáveis para construir a query dinâmica
    v_tabela_sql TEXT := 'DIM_PACIENTE';
    v_coluna_sql TEXT := 'Faixa_Etaria';
    v_query_dinamica TEXT;
    
    -- 2. O cursor (não vinculado) que será usado pela query dinâmica
    v_cursor REFCURSOR;
    
    -- 3. Variáveis para guardar os dados do loop
    v_faixa_atual VARCHAR;
    v_contagem_atual BIGINT;
BEGIN
    -- 1. Construir a Query Dinâmica como uma string
    -- Esta query já faz a estatística (contagem) que precisamos
    v_query_dinamica := FORMAT(
        'SELECT %I, COUNT(*) FROM %I WHERE Flag_Versao_Atual = TRUE GROUP BY %I',
        v_coluna_sql, 
        v_tabela_sql, 
        v_coluna_sql
    );
    
    -- 2. Abrir o Cursor (não vinculado) para a query dinâmica
    OPEN v_cursor FOR EXECUTE v_query_dinamica;
    
    -- 3. Percorrer (Loop) os registros do cursor
    LOOP
        -- 4. Pegar a próxima linha do cursor
        FETCH v_cursor INTO v_faixa_atual, v_contagem_atual;
        
        -- 5. Sair do loop se não houver mais linhas
        EXIT WHEN NOT FOUND;
        
        -- 6. "Retornar" a linha atual para a tabela de saída da função
        faixa_etaria_out := v_faixa_atual;
        contagem_out := v_contagem_atual;
        RETURN NEXT;
        
    END LOOP;
    
    -- 7. Fechar o cursor
    CLOSE v_cursor;
    
END;
$$ LANGUAGE plpgsql;


-- Este bloco anonimo calculou a faixa etaria dos dados que já estavam armazenado no banco de dados
DO $$
BEGIN
    RAISE NOTICE 'Iniciando atualização da Faixa Etária...';

    UPDATE DIM_PACIENTE
    SET Faixa_Etaria = 
        CASE
            WHEN EXTRACT(YEAR FROM AGE(Data_Nascimento)) <= 12 THEN '0-12 (Criança)'
            WHEN EXTRACT(YEAR FROM AGE(Data_Nascimento)) <= 17 THEN '13-17 (Adolescente)'
            WHEN EXTRACT(YEAR FROM AGE(Data_Nascimento)) <= 29 THEN '18-29 (Jovem Adulto)'
            WHEN EXTRACT(YEAR FROM AGE(Data_Nascimento)) <= 49 THEN '30-49 (Adulto)'
            WHEN EXTRACT(YEAR FROM AGE(Data_Nascimento)) <= 64 THEN '50-64 (Meia-idade)'
            ELSE '65+ (Idoso)'
        END
    WHERE 
        Flag_Versao_Atual = TRUE;

    RAISE NOTICE 'Atualização concluída.';
END;
$$;