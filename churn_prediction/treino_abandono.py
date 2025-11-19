import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
import joblib
import warnings

# Ignora avisos
warnings.filterwarnings('ignore', category=FutureWarning)
warnings.filterwarnings('ignore', category=UserWarning)

# --- 1. Carregar e Preparar os Dados ---
print("Carregando dados de treino.csv...")
try:
    data = pd.read_csv("churn_prediction/master_data_corrigido.csv")
except FileNotFoundError:
    print("ERRO: O arquivo 'treino.csv' não foi encontrado.")
    exit()

# Limpeza
data = data.dropna(subset=['flag_churn'])
data['flag_churn'] = data['flag_churn'].astype(int)

# --- 2. Definir Features (X) e Alvo (y) ---
print("Definindo features (X) e alvo (y)...")
y = data['flag_churn']
X = data.drop('flag_churn', axis=1)

# === MUDANÇA IMPORTANTE AQUI ===
# Adicionamos as novas colunas de satisfação à lista
numeric_features = [
    'qtd_consultas_no_mes', 
    'valor_pago_no_mes',
    'avg_nota_geral',              
    'avg_nota_atendimento',        
    'avg_nota_dentista',
    'valor_do_ultimo_procedimento'                         
]
categorical_features = [
    'faixa_etaria', 
    'cidade_paciente', 
    'estado_paciente', 
    'nome_convenio',
    'cidade_unidade',
    'nome_procedimento'
]
# =================================

# --- 3. Transformar Dados Categóricos (One-Hot Encoding) ---
print("Criando o 'preprocessor'...")
preprocessor = ColumnTransformer(
    transformers=[
        ('num', 'passthrough', numeric_features),
        ('cat', OneHotEncoder(handle_unknown='ignore', sparse_output=False), categorical_features)
    ],
    remainder='drop'
)

X_processed = preprocessor.fit_transform(X)

# --- 4. Dividir Dados para Treino e Teste ---
print("Dividindo dados para treino (80%) e teste (20%)...")
X_train, X_test, y_train, y_test = train_test_split(X_processed, y, test_size=0.2, random_state=42, stratify=y)

# --- 5. Treinar o Modelo ---
print("Treinando o novo modelo...")
model = RandomForestClassifier(random_state=42, class_weight='balanced', n_estimators=100)
model.fit(X_train, y_train)

# --- 6. Avaliar o Modelo ---
print("Avaliando o modelo...")
y_pred = model.predict(X_test)

print("\n" + "="*30)
print("--- RELATÓRIO DE AVALIAÇÃO (COM DADOS DE SATISFAÇÃO) ---")
print(f"Acurácia: {accuracy_score(y_test, y_pred):.2f}")
print("\nMatriz de Confusão:")
print(confusion_matrix(y_test, y_pred))
print("\nRelatório de Classificação:")
print(classification_report(y_test, y_pred, target_names=['Não-Churn (0)', 'Churn (1)']))
print("="*30)

# --- 7. Salvar o Modelo e o Preprocessor ---
print("\nSalvando o NOVO modelo em 'modelo_churn2.pkl'...")
joblib.dump(model, 'modelo_churn_para_uso.pkl')

print("Salvando o NOVO preprocessor em 'preprocessor2.pkl'...")
joblib.dump(preprocessor, 'preprocessor_para_uso.pkl')

print("\n--- PROCESSO CONCLUÍDO! ---")