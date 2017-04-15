%Base de fatos com o grafo dado pelo professor no material
arco(g1, b, a). arco(g1, a, c). arco(g1, c, g). arco(g1, a, e). arco(g1, e, b). arco(g1, e, d).
arco(g1, f, e). arco(g1, g, f). arco(g1, d, g).


arco(g3, b, a). arco(g3, a, c). arco(g3, c, g). arco(g3, a, e). arco(g3, e, b). arco(g3, e, d).
arco(g3, f, e). arco(g3, g, f). arco(g3, g, k). arco(g3, d, g).


arco(g2, a, b). arco(g2, b, c). arco(g2, c, d). arco(g2, d, e). arco(g2, e, f). arco(g2, f, g). arco(g2, g, a).
arco(g8, a, b). arco(g8, b, a). arco(g8, b, c). arco(g8, c, b).

%K33
arco(g4, a, d). arco(g4, a, e). arco(g4, a, f). 
arco(g4, b, d). arco(g4, b, e). arco(g4, b, f). 
arco(g4, c, d). arco(g4, c, e). arco(g4, c, f).  

%K5
arco(g5, a, b). arco(g5, a, c). arco(g5, a, d). arco(g5, a, e). 
arco(g5, b, c). arco(g5, b, d). arco(g5, b, e). 
arco(g5, c, d). arco(g5, c, e). 
arco(g5, d, e). 

%K5 com dois nos extra
arco(g7, a, w). arco(g7, w, z). arco(g7, z, b). arco(g7, a, c). arco(g7, a, d). arco(g7, a, e). 
arco(g7, b, c). arco(g7, b, d). arco(g7, b, e). 
arco(g7, c, d). arco(g7, c, e). 
arco(g7, d, e). 

%K33 com um extra A - H, H - D
arco(g6, a, h). arco(g6, h, d). arco(g6, a, e). arco(g6, a, f). arco(g6, b, d). arco(g6, b, e). 
arco(g6, b, f). arco(g6, c, d). arco(g6, c, e). arco(g6, c, f).  

%Isomorfico com g6
arco(g66, 3, 6). arco(g66, 1, 0). arco(g66, 0, 4). arco(g66, 1, 5). arco(g66, 1, 6). arco(g66, 2, 4). 
arco(g66, 2, 5). arco(g66, 2, 6). arco(g66, 3, 4). arco(g66, 3, 5).  


%--Exercicio a ----------------------------------

/*para listarmos todos os nodos do grafo, podemos procurar por todos os começos e finais dos arcos
e colocar eles em uma lista sem elementos duplicados
*/
nodos_do_grafo(G, L) :-
    findall(X,arco(G,X,_),L1),
    findall(Y,arco(G,_,Y),L2),
    append(L1,L2,L3),
    remove_dup(L3,L).

/*A parte mais dificil deste exercicio é justamente remover os nodos duplicados da lista
o predicado abaixo faz esse procedimento*/

remove_dup([],[]).
remove_dup(L1,L2) :-
    remove_dup(L1,[],L2) .

remove_dup([],_,[]).
remove_dup([H1|T1],Repetidos,L) :-
    memberchk(H1,Repetidos) ->
        remove_dup(T1,Repetidos,L);
        append([H1],Repetidos,R),
        L = [H2|T2],
        H2 = H1,
        remove_dup(T1,R,T2).

%--Exercicio b ----------------------------------

%O predicado que foi solicitado a implementação no exercício precisa de um predicado auxiliar para funcionar
%pois precisamos manter uma lista de nos já visitados para evitar loop infinito 

conectado(G,N1,N2) :-
    conectado(G,[],N1,N2).
conectado(G,_,N1,N2) :-
    arco(G,N1,N2).

conectado(G,Visitado,N1,N2) :-
    arco(G,N1,X),
    \+memberchk(X,Visitado),
    [X|Visitado] = V,
    conectado(G,V,X,N2).

%--Exercicio c ----------------------------------
ciclo(G,N) :-
    conectado(G,N,N).

%--Exercicio d ----------------------------------
grafo_ciclico(G) :- 
    arco(G,X,_),
    ciclo(G,X),!;
    arco(G,_,Y),
    ciclo(G,Y),!.

%--Exercicio e ----------------------------------

caminho(G,N1,N2,C) :- 
    caminho(G,[],N1,N2,C).


caminho(G,_,N1,N2,[N1,N2]) :-
    arco(G,N1,N2).

