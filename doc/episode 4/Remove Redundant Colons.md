I began writing the grammar for `.rnet` and see colons in the generated code that are redundant
```
  ...
  children: [❲1→2❳❲n8kg52j3blKjJ06txv2A-24❳ ❲World❳❲wK0F3og9NH9Dy6XDwJbj-1❳ ❲Hello❳❲wK0F3og9NH9Dy6XDwJbj-5❳]
  wires: {
  ...
```
These colons aren't necessary. 

I removed them by tweaking `generate.pl`.
