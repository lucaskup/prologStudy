%--exercício a--------------------------------------------------

pertence(_,[]):-
    false.
pertence(E,[C|L]):-
    E==C;
    pertence(E,L).

%--exercicio b--------------------------------------------------

somatorio([],0).
somatorio([C|L],S):- 
    number(C),
    somatorio(L,SC),
    S is SC + C.

%--exercicio c--------------------------------------------------

indice(E, [H|T], I) :-
    %condicao base, se o elemento esta na cabeça da lista o índice é 1
    E = H,
    I is 1;
    %caso ele não esteja na cabeça, segue procurando, porém o índice deve sofrer incremento de 1
    indice(E,T,I1),    
    I is I1 + 1.

%--exercicio d--------------------------------------------------

%condição base, caso as listas estejam vazias retorna verdadeiro
altera(_, [], _, []).
altera(E, [H1|T1], I, [H2|T2]) :-
%existem duas possibilidades para construir a segunda lista
%caso o indice seja 1 a cabeça da segunda lista tem que ser
%criada com o elemento E, caso contrário com a cabeça da
%primeira lista    
    (I = 1,
    H2 = E;
    H2 = H1), 
    I1 is I - 1,
%cada iteracao constroi/testa uma posicao da lista
%e deve continuar com o restante da lista
    altera(E, T1, I1, T2).

%--exercicio e--------------------------------------------------

%para inverter a lista foi necessario criar um predicado com 3 argumentos para
%ACCumular/inverter a lista inicial, o predicado do exercicio recebe apenas 2 argumentos
%e aciona o segundo predicado passando uma lista em branco para ela inverter a lista
inverso(L, R):-
    inverso(L,[],R).
%caso base, se a lista original esta em vazia a lista acumulada esta invertida
%um exemplo disso seria
% [a|[b|[c]]] -> []
% [b|[c]] -> [a]
% [c] -> [b|[a]]
% [] -> [c|[b|[a]]]
inverso([], ACC, ACC).
%se nao caiu nos casos bases faz uma iteracao colocando a cabeca da lista no ACC
inverso([H1|T1], ACC,R) :-
    inverso(T1,[H1|ACC],R).

%--exercicio f --------------------------------------------------

%caso base, concatenar listas vazias gera listas vazias
concatena([],[],[]).
%caso 2, lista 1 esta fazia, lista 3 deve ser formado a partir da lista 2
concatena([], [H1|T1], [H3|T3]) :-
    H1 = H3, %a cabeca das listas 2 e 3 deve ser igual
    concatena([], T1, T3).%segue avaliando o restante das listas 2 e 3, lista 1 segue em branco
%caso 1, lista 1 tem elementos, lista 3 deve ser formado a partir da lista 1
concatena([H1|T1], L2, [H3|T3]) :-
    H1 = H3, %a cabeca das listas 1 e 3 deve ser igual
    concatena(T1, L2, T3). %segue avaliando o restante das listas 1 e 3, lista 2 somente repassa

%--exercicio g --------------------------------------------------

insere_elem([H1|T1], E, I, [H2|T2]) :- %– verdadeiro se o elemento E for inserido na posição de índice
%I da lista L1, resultando na lista L2. Falso caso contrário. Note que este predicado também
%deverá poder ser usado para eliminar um elemento da posição de índice I da lista L2, se esta
%lista for dada como fixa, enquanto L1 e E estiverem livres.
    I = 1,
    H2 = E,
    insere_elem([H1|T1], E, 0, T2).
insere_elem([H1|T1], E, I, [H2|T2]) :-
    I \= 1,
    H1 = H2,
    I1 is I - 1,
    insere_elem(T1, E, I1, T2).
insere_elem(L1, E, I, [H2|T2]):-
    L1 = [],
    I = 1,
    H2 = E,
    T2 = [].
insere_elem([], _, I, []):-
    I < 1.

    
    





