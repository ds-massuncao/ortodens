import psycopg2
from typing import Dict, Any
from config.database import DB_CONFIG
import streamlit as st
 
class FeedbackService:
    @staticmethod
    def salvar_feedback(respostas: Dict[str, Any]) -> bool:
        '''Salva o feedback no banco de dados com tratamento de erros'''
       
        # Lista explícita de campos para garantir a ordem e validar a existência
        campos_obrigatorios = [
            'id_consulta','dentista_atendimento', 'dentista_tecnica', 'dentista_empatia',
            'recepcionista_cordialidade', 'recepcionista_eficiencia',
            'assistente_suporte', 'clinica_limpeza', 'clinica_equipamentos',
            'clinica_ambiente'
        ]
 
        # Query de inserção
        query = """
        INSERT INTO tb_feedback (
            id_consulta, dentista_atendimento, dentista_tecnica, dentista_empatia,
            recepcionista_cordialidade, recepcionista_eficiencia,
            assistente_suporte, clinica_limpeza, clinica_equipamentos,
            clinica_ambiente
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id;
        """
 
        try:
            # Preparar valores. Gera KeyError se faltar campo.
            valores = tuple(respostas[campo] for campo in campos_obrigatorios)
 
            # Conectar usando Context Manager
            with psycopg2.connect(**DB_CONFIG) as conn:
                with conn.cursor() as cur:
                    # Executar a inserção
                    cur.execute(query, valores)
                    feedback_id = cur.fetchone()[0]
                   
                    # Commit da transação
                    conn.commit()
                   
                    st.success(f"✅ Feedback salvo com sucesso! ID: {feedback_id}")
                    return True
       
        except KeyError as e:
            st.error(f"❌ Erro interno: Dados incompletos. Faltando o campo: {e}")
            return False
 
        except psycopg2.Error as e:
            # 23505 = Unique Violation (Tentativa de duplicar registro único)
            if e.pgcode == '23505':
                st.warning(f"⚠️ A consulta **{respostas.get('id_consulta')}** já foi avaliada anteriormente.")
            # 23503 = Foreign Key Violation (O ID da consulta não existe na tabela original)
            elif e.pgcode == '23503':
                st.error(f"❌ O código de consulta **{respostas.get('id_consulta')}** não foi encontrado no sistema.")
            else:
                st.error("❌ Erro ao salvar no banco de dados.")
           
            return False
           
        except Exception as e:
            st.error("❌ Erro inesperado ao salvar feedback.")
            return False
 
    @staticmethod
    def criar_tabela() -> bool:
        '''Cria a tabela tb_feedback se não existir'''
       
        create_table_query = """
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
            CONSTRAINT uq_consulta_feedback UNIQUE (id_consulta)
        );
        """
       
        try:
            with psycopg2.connect(**DB_CONFIG) as conn:
                with conn.cursor() as cur:
                    cur.execute(create_table_query)
                    conn.commit()
                   
            st.success("✅ Tabela tb_feedback criada/verificada com sucesso!")
            return True
           
        except psycopg2.Error as e:
            st.error(f"❌ Erro ao criar tabela: {e}")
            return False
           
        except Exception as e:
            st.error(f"❌ Erro inesperado: {e}")
            return False
 
 
 
 
    @staticmethod
    def testar_conexao() -> bool:
        '''Testa a conexão com o banco de dados'''
        try:
            with psycopg2.connect(**DB_CONFIG) as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT version();")
                    versao = cur.fetchone()
                    st.success(f"✅ Conexão com PostgreSQL estabelecida!")
                    st.info(f"Versão: {versao[0]}")
                    return True
           
        except psycopg2.Error as e:
            st.error(f"❌ Erro ao conectar ao banco: {e}")
            st.error("Verifique as configurações no arquivo .env")
            return False
           
        except Exception as e:
            st.error(f"❌ Erro inesperado: {e}")
            return False
 
 
 
 
    @staticmethod
    def contar_feedbacks() -> int:
        '''Retorna o número total de feedbacks registrados'''
        try:
            with psycopg2.connect(**DB_CONFIG) as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT COUNT(*) FROM tb_feedback;")
                    total = cur.fetchone()[0]
                    return total
           
        except Exception as e:
            st.error(f"Erro ao contar feedbacks: {e}")
            return 0
       
    @staticmethod
    def verificar_estrutura_tabela() -> bool:
        '''Verifica se a tabela existe e sua estrutura'''
        try:
            with psycopg2.connect(**DB_CONFIG) as conn:
                with conn.cursor() as cur:
                    # Verificar se a tabela existe
                    cur.execute("""
                        SELECT EXISTS (
                            SELECT FROM information_schema.tables
                            WHERE table_name = 'tb_feedback'
                        );
                    """)
                    existe = cur.fetchone()[0]
                   
                    if existe:
                        st.success("✅ Tabela tb_feedback existe!")
                       
                        # Ver a estrutura
                        cur.execute("""
                            SELECT column_name, data_type, is_nullable
                            FROM information_schema.columns
                            WHERE table_name = 'tb_feedback'
                            ORDER BY ordinal_position;
                        """)
                        colunas = cur.fetchall()
                       
                        st.write("📋 **Estrutura da tabela:**")
                        for col in colunas:
                            st.write(f"- **{col[0]}** ({col[1]}) - Nullable: {col[2]}")
                       
                        return True
                    else:
                        st.error("❌ Tabela tb_feedback NÃO existe!")
                        return False
           
        except Exception as e:
            st.error(f"❌ Erro ao verificar tabela: {e}")
            return False