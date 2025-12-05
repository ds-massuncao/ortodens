from typing import Dict, Optional
 
class Pergunta:
    def __init__(self, categoria: str, pergunta: str, campo: str):
        self.categoria = categoria
        self.pergunta = pergunta
        self.campo = campo
 
class FeedbackModel:
    PERGUNTAS = [
        Pergunta(
            categoria="Consulta",
            pergunta="Me informe o Código da Consulta",
            campo="id_consulta"
        ),
        Pergunta(
            categoria="Dentistas",
            pergunta="Como você avalia a **qualidade do atendimento** dos dentistas?",
            campo="dentista_atendimento"
        ),
        Pergunta(
            categoria="Dentistas",
            pergunta="Como você avalia a **técnica e competência** dos dentistas?",
            campo="dentista_tecnica"
        ),
        Pergunta(
            categoria="Dentistas",
            pergunta="Como você avalia a **empatia** dos dentistas?",
            campo="dentista_empatia"
        ),
        Pergunta(
            categoria="Recepcionistas",
            pergunta="Como você avalia a **cordialidade** das recepcionistas?",
            campo="recepcionista_cordialidade"
        ),
        Pergunta(
            categoria="Recepcionistas",
            pergunta="Como você avalia a **eficiência** das recepcionistas?",
            campo="recepcionista_eficiencia"
        ),
        Pergunta(
            categoria="Assistentes",
            pergunta="Como você avalia o **suporte dos assistentes** durante os procedimentos?",
            campo="assistente_suporte"
        ),
        Pergunta(
            categoria="Clínica",
            pergunta="Como você avalia a **limpeza** da clínica?",
            campo="clinica_limpeza"
        ),
        Pergunta(
            categoria="Clínica",
            pergunta="Como você avalia os **equipamentos** da clínica?",
            campo="clinica_equipamentos"
        ),
        Pergunta(
            categoria="Clínica",
            pergunta="Como você avalia o **ambiente** da clínica?",
            campo="clinica_ambiente"
        )
    ]
   
    @staticmethod
    def get_total_perguntas() -> int:
        return len(FeedbackModel.PERGUNTAS)
   
    @staticmethod
    def get_pergunta(indice: int) -> Optional[Pergunta]:
        if 0 <= indice < len(FeedbackModel.PERGUNTAS):
            return FeedbackModel.PERGUNTAS[indice]
        return None