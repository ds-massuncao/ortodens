import streamlit as st
from models.feedback import FeedbackModel
from services.feedback_service import FeedbackService
from utils.validators import Validators
import os
 
# Configuração da página
st.set_page_config(
    page_title="Pesquisa de Satisfação",
    page_icon="🦷",
    layout="centered"
)
 
def inicializar_sessao():
    '''Inicializa as variáveis de sessão'''
    if 'iniciado' not in st.session_state:
        st.session_state.iniciado = False
    if 'pergunta_atual' not in st.session_state:
        st.session_state.pergunta_atual = 0
    if 'respostas' not in st.session_state:
        st.session_state.respostas = {}
    if 'historico_chat' not in st.session_state:
        st.session_state.historico_chat = []
    if 'concluido' not in st.session_state:
        st.session_state.concluido = False
 
def adicionar_mensagem(role: str, content: str):
    '''Adiciona mensagem ao histórico do chat'''
    st.session_state.historico_chat.append({"role": role, "content": content})
 
def resetar_pesquisa():
    '''Reseta a pesquisa COMPLETAMENTE'''
    st.session_state.iniciado = False
    st.session_state.pergunta_atual = 0
    st.session_state.respostas = {}
    st.session_state.historico_chat = []
    st.session_state.concluido = False  # ✅ JÁ ESTÁ RESETANDO
 
 
# --- NOVA FUNÇÃO AUXILIAR ---
def finalizar_pesquisa():
    '''Tenta salvar os dados e finalizar a pesquisa'''
   
    # O FeedbackService já cuida de mostrar se deu certo (Success) ou erro (Error/Warning)
    resultado = FeedbackService.salvar_feedback(st.session_state.respostas)
   
    st.write(f"🔍 DEBUG - Resultado do salvamento: {resultado}")
   
    if resultado:
        st.session_state.concluido = True
       
        mensagem = """
        ✅ **Pesquisa concluída com sucesso!**
       
        Muito obrigado pelo seu tempo e feedback! 🙏
       
        **Para fazer outra pesquisa, digite:**
        - **'nova pesquisa'** ou
        - **'iniciar'**
        """
        adicionar_mensagem("assistant", mensagem)
        return True
   
    return False
 
def processar_resposta(user_input: str):
 
    # --- 1. Comando para iniciar (ACEITAR MESMO SE JÁ CONCLUÍDO) ---
    if Validators.eh_comando_iniciar(user_input):
        # Se já estava concluído, limpa tudo primeiro
        if st.session_state.concluido:
            resetar_pesquisa()
       
        st.session_state.iniciado = True
        pergunta = FeedbackModel.get_pergunta(0)
       
        if pergunta:
            resposta = f"**{pergunta.categoria}**\n\n{pergunta.pergunta}"
            adicionar_mensagem("assistant", resposta)
        return
   
    # --- 2. Comando para nova pesquisa ---
    if st.session_state.concluido and Validators.eh_comando_nova_pesquisa(user_input):
        resetar_pesquisa()
        adicionar_mensagem("assistant", "✅ Pesquisa resetada! Digite **'iniciar'** para começar novamente.")
        return
   
    # --- 3. Se concluído e não é comando válido, avisar ---
    if st.session_state.concluido:
        adicionar_mensagem("assistant", "Pesquisa já concluída! Digite **'nova pesquisa'** ou **'iniciar'** para começar outra.")
        return
   
    # --- 4. Se não iniciou ainda ---
    if not st.session_state.iniciado:
        adicionar_mensagem("assistant", "Digite **'iniciar'** para começar a pesquisa.")
        return
   
    # --- 5. Processar fluxo da pesquisa ---
    total_perguntas = FeedbackModel.get_total_perguntas()
   
    if st.session_state.pergunta_atual >= total_perguntas:
        finalizar_pesquisa()
        return
 
    # ===== VALIDAÇÃO DE NÚMEROS =====
    valor_para_salvar = None
 
    # CASO 1: Primeira pergunta (Código da Consulta)
    if st.session_state.pergunta_atual == 0:
        try:
            valor_para_salvar = int(user_input.strip())
            if valor_para_salvar <= 0:
                adicionar_mensagem("assistant", "⚠️ O código da consulta deve ser um **número positivo**. Tente novamente.")
                return
        except ValueError:
            adicionar_mensagem("assistant", "⚠️ O código da consulta deve conter apenas **números**. Tente novamente.")
            return
       
    # CASO 2: Demais perguntas (Notas 1-10)
    else:
        is_valid, nota, erro = Validators.validar_nota(user_input)
        if not is_valid:
            adicionar_mensagem("assistant", erro)
            return
        valor_para_salvar = nota
 
    # Obter pergunta atual para saber o campo do banco
    pergunta_atual = FeedbackModel.get_pergunta(st.session_state.pergunta_atual)
   
    if not pergunta_atual:
        adicionar_mensagem("assistant", "❌ Erro: Pergunta não encontrada.")
        return
   
    # Salva o valor
    st.session_state.respostas[pergunta_atual.campo] = valor_para_salvar
   
    # Avançar
    st.session_state.pergunta_atual += 1
   
    # Próxima pergunta
    if st.session_state.pergunta_atual < total_perguntas:
        proxima = FeedbackModel.get_pergunta(st.session_state.pergunta_atual)
        if proxima:
            instrucao = "\n\n*Digite um número de 1 a 10:*"
            resposta = f"**{proxima.categoria}**\n\n{proxima.pergunta}{instrucao}"
            adicionar_mensagem("assistant", resposta)
    else:
        finalizar_pesquisa()
 
 
   
