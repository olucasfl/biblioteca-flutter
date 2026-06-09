# Projeto: Biblioteca (app acadêmico Flutter)

## Contexto
App mobile em Flutter para a disciplina de Desenvolvimento Mobile da faculdade.
É um trabalho acadêmico que será apresentado a um professor. Objetivo: um app
de biblioteca de livros simples, organizado e fácil de explicar.

## Regras OBRIGATÓRIAS
- Nível iniciante/intermediário. Nada que um estudante não conseguiria explicar.
- SEM comentários no código. Nenhum comentário em nenhum arquivo.
- Apenas Flutter/Dart puro. NÃO adicionar pacotes externos (nada de provider,
  riverpod, bloc, http, sqflite, etc.). Usar só o que já vem no Flutter.
- Sem backend, sem internet, sem banco de dados. Todos os dados ficam em memória.
- Estado simples: usar apenas setState e passagem de parâmetros entre telas.
- Imagens: NÃO usar imagens da internet. Para a "capa" dos livros, usar um
  quadrado colorido com a inicial ou um ícone.
- Código limpo e indentado. Textos da interface em português.

## Estrutura (dentro de lib/)
- lib/main.dart        -> ponto de entrada
- lib/models/          -> classes de modelo (Livro, Usuario)
- lib/data/            -> lista fixa de livros + listas em memória (usuarios, favoritos)
- lib/screens/         -> uma tela por arquivo

## Telas
1. Login: e-mail, senha, botão Entrar, link "Criar conta". Valida campos vazios.
2. Cadastro: nome, e-mail, senha. Salva na lista de usuários e volta pro login.
3. Home (lista de livros): lista com capa-ícone, título e autor. Campo de busca
   que filtra por título/autor. Barra inferior com "Início" e "Favoritos".
4. Detalhe do livro: capa, título, autor, gênero, descrição e botão de favoritar.
5. Favoritos: lista apenas dos livros marcados como favoritos.

## Funcionalidades (mínimo 5)
Cadastro, Login, Listagem, Busca/filtro, Detalhe do livro, Favoritar/desfavoritar.

## Dados
- Lista fixa de ~10 livros conhecidos (título, autor, gênero, descrição curta) em lib/data/.
- Usuários e favoritos ficam em listas em memória (podem resetar ao fechar, tudo bem).

## UI/UX
- Material Design 3 (padrão do Flutter).
- Cor principal: índigo. Fundos claros, cards com cantos arredondados, visual limpo.