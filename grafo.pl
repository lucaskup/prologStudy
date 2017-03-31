%Base de fatos com o grafo dado pelo professor no material
arco(g1, b, a). arco(g1, a, c). arco(g1, c, g). arco(g1, a, e). arco(g1, e, b). arco(g1, e, d).
arco(g1, f, e). arco(g1, g, f). arco(g1, d, g).

%Base de fatos com o grafo dado pelo professor no material
arco(g3, b, a). arco(g3, a, c). arco(g3, c, g). arco(g3, a, e). arco(g3, e, b). arco(g3, e, d).
arco(g3, f, e). arco(g3, g, f). arco(g3, g, k). arco(g3, d, g).


arco(g2, a, b). arco(g2, b, c). arco(g2, c, d). arco(g2, d, e). arco(g2, e, f). arco(g2, f, g). arco(g2, g, a).
 arco(g8, b, c). arco(g8, c, d). arco(g8, d, e). arco(g8, e, f). arco(g8, f, g). arco(g8, g, a). arco(g8, a, b).

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



%euleriano(G) – verdadeiro se o grafo G tem um ciclo Euleriano
%planar(G) – verdadeiro se o grafo G é planar.

%--Exercicio J ----------------------------------
isomorfos(G1,G2) :- 
    findall(A-B,arco(G1,A,B),A1),
    findall(C-D,arco(G2,C,D),A2),
    sort(A1,S),
    sort(A2,S).
