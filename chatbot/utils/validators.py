class Validators:
    @staticmethod
    def validar_nota(valor: str) -> tuple[bool, int, str]:
        '''
        Valida se o valor é uma nota válida (1-10)
        Retorna: (is_valid, nota, mensagem_erro)
        '''
        try:
            nota = int(valor.strip())
           
            if 1 <= nota <= 10:
                return (True, nota, "")
            else:
                return (False, 0, "⚠️ Por favor, digite um número entre **1 e 10**.")
       
        except ValueError:
            return (False, 0, "⚠️ Por favor, digite apenas um **número** entre 1 e 10.")
   
    @staticmethod
    def eh_comando_iniciar(texto: str) -> bool:
        '''Verifica se o texto é um comando para iniciar a pesquisa'''
        comandos = ['iniciar', 'começar', 'start', 'sim', 'ok']
        return texto.lower().strip() in comandos
   
    @staticmethod
    def eh_comando_nova_pesquisa(texto: str) -> bool:
        '''Verifica se o texto é um comando para nova pesquisa'''
        comandos = ['nova pesquisa', 'nova', 'reiniciar', 'recomeçar']
        return texto.lower().strip() in comandos