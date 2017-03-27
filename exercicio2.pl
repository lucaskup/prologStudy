%--exercício a--------------------------------------------------

%Caso base, linha igual a 0 e Coluna igual a 1, deve unificar somente quando H = E pois esta acessando o indice devido
indice(E,I,J,[H|T]) :-
    I = 0,
    J = 1,
    H = E.

%Caso 1, a linha ainda é maior que 1, logo temos que seguir validando as demais linhas e decrementando I
indice(E,I,J,[H|T]) :-
    I > 1,
    I1 is I - 1,
    indice(E,I1,J,T).

%Caso 2, linha igual a 1 achou a linha certa, agora precisa continuar avaliando a lista contida em H,
%para evitar que continue unificando com esse caso o valor de I segue zerado
indice(E,I,J,[H|T]) :-
    I = 1,
    indice(E,0,J,H).
%Caso 3, I = 0 ou seja, já achou a linha, porém ainda não esta na coluna certa (J>0) nesse caso segue para a 
%próxima coluna
indice(E,I,J,[H|T]) :-
    I = 0,
    J > 1,
    J1 is J - 1,
    indice(E,0,J1,T).

%--exercício b--------------------------------------------------

% Caso seja a linha 0 (significa que esta acessando a linha desejada)
% e a coluna for igual a 0, o elemento H2 deve ser igual a E e o 
% restante da linha deve ser igual T1 = T2
altera(E, [H1|T1], I, J, [H2|T2]) :- 
    I = 0,
    J = 1,
    E = H2,
    T1 = T2.

%se nao estamos na linha desejada, as linhas H1 e H2 devem ser iguais
%seguimos para o teste da próxima linha
altera(E, [H1|T1], I, J, [H2|T2]) :- 
    I > 1,
    H1 = H2,
    I1 is I - 1,
    altera(E, T1, I1, J, T2).
%Se chegamos na linha desejada, o restante da tabela deve ser igual e seguimos avaliando as colunas
altera(E, [H1|T1], I, J, [H2|T2]) :- 
    I = 1,
    T1 = T2,
    altera(E, H1, 0, J, H2).
% Se a coluna for diferente de 1 temos que fazer os valores das colunas da tabela original
% ser igual a nova tabela e seguir testando.
altera(E, [H1|T1], I, J, [H2|T2]) :- 
    I = 0,
    J \= 1,
    J1 is J - 1,
    H1 = H2,
    altera(E, T1, 0, J1, T2).

%--exercício c--------------------------------------------------
%Uma matriz é transposta da outra se a primeira coluna da primeira 
%é igual a primeira linha da segunda, recursivamente
transposta(M,[H2|T2]):-
    primColuna(M,X,H2),
    transposta(X,T2).

%Caso base, transposta de uma matriz vazia é igual a matriz vazia
transposta([],[]).
% Esse teste serve para assegurar que a tabela é uma matriz,
% como isso é feito, bom, se o primeiro elemento da primeira matriz esta
% vazio, todos os demais devem estar vazios tambem, entao segue a iteracao
% com a esperança de cair no caso base
transposta([[]|T],[]) :-
    transposta(T,[]).

%predicado auxiliar para tratar o exercício, captira a primera coluna da matriz e 
% da como saida a tabela restante e uma lista representando a primeira coluna
primColuna([[H|T1]|R1],[H2|T2],[H3|T3]) :-
    T1 = H2,
    H = H3,
    primColuna(R1,T2,T3).
primColuna([],[],[]).


%--exercício d--------------------------------------------------

%quando o indice é igual a 1 temos que inserir a linha L na matriz e seguir avaliando
insere_lin([H1|T1], I, L,[H2|T2]) :-
    I = 1,
    H2 = L,
    I1 is 1 - 1,
    insere_lin([H1|T1], I1, L,T2).

%quando o indice não é 1 basta copiar as listas
insere_lin([H1|T1], I, L,[H2|T2]) :-
    I \= 1,
    H2 = H1,
    I1 is I - 1,
    insere_lin(T1, I1, L,T2).

%Caso base 1 listas acabaram e indice diferente de 1, missao cumprida
insere_lin(T1, I, _, T2) :-
    I \= 1,
    T1 = [],
    T2 = [].

%Caso base 2 Lista 1 acabou e indice igual a 1, insercao na lista 2 ultima posicao
insere_lin(T1, I, L, [H2|T2]) :-
    I = 1,
    T1 = [],
    H2 = L,
    T2 = [].
    


