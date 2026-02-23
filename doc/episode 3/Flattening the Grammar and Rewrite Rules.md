The biggest change to the grammar and rewrite rules is to replace the `+` operator with recursion (`Cells?` at the end of each `Cells` branch). 

Recursion allows the rewriter to set up `diagramid` and `cellid` dynamic variables that flow into the rest of the attribute rules. The attribute rules (`Attr`) use the most-recent values of `diagramid` and `cellid` in writing flattened facts. Each generated fact must contain a back-reference to the `diagramid` and the `cellid`.

This trick of saving the "current" `diagramid` and `cellid` on respective stacks is used to tree-walk structured source code and to convert it into "unstructured", flat source code.

Aside: the variables (which I call `%parameter`s) `diagramid` and `cellid` are like dynamically bound variables in Lisp 1.5 or "earmuff" variables in Common Lisp. In Common Lisp, earmuff variables are created using the `defparameter` function. Earmuff variables are dynamically bound variables. A lower-level way to create dynamically bound variables is to declare them as "special". Further aside: the term "earmuff" refers to the convention that dynamically bound variables have names that are prefixed and suffixed with the asterisk `"*"` character, e.g. `*xyz*`.
# Grammar mr.ohm


```
mr2swipl {
  Top = "group" "{" Diagram+ "}"
  Diagram = "diagram" "{" Cellid "[" Cells "]" "}"
  Cells = 
   | "gate" "{" Cellid Attr "}" Cells? -- gate
   | "rect" "{" Cellid Attr "}" Cells? -- rect
   | "edge" "{" Cellid Attr "}" Cells? -- edge
  Cellid= "id" "=" str
  Attr = name "=" str Attr?
  str = "\"" (~"\"" any)* "\""
  name = letter alnum*
}
```
# Rewrite Rules mr.rwr
The rewrite rules for `Diagram`, `Cells_gate`, `Cells_rect` and `Cells_edge` contain `rwr` syntax that pushes new bindings for the `diagramid` and `cellid` dynamic variables. The topmost binding of each variable are accessed with the syntax `⟪diagramid⟫` and `⟪cellid⟫`[^1] used inside rewrite strings `‛...’`
[^1]:N.B. the unicode angle brackets for parameter references are different symbols than the double-angle-brackets used for string interpolation.
```
% parameter diagramid
% parameter cellid
% rewrite mr2swipl {
  Top [_group lb Diagram+ rb] = ‛«Diagram»’
  Diagram [_diagram lb id lb2 Cells rb2 rb] =
    ⎡ diagramid=‛«id»’
      ‛\ndiagram(⟪diagramid⟫).«Cells»’
    ⎦

  Cells_gate [_cell lb id Attr rb rec?] =
    ⎡ cellid=‛«id»’
      ‛\ngate(⟪diagramid⟫,⟪cellid⟫).«Attr»«rec»’
    ⎦
  Cells_rect [_cell lb id Attr rb rec?] = 
    ⎡ cellid=‛«id»’
      ‛\nrect(⟪diagramid⟫,⟪cellid⟫).«Attr»«rec»’
    ⎦
  Cells_edge [_cell lb id Attr rb rec?] =
    ⎡ cellid=‛«id»’
      ‛\nedge(⟪diagramid⟫,⟪cellid⟫).«Attr»«rec»’
    ⎦

  Cellid [_id eq str] = ‛«str»’
  Attr [name eq str rec?] = ‛\n«name»(⟪diagramid⟫,⟪cellid⟫,«str»).«rec»’
  str [dqL cs* dqR] = ‛«dqL»«cs»«dqR»’
  name [letter alnum*] = ‛«letter»«alnum»’
}
```


# RWR Walkthrough
## line 1
The declaration
```
% parameter diagramid
```
creates a dynamic variable `diagramid`. 

A dynamic variable is like a stack of scoped values . The topmost stack value is the "current" value of the variable. When a scope is entered, a new value is pushed onto the stack. When a scope is exited, the topmost value is popped off, revealing the previous value of the variable and making it - again - the "current" value of the dynamic variable.

A `%parameter` dynamic variable is implemented, literally, as a stack. The syntax `⟪diagramid⟫` returns the topmost value of the dynamic variable. 

The syntax
```
⎡ diagramid=‛... ...’
  ‛...’
⎦
```

