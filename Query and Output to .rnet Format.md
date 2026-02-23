

:- use_module(library(apply)).

ref(D,Id,Port) --> 
    { value(D,Id,N) }, 
    ["❲~w❳❲~w❳❲~w❳"-[N,Id,Port]].

% not needed - just use format/2 with computed atoms

rnet(D) :-
    diagram(D),
    % children
    findall(S, (rect(D,Id), parent(D,Id,"1"), \+isPort(D,Id),
                value(D,Id,N), format(atom(S),"❲~w❳❲~w❳",[N,Id])), Cs),
    atomic_list_concat(Cs,' ',Children),
    % wires
    findall(S, wire(D,S), Ws),
    atomic_list_concat(Ws,'\n    ',Wires),
    format("container {\n  children: [~w]\n  wires: {\n    ~w\n  }\n}\n",[Children,Wires]).

wire(D,S) :- down(D,G,CN,CP),   partid(D,CN,Id), format(atom(S),"down .❲~w❳ ❲~w❳❲~w❳❲~w❳",[G,CN,Id,CP]).
wire(D,S) :- up(D,G,CN,CP),     partid(D,CN,Id), format(atom(S),"up ❲~w❳❲~w❳❲~w❳ .❲~w❳",[CN,Id,CP,G]).
wire(D,S) :- across(D,C1,P1,C2,P2), partid(D,C1,I1), partid(D,C2,I2),
             format(atom(S),"across ❲~w❳❲~w❳❲~w❳ ❲~w❳❲~w❳❲~w❳",[C1,I1,P1,C2,I2,P2]).
wire(D,S) :- through(D,I,O),    format(atom(S),"through .❲~w❳ .❲~w❳",[I,O]).

partid(D,Name,Id) :- rect(D,Id), parent(D,Id,"1"), value(D,Id,Name).

main :- diagram(D), atom_concat(D,'.rnet',F), tell(F), rnet(D), told.