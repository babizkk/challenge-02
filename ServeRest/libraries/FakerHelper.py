"""
Biblioteca para gerar dados aleatórios para os testes
Usa a biblioteca Faker para dados mais realistas
"""
import random
from faker import Faker


class FakerHelper:
    """Gera dados aleatórios para uso nos testes"""
    
    def __init__(self):
        self.fake = Faker('pt_BR')
        
        self.produtos = [
            "Mouse", "Teclado", "Monitor", "Notebook", "Smartphone",
            "Tablet", "Headset", "Webcam", "Impressora", "Scanner",
            "Roteador", "Switch", "Mousepad", "Cadeira", "Mesa",
            "Luminaria", "Suporte", "Hub USB", "Pendrive", "HD Externo"
        ]
    
    def gerar_nome(self):
        """Gera um nome aleatório"""
        return self.fake.name()
    
    def gerar_email(self):
        """Gera um email aleatório único"""
        return self.fake.unique.email()
    
    def gerar_senha(self, tamanho=8):
        """Gera uma senha aleatória"""
        return self.fake.password(length=tamanho, special_chars=False)
    
    def gerar_nome_produto(self):
        """Gera um nome de produto aleatório"""
        produto = random.choice(self.produtos)
        numero = random.randint(100, 999)
        modelo = random.choice(['Pro', 'Plus', 'Max', 'Ultra', 'Premium', 'Standard'])
        return f"{produto} {modelo} {numero}"
    
    def gerar_descricao(self):
        """Gera uma descrição aleatória"""
        return self.fake.text(max_nb_chars=100)
    
    def gerar_preco(self, minimo=100, maximo=9999):
        """Gera um preço aleatório"""
        return random.randint(minimo, maximo)
    
    def gerar_quantidade(self, minimo=1, maximo=100):
        """Gera uma quantidade aleatória"""
        return random.randint(minimo, maximo)
    
    def gerar_numero_aleatorio(self, minimo=1, maximo=1000):
        """Gera um número aleatório"""
        return random.randint(minimo, maximo)
    
    def gerar_texto_aleatorio(self, tamanho=10):
        """Gera um texto aleatório"""
        return self.fake.text(max_nb_chars=tamanho)
    