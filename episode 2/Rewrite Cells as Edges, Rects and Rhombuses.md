The previous work indicates that it might be easy to use `t2t` to rewrite cells with their appropriate kinds.

For example, if we see
```
        cell {
            id="n8kg52j3blKjJ06txv2A-1"
            parent="1"
            kind="rhombus"
            value=""}
```

we should rewrite it as
```
        gate {
            id="n8kg52j3blKjJ06txv2A-1"
            value=""}
```

and 
```
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-1"
            parent="1"
            kind="rect"
            value="World"}
```

should become
```
        rect {
            id="wK0F3og9NH9Dy6XDwJbj-1"
            parent="1"
            value="World"}
```

and
```
        cell {
            id="n8kg52j3blKjJ06txv2A-29"
            parent="1"
            source="n8kg52j3blKjJ06txv2A-26"
            kind="edge"
            target="n8kg52j3blKjJ06txv2A-2"}
```

should become
```
        edge {
            id="n8kg52j3blKjJ06txv2A-29"
            source="n8kg52j3blKjJ06txv2A-26"
            target="n8kg52j3blKjJ06txv2A-2"}
```

N.B. I need to keep the "parent" field for rects, because I haven't yet figured out the ownership relationships between different kinds of rects (ports that belong to parts - both "rects").

How should that be done with `t2t`?

Firstly, I need to set up patterns for each kind of cell, 
- a `rect` cell contains `id`, `parent` and `value` attributes and must contain `kind="rect"`.
- a `gate` cell contains `id` and `value` attributes and must contain `kind="rhombus"`
- an `edge` cell contains `id`, `source` and `target` attributes and must contain `kind="edge"`