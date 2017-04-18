/*
objterm(O,R,C,T)
onde O identifica o objetivo correspondente ao nodo, 
R é uma lista de identificadores de recursos
(pessoas, equipamentos, materiais, etc.) necessários para atingir o objetivo, 
C é um valor numérico com a estimativa de custo necessário para atingir o objetivo e 
T uma estimativa em dias do tempo necessário para alcançar o objetivo.
Além disso suponha que cada nodo intermediário da EAP contenha como valor termos com a
seguinte estrutura:
*/


/*extrai_grafo_aon(arv(objint('VirarMestre',par),
                   [arv(objint('TecnicasProg',par),
                       [arv(objterm('Prolog',['Dev','Prog'],666,2),[]),
                        arv(objterm('StandardML',['Prolog'],666,2),[])
                       ]),
                    arv(objterm('Prog',['Logica'],666,2),[])
                   ]),g1).


extrai_grafo_aon(arv(objint('TituloMestre',par),
                   [arv(objterm('Ingles',['V'],200,1),[]),
                    arv(objterm('DefesaDissertacao',['Ingles','TecnicasProg','ModSim','Probabilidade','Analise de Algoritimos'],22000,365),[]),
                    arv(objint('1Semestre',par),
                       [arv(objterm('TecnicasProg',['V'],5000,180),[]),
                        arv(objterm('ModSim',['V'],5000,180),[])
                       ]),
                   arv(objint('2Semestre',par),
                       [arv(objterm('Probabilidade',['TecnicasProg','ModSim'],5000,180),[]),
                        arv(objterm('Analise de Algoritimos',['TecnicasProg','ModSim'],5000,180),[])
                       ])
                   ]),g1).


extrai_grafo_aon(arv(objint('TituloMestre',par),
                   [arv(objterm('Ingles',['V'],200,1),[]),
                    arv(objterm('DefesaDissertacao',['Ingles','TecnicasProg','Mod e Sim','Probabilidade','Analise de Algoritimos'],22000,365),[])
                   ]),g1).



*/

%--Exercicio a ----------------------------------

todos_objetivos(arv(objterm(O,_,_,_),[]),[O]).
todos_objetivos(arv(objint(_,_),[H|T]),L):-
    todos_objetivos(H,L1),
    todos_objetivos(T,L2),
    append(L1,L2,L).
todos_objetivos([],[]).
todos_objetivos([H|T],L):-
    todos_objetivos(H,L1),
    todos_objetivos(T,L2),
    append(L1,L2,L).

assert_recursos(G,Lista,[H|T],O):-
    memberchk(H,Lista) ->    
        assert(arco(G,O,H)),
        assert_recursos(G,Lista,T,O);
        assert_recursos(G,Lista,T,O).
assert_recursos(_,_,[],_).

extrai_grafo_aon(Arv,G):-
    retractall(arco(G,_,_)),
    retractall(nodo(G,_,_)),
    todos_objetivos(Arv,Lista),
    extrai_grafo_aon(Arv,Lista,G).

extrai_grafo_aon(arv(objterm(O,[H|T],_,D),[]),Lista,G):-
    assert(nodo(G,O,D)),
    memberchk(H,Lista) ->
        assert(arco(G,O,H)),
        assert_recursos(G,Lista,T,O);
        assert_recursos(G,Lista,T,O).

extrai_grafo_aon(arv(objint(_,_),[H|T]),Lista,G):-
    extrai_grafo_aon(H,Lista,G),
    extrai_grafo_aon(T,Lista,G).

extrai_grafo_aon([],_,_).

extrai_grafo_aon([H|T],Lista,G):-
    extrai_grafo_aon(H,Lista,G),
    extrai_grafo_aon(T,Lista,G).

%--Exercicio b ----------------------------------

caminho_critico(G,[H|T],P,H) :-
    arco(G,H,Y),
    nodo(G,H,P1),
    caminho_critico(G,T,P2,Y),
    P is P1 + P2.

caminho_critico(G,[H|T],P,H) :-
        \+arco(G,H,_),
        nodo(G,H,P),
        T = [].

caminho_critico(G,[H|T],P) :-
    nodo(G,H,P1),
    arco(G,H,Y),
    \+arco(G,_,H),
    caminho_critico(G,T,P2,Y),
    P is P1 + P2.

prazo_max(G,P) :- 
    findall(D,caminho_critico(G,_,D),L),
    sort(0,  @>, L,  [P|_]).

%--Exercicio c ----------------------------------
caminho_critico(G,L) :-
    prazo_max(G,P),
    caminho_critico(G,L,P).




