I wrote a short grammar that can pattern match the results from stage 5.

![](rnet2swipl%20grammar%20Screenshot%202026-02-21%20at%207.53.08%20AM.png)
Next, I wrote a set of rewrite rules for this grammar that appends commas to each attribute and each cell and each diagram.

To start with, I made the rewrite an identity - output == input with some spaces removed. This helps to wring out some of the silly typos before proceeding with a proper rewrite.
```
% rewrite rnet2swipl {
  Top [_group lb Diagram+ rb] = ‛«_group»«lb»«Diagram»«rb»’
  Diagram [_diagram lb IDattr Cell+ rb] = ‛«_diagram»«lb»«IDattr»«Cell»«rb»’
  IDattr [_id eq str] = ‛«_id»«eq»«str»’
  Cell [_cell lb Attr+ rb] = ‛«_cell»«lb»«Attr»«rb»’
  Attr [name eq str] = ‛«name»«eq»«str»’
  str [dqL cs* dqR] = ‛«dqL»«cs»«dqR»’
  name [letter alnum*] = ‛«letter»«alnum»’
}
```

The result of the identity rewrite looks like the input.

Now, I can tweak the rewrite rules to get what I want (commas in the right places, along with some redundant commas, and some newlines for pretty-printing). 
```
% rewrite rnet2swipl {
  Top [_group lb Diagram+ rb] = ‛«_group» «lb»«Diagram»«rb»’
  Diagram [_diagram lb IDattr Cell+ rb] = ‛\n«_diagram» «lb»«IDattr»«Cell»«rb»’
  IDattr [_id eq str] = ‛\n«_id»«eq»«str»,’
  Cell [_cell lb Attr+ rb] = ‛\n«_cell» «lb»«Attr»«rb»,’
  Attr [name eq str] = ‛\n«name»«eq»«str»,’
  str [dqL cs* dqR] = ‛«dqL»«cs»«dqR»’
  name [letter alnum*] = ‛«letter»«alnum»’
}
```

and, some extra pretty-printing in `commas.py`:
```
#!/usr/bin/env python
import sys
s = sys.stdin.read().replace(',)', ')').replace(',}', '}').replace(',]', ']')
sys.stdout.write(s.replace("}", "\n}"))
```

The output, after post-processing with `commas.py` is:

```
group {
    diagram {
	id="o9M2tmKP6ZUbm1JD93Ax",
	cell {
	    id="n8kg52j3blKjJ06txv2A-1",
	    parent="1",
	    kind="rhombus",
	    value=""
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-2",
	    parent="1",
	    kind="rhombus",
	    value=""
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-24",
	    parent="1",
	    kind="rect",
	    value="1→2"
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-25",
	    parent="n8kg52j3blKjJ06txv2A-24",
	    kind="rect",
	    value="2"
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-26",
	    parent="n8kg52j3blKjJ06txv2A-24",
	    kind="rect",
	    value="1"
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-27",
	    parent="n8kg52j3blKjJ06txv2A-24",
	    kind="rect",
	    value="1"
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-28",
	    parent="n8kg52j3blKjJ06txv2A-24",
	    kind="rect",
	    value="2"
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-29",
	    parent="1",
	    source="n8kg52j3blKjJ06txv2A-26",
	    kind="edge",
	    target="n8kg52j3blKjJ06txv2A-2"
	},
	cell {
	    id="n8kg52j3blKjJ06txv2A-30",
	    parent="1",
	    source="n8kg52j3blKjJ06txv2A-28",
	    kind="edge",
	    target="n8kg52j3blKjJ06txv2A-2"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-1",
	    parent="1",
	    kind="rect",
	    value="World"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-2",
	    parent="wK0F3og9NH9Dy6XDwJbj-1",
	    kind="rect",
	    value=""
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-3",
	    parent="wK0F3og9NH9Dy6XDwJbj-1",
	    kind="rect",
	    value=""
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-4",
	    parent="wK0F3og9NH9Dy6XDwJbj-1",
	    kind="rect",
	    value="✗"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-5",
	    parent="1",
	    kind="rect",
	    value="Hello"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-6",
	    parent="wK0F3og9NH9Dy6XDwJbj-5",
	    kind="rect",
	    value=""
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-7",
	    parent="wK0F3og9NH9Dy6XDwJbj-5",
	    kind="rect",
	    value=""
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-8",
	    parent="wK0F3og9NH9Dy6XDwJbj-5",
	    kind="rect",
	    value="✗"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-9",
	    parent="1",
	    source="n8kg52j3blKjJ06txv2A-1",
	    kind="edge",
	    target="wK0F3og9NH9Dy6XDwJbj-2"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-10",
	    parent="1",
	    source="n8kg52j3blKjJ06txv2A-1",
	    kind="edge",
	    target="wK0F3og9NH9Dy6XDwJbj-6"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-11",
	    parent="1",
	    source="wK0F3og9NH9Dy6XDwJbj-3",
	    kind="edge",
	    target="n8kg52j3blKjJ06txv2A-25"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-12",
	    parent="1",
	    source="wK0F3og9NH9Dy6XDwJbj-7",
	    kind="edge",
	    target="n8kg52j3blKjJ06txv2A-27"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-13",
	    parent="1",
	    kind="rhombus",
	    value="✗"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-14",
	    parent="1",
	    source="wK0F3og9NH9Dy6XDwJbj-4",
	    kind="edge",
	    target="wK0F3og9NH9Dy6XDwJbj-13"
	},
	cell {
	    id="wK0F3og9NH9Dy6XDwJbj-15",
	    parent="1",
	    source="wK0F3og9NH9Dy6XDwJbj-8",
	    kind="edge",
	    target="wK0F3og9NH9Dy6XDwJbj-13"
	}
    }
}
```