caminho(G,Visitado,N1,N2,[N1|T]) :-
    arco(G,N1,X),
    \+memberchk(X,Visitado),
    [X|Visitado] = V,
    caminho(G,V,X,N2,T).

%--Exercicio f ----------------------------------
caminho_mais_curto(G, N1,N2,C) :- 
    findall(X,caminho(G,N1,N2,X),Y),
    menorlista(Y,C).

menorlista(Y,C):-
    menorlista(Y,[],C).
menorlista([],Temp,Temp).

menorlista([H|T],Temp,C) :-
    Temp = [] ->
        menorlista(T,H,C);
        length(H,X),
        length(Temp,Y),
        X < Y ->
            menorlista(T,H,C);
            menorlista(T,Temp,C).
        
%--Exercicio g ----------------------------------

hamiltoniano(G) :- 
    nodos_do_grafo(G,Nodos),
    arco(G,X,_),
    hamiltoniano(G,X,Nodos),!.
hamiltoniano(G) :- 
    nodos_do_grafo(G,Nodos),
    arco(G,_,Y),
    hamiltoniano(G,Y,Nodos),!.

hamiltoniano(G,X,Nodos) :-
    caminho(G,X,X,C),
    C = [X|T],
    remove_dup(T,Caminho),
    length(T,NNodos),
    length(Nodos,NNodos),
    length(Caminho,NNodos),!.


%--Exercicio h ----------------------------------

/* Um grafo euleriano é aquele que apresenta um ciclo euleriano, ou seja, no qual é possivel traçar um caminho que
passe por todas as arestas e termine no nodo inicial. Os testes para definir o grafo como euleriano sao muito semelhantes
ao hamiltoniano, porém dessa vez ao invés de testarmos os nodos percorridos devemos testar as arestas.
Assim é necessário definir predicados para capturar todas as arestas do grafo e aplicar os mesmos testes do caminho
hamiltoniano.*/
euleriano(G) :- 
    todas_arestas(G,Arestas),
    arco(G,X,_),
    euleriano(G,X,Arestas),!.
euleriano(G) :- 
    todas_arestas(G,Arestas),
    arco(G,_,Y),
    euleriano(G,Y,Arestas),!.

euleriano(G,X,Arestas) :-
    caminho_aresta(G,X,X,C),
    remove_dup(C,Caminho),
    length(C,Num_Arestas),
    length(Arestas,Num_Arestas),
    length(Caminho,Num_Arestas),!.

%precisamos saber se a quantidade de arestas é igual a quantidade do caminho realizado, portando precisamos saber todas as arestas
todas_arestas(G,T) :-
    findall(X,aresta(G,X),T).

%predicado auxiliar para ser usado no findall
aresta(G,X):-
    arco(G,Y,Z),
    atom_concat(Y,'-', Ktemp),
    atom_concat(Ktemp,Z,X).


%predicado igual ao caminho porém retorna as arestas e não os vertices visitados.
caminho_aresta(G,N1,N2,C) :- 
    caminho_aresta(G,[],N1,N2,C).


caminho_aresta(G,_,N1,N2,[X]) :-
    arco(G,N1,N2),
    atom_concat(N1,'-', Ktemp),
    atom_concat(Ktemp,N2,X).

caminho_aresta(G,Visitado,N1,N2,[H|T]) :-
    arco(G,N1,X),
    atom_concat(N1,'-', Ktemp),
    atom_concat(Ktemp,X,H),
    \+memberchk(X,Visitado),
    [X|Visitado] = V,
    caminho_aresta(G,V,X,N2,T).

%--Exercicio i ----------------------------------

/*A planaridade de um grafo é definida pelo teorema de Kuratowski, um grafo é planar se não fazem parte dele grafos K33 e K5
No entanto estes grafos podem aparecer tanto de forma direta como de forma indireta, de modo que nos de grau 2 (aqueles que 
possuem apenas duas arestas) não adicionam nenhuma complexidade geometrica (seriam equivalentes a uma linha) então antes de 
realizar o teste de planaridade, o grafo é simplificado excluindo-se todos os nos de grau 2 para apenas posteriormente realizar o teste*/
planar(G) :- 
    cria_grafo_aux(G),
    planar_aux(G).

planar_aux(G) :-
    possui_grau_dois(G) ->
        planar_aux(G);
        \+k33(G),
        \+k5(G).

%Esse predicado auxiliar grava o grafo na forma arco_aux, pois nos próximos predicados ele será manipulado
cria_grafo_aux(G):-
    retractall(arco_aux(G,_,_)),    
    forall(arco(G,X,Y),assert(arco_aux(G,X,Y))).

