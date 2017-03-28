%--exercício a--------------------------------------------------
/*o caminhamento pre fixado deve construir uma lista cujo primeiro elemento é igual ao elemento H do arvbin
os filhos a esquerda L e a Direita R devem continuar uma definicao recursiva, com a ajuda do predicado
concatena nem precisamos definir muito mais, pois as listas L1 e L2 devem ser concatenadas em T*/
percurso_pre(nil, []).
percurso_pre(arvbin(H,L,R), [H|T]) :-
    percurso_pre(L,L1),
    percurso_pre(R,L2),
    append(L1,L2,T).


%--exercício b--------------------------------------------------
/*Análogo ao exercicio anterior, porém o elemento H deve estar na ultima posicao da lista*/
percurso_pos(nil, []).
percurso_pos(arvbin(H,L,R), T) :-
    percurso_pos(L,L1),
    percurso_pos(R,L2),
    append(L1,L2,X),
    append(X,[H],T).

%--exercício c--------------------------------------------------
/*Análogo ao exercicio anterior, porém o elemento H deve estar entre as listas*/
percurso_sim(nil, []).
percurso_sim(arvbin(H,L,R), T) :-
    percurso_sim(L,L1),
    percurso_sim(R,L2),
    append(L1,[H],X),
    append(X,L2,T).

%--exercício d--------------------------------------------------

/*Como estamos trabalhando apenas com operadores binários, valores e/ou variaveis estao
apenas em nodos folhas da arvore, eles devem ser necessariamente um numero ou
uma variavel que deve ser resolvida*/
calc(L,arvbin(A,nil,nil),V) :-
    number(A),
    A = V;
    resolve_var(L,A,V).

/*Se não estamos em um nodo folha, devemos calcular a sub arvore direita e esquerda para entao fazer a operacao
definida por A Operador B*/
calc(L,arvbin(Operador,Left,Right),V) :-
    calc(L,Left,A),
    calc(L,Right,B),    
    valor(A,Operador,B,V).
    
/*predicado auxiliar 1, procura na lista L o valor da variavel X, a primeira definicao
trata o caso que encontrou e a segunda trata a recursão para buscar os demais elementos*/
resolve_var([val(X,V)|_],X,V).
resolve_var([val(A,_)|T],X,V) :-
    A \= X,
    resolve_var(T,X,V).
    

%Predicado auxiliar 2, resolve as operações explicitadas no enunciado
valor(A,+,B,R):-
    R is A + B.
valor(A,-,B,R):-
    R is A - B.
valor(A,*,B,R):-
    R is A * B.
valor(A,/,B,R):-
    R is A / B.
valor(A,^,B,R):-
    R is A ^ B.


%--exercício e--------------------------------------------------

insere_abb(nil, V, arvbin(V,nil,nil)).
insere_abb(arvbin(X,L,R), V, arvbin(X,L,A)) :-
    V > X,
    insere_abb(R,V,A).
insere_abb(arvbin(X,L,R), V, arvbin(X,A,R)) :-
    V < X,
    insere_abb(L,V,A).

