portOf(D,R,P):-
    rect(D,P), rect(D,R), parent(D,P,R).

isPort(D,P):-
    portOf(D,_,P).

partName(D,Part,Name):-
    rect(D,Part), value(D,Part,Name).

portName(D,Port,Name):-
    isPort(D,Port), value(D,Port,Name).

gateName(D,Gate,Name):-
    gate(D,Gate), value(D,Gate,Name).

down(D,GateName,ChildId,ChildName,ChildPortName):-
    edge(D,E), gate(D,Gate), rect(D,ChildId),
    portOf(D,ChildId,ChildPort),
    source(D,E,Gate), target(D,E,ChildPort),
    gateName(D,Gate,GateName),
    partName(D,ChildId,ChildName),
    portName(D,ChildPort,ChildPortName).

up(D,GateName,ChildId,ChildName,ChildPortName):-
    edge(D,E), gate(D,Gate), rect(D,ChildId),
    portOf(D,ChildId,ChildPort),
    source(D,E,ChildPort), target(D,E,Gate),
    gateName(D,Gate,GateName),
    partName(D,ChildId,ChildName),
    portName(D,ChildPort,ChildPortName).

across(D,C1Id,C1Name,C1Port,C2Id,C2Name,C2Port):-
    edge(D,E),
    rect(D,C1Id), portOf(D,C1Id,CP1), source(D,E,CP1),
    rect(D,C2Id), portOf(D,C2Id,CP2), target(D,E,CP2),
    partName(D,C1Id,C1Name), portName(D,CP1,C1Port),
    partName(D,C2Id,C2Name), portName(D,CP2,C2Port).

through(D,InName,OutName):-
    edge(D,E),
    gate(D,In), gate(D,Out),
    source(D,E,In), target(D,E,Out),
    gateName(D,In,InName),
    gateName(D,Out,OutName).
