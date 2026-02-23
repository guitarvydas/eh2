I want to convert the following diagram
![](helloworldpy%20Screenshot%202026-02-22%20at%206.42.04%20AM.png)
into intermediate form (`helloworldpy.rnet`)
```
container {
  children: [❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳ ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳ ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳]
  wires: {
    down .❲❳ ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳❲❳
    down .❲❳ ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳❲❳
    up ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲1❳ .❲❳
    up ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲2❳ .❲❳
    up ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳❲✗❳ .❲✗❳
    up ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳❲✗❳ .❲✗❳
    across ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳❲❳ ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲2❳
    across ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳❲❳ ❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳❲1❳
  }
}
```
and then convert that into JSON
```
{ "helloworldpy" : {
    "children" : [
        {"template" : "1→2", "id" : "n8kg52j3blKjJ06txv2A-24"},
        {"template" : "World", "id" : "wK0F3og9NH9Dy6XDwJbj-1"},
        {"template" : "Hello", "id" : "wK0F3og9NH9Dy6XDwJbj-5"}
    ],
    "wires": [
        {"type": "down",   "sender": {"id": ".", "port": ""},                        "receiver": {"id": "wK0F3og9NH9Dy6XDwJbj-5",        "port": ""}},
        {"type": "down",   "sender": {"id": ".", "port": ""},                        "receiver": {"id": "wK0F3og9NH9Dy6XDwJbj-1",        "port": ""}},
        {"type": "up",     "sender": {"id": "n8kg52j3blKjJ06txv2A-24", "port": ""}, "receiver": {"id": ".", "port": ""}},
        {"type": "up",     "sender": {"id": "n8kg52j3blKjJ06txv2A-24", "port": ""}, "receiver": {"id": ".", "port": ""}},
        {"type": "up",     "sender": {"id": "wK0F3og9NH9Dy6XDwJbj-1",  "port": "✗"},"receiver": {"id": ".", "port": ""}},
        {"type": "up",     "sender": {"id": "wK0F3og9NH9Dy6XDwJbj-5",  "port": "✗"},"receiver": {"id": ".", "port": ""}},
        {"type": "across", "sender": {"id": "wK0F3og9NH9Dy6XDwJbj-1",  "port": ""}, "receiver": {"id": "n8kg52j3blKjJ06txv2A-24", "port": ""}},
        {"type": "across", "sender": {"id": "wK0F3og9NH9Dy6XDwJbj-5",  "port": ""}, "receiver": {"id": "n8kg52j3blKjJ06txv2A-24", "port": ""}}
    ]
}}
```

Episodes 1,2 and 3 cover the conversion of the diagram to internal form.

Episode 4 concerns converting the internal form into JSON.