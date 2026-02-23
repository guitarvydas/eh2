What should Container diagrams be called? In electronics, they are called "schematics", but, unlike "schematics" Container diagrams are recursive (Containers can contain Containers (or Leaf nodes)). Maybe the name should be "little network"? Shorten to "lnet"? Or "recursive schematic" or "recursive network"? Shortened to "rschem" or "rnet" or "rscm"? 

Reject "rscm" because it carries the baggage of being Scheme-like (.scm). 

I like the "r" to remind us that these things are recursive, not flat. 

I like "rnet".

An rnet contains exactly one level of a network. It contains
- a list of parts at that level
- a list of wires between parts at the level and/or the enclosing Container.

## Isolation, Completely Stand-alone Parts
No other connections are allowed. Parts cannot refer to parts in other Containers. Wires can only refer to parts within the same rnet or to the enclosing Container. Completely stand-alone. Black boxes. You cannot look "inside" a black box part, you can only see the ports (input and output) that it provides on its periphery.

This is an important aspect of LEGO-like pluggability. 

Functions in functional notation do not provide this degree of isolation. Functions pass data *and* they pass control flow, i.e. the calling function blocks until the callee returns. This is implicit synchrony. This is tight coupling. 