possui_grau_dois(G):-
    arco_bi(G,A,C),
    arco_bi(G,A,B),
    B \= C,
    \+possui_arco_dif(G,A,[B,C]),
    (arco_aux(G,A,B) ->    
        retract(arco_aux(G,A,B));
        retract(arco_aux(G,B,A))),
    (arco_aux(G,A,C) ->        
        retract(arco_aux(G,A,C));
        retract(arco_aux(G,C,A))),
    assert(arco_aux(G,B,C)),    
    write(A),
    write(B),
    write(C),
    nl.

possui_arco_dif(G,A,L):-
    arco_bi(G,A,B),
    \+memberchk(B,L).

/*O fato de nossos grafos serem dirigidos pode atrapalhar o teste de planaridade, para evitar isso foi criado um predicado que trata
o grafo G como não dirigido, permitindo tanto relacionamentos A - B como B - A, nos testes de planaridade devemos considerar o grafo
como não dirigido*/

arco_bi(G,A,B) :- 
%    xor(arco(G,A,B),arco(G,B,A)).
    arco_aux(G,A,B);
    arco_aux(G,B,A).

k33(G) :-
    k33(G,_,_,_,_,_,_).

/*
O grafo K33 constitui um grupo de 6 nodos sendo: 3 nodos distintos conectados a outros 3 nodos distintos,
o teste abaixo unifica com grafos do tipo K33
*/
k33(G,A,B,C,D,E,F) :- 
    arco_bi(G,A,D),
    arco_bi(G,A,E),
    arco_bi(G,A,F),
    arco_bi(G,B,D),
    arco_bi(G,B,E),
    arco_bi(G,B,F),
    arco_bi(G,C,D),
    arco_bi(G,C,E),
    arco_bi(G,C,F),
    A \= B,
    A \= C,
    A \= D,
    A \= E,
    A \= F,
    B \= C,
    B \= D,
    B \= E,
    B \= F,
    C \= D,
    C \= E,
    C \= F,
    D \= E,
    D \= F,
    E \= F,!.

/* O grafo K5 é basicamente uma estrela, são 5 nodos que se conectam entre si de forma que cada nodo seja conectado
aos outros 4 nodos. Abaixo o predicado que faz essa unificação. */

k5(G) :- 
    arco_bi(G,A,B),
    arco_bi(G,A,C),
    arco_bi(G,A,D),
    arco_bi(G,A,E),

    arco_bi(G,B,C),
    arco_bi(G,B,D),
    arco_bi(G,B,E),

    arco_bi(G,C,D),
    arco_bi(G,C,E),
    
    arco_bi(G,D,E),

    A \= B,
    A \= C,
    A \= D,
    A \= E,
    B \= C,
    B \= D,
    B \= E,
    C \= D,
    C \= E,
    D \= E,!.

%--Exercicio J ----------------------------------
automorfismo(G1,G2) :- 
    findall(A-B,arco(G1,A,B),A1),
    findall(C-D,arco(G2,C,D),A2),
    sort(A1,S),
    sort(A2,S).

isomorfismo(G1,G2) :-
    findall(A,arco(G1,A,_),L1),
    findall(C,arco(G2,C,_),L2),
    length(L1,T),
    length(L2,T),
    findall(B,arco(G1,_,B),L11),
    findall(D,arco(G2,_,D),L22),
    length(L11,T2),
    length(L22,T2),
    append(L1,L11,LG1),
    append(L2,L22,LG2),
    sort(LG1,LG1Sorted),
    sort(LG2,LG2Sorted),
    length(LG1Sorted,T3),
    length(LG2Sorted,T3),
    write('LG1Sorted: '),    
    write(LG1Sorted),
    permutation(LG2Sorted,LG2_Permuta),
    write('Permutacao G2: '),    
    write(LG2_Permuta),
    nl,
    prepara_gera_equiv(G1,LG1Sorted,G2,LG2_Permuta),
    equivalencia_iso(G1,G2).

prepara_gera_equiv(G1,L1,G2,L2) :-
    retractall(equiv(G1,_,G2,_)),
    gera_equiv(G1,L1,G2,L2).

gera_equiv(_,[],_,[]).

gera_equiv(G1,[H1|T1],G2,[H2|T2]) :-
    assert(equiv(G1,H1,G2,H2)),
    gera_equiv(G1,T1,G2,T2).

equivalencia_iso(G1,G2) :-
    forall(arco(G1,A,B),(equiv(G1,A,G2,C),equiv(G1,B,G2,D),arco(G2,C,D))).






