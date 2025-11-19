# 📊 Projeto Integrador III - Análise Institucional da Clínica Sorriso Metálico

![GitHub repo size](https://img.shields.io/github/repo-size/seu-usuario/seu-repositorio)
![GitHub language count](https://img.shields.io/github/languages/count/seu-usuario/seu-repositorio)
![GitHub top language](https://img.shields.io/github/languages/top/seu-usuario/seu-repositorio)
![License](https://img.shields.io/github/license/seu-usuario/seu-repositorio)

Este repositório apresenta o **Projeto Integrador III** do curso de **Big Data para Negócios** da **FATEC Ipiranga**, focando na análise institucional da **Rede de Clínicas Sorriso Metálico** e na aplicação de **Business Intelligence (BI)** e **Big Data**.

---

## 🛠 Tecnologias e Ferramentas Utilizadas

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=sql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat&logo=mongodb&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=flat&logo=microsoft-power-bi&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=flat&logo=jupyter&logoColor=white)

---

## 📌 Sumário

- [Integrantes do Projeto](#-integrantes-do-projeto)
- [Sobre o Projeto](#-sobre-o-projeto)  
- [Sobre a Empresa](#-sobre-a-empresa)  
- [Objetivo da Empresa](#-objetivo-da-empresa)  
- [Missão, Visão e Valores](#-missão-visão-e-valores)  
- [Aplicação de Business Intelligence](#-aplicação-de-business-intelligence)  
- [Artefatos de Programação em Banco de Dados](#-artefatos-de-Programação-em-Banco-de-Dados)
- [Referência](#-referência)  
- [Contato](#-contato)  

---
## Integrantes do Projeto

**Bruno Pereira de Souza Costa** - 2041382421009</br>
**Cauan Santos Alves Jacinto** - 2041382421026</br>
**Jadilson de Souza Cardoso** - 2041382421011</br>
**Marcos Assunção da Silva** - 2041382421038</br>
**Renato Fidelis Fausto Silva** - 2041382421008</br>

---

## 📂 Sobre o Projeto

O projeto tem como objetivos principais:

- Compreender e aplicar técnicas de **ETL (Extract, Transform, Load)** em **bancos de dados relacionais**;  
- Construir **modelos dimensionais** para análise de indicadores e suporte à decisão;  
- Desenvolver um **Data Warehouse** para centralização de informações estratégicas;  
- Aplicar técnicas de **mineração de dados** utilizando **estatística e Inteligência Artificial** para gerar insights;  
- Compreender as etapas de **geração de conhecimento** a partir de dados organizacionais.

---

## 🏢 Sobre a Empresa

A **Rede de Clínicas Sorriso Metálico**, fundada em 2002, consolidou-se no mercado odontológico oferecendo **serviços de qualidade a preços acessíveis**.  

Inicialmente especializada em **ortodontia**, expandiu sua atuação para **estética dental, clínica geral, implantes, próteses e odontopediatria**.  

A clínica possui **infraestrutura moderna** e protocolos rigorosos de **biossegurança e esterilização**, garantindo segurança, conforto e credibilidade aos pacientes (SORRISO METÁLICO, 2025).

---

## 🎯 Objetivo da Empresa

A clínica busca **democratizar o acesso a serviços odontológicos de excelência**, promovendo **saúde bucal e bem-estar dos pacientes**.  

Reconhece o **impacto transformador do sorriso**, fortalecendo autoestima, confiança e qualidade de vida dos indivíduos (SORRISO METÁLICO, 2025).

---

## 🌟 Missão, Visão e Valores

- **Missão:** Atendimento odontológico de excelência, aliado a preços acessíveis, promovendo saúde bucal e bem-estar.  
- **Visão:** Tornar-se referência no setor odontológico, transformando sorrisos de forma acessível e responsável.  
- **Valores:** Comprometimento, honestidade, transparência, cortesia, respeito aos clientes e atendimento personalizado (SORRISO METÁLICO, 2025).

---

## 💻 Aplicação de Business Intelligence

O projeto aplica técnicas avançadas de **BI**:

- **ETL:** Extração, transformação e carga de dados clínicos em bancos relacionais;  
- **Modelos dimensionais:** Criação de tabelas fato e dimensão para análise de desempenho;  
- **Data Warehouse:** Centralização de informações estratégicas;  
- **Mineração de dados e IA:** Identificação de padrões e geração de insights;  
- **Geração de conhecimento:** Transformação de dados brutos em informações estratégicas.

---

## Artefatos de Programação em Banco de Dados  

**1. Trigger: Cálculo Automático de Faixa Etária (APBD)**
Esta seção documenta a função fn_atualiza_faixa_etaria() e o trigger tg_dim_paciente_faixa_etaria associado a ela.

**Objetivo e Relevância**
- **O que faz:** O trigger calcula e preenche automaticamente a coluna Faixa_Etaria (ex: "18-29 (Jovem Adulto)") na tabela DIM_PACIENTE.
- **Quando dispara:** Ele é acionado antes (BEFORE) que qualquer novo paciente seja inserido (INSERT) ou que a Data_Nascimento de um paciente existente seja alterada (UPDATE).
- **Benefício para o Projeto:** Garante a consistência e integridade dos dados demográficos. Ao automatizar esse cálculo no nível do banco de dados, eliminamos a chance de erro humano ou falha do ETL, garantindo que a faixa etária esteja sempre correta e preenchida. Isso é vital para a segmentação de pacientes e para o modelo de Machine Learning.

**2. Stored Procedure: Estatística de Pacientes por Faixa Etária (APBD)**
Esta seção documenta a stored procedure (função) sp_contar_pacientes_por_faixa_etaria(), que atende ao requisito de usar um cursor não vinculado e query dinâmica.

**Objetivo e Relevância**
- **Estatística Calculada:** A Contagem Total (COUNT) de pacientes para cada categoria de Faixa_Etaria.
- **Como funciona (Requisito):** A função constrói uma query SQL dinamicamente como uma string. Em seguida, ela abre um REFCURSOR (cursor não vinculado) para executar essa string e percorre (faz um loop) os resultados, retornando-os em formato de tabela.
- **Relevância para o Projeto:** Esta é uma estatística de negócio fundamental. Ela responde à pergunta: "Qual é o perfil demográfico principal da nossa clínica?". Com essa informação, a gestão pode tomar decisões estratégicas de marketing (focar em implantes para "Idosos" ou ortodontia para "Adolescentes") e entender melhor o público que está analisando no modelo de churn.
- **Tabelas e Colunas Usadas:**
    **- Tabela:** DIM_PACIENTE
    **- Colunas:** Faixa_Etaria (para agrupar) e Flag_Versao_Atual (para filtrar).

**3. Análise Preditiva: Previsão de Risco de Churn**
Esta seção documenta o modelo de Machine Learning e o pipeline de dados construído para prever a probabilidade de abandono (churn) de pacientes ativos.

**Objetivo e Relevância**
- **Objetivo:** Identificar proativamente quais pacientes ativos (que ainda não abandonaram a clínica) possuem alta probabilidade de se tornarem churn nos próximos meses.
- **Como funciona:** O modelo utiliza um algoritmo de Random Forest Classifier treinado com dados históricos do Data Warehouse. Ele analisa padrões comportamentais (frequência, pagamentos), demográficos, de sentimento (pesquisas de satisfação) e de contexto (tipo de procedimento) para calcular uma probabilidade de risco (0% a 100%).
- **Relevância para o Projeto:** Transforma a estratégia da clínica de reativa para proativa.
    - **Antes:** A clínica só percebia a perda do cliente após 180 dias de inatividade.
    - **Agora:** O sistema gera uma "Lista de Ação" com precisão de 73%, permitindo que a equipe de retenção entre em contato com pacientes em risco antes que eles deixem de     frequentar a clínica, protegendo a receita recorrente.

**Arquitetura da Solução**
O processo funciona em um ciclo automatizado:
- **Extração:** O Data Warehouse gera um "retrato" atual dos pacientes ativos.
- **Inferência:** Um script Python carrega o modelo treinado (.pkl) e calcula a probabilidade.
- **Carga:** As probabilidades são salvas na coluna Probabilidade_Churn da tabela DIM_PACIENTE.

**Performance do Modelo (Dados de Validação):**
- **Recall (Captura):** 79% (Identifica 8 em cada 10 potenciais cancelamentos).
- **Precision (Assertividade):** 73% (A cada 100 alertas gerados, 73 são reais riscos de churn).

---

## 📚 Referência

SORRISO METÁLICO. *Quem somos*. Disponível em: <https://dentistasorrisometalico.com.br/quem-somos/>. Acesso em: 25 ago. 2025.

---


*Este repositório integra o Projeto Integrador III da FATEC Ipiranga, unindo análise institucional, Business Intelligence e técnicas de Big Data aplicadas ao setor odontológico.*