creates a new scope and evaluates `‛...’` within that scope. The original `‛... ...’` is evaluated before the new scope is created, hence, it uses the "previous" scope and the "previous" values of any variables.

The syntax `‛...’` creates a new string. Several operations are allowed inside the quotes
- stand alone characters are simply copied into the resulting new string
- `«x»` interpolates the `x` argument into the resulting new string. The `x` argument must appear by name in the `[...]` argument of the rewrite rule and represents an opaque data structure created by the front-end parser - the "CST". The CST is evaluated in a recursive descent manner to return a string (e.g. it is tree-walked and recursively evaluated to build a single sub-string).
- `⟪y⟫` (note that the unicode brackets `⟪...⟫` are different from the unicode brackets `«...»` used for argument interpolation, above) interpolates the value of the `%parameter` (e.g. "y", here). The "current" value (top-most in the "stack") is fetched and inserted into the resulting new string
- `⎨f ‛...’ ‛...’ ...⎬` call the support function `f` written in some host language (currently Javascript, due to the use of Ohm implemented in Javascript). The function returns a (single) string whose value is inserted into the resulting new string. If the function requires parameters, the parameters, each, consist of `‛...’` string-building operations (recursive - string builders can contain other string-builders). A support function that requires no arguments (the common case) is written as `⎨f⎬`.

## line 2
```
% parameter cellid
```
This creates a dynamic variable (a stack of variables) named `cellid`.
## line 3
```
% rewrite mr2swipl {
```
This declares a set of rewrite rules for the grammar `mr2swipl`. The rules are enclosed in a pair of brace brackets.
## line 4
```
 Top [_group lb Diagram+ rb] = ‛«Diagram»’
```
This is the first rewrite rule. It matches with the grammar rule named `Top`. On successful parsing the grammar hands four arguments to this rule. I've given each argument an arbitrary name. Naming must follow legal naming conventions in Javascript. Additionally, when the grammar contains an "iteration operator" (`+`/`*`/`?`), the operator must also be included as a suffix for the argument.

The name of the rewrite rule, `Top` comes first, then the group of sub-match arguments `[_group lb Diagram+ rb]` enclosed in square brackets.

The matching grammar rule is:
```
  Top = "group" "{" Diagram+ "}"
```
Here, we see that the third match in the body of the grammar rule is `Diagram+` which uses a `+` iteration operator, hence, we write `Diagram+` in the above rewrite rule, too.

Following the rule name an argument group, is an equal sign `=`. Following that comes the rewrite. Usually, the rewrite just consists of a rewrite string enclosed in begin and end unicode quotes `‛«Diagram»’`, but, can also include scopes. I don't need to add scopes at this point, so only the rewrite string `‛«Diagram»’` is seen here (scopes are used in other rules, further down).

This rewrite string `‛«Diagram»’` contains only a single argument-interpolation operation and nothing else. Hence, the result string is simply the value of the evaluated argument `Diagram+`. The rewriter has already been told that `Diagram` will contain an "iterator" CST, so the `+` must not be repeated here. The effect of this simple rewrite is to cause the rewriter to recursively evaluate (tree-walk) the `Diagram` argument CST created by the parser. You don't need to know what the CST looks like, just name it and use it here - the rewriting engine does the rest of the evaluation work. The evaluation of the CST results in a single string. That string is interpolated into the result and is returned from this rule.

It's just a simple recursive traversal of the parse tree (CST) where every node creates a string using strings created by its children nodes.

## Line 5
```
  Diagram [_diagram lb id lb2 Cells rb2 rb] =
```
This is the second rewrite rule, corresponding to the grammar rule:
```
  Diagram = "diagram" "{" Cellid "[" Cells "]" "}"
```
The args correspond to the grammar's sub-matches...
- `_diagram` corresponds to `"diagram"`
- `lb` (left brace) corresponds to `"{"`
- `id` corresponds to `Cellid` (another grammar rule)
- `lb2` (left bracket with a different JS name than the first `lb`) corresponds to `"["`
- `Cells` corresponds to the call to the `Cells` grammar rule
- `rb2` (right bracket) corresponds to `"]"`
- `rb` (right brace) corresponds to `"}"`

