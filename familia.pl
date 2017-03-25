%% programa da familia
pai(tare, abraao). %1
pai(tare, nacor). %2
pai(tare, aran). %3
pai(aran, lot). %4 /* 7 fatos */
pai(aran, melca). %5
pai(aran, jesca). %6
mae(sara, isaac). %7
%%
fem(X):-mae(X,_). %1
mas(X):-pai(X,_).
casal(X,Y):-fem(X),mas(Y).
irmao(X,Y):-pai(P,X),pai(P,Y), X\==Y. %2 /* 3 regras */
tio(T,X):-pai(P,X),irmao(P,T). %3
