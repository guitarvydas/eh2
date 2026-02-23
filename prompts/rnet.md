# definitions
a part name consists of 2 sections
❲template name❳❲id on diagram❳

a part name with a port consists of 3 sections
❲template name❳❲id on diagram❳❲port name❳

the enclosing parent self consists of a '.' and a port name
.❲port name❳

a port name can be the empty string, which is written as ❲❳

wires:
a "down" wire consists of 3 space separated regions ("down" self-port-name target-part-port)
down .❲port name❳ ❲template name❳❲id on diagram❳❲port name❳

an "up" wire consists of 3 space separated regions ("up" target  target-part-port self-port-name)
up ❲template name❳❲id on diagram❳❲port name❳ .❲port name❳

an "across" wire consists of 3 space separated regions ("up" sender-part-port receiver-part-port)
down .❲port name❳ ❲template name❳❲id on diagram❳❲port name❳

a "through" wire consists of 3 space separated regions ("through" self-port-name self-port-name)
down .❲port name❳ ❲template name❳❲id on diagram❳❲port name❳

# request
Given a basic set of queries, as below, what is the swipl query that will transform factbases to `.rnet` files?

Parent "1" is the top level diagram. The diagram is a Container itself.

An example of a factbase and the resulting `.rnet` file are given below

# basic queries
```
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

```
# example factbase
```
diagram("o9M2tmKP6ZUbm1JD93Ax").
edge("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-29").
edge("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30").
edge("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-10").
edge("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-11").
edge("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-12").
edge("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-14").
edge("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-15").
edge("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-9").
gate("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1").
gate("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-2").
gate("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-13").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","1").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-2","1").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-24","1").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-25","n8kg52j3blKjJ06txv2A-24").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-26","n8kg52j3blKjJ06txv2A-24").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-27","n8kg52j3blKjJ06txv2A-24").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-28","n8kg52j3blKjJ06txv2A-24").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-29","1").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-1","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-10","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-11","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-12","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-13","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-14","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-15","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-2","wK0F3og9NH9Dy6XDwJbj-1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-3","wK0F3og9NH9Dy6XDwJbj-1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-4","wK0F3og9NH9Dy6XDwJbj-1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-5","1").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-6","wK0F3og9NH9Dy6XDwJbj-5").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-7","wK0F3og9NH9Dy6XDwJbj-5").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-8","wK0F3og9NH9Dy6XDwJbj-5").
parent("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-9","1").
rect("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-24").
rect("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-25").
rect("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-26").
rect("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-27").
rect("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-28").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-1").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-2").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-3").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-4").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-5").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-6").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-7").
rect("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-8").
source("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-29","n8kg52j3blKjJ06txv2A-26").
source("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30","n8kg52j3blKjJ06txv2A-28").
source("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-10","n8kg52j3blKjJ06txv2A-1").
source("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-11","wK0F3og9NH9Dy6XDwJbj-3").
source("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-12","wK0F3og9NH9Dy6XDwJbj-7").
source("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-14","wK0F3og9NH9Dy6XDwJbj-4").
source("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-15","wK0F3og9NH9Dy6XDwJbj-8").
source("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-9","n8kg52j3blKjJ06txv2A-1").
target("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-29","n8kg52j3blKjJ06txv2A-2").
target("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30","n8kg52j3blKjJ06txv2A-2").
target("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-10","wK0F3og9NH9Dy6XDwJbj-6").
target("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-11","n8kg52j3blKjJ06txv2A-25").
target("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-12","n8kg52j3blKjJ06txv2A-27").
target("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-14","wK0F3og9NH9Dy6XDwJbj-13").
target("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-15","wK0F3og9NH9Dy6XDwJbj-13").
target("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-9","wK0F3og9NH9Dy6XDwJbj-2").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-2","").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-24","1→2").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-25","2").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-26","1").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-27","1").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-28","2").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-1","World").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-13","✗").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-2","").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-3","").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-4","✗").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-5","Hello").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-6","").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-7","").
value("o9M2tmKP6ZUbm1JD93Ax","wK0F3og9NH9Dy6XDwJbj-8","✗").
```
# example rnet
```
container {
  children: [❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳ ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳ ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳]
  wires: {
    down .❲❳ ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳❲❳
    down .❲❳ ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳❲❳
    up ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲1❳ .❲❳
    up ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲2❳ .❲❳
    across ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳❲❳ ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲1❳
    across ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳❲❳ ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲2❳
    up ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳❲✗❳ .❲✗❳
    up ❲World❲wK0F3og9NH9Dy6XDwJbj-1❳❲✗❳ .❲✗❳
  }
}
```


