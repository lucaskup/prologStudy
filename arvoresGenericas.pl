/*

arv( V, L )
onde V é o valor armazenado no nodo e L é uma lista de nodos filhos deste nodo. Note que a ordem
da lista L é importante, o primeiro elemento de L é o nodo mais a esquerda, enquanto que o último
nodo da lista L é o nodo mais à direita da árvore.

objterm(O,R,C,T)
onde O identifica o objetivo correspondente ao nodo, 
R é uma lista de identificadores de recursos
(pessoas, equipamentos, materiais, etc.) necessários para atingir o objetivo, 
C é um valor numérico com a estimativa de custo necessário para atingir o objetivo e 
T uma estimativa em dias do tempo necessário para alcançar o objetivo.
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

/*
##########################################
#######   Consulta para testes   #########
##########################################

recursos_obj(arv(objint('VirarMestre',par),
                   [arv(objterm('QualquerCoisa',['Programador','Analista'],666,2),[]),
                    arv(objterm('CoisaEspecifica',['Programador','Testador'],666,2),[])
                   ]),'QualquerCoisa',X).

*/

%Exercício muito semelhante ao anterior, porem aqui precisamos testar os objetivos
recursos_obj(arv(objterm(Objetivo1,Recursos,_,_),[]),Objetivo2, R):-
    Objetivo1 = Objetivo2 ->
        R = Recursos;
        R = [].
% casos seja passado uma lista em branco, nao tem recursos
recursos_obj([],_, []).


%Aqui reaproveitamos os predicados do exercicio anterior, caso Objetivo1 e Objetivo2
%sejam iguais, devemos proceder buscando os recursos totais, porém se nao forem iguais
%devemos continuar testando o objetivo, isso se deve ao fato de precisarmos dos recurso para
%determinado objetivo bem como para seus sub objetivos
recursos_obj(arv(objint(Objetivo1,_),[H|T]),Objetivo2, R) :-
    Objetivo1 = Objetivo2  ->    
        total_recursos(H,X),
        total_recursos(T,Y),
        insere_sem_duplicar(X,Y,R);
        recursos_obj(H,Objetivo2,X),
        recursos_obj(T,Objetivo2,Y),
        insere_sem_duplicar(X,Y,R).

recursos_obj([H|T],O, R) :-
    recursos_obj(H,O,X),
    recursos_obj(T,O,Y),
    insere_sem_duplicar(X,Y,R).

%--exercício c--------------------------------------------------

/*
##########################################
#######   Consulta para testes   #########
##########################################

custo_total(arv(objint('VirarMestre',par),
                   [arv(objterm('QualquerCoisa',['Programador','Analista'],666,2),[]),
                    arv(objterm('CoisaEspecifica',['Programador','Testador'],666,2),[])
                   ]),X).
*/

%O custo total do projeto é simples, ele está vinculado sempre em nodos terminais, nesses casos apenas
%precisamos pegar o custo dos objetos terminais
custo_total(arv(objterm(_,_,C,_),[]), C).
%O custo total de uma lista em branco é 0
custo_total([], 0).
%O custo de um objetivo intermediario é a soma de todos os custos dos objetivos vinculados a ele
custo_total(arv(objint(_,_),[H|T]), C) :- 
    custo_total(H, C1),
    custo_total(T, C2),
    C is C1 + C2.
%mesma implementacao do predicado anterior porém agora para percorrer a lista
custo_total([H|T], C) :- 
    custo_total(H, C1),
    custo_total(T, C2),
    C is C1 + C2. 

%--exercício d--------------------------------------------------
/*
##########################################
#######   Consulta para testes   #########
##########################################
custo_obj(arv(objint('VirarMestre',par),
                   [arv(objterm('QualquerCoisa',['Programador','Analista'],666,2),[]),
                    arv(objterm('CoisaEspecifica',['Programador','Testador'],766,2),[])
                   ]),'VirarMestre',X).
*/

% O custo de um no terminal é o proprio custo do no
custo_obj(arv(objterm(Objetivo1,_,Custo,_),[]),Objetivo2, C) :-
    Objetivo1 = Objetivo2 ->
        C = Custo;
        C = 0.

% O custo de uma lista vazia é 0
custo_obj([],_, 0).

% O custo de um objetivo intermediario é a soma dos custos dos objetivos finais,
%porem caso o objetivo intermediario seja o desejado podemos somar os demais independente
%do objetivo
custo_obj(arv(objint(Objetivo1,_),[H|T]),Objetivo2, C) :-
    Objetivo1 = Objetivo2  ->    
        custo_total(H,C1),
        custo_total(T,C2),
        C is C1 + C2;
        custo_obj(H,Objetivo2,C1),
        custo_obj(T,Objetivo2,C2),
        C is C1 + C2.

% No caso de custos de uma lista precisamos chamar o predicado para cada um dos elementos da lista
custo_obj([H|T],O, C) :-
    custo_obj(H,O,C1),
    custo_obj(T,O,C2),
    C is C1 + C2.

%--exercício e--------------------------------------------------

/*
##########################################
#######   Consulta para testes   #########
##########################################
prazo_total(arv(objint('VirarMestre',par),
                   [arv(objterm('QualquerCoisa',['Programador','Analista'],666,2),[]),
                    arv(objterm('CoisaEspecifica',['Programador','Testador'],666,14),[])
                   ]),X).
*/


%O prazo total do projeto é simples, ele está vinculado sempre em nodos terminais, nesses casos apenas
%precisamos pegar o prazo dos objetos terminais
prazo_total(arv(objterm(_,_,_,C),[]), C).
%O prazo total de uma lista em branco é 0
prazo_total([], 0).
%O prazo de um objetivo intermediario é a soma de todos os prazos dos objetivos vinculados a ele
prazo_total(arv(objint(_,_),[H|T]), C) :- 
    prazo_total(H, C1),
    prazo_total(T, C2),
    C is C1 + C2.
%mesma implementacao do predicado anterior porém agora para percorrer a lista
prazo_total([H|T], C) :- 
    prazo_total(H, C1),
    prazo_total(T, C2),
    C is C1 + C2. 

%--exercício f--------------------------------------------------

/*
##########################################
#######   Consulta para testes   #########
##########################################
prazo_obj(arv(objint('VirarMestre',par),
                   [arv(objterm('QualquerCoisa',['Programador','Analista'],666,2),[]),
                    arv(objterm('CoisaEspecifica',['Programador','Testador'],766,14),[])
                   ]),'QualquerCoisa',X).

*/

% O prazo de um no terminal é o proprio custo do no
prazo_obj(arv(objterm(Objetivo1,_,_,Prazo),[]),Objetivo2, C) :-
    Objetivo1 = Objetivo2 ->
        C = Prazo;
        C = 0.

% O prazo de uma lista vazia é 0
prazo_obj([],_, 0).

% O prazo de um objetivo intermediario é a soma dos prazos dos objetivos finais,
%porem caso o objetivo intermediario seja o desejado podemos somar os demais independente
%do objetivo
prazo_obj(arv(objint(Objetivo1,_),[H|T]),Objetivo2, C) :-
    Objetivo1 = Objetivo2  ->    
        prazo_total(H,C1),
        prazo_total(T,C2),
        C is C1 + C2;
        prazo_obj(H,Objetivo2,C1),
        prazo_obj(T,Objetivo2,C2),
        C is C1 + C2.

% No caso de prazos de uma lista precisamos chamar o predicado para cada um dos elementos da lista
prazo_obj([H|T],O, C) :-
    prazo_obj(H,O,C1),
    prazo_obj(T,O,C2),
    C is C1 + C2.