Note that the above names are arbitrary, but must be unique and legal Javascript names. I arbitrarily chose `lb` to be left brace, and wanted to use the same name for the left bracket, but had to differentiate the name by suffixing it with the numeral `2`.

The rest of the rewrite rule spans lines 6,7, and, 8, below.
## Line 6
```
⎡ diagramid=‛«id»’
```
This line opens a new rewrite scope and initializes the `diagramid` dynamic variable to the value of the the `id` argument.
## line 7
```
      ‛\ndiagram(⟪diagramid⟫).«Cells»’
```
This is the actual rewrite. It composes a string in the scope established in line 6, hence, `⟪diagramid⟫` interpolates the value of the `diagramid` dynamic variable. See line 6 for how that was initialized. In this code, the `id` for the diagram is interpolated into the result string.

The reference to `«Cells»` recursively evaluates the Cells CST and interpolates its result into the result string. In this example, this evaluates to a long string of Prolog facts. I won't bother repeating them here.

The characters `\ndiagram(`and `).` are simply copied, verbatim, into the result string.

The final result is (abbreviated):
```
diagram("o9M2tmKP6ZUbm1JD93Ax").
edge("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-29").
edge("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30").
...
```
## line 8
```
    ⎦
```
This closes the scope and pops the value of `diagramid` off of the `%parameter diagramid` stack. Any further use of `⟪diagramid⟫` should result in a stack underflow exception. Of course, this doesn't happen in this example, since this code has already been debugged and is written in an acceptable manner.
## Cells Rewrite Rules
```
  Cells_gate [_cell lb id Attr rb rec?] =
    ⎡ cellid=‛«id»’
      ‛\ngate(⟪diagramid⟫,⟪cellid⟫).«Attr»«rec»’
    ⎦
  Cells_rect [_cell lb id Attr rb rec?] = 
    ⎡ cellid=‛«id»’
      ‛\nrect(⟪diagramid⟫,⟪cellid⟫).«Attr»«rec»’
    ⎦
  Cells_edge [_cell lb id Attr rb rec?] =
    ⎡ cellid=‛«id»’
      ‛\nedge(⟪diagramid⟫,⟪cellid⟫).«Attr»«rec»’
    ⎦

  Cellid [_id eq str] = ‛«str»’
  Attr [name eq str rec?] = ‛\n«name»(⟪diagramid⟫,⟪cellid⟫,«str»).«rec»’
```

The grammar picks off three kinds of Cells
- gate
- rect
- edge.

The rewriter rewrites them as Prolog facts, for example
```
gate("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","1").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","").
```

The recursive nature of the grammar and the rewrite rules pastes these Prolog facts together in a sequential manner. For example, the `Cells_gate` rule pushes the gate's id onto `cellid` then recursively evaluates the remaining attributes using the recursive rule `Attr`. Each call to `Attr`, in the rewriter, creates one Prolog fact, and then appends more such facts, recursively, into the result string.

Continuing with this example, the deepest call to `Attr` creates
```
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","").
```
which contains, in order, the diagram id, the cell id, then the value "" (an empty string).

This string is returned up the tree which creates
```
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","1").
```
and then pastes the `value(...).` rule onto the tail of this result.

The topmost call to `Attr` produces
```
gate("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1").
```
and glues the other two rules onto the tail of this string to give the three-line result above.

When the recursion in `Attr` stops, we recur, again on `Cells` and append the results on this result string. The final result is a long string of Prolog facts, which I don't repeat here.

SWIPL Prolog prefers that the facts be grouped and sorted. This is done using the `sort` command near the end of the `@makec` script.

## The Rest of the Rewrite Rules  
```
  str [dqL cs* dqR] = ‛«dqL»«cs»«dqR»’
  name [letter alnum*] = ‛«letter»«alnum»’
}
```
Strings (`str`) and names are parsed, then reconstructed and returned "as is" to the rest of the rules in the above rewrite script.

`str` is given three arguments
1. the left double quote
2. a bunch of characters that are not double quotes (the `*` says that there might be no characters in the bunch)
3. the right double quote.

The rewrite rule says to just glue the values of the three arguments together to form the result string.

Likewise for `name`. It has at least one letter followed by zero or more alpha numeric letters. I might need to modify these rules to include the underscore `"_"` character which is not matched by the built in rules `letter` nor `alnum`.
