/*

arv( V, L )
onde V é o valor armazenado no nodo e L é uma lista de nodos filhos deste nodo. Note que a ordem
da lista L é importante, o primeiro elemento de L é o nodo mais a esquerda, enquanto que o último
nodo da lista L é o nodo mais à direita da árvore.

objterm(O,R,C,T)
onde O identifica o objetivo correspondente ao nodo, 
R é uma lista de identificadores de recursos
(pessoas, equipamentos, materiais, etc.) necessários para atingir o objetivo, C é um valor numérico
com a estimativa de custo necessário para atingir o objetivo e T uma estimativa em dias do tempo
necessário para alcançar o objetivo.
Além disso suponha que cada nodo intermediário da EAP contenha como valor termos com a
seguinte estrutura:
objint(O,SP)
onde O identifica o objetivo correspondente ao nodo e SP identifica se os subobjetivos ou
subprojetos deste objetivo podem ser buscados em paralelo (par) ou em sequência (seq).
*/


%--exercício a--------------------------------------------------

/*
##########################################
#######   Consulta para testes   #########
##########################################

total_recursos(arv(objint(VirarMestre,par),
                   [arv(objterm('QualquerCoisa',['Programador','Analista'],666,2),[]),
                    arv(objterm('QualquerCoisa',['Programador','Testador'],666,2),[])
                   ]),X).
*/


/*Basicamente o predicado total_recursos aceita uma arvore ou uma lista de arvores
Caso seja um nodo terminal, a lista de recursos é igual a lista de recursos do nodo
*/
total_recursos(arv(objterm(_,R,_,_),[]), R).
% casos seja passado uma lista em branco, nao tem recursos
total_recursos([], []).

/*Os nodos intermediarios da arvore possuem valor do tipo objint, esses nodos nao tem recursos, 
mas seus filhos potencialmente tem, entao refazemos a chamada ao predicado e garantimos que R
é uma lista concatenada dos dois retornos porém sem elementos duplicados*/
total_recursos(arv(objint(_,_),[H|T]), R) :-
    total_recursos(H,X),
    total_recursos(T,Y),
    insere_sem_duplicar(X,Y,R).

/*A avaliacao da lista de arvores é igual a avaliação da arvore*/
total_recursos([H|T], R) :-
    total_recursos(H,X),
    total_recursos(T,Y),
    insere_sem_duplicar(X,Y,R).

/*A inserção sem duplicar elementos na lista faz uso da função member e da implicação -> (if)
se é membro segue a avaliação se não é membro efetua a inserção e daí passa a fazer a avaliação*/
insere_sem_duplicar([],Y,Y).
insere_sem_duplicar([H|T],Y,R) :-
    member(H,Y) ->
        insere_sem_duplicar(T,Y,R);
        append([H],Y,Z),
        insere_sem_duplicar(T,Z,R).

%--exercício b--------------------------------------------------
