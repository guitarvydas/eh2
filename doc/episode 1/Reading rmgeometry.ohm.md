```
rmgeometry {
  Main = Header Diagram+ "</mxfile>"
  Header = "<mxfile" attribute+ ">"
  Diagram = "<diagram" attribute+ ">" GraphModel+ "</diagram>"
  GraphModel = "<mxGraphModel" attribute+ ">" Root "</mxGraphModel>"
  Root = "<root>" Cell+ "</root>"

  Cell =
    | "<mxCell" attribute+ ">" Geometry "</mxCell>" -- long
    | "<mxCell" attribute+ "/>"  -- short

  Geometry =
    | "<mxGeometry" attribute+ ">" (~endGeometry any)+ endGeometry -- long
    | "<mxGeometry" attribute+ "/>" -- short
  endGeometry = "</mxGeometry>"

  attribute = name "=" str
  name = letter alnum*
  str = "\"" (~"\"" any)* "\""
}
```

The grammar parses the input file (`helloworldpy.drawio`) by providing pattern matching rules.

Ohm syntax is very similar to BNF (actually eBNF).

The grammar consists of a name followed by the set of pattern-matching rules enclosed in brace brackets.

There are 10 rules in this grammar
1. Main
2. Header
3. Diagram
4. GraphModel
5. Root
6. Cell
7. Geometry
8. attribute
9. name
10. str.

Capitalization is important. When a rule name begins with a capital letter, OhmJS skips spaces, which saves work for programmers and maintains readability. 

OhmJS is based on PEG - [Parsing Expression Grammars]([https://en.wikipedia.org/wiki/Parsing_expression_grammar](https://en.wikipedia.org/wiki/Parsing_expression_grammar)) 

Normally, PEGs require one to write matches for even small details like spaces (space, newline, tab, etc.). OhmJS saves the trouble and noise by allowing spaces to be automatically skipped for *syntactic rules* (rules whose name begins with a capital letter).

OhmJS rules that have lower-case letters at the front of their names are *lexical rules* and operate like traditional PEG rules with no space skipping.

When describing pattern matching rules for high-level grammatical constructs, it is common to use Syntactic rules (capitalized), yet, there are some cases where lower-level pattern matching must preserve every incoming character and require the programmer to specify every niggly detail, in which case *lexical rules* must be used.

A grammar rule consists of the rule name following by an `=` sign, followed by all of the matches that constitute the rule.

For purposes of this discussion, let's skip to the `Diagram` rule.
```
  Diagram = "<diagram" attribute+ ">" GraphModel+ "</diagram>"
```

The `Diagram` rule matches an XML `<diagram` `...``</diagram>` construct.

 It contains five matches
 1. it must match the string `<diagram`
 2. then, 1 or more (`+`) attributes. The `attribute` sub-rule is called for each match, here
 3. it must match the string `>`
 4. it must match 1 or more `GraphModel` sub-rules
 5. and, finally, it must match the string `</diagram>`.

If the matching fails at any point, the whole rule fails.

Some rules, eg. `Cell` and `Geometry` contain several branches. Each branch begins with `|` and usually ends with a branch name like `-- long`.
If the matching fails at any point, the whole rule fails, and the parser backtracks and tries the next rule (if any). The branch name is used in the *semantics* portion of OhmJS code, creating a semantics rule name by combining the grammar rule name, an `_` and the branch name. The `.rwr` rewrite rule compiler automatically creates  *semantic* code to correspond with OhmJS grammars. The `t2t` tool joins the two rule files together into a complete whole.

I only discuss the grammar syntax needed for this example. The full syntax of OhmJS grammars can be found on the [ohmjs](ohmjs.org) website.