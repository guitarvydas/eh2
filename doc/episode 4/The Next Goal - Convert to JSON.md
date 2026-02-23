# Goal
I want to map `helloworldpy.rnet`
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

into JSON (hand-written for this prototype):
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

# Machine Readbility

**Python**

```python
import json
data = json.loads(s)  # or json.load(f) from a file
```

Result is nested dicts and lists — directly accessible as `data["helloworldpy"]["children"]` etc.

**JavaScript**

```javascript
const data = JSON.parse(s);
```

Result is a plain JS object — `data.helloworldpy.children` etc. JSON is native to JS.

**Common Lisp**

```lisp
(ql:quickload :cl-json)
(defvar data (json:decode-json-from-string s))
```

Result is an alist — slightly less convenient than the other two but perfectly workable. `cl-json` is the standard library for this.

---

Of the three, JavaScript is the most natural fit (JSON literally stands for _JavaScript_ Object Notation), Python is nearly as seamless, and Common Lisp requires a library but is still straightforward. All three can round-trip the data back to JSON just as easily.