First, I fixed the output of kinds to make a list of children in square brackets `[...]`.

Then, I fixed up `rnet2swipl` to recognize the output after the `kinds` stage is run.

The output `out.mr` contains `gate{...}`, `rect{...}` and `edge{...}` instead of raw cell facts.

Now, I want to query for a child rect that has another rect as its parent. In Prolog, when you get the query working, you can ask for multiple retries at the command line or use `forall` and `findall` to find all matches.

For starters, let's just get one match to work.

There are two ways to express this query.

# Query A
A query consists of sub-queries strung joined together by commas.

The first sub-query, here, is
```
group(diagram{children: Children})
```

which matches a `group` that contains a `diagram` which contains a list of children. The upper case name `Children` is a "logic variable", which means that it starts out empty and is filled in by the underlying Prolog engine every time all sub-matches of the match succeed. You can see that the logic variable `Children`is used in the subsequent queries, which means that *all* instances of the variable need to be the same (consistent) in the sub-queries, for the full match to succeed.

```
?- group(diagram{id:_,children: Children}),
   member(rect{id: Id, parent: _, value: _}, Children),
   member(rect{id: Id2, parent: Id, value: _}, Children).
```

Let's try just the first sub-query. I start `swipl`, then load the factbase using `consult('out.pl').` Then I run the sub-query `group(diagram{id:_,children: Children}).` the result shows that the logic variable `Children` is bound to a list of cells (gate, rect, edge). Each cell is a dict, denoted by the brace brackets `{...}`.

Run this query on the command line on your local machine.

Here is the output that I captured:
```
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 9.2.9)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit https://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?- consult('out.pl').
**true.**

?- group(diagram{id:_,children: Children}).

Children = [gate{id:"n8kg52j3blKjJ06txv2A-1", parent:"1", value:""}, gate{id:"n8kg52j3blKjJ06txv2A-2", parent:"1", value:""}, rect{id:"n8kg52j3blKjJ06txv2A-24", parent:"1", value:"1→2"}, rect{id:"n8kg52j3blKjJ06txv2A-25", parent:"n8kg52j3blKjJ06txv2A-24", value:"2"}, rect{id:"n8kg52j3blKjJ06txv2A-26", parent:"n8kg52j3blKjJ06txv2A-24", value:"1"}, rect{id:"n8kg52j3blKjJ06txv2A-27", parent:"n8kg52j3blKjJ06txv2A-24", value:"1"}, rect{id:"n8kg52j3blKjJ06txv2A-28", parent:"n8kg52j3blKjJ06txv2A-24", value:"2"}, edge{id:"n8kg52j3blKjJ06txv2A-29", parent:"1", source:"n8kg52j3blKjJ06txv2A-26", target:"n8kg52j3blKjJ06txv2A-2"}, ...{... : ..., ... : ..., ... : ..., ... : ...}|...].
?-
```

The answer indicates that this is the only match, since it doesn't give me the option to ask for more (using ";") and just gives me the top level Prolog prompt `?- `.

