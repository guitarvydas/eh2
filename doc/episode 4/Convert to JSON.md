The `helloworldpy.rnet` file is rewritten as JSON using a simple `t2t` script plus two small rewriters (written in Python)
```
${PBP}/t2t rnet2json <"$1".rnet | ./fixname.py "$1" | ./commas.py > "$1".json
```

## T2T Grammar
We pattern match `.rnet` source code (shown earlier as `helloworldpy.rnet`).
```
rnet2json {
  Main = "container" "{" Children Wires "}"
  Children = "children" "[" PartDecl+ "]"
  Wires = "wires" "{" Wire+ "}" 

  PartDecl = Template ID
  PartRef = Template ID
  Template = BracketedString
  ID = BracketedString
  BracketedString = "❲" (~"❳" any)* "❳"
  Wire =
    | "down" SelfSender Receiver
    | "across" Sender Receiver
    | "up" Sender SelfReceiver
    | "through" SelfSender SelfReceiver
  Port = BracketedString
  Sender = PartRef Port
  Receiver = PartRef Port
  SelfSender = "." Port
  SelfReceiver = "." Port
}
```
## T2T Rewrite Rules
The `.rnet` format can be trivially rewritten as JSON. In most cases I simply need to add double-quoted keys.

I leave a placeholder "???" where the name of the Container will be inserted.

I'm not entirely sure that this is the final format that is wanted. I need to consider how this will be stored by the loader in a dict, and, I need to consider how a drawio diagram with multiple tabs will be converted.  For now, I will just move forward with what I've got. The whole thing is automated, so fixing it up later should be easy and re-generating the code will just involve running `./@make` again.

```
% rewrite rnet2json {
  Main [_container lb Children Wires rb] = ‛{ "???" : { «Children»«Wires»}\n}’
  Children [_children lb PartDecl+ rb] = ‛\n"children" : [«PartDecl»],’
  Wires [_wires lb Wire+ rb] =  ‛\n"wires" : [\n«Wire»]’

  PartDecl [Template ID] = ‛\n{"template" : «Template», "id" : «ID»},’
  PartRef [Template ID] = ‛"id" : «ID»’
  Template [s] = ‛«s»’
  ID [s] = ‛«s»’
  BracketedString [lb cs* rb] = ‛"«cs»"’
  Wire [_direction sender receiver] = ‛\n{"dir" : "«_direction»", "sender" : «sender», "receiver" : «receiver»},’
  Port [s] = ‛«s»’
  Sender [Part Port] = ‛{«Part», "port" : «Port»}’
  Receiver [Part Port] = ‛{«Part», "port" : «Port»}’
  SelfSender [_dot Port] = ‛{"id" : ".", "port" : «Port»}’
  SelfReceiver [_dot Port] = ‛{"id" : ".", "port" : «Port»}’
}
```

## fixname.py
This rewriter simply plugs `helloworldpy`  - the command line arg - into the placeholder "???"
```
#!/usr/bin/env python
import sys

template = sys.stdin.read()
print(template.replace('???', sys.argv[1]))
```
## commas.py
This rewriter simply removes redundant commas to create legal JSON that contains comma-separated lists, without a comma after the final element of the list.
```
#!/usr/bin/env python
import sys
s = sys.stdin.read().replace(',)', ')').replace(',}', '}').replace(',]', ']')
sys.stdout.write(s)
```
