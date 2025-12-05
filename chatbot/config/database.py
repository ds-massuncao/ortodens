import os
from dotenv import load_dotenv
 
load_dotenv()
 
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'sorriso_metalico'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'SENHA'),
    'port': int(os.getenv('DB_PORT', 5432))
}