## Multiple Matches and Retries
To see multiple retries, I can try a different query (which won't be a part of our final version). I created a file `/tmp/xxx.pl` that contains:
```
child(Child):-group(diagram{id:_,children:Children}),member(Child,Children).
```

This creates a rule called `child` (lower case) that has one two-way logic variable `Child` (upper case). Unlike functions in many modern languages, "parameters" to Prolog rules can start out empty and are filled in by the engine. After each match, the engine displays the value of the parameter(s) then waits for either a `;` to backtrack and find another suitable match or `.` to quit.

Here, I try this `child` query and get 4 answers before quitting:
```
?- consult('/tmp/xxx.pl').
true.

?- child(X).
X = gate{id:"n8kg52j3blKjJ06txv2A-1", parent:"1", value:""} ;
X = gate{id:"n8kg52j3blKjJ06txv2A-2", parent:"1", value:""} ;
X = rect{id:"n8kg52j3blKjJ06txv2A-24", parent:"1", value:"1→2"} ;
X = rect{id:"n8kg52j3blKjJ06txv2A-25", parent:"n8kg52j3blKjJ06txv2A-24", value:"2"} .

?- 
```

I supplied the empty logic variable `X` to start things off. The Prolog engine tries matching until all sub-rules succeed, then shows the value bound to the logic variable `X`. In this case, the engine needs to match two sub-rules in a consistent way, before declaring that it has found a successful match.

The first sub-rule is 
```
group(diagram{id:_,children:Children})
```

and the second sub-rule is
```
member(Child,Children)
```

For the whole rule to match, each sub-rule must match the same value for the internal logic variable `Children`. 

Basically the rule says, 
1. Find a `group` that contains a `diagram` with a field `id` and a field `children`. I don't care what the value of `id` is (`"_"`), but I want the value of `children` to be bound to the variable `Children`.
2. Next, find any member of `Children` (as determined in step 1) and bind that member to the variable `Child`.
3. Then, the match succeeds, the engine pauses and prints out the value of the `Child` variable and awaits either a `;` or a `.` from the keyboard.

I hit `;` three times, then I hit `.` In this factbase, there are a lot of Children and I didn't want to see every one of them, just a few to check that the pattern worked.

It should be "obvious" that a programmer could write this pattern matching loop in some language like Javascript, but, the Prolog syntax is more succinct and doesn't try to tell the engine how to perform the matching nor how to store the data structures needed by the pattern matcher.

The Prolog syntax is *declarative*. I simply expressed what had to match, the engine figured out how to make that happen and gave me each intermediate match.

## Back to the Main Query
Now, it should be possible to see what the original query does.

Below, I show the query and only one intermediate result. `Id` is the parent `rect` of the `Id2` `rect`.

```
?- group(diagram{id:_,children: Children}),
|       member(rect{id: Id, parent: _, value: _}, Children),
|       member(rect{id: Id2, parent: Id, value: _}, Children).
Children = [gate{id:"n8kg52j3blKjJ06txv2A-1", parent:"1", value:""}, gate{id:"n8kg52j3blKjJ06txv2A-2", parent:"1", value:""}, rect{id:"n8kg52j3blKjJ06txv2A-24", parent:"1", value:"1→2"}, rect{id:"n8kg52j3blKjJ06txv2A-25", parent:"n8kg52j3blKjJ06txv2A-24", value:"2"}, rect{id:"n8kg52j3blKjJ06txv2A-26", parent:"n8kg52j3blKjJ06txv2A-24", value:"1"}, rect{id:"n8kg52j3blKjJ06txv2A-27", parent:"n8kg52j3blKjJ06txv2A-24", value:"1"}, rect{id:"n8kg52j3blKjJ06txv2A-28", parent:"n8kg52j3blKjJ06txv2A-24", value:"2"}, edge{id:"n8kg52j3blKjJ06txv2A-29", parent:"1", source:"n8kg52j3blKjJ06txv2A-26", target:"n8kg52j3blKjJ06txv2A-2"}, ...{... : ..., ... : ..., ... : ..., ... : ...}|...],
Id = "n8kg52j3blKjJ06txv2A-24",
Id2 = "n8kg52j3blKjJ06txv2A-25" 
```

# Query B

Another way to write the original query is below:

```
?- group(diagram{id:_,children: Children}),
   member(Parent, Children),
   is_dict(Parent, rect),
   get_dict(id, Parent, ParentId),
   member(Child, Children),
   is_dict(Child, rect),
   get_dict(parent, Child, ParentId).
```

Here, we string together a bunch of sub-queries
1. Look for a group containing a diagram
2. Get any child within the children list, call the child `Parent`, then ensure that it is a dict then fetch its `id` into `ParentId`.
3. Get any child within the children list (this sub-query might match the same child as in step 2, but the rest of this sub-query will fail, so we don't need to explicitly exclude matching the same child again), call it `Child`, ensure that it's a dict, fetch its `parent` and ensure that it is the same as the above `ParentID`. When this doesn't work, the engine backtracks and keeps trying until it finds a suitable `Child` whose `parent` is `ParentId` (it prints each successful match one at a time depending on keystrokes `;` or `.`, but, if it doesn't find any successful matches, it prints 'false').

Running this query tends to given an overwhelming amount of information. We don't want to see the intermediate bindings to `Children` and `ParenID`, we just want to see the cells `Child` and `Parent`. We can do that by putting this query into rule in a file, say `/tmp/yyy.pl`
```
port(Parent,Port):-group(diagram{id:_,children: Children}),
   member(Parent, Children),
   is_dict(Parent, rect),
   get_dict(id, Parent, ParentId),
   member(Port, Children),
   is_dict(Port, rect),
   get_dict(parent, Port, ParentId).
```

I do this and get the results:

```
?- consult('/tmp/yyy.pl').
true.

?- port(Parent,Port).
Parent = rect{id:"n8kg52j3blKjJ06txv2A-24", parent:"1", value:"1→2"},
Port = rect{id:"n8kg52j3blKjJ06txv2A-25", parent:"n8kg52j3blKjJ06txv2A-24", value:"2"} ;
Parent = rect{id:"n8kg52j3blKjJ06txv2A-24", parent:"1", value:"1→2"},
Port = rect{id:"n8kg52j3blKjJ06txv2A-26", parent:"n8kg52j3blKjJ06txv2A-24", value:"1"} ;
Parent = rect{id:"n8kg52j3blKjJ06txv2A-24", parent:"1", value:"1→2"},
Port = rect{id:"n8kg52j3blKjJ06txv2A-27", parent:"n8kg52j3blKjJ06txv2A-24", value:"1"} .
```

(If you try this, starting with your own diagram, remember that the actual IDs will probably be different from the ones I show here).

# Which Query to Use?

The first query A is more succinct, but, requires me to specify every key/value pair for each kind of cell.

The second query B doesn't require specifying every key/value pair, but needs more code.

At present, I know what keys will be in each kind of cell, so using style A is possible. 

At present, I'm still working out the kinks in this design, so writing less code is an advantage, since, I might just throw all of the code away and start over again. I don't want to spend time writing too much code at this stage, so I might stick with style A, but, this decision might come back to haunt me if I, later, change what key/value pairs I want to have for each kind of cell. 

Maybe I should write some intermediate rules to abstract out parts of the searches? Maybe that would result in less "new" code as I move forward? I'll keep that option in mind.

