portOf(R,P):-
    rect(D,P),
    rect(D,R),
    parentOf(D,P,R).

parentOf(D,P,LongR):-
    parent(D,P,LongR).
parentOf(D,P,R):-
    synonym(LongR,R),
    parent(D,P,LongR).
%% parentOf(D,P,R):-
%%     parent(D,P,R),!.
%% parentOf(D,LongP,R):-
%%     synonym(LongP,P),
%%     parent(D,P,R),!.
%% parentOf(D,P,LongR):-
%%     synonym(LongR,R),
%%     parent(D,P,R),!.
    


%% parentOf(D,LongPID,LongRID):-
%%     parent(D,LongPID,LongRID),
%%     !.
%% parentOf(D,FPID,FRID):-
%%     parent(D,FPID,FRID),
%%     !.
%% parentOf(D,FPID,LongRID):-
%%     synonym(LongRID,FRID),
%%     parent(D,FPID,FRID),
%%     !.
%% parentOf(D,LongPID,FRID):-
%%     synonym(LongPID,FPID),
%%     parent(D,FPID,FRID),
%%     !.
