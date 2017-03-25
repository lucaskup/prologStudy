tamanho([_|Xs],Acc,1+T):-tamanho(Xs,Acc+1,T).
tamanho([],Acc,Acc).
