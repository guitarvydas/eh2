# The Flat Factbase Option
Maybe it would take fewer lines of query code to flatten the structure?

Since I'm generating the code automatically and I don't care about readability of intermediate code (as long as the code and factbase is machine readable), maybe I should just rewrite `rnet2swipl` to output a flat series of facts? And then, rewrite the queries? 

This might be worth a few minutes of time to try out.

Each fact would have to be qualified by the diagram that it belongs to, and, most facts need to be qualified by the cell id that they belong to.

For example
```
group(
    diagram{
        id:"o9M2tmKP6ZUbm1JD93Ax",
        children: [ 
            gate{
                id:"n8kg52j3blKjJ06txv2A-1",
                parent:"1",
                value:""
            },
            rect{
                id:"n8kg52j3blKjJ06txv2A-24",
                parent:"1",
                value:"1→2"
            },
            edge{
                id:"n8kg52j3blKjJ06txv2A-30",
                parent:"1",
                source:"n8kg52j3blKjJ06txv2A-28",
                target:"n8kg52j3blKjJ06txv2A-2"
            }
        ]
    }
}
```

would be flattened to
```
gate("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","1").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-1","").
rect("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-24").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-24","1").
value("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-24","1→2").
edge("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30").
parent("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30","1"),
source("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30","n8kg52j3blKjJ06txv2A-28").
target("o9M2tmKP6ZUbm1JD93Ax","n8kg52j3blKjJ06txv2A-30","n8kg52j3blKjJ06txv2A-2").
```

I'll change `rnet2swipl` to emit the factbase in this flat manner. Then, I'll rewrite the query and see if it "feels" lighter weight...

The `.rwr` rewriter has syntax for preserving various bits of data using the `%parameter` commands. This will be the first time in this project that we need to use this feature.

# Back To The Query
Now, back to the query I made earlier " I want to query for a child rect that has another rect as its parent."

## Something Is Wrong
Something is wrong. I wrote out the logic for the above query, but when I try them in swipl, the pattern matches fail. Either
- my logic code is faulty
- something is wrong in the factbase
- drawio has produced an `.drawio` file that doesn't match up with what the graphical version appears to say (this happens - it is possible to make it look like a port belongs to a part, yet the relationship is not captured by drawio - OTOH, this drawing was copied from an already working project, so I would think that this is not the problem)
- something else.

The logic code I wrote says that we need two `rects` on the same diagram and that one is the parent of the other. Then, I had to write four variations  of id equivalence to account for the fact that some id's are forward declarations and some are "long" ids assigned by drawio.

Here is the logic code that I think should work:
```
portOf(Parent,Port):-
    rect(D,Port),
    rect(D,Parent),
    parentOf(D,Port,Parent).

parentOf(D,LongPortID,LongParentID):-
    parent(D,LongPortID,LongParentID),
    !.
parentOf(D,ForwardDeclarationPortID,ForwardDeclarationParentID):-
    parent(D,ForwardDeclarationPortID,ForwardDeclarationParentID),
    !.
parentOf(D,ForwardDeclarationPortID,LongParentID):-
    synonym(LongParentID,ForwardDeclarationParentID),
    parent(D,ForwardDeclarationPortID,ForwardDeclarationParentID),
    !.
parentOf(D,LongPortID,ForwardDeclarationParentID):-
    synonym(LongPortID,ForwardDeclarationPortID),
    parent(D,ForwardDeclarationPortID,ForwardDeclarationParentID),
    !.
```

Let's debug this by looking at a simple relationship that I know must exist. If I look at that, maybe I'll see what's wrong. 

The simple relationship is that there are two ports with label "2" that must belong to the `"1→2"` part
![](helloworldpy%20Screenshot%202026-02-22%20at%206.42.04%20AM.png)
First, let's see if the factbase, `out.mr` contains that information.

The relationship exists in `out.mr`
```
              ...
	    rect {
		id="n8kg52j3blKjJ06txv2A-24"
		parent="1"
		value="1→2"}
	    rect {
		id="n8kg52j3blKjJ06txv2A-25"
		parent="n8kg52j3blKjJ06txv2A-24"
		value="2"}
              ...
            rect {
		id="n8kg52j3blKjJ06txv2A-28"
		parent="n8kg52j3blKjJ06txv2A-24"
		value="2"}
              ...
```

Next, let's see if the same thing exists in `out.pl`.
```
synonym("n8kg52j3blKjJ06txv2A-24",4).
```
Thankfully, our test data is not very complicated yet. Just using a text edit to search for "-24" and 4 should be enough.
```
parent(1,5,"n8kg52j3blKjJ06txv2A-24").
parent(1,6,"n8kg52j3blKjJ06txv2A-24").
parent(1,7,"n8kg52j3blKjJ06txv2A-24").
parent(1,8,"n8kg52j3blKjJ06txv2A-24").
```
```
...
parent(1,4,"1").
...
rect(1,4).
...
synonym("n8kg52j3blKjJ06txv2A-24",4).
...
value(1,4,"1→2").
...
```

This says that id 4 
- has the label "1→2"
- it's a `rect`
- it's parent is the main diagram, and
- its synonym is "n8kg52j3blKjJ06txv2A-24". 
The parent value of "1" doesn't actually match with the diagram id 1 (the former is a string, the latter is a number), but, that probably doesn't matter in this problem.

So, that seems correct. What am I missing?

I'll try some ultra-simple swipl queries
```
?- synonym(X,4).
X = "n8kg52j3blKjJ06txv2A-24".
```

```
?- rect(_,5).
**true.**

?- rect(_,6).
**true.**

?- rect(_,7).
**true.**

?- rect(_,8).
**true.**

?- parent(_,5,P).
P = "n8kg52j3blKjJ06txv2A-24".

?- parent(_,6,P).
P = "n8kg52j3blKjJ06txv2A-24".

?- parent(_,7,P).
P = "n8kg52j3blKjJ06txv2A-24".

?- parent(_,8,P).
P = "n8kg52j3blKjJ06txv2A-24".
```

So, each of the children are `rect`s and they are all children of "n8kg52j3blKjJ06txv2A-24".

Did I get the order of some arguments backwards in the query that I'm debugging?

```
?- rect(_,5),rect(_,4),synonym(ID,4),parent(_,5,ID).
ID = "n8kg52j3blKjJ06txv2A-24".
```
This says that 5 is a rect, 4, is a rect, and the long id for 4 is the parent of 5. That seems correct.

Next
```
?- parentOf(1,5,4).
**false.**
```
This should return `true` since the parent of 5 is 4 (on diagram 1).

Let's test each variant separately in hopes of seeing where the bug/typo is.

```
?- synonym(LongParentID,4).
LongParentID = "n8kg52j3blKjJ06txv2A-24".

?- synonym(LongParentID,4),parent(_,LongParentID,4).
**false.**

?- synonym(LongParentID,4),parent(_,5,LongParentID).
LongParentID = "n8kg52j3blKjJ06txv2A-24".
```
It looks like I swapped the child and parent ids here.

Named parameters - key/value pairs - would have prevented this mistake, but, I'm experimenting to see if avoiding dicts will help me write less code. The trade-off is that I have to put parameters in the correct order. Named parameters are helpful for human-written code, but not necessary for machine-generated code (machines don't need readability, they can perform repeatable tasks without getting bored and making mistakes).