def main():
   
    # Inicializar sessão
    inicializar_sessao()
   
   
   
    # Título
    st.title("🦷 Pesquisa de Satisfação")
    st.markdown("### Clínica Sorriso Metálico")
   
 
   
    # # Adicionar botão de teste de conexão (apenas para debug)
    # if st.sidebar.button("🔧 Testar Conexão DB", use_container_width=True):
    #     with st.spinner("Testando conexão..."):
    #         if FeedbackService.testar_conexao():
    #             total = FeedbackService.contar_feedbacks()
    #             st.sidebar.info(f"📊 Total de feedbacks: {total}")
    #         else:
    #             st.sidebar.error("Falha na conexão com o banco.")
 
    # if st.sidebar.button("🔍 Verificar Tabela", use_container_width=True):
    #     FeedbackService.verificar_estrutura_tabela()
 
 
    # Container do chat
    chat_container = st.container()
   
    with chat_container:
        # Exibir histórico
        for msg in st.session_state.historico_chat:
            with st.chat_message(msg["role"]):
                st.markdown(msg["content"])
       
        # Mensagem inicial (Boas vindas)
        if not st.session_state.iniciado and not st.session_state.concluido:
            if len(st.session_state.historico_chat) == 0:
                with st.chat_message("assistant"):
                    st.markdown("""
                    Olá! 👋 Seja bem-vindo(a) à pesquisa de satisfação da nossa clínica!
                   
                    Sua opinião é muito importante para melhorarmos nossos serviços.
                   
                    A pesquisa contém **9 perguntas** e leva apenas alguns minutos.
                    Você avaliará cada aspecto com nota de **1 a 10**, onde:
                    - **1** = Muito insatisfeito
                    - **10** = Muito satisfeito
                   
                    **Digite 'iniciar' para começar!**
                    """)
   
 
    # Input do usuário
    user_input = st.chat_input("Digite sua mensagem...")
   
    if user_input:
        # Adicionar mensagem do usuário
        adicionar_mensagem("user", user_input)
       
        with chat_container:
            with st.chat_message("user"):
                st.markdown(user_input)
       
        # Processar resposta
        processar_resposta(user_input)
        st.rerun()
   
    # Sidebar
    with st.sidebar:
 
        # 🎨 LOGO COM CAMINHO ABSOLUTO
        logo_path = os.path.join(os.path.dirname(__file__), "assets", "sm_logo.jpg")
       
        try:
            st.image(logo_path, use_container_width=True)
        except Exception as e:
            # Se não encontrar, usa emoji
            st.markdown("<h1 style='text-align: center; font-size: 60px;'>🦷</h1>", unsafe_allow_html=True)
       
       
        st.markdown("### 📊 Progresso")
       
        total_p = FeedbackModel.get_total_perguntas()
       
        if st.session_state.iniciado and not st.session_state.concluido:
            # Proteção para não dividir por zero ou mostrar progresso > 1
            if total_p > 0:
                progresso = min(st.session_state.pergunta_atual / total_p, 1.0)
                st.progress(progresso)
                st.markdown(f"**{st.session_state.pergunta_atual}** de **{total_p}** perguntas respondidas")
        elif st.session_state.concluido:
            st.progress(1.0)
            st.markdown("✅ **Pesquisa concluída!**")
        else:
            st.progress(0.0)
            st.markdown("Aguardando início...")
       
        st.markdown("---")
        st.markdown("### ℹ️ Escala de Avaliação")
        st.markdown("""
        - **1-2**: Muito insatisfeito
        - **3-4**: Insatisfeito
        - **5-6**: Neutro
        - **7-8**: Satisfeito
        - **9-10**: Muito satisfeito
        """)
       
        if st.button("🔄 Reiniciar Pesquisa", use_container_width=True):
            resetar_pesquisa()
            st.rerun()
 
if __name__ == "__main__":
    main()