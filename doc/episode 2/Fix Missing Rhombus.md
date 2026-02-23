Look at `cull.ohm`. I copied this from the state machine project. 

In the state machine project, nodes are ellipses and edges have labels. This is not the case for Container diagrams. Nodes are rounded rectangles and edges do not have labels. Gates are rhombuses. Ports are, also, rectangles, but have edges coming out of or into them.

This affects the `attr`rule. I need to remove "ellipse" and "edgeLabel" and replace with matching appropriate to Container diagrams.
```
  attr =
    | "style" "=" "\"" "edgeStyle" strtail -- edgeStyle
    | "style" "=" "\"" "rhombus" strtail -- rhombus
    | "style" "=" "\"" "rounded=1" strtail -- rect
```

