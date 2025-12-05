import psycopg2
from psycopg2.extras import RealDictCursor
from config.database import DB_CONFIG
import streamlit as st
 
class DatabaseConnection:
    @staticmethod
    def get_connection():
        '''Cria e retorna uma conexão com o banco de dados'''
        try:
            conn = psycopg2.connect(**DB_CONFIG)
            return conn
        except Exception as e:
            st.error(f"Erro ao conectar ao banco de dados: {e}")
            return None
   
    @staticmethod
    def execute_query(query, params=None, fetch=False):
        '''Executa uma query no banco de dados'''
        conn = None
        cur = None
        try:
            conn = DatabaseConnection.get_connection()
            if conn is None:
                return None
           
            cur = conn.cursor(cursor_factory=RealDictCursor)
            cur.execute(query, params)
           
            if fetch:
                result = cur.fetchall()
                conn.close()
                return result
            else:
                conn.commit()
                conn.close()
                return True
               
        except Exception as e:
            if conn:
                conn.rollback()
            st.error(f"Erro ao executar query: {e}")
            return None
        finally:
            if cur:
                cur.close()
            if conn:
                conn.close()