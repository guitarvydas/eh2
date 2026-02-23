portOf(D,R,P):-
    rect(D,P),
    rect(D,R),
    parent(D,P,R).

isPort(D,P):-
    portOf(D,_,P).

part(Name):-
    rect(D,R),parent(D,R,"1"),value(D,R,Name).

partName(D,Part,Name):-
    rect(D,Part),
    value(D,Part,Name).

portName(D,Port,Name):-
    isPort(D,Port),
    value(D,Port,Name).

gateName(D,Gate,Name):-
    gate(D,Gate),
    value(D,Gate,Name).

down(D,GateName,ChildName,ChildPortName):-
    edge(D,E),
    rect(D,Child),
    portOf(D,Child,ChildPort),
    partName(D,Child,ChildName),
    gate(D,Gate),
    source(D,E,Gate),
    target(D,E,ChildPort),
    portName(D,ChildPort,ChildPortName),
    gateName(D,Gate,GateName).

up(D,GateName,ChildName,ChildPortName):-
    edge(D,E),
    rect(D,Child),
    portOf(D,Child,ChildPort),
    partName(D,Child,ChildName),
    gate(D,Gate),
    source(D,E,ChildPort),
    target(D,E,Gate),
    portName(D,ChildPort,ChildPortName),
    gateName(D,Gate,GateName).

across(D,Child1Name,Child1PortName,Child2Name,Child2PortName):-
    edge(D,E),

    rect(D,Child1),
    portOf(D,Child1,Child1Port),
    partName(D,Child1,Child1Name),
    portName(D,Child1Port,Child1PortName),

    rect(D,Child2),
    portOf(D,Child2,Child2Port),
    partName(D,Child2,Child2Name),
    portName(D,Child2Port,Child2PortName),

    source(D,E,Child1Port),
    target(D,E,Child2Port).

through(D,InName,OutName):-
    edge(D,E),
    gate(D,In),
    gate(D,Out),
    source(D,E,In),
    target(D,E,Out),
    gateName(D,In,InName),
    gateName(D,Out,OutName).