Is this enough to for SWIPL?

No.

```
$ swipl

Welcome to SWI-Prolog (threaded, 64 bits, version 9.2.9)

SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.

Please run ?- license. for legal details.

  

For online help and background, visit https://www.swi-prolog.org

For built-in help, use ?- help(Topic). or ?- apropos(Word).

  

?- consult('swipl5.txt').

**ERROR: /Users/paultarvydas/projects/eh2/swipl5.txt:157:1: Syntax error: Unexpected end of file**

**true.**
```

I whittle the test case down to one cell, in file `temp.pl`
```
group {
    diagram {
        id="o9M2tmKP6ZUbm1JD93Ax",
        cell {
            id="n8kg52j3blKjJ06txv2A-1",
            parent="1",
            kind="rhombus",
            value=""
        }
```

and still get a swipl load error
```
?- consult(temp).

**ERROR: /Users/paultarvydas/projects/eh2/temp.pl:11:1: Syntax error: Unexpected end of file**

**true.**
```

After some quick playing around, this form seems to be acceptable:
```
group(
    diagram(
	id="o9M2tmKP6ZUbm1JD93Ax",
	cell(
	    id="n8kg52j3blKjJ06txv2A-1",
	    parent="1",
	    kind="rhombus",
	    value=""
	)
    )
).
```

i.e. the brace brackets should be parentheses, there should be no spaces before open parentheses, and there should be a period at the end.

Let's try that.
```
% rewrite rnet2swipl {
  Top [_group lb Diagram+ rb] = ‛«_group»(«Diagram»).’
  Diagram [_diagram lb IDattr Cell+ rb] = ‛\n«_diagram»(«IDattr»«Cell»)’
  IDattr [_id eq str] = ‛\n«_id»«eq»«str»,’
  Cell [_cell lb Attr+ rb] = ‛\n«_cell»(«Attr»),’
  Attr [name eq str] = ‛\n«name»«eq»«str»,’
  str [dqL cs* dqR] = ‛«dqL»«cs»«dqR»’
  name [letter alnum*] = ‛«letter»«alnum»’
}
```

and `commas.py` (added newline before right paren):

```
#!/usr/bin/env python
import sys
s = sys.stdin.read().replace(',)', ')').replace(',}', '}').replace(',]', ']')
sys.stdout.write(s.replace("}", "\n}").replace(')', '\n)'))
```

after removing some redundant `echo` statements in the bash scripts, the result is acceptable to swipl
```
$ ./@make >swipl5.pl
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 9.2.9)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.
For online help and background, visit https://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).
?- consult(swipl5).
**true.**
?-
```

