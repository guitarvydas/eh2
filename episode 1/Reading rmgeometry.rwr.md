```
% rewrite rmgeometry {
  Main [_begin Diagram+ _end] = ‛group {\n«Diagram»\n}’
  Header [_begin attr+ gt] = ‛’
  Diagram [_begin attrs+ gt GraphModels+ _end] = ‛\ndiagram {«attrs»«GraphModels»\n}’
  GraphModel [_begin attribute+ gt Root _end] = ‛«Root»’
  Root [_begin Cells+ _end] = ‛«Cells»’

  Cell_long [_begin attributes+ gt Geometry _end] = ‛\ncell {«attributes»\n}’
  Cell_short[_begin attributes+ slashgt] = ‛’

  Geometry_long [_begin attribute+ gt cs+ endGeometry] = ‛’
  Geometry_short [_begin attribute+ slashgt]= ‛’
  endGeometry [_] = ‛’

  attribute [name eq str] = ‛\n«name»=«str»’
  name [letter alnum*] = ‛«letter»«alnum»’
  str [_begin cs* _end] = ‛"«cs»"’
}
```

The rewrite rules combine the parsed input text into new output text as specified by the rules.

The rewrite ruleset begins with `% rewrite` followed by the grammar name followed by a brace bracketed section of rules. [*One can specify %parameters before the  % rewrite section, but, we'll leave that detail for later. It is not needed for the rmgeometry rule set.*]

There must be one rewrite rule for each corresponding grammar rule. In the case where a grammar rule has branches, each branch must correspond to a rewrite rule named accordingly (grammar rule name `_` branch name).

Let's look at the `Diagram` rewrite rule, which corresponds to the `Diagram` grammar rule.
```
  Diagram [_begin attrs+ gt GraphModels+ _end] = ‛\ndiagram {«attrs»«GraphModels»\n}’
```

The grammar rule matches five patterns and sends them to the `Diagram` rewrite rule as "parameters" (small concrete syntax trees) to the rewrite rule. The parameter names are arbitrary, but must adhere to Javascript naming standards. In this particular case, I chose the names
- `_begin`
- `attrs`
- `gt`
- `GraphModel`
- `_end`

As it stands, the `+` / `*` / `?` suffix operators must match the original grammar. This  suffix matching could be automated, but, currently isn't.

The grammar rule `Diagram` is, once again,
```
  Diagram = "<diagram" attribute+ ">" GraphModel+ "</diagram>"
```

In the grammar rule, the matches specify suffix operators for `attribute+` and `GraphModel+`. The parameters passed from the parser to the rewriter are slightly different when the `+`/`*`/`?` operators are used in the grammar. The rewriting tools needs to know that the parameters a different, hence, we need to ensure that the suffix operators are correctly shown on the parameters to the rewrite rules. (Getting this wrong can lead to subtle bugs, hence, we hope that this will be automatically tracked in the future. Automating this is probably not difficult, but, implementing it detracts from the bigger picture of how this notation can work, hence, we're simply avoiding it at the moment).

To be more specific about using the `helloworldpy.drawio` example shown earlier, the grammar matches the `diagram` element in the `helloworldpy.drawio` 
`<diagram name="main" id="o9M2tmKP6ZUbm1JD93Ax">` ... `</diagram>`
and binds the rewrite rule parameters as follows:
- `_begin` is bound to `<diagram`
- `attrs` is bound to the list (`name="main"` `id="o9M2tmKP6ZUbm1JD93Ax"`)
- `gt` is bound to `>`
- `GraphModel` is bound to a list (`...`) of all of the content portions between the `<mxGraphModel` and `</mxGraphModel>` brackets
- `_end` is bound to `</diagram>`

The rewrite rule `Diagram` formats a new string using some of the bindings, while ignoring some of the other binding, to create a return string
```

diagram {
<the string returned by the attrs+ match>
<the string returned by the GraphModel+ match>
}
```

(newlines are inserted in the `attrs+` and `GraphModel+` rules).

The `Diagram` rewrite rule discards `<diagram` and `>` and `</diagram>`. This kind of rewriting happens in a recursive manner, the deepest rewrite rule returns a string which is pasted into the next rule up and so on.

The actual rewrites from each stage can be observed by capturing the rewritten code as it is being piped downstream to subsequent stages.

As an example, the `rmgeometry` rewrite creates the following intermediate result. Remember that this result is only a partial result. The file is rewritten with `group{...)` and `diagram{...}` and `cell{...}` constructs and the `mxGeometry` elements have been deleted. The result is not legal `graphML` nor `JSON`, but, the subsequent stage (`cull`) contains a grammar that accepts this format.
```
group {

diagram {
name="main"
id="o9M2tmKP6ZUbm1JD93Ax"
cell {
id="n8kg52j3blKjJ06txv2A-1"
parent="1"
style="rhombus;whiteSpace=wrap;html=1;rounded=1;fontStyle=1;glass=0;sketch=0;fontSize=12;points=[[0,0.5,0,0,0],[0.5,0,0,0,0],[0.5,1,0,0,0],[1,0.5,0,0,0]];shadow=1;fontFamily=Helvetica;fontColor=default;labelBackgroundColor=none;"
value=""
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-2"
parent="1"
style="rhombus;whiteSpace=wrap;html=1;rounded=1;fontStyle=1;glass=0;sketch=0;fontSize=12;points=[[0,0.5,0,0,0],[0.5,0,0,0,0],[0.5,1,0,0,0],[1,0.5,0,0,0]];shadow=1;fillColor=#0050ef;fontColor=#ffffff;strokeColor=#001DBC;fontFamily=Helvetica;labelBackgroundColor=none;"
value=""
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-24"
parent="1"
style="rounded=1;whiteSpace=wrap;html=1;container=1;recursiveResize=0;verticalAlign=top;arcSize=6;fontStyle=1;autosize=0;points=[];absoluteArcSize=1;shadow=1;strokeColor=#6c8ebf;fillColor=#dae8fc;fontFamily=Helvetica;fontSize=11;gradientColor=#E6E6E6;fontColor=default;labelBackgroundColor=none;"
value="1→2"
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-25"
parent="n8kg52j3blKjJ06txv2A-24"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];arcSize=50;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=none;"
value="2"
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-26"
parent="n8kg52j3blKjJ06txv2A-24"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;arcSize=50;fontFamily=Helvetica;fontSize=11;labelBackgroundColor=none;"
value="1"
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-27"
parent="n8kg52j3blKjJ06txv2A-24"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];arcSize=50;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=none;"
value="1"
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-28"
parent="n8kg52j3blKjJ06txv2A-24"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;arcSize=50;fontFamily=Helvetica;fontSize=11;labelBackgroundColor=none;"
value="2"
vertex="1"
}
cell {
id="n8kg52j3blKjJ06txv2A-29"
edge="1"
parent="1"
source="n8kg52j3blKjJ06txv2A-26"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;strokeColor=default;strokeWidth=2;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;"
target="n8kg52j3blKjJ06txv2A-2"
}
cell {
id="n8kg52j3blKjJ06txv2A-30"
edge="1"
parent="1"
source="n8kg52j3blKjJ06txv2A-28"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;strokeColor=default;strokeWidth=2;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;"
target="n8kg52j3blKjJ06txv2A-2"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-1"
parent="1"
style="rounded=1;whiteSpace=wrap;html=1;container=1;recursiveResize=0;verticalAlign=top;arcSize=6;fontStyle=1;autosize=0;points=[];absoluteArcSize=1;shadow=1;strokeColor=#6c8ebf;fillColor=#dae8fc;fontFamily=Helvetica;fontSize=11;gradientColor=#0050EF;fontColor=default;labelBackgroundColor=none;"
value="World"
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-2"
parent="wK0F3og9NH9Dy6XDwJbj-1"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];arcSize=50;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=none;"
value=""
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-3"
parent="wK0F3og9NH9Dy6XDwJbj-1"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;arcSize=50;fontFamily=Helvetica;fontSize=11;labelBackgroundColor=none;"
value=""
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-4"
parent="wK0F3og9NH9Dy6XDwJbj-1"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;arcSize=50;fontFamily=Helvetica;fontSize=11;textOpacity=30;labelBackgroundColor=none;"
value="✗"
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-5"
parent="1"
style="rounded=1;whiteSpace=wrap;html=1;container=1;recursiveResize=0;verticalAlign=top;arcSize=6;fontStyle=1;autosize=0;points=[];absoluteArcSize=1;shadow=1;strokeColor=#6c8ebf;fillColor=#dae8fc;fontFamily=Helvetica;fontSize=11;gradientColor=#0050EF;fontColor=default;labelBackgroundColor=none;"
value="Hello"
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-6"
parent="wK0F3og9NH9Dy6XDwJbj-5"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];arcSize=50;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=none;"
value=""
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-7"
parent="wK0F3og9NH9Dy6XDwJbj-5"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;arcSize=50;fontFamily=Helvetica;fontSize=11;labelBackgroundColor=none;"
value=""
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-8"
parent="wK0F3og9NH9Dy6XDwJbj-5"
style="rounded=1;whiteSpace=wrap;html=1;sketch=0;points=[[0,0.5,0,0,0],[1,0.5,0,0,0]];fillColor=#1ba1e2;fontColor=#ffffff;strokeColor=#006EAF;arcSize=50;fontFamily=Helvetica;fontSize=11;textOpacity=30;labelBackgroundColor=none;"
value="✗"
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-9"
edge="1"
parent="1"
source="n8kg52j3blKjJ06txv2A-1"
style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;curved=0;strokeWidth=2;"
target="wK0F3og9NH9Dy6XDwJbj-2"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-10"
edge="1"
parent="1"
source="n8kg52j3blKjJ06txv2A-1"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;strokeColor=default;strokeWidth=2;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;"
target="wK0F3og9NH9Dy6XDwJbj-6"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-11"
edge="1"
parent="1"
source="wK0F3og9NH9Dy6XDwJbj-3"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;strokeColor=default;strokeWidth=2;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;"
target="n8kg52j3blKjJ06txv2A-25"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-12"
edge="1"
parent="1"
source="wK0F3og9NH9Dy6XDwJbj-7"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;strokeColor=default;strokeWidth=2;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;"
target="n8kg52j3blKjJ06txv2A-27"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-13"
parent="1"
style="rhombus;whiteSpace=wrap;html=1;rounded=1;fillColor=#0050ef;fontColor=#ffffff;strokeColor=#001DBC;fontStyle=1;glass=0;sketch=0;fontSize=12;points=[[0,0.5,0,0,0],[0.5,0,0,0,0],[0.5,1,0,0,0],[1,0.5,0,0,0]];shadow=1;opacity=30;textOpacity=30;labelBackgroundColor=none;fontFamily=Helvetica;"
value="✗"
vertex="1"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-14"
edge="1"
parent="1"
source="wK0F3og9NH9Dy6XDwJbj-4"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;strokeColor=default;strokeWidth=1;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;dashed=1;"
target="wK0F3og9NH9Dy6XDwJbj-13"
}
cell {
id="wK0F3og9NH9Dy6XDwJbj-15"
edge="1"
parent="1"
source="wK0F3og9NH9Dy6XDwJbj-8"
style="edgeStyle=orthogonalEdgeStyle;shape=connector;curved=0;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;exitPerimeter=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;dashed=1;strokeColor=default;strokeWidth=1;align=center;verticalAlign=middle;fontFamily=Helvetica;fontSize=11;fontColor=default;labelBackgroundColor=default;endArrow=classic;"
target="wK0F3og9NH9Dy6XDwJbj-13"
}
}
}
```

