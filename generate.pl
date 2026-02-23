:- consult(queries).

wire(D,S) :- down(D,G,Id,CN,CP),           format(atom(S),"down .❲~w❳ ❲~w❳❲~w❳❲~w❳",[G,CN,Id,CP]).
wire(D,S) :- up(D,G,Id,CN,CP),             format(atom(S),"up ❲~w❳❲~w❳❲~w❳ .❲~w❳",[CN,Id,CP,G]).
wire(D,S) :- across(D,I1,C1,P1,I2,C2,P2), format(atom(S),"across ❲~w❳❲~w❳❲~w❳ ❲~w❳❲~w❳❲~w❳",[C1,I1,P1,C2,I2,P2]).
wire(D,S) :- through(D,I,O),               format(atom(S),"through .❲~w❳ .❲~w❳",[I,O]).

rnet(D,Base) :-
    findall(S, (rect(D,Id), parent(D,Id,"1"), \+isPort(D,Id),
                value(D,Id,N), format(atom(S),"❲~w❳❲~w❳",[N,Id])), Cs),
    atomic_list_concat(Cs,' ',Children),
    findall(S, wire(D,S), Ws),
    atomic_list_concat(Ws,'\n    ',Wires),
    atom_concat(Base,'.rnet',F),
    tell(F),
    format("container {\n  children [~w]\n  wires {\n    ~w\n  }\n}\n",[Children,Wires]),
    told.

main :-
    current_prolog_flag(argv,[Base,Factbase|_]),
    consult(Factbase),
    diagram(D),
    rnet(D,Base).
