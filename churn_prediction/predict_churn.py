import joblib
import pandas as pd
import warnings
import sys

# Ignora avisos para manter a saída limpa
warnings.filterwarnings('ignore', category=FutureWarning)
warnings.filterwarnings('ignore', category=UserWarning)

# --- Nomes dos arquivos (Constantes) ---
INPUT_FILE = "churn_prediction/master_data_dw1.csv"
OUTPUT_FILE = 'churn_prediction/previsoes_feitas_para_uso.csv' 

# 🚨 ATENÇÃO: Coloque o nome dos seus ÚLTIMOS e MELHORES arquivos .pkl
MODEL_FILE = 'churn_prediction/modelo_churn_para_uso.pkl' 
PREPROCESSOR_FILE = 'churn_prediction/preprocessor_para_uso.pkl' 

# --- DEFINIÇÃO FINAL DAS FEATURES (DO SEU MELHOR MODELO) ---
COLUNAS_NUMERICAS = [
    'qtd_consultas_no_mes', 
    'valor_pago_no_mes',
    'avg_nota_geral',
    'avg_nota_atendimento',
    'avg_nota_dentista',
    'valor_do_ultimo_procedimento'
]
COLUNAS_CATEGORICAS = [
    'faixa_etaria', 
    'cidade_paciente', 
    'estado_paciente', 
    'nome_convenio',
    'cidade_unidade',
    'nome_procedimento'
]
# -----------------------------------------------------------

def prever():
    print(f"Iniciando processo de previsão...")
    
    # --- 1. Carregar o Modelo e o Preprocessor ---
    try:
        model = joblib.load(MODEL_FILE)
        preprocessor = joblib.load(PREPROCESSOR_FILE)
        print(f"Modelo '{MODEL_FILE}' e preprocessor '{PREPROCESSOR_FILE}' carregados.")
    except FileNotFoundError:
        print(f"ERRO: Arquivos .pkl não encontrados.")
        print(f"Verifique os nomes em MODEL_FILE e PREPROCESSOR_FILE no script.")
        sys.exit(1)

    # --- 2. Carregar Novos Dados (do DW_A) ---
    try:
        novos_dados = pd.read_csv(INPUT_FILE)
        print(f"Lidos {len(novos_dados)} registros do arquivo '{INPUT_FILE}'.")
    except FileNotFoundError:
        print(f"ERRO: Arquivo de entrada '{INPUT_FILE}' não foi encontrado.")
        sys.exit(1)
        
    if 'sk_paciente' not in novos_dados.columns:
        print(f"ERRO: O arquivo '{INPUT_FILE}' deve conter a coluna 'sk_paciente'.")
        sys.exit(1)
        
    sk_pacientes = novos_dados['sk_paciente']
    
    # --- 3. Preparar os Novos Dados ---
    print("Processando novos dados com o preprocessor...")
    
    colunas_features = COLUNAS_NUMERICAS + COLUNAS_CATEGORICAS
    
    # Verifica se todas as colunas necessárias existem no CSV
    for col in colunas_features:
        if col not in novos_dados.columns:
            print(f"ERRO: A coluna '{col}' estava no treino mas não foi encontrada no 'para_prever.csv'.")
            sys.exit(1)
            
    X_new = novos_dados[colunas_features]
    X_processed = preprocessor.transform(X_new)
    
    # --- 4. Fazer as Previsões ---
    print("Calculando probabilidades de churn...")
    probabilidades = model.predict_proba(X_processed)
    prob_churn = probabilidades[:, 1]
    
    # --- 5. Salvar os Resultados ---
    print(f"Salvando resultados em '{OUTPUT_FILE}'...")
    df_resultados = pd.DataFrame({
        'sk_paciente_pred': sk_pacientes,
        'probabilidade_churn': prob_churn
    })
    
    df_resultados.to_csv(OUTPUT_FILE, index=False, float_format='%.4f')
    
    print("--- Previsão Concluída com Sucesso ---")

if __name__ == "__main__":
    prever()