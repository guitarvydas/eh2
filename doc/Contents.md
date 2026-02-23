[Goal](Goal.md)

# Episode 0 - Rough Drafts
I began to rewrite the `eh` engine in a meta language, then stopped and began writing up my progress with episode 1.

These rough drafts are fairly sparse and incomplete. I include them only to give a flavour of where I'm headed. Feel free to skip over these drafts and to proceed to Episode 1 .
[Rough Draft - eh.mr](Rough%20Draft%20-%20eh.mr.md)
[Rough Draft - notes on eh specification](Rough%20Draft%20-%20notes%20on%20eh%20specification.md)

# Transmogrifying The Diagram to an Intermediate Language
## Episode 1
[Step 1 - Sub-Goal](Step%201%20-%20Sub-Goal.md)
[Tool to Transmogrify the Diagram to .pbpcontainer Code (part 1)](Tool%20to%20Transmogrify%20the%20Diagram%20to%20.pbpcontainer%20Code%20(part%201).md)
[Reading rmgeometry.ohm](Reading%20rmgeometry.ohm.md)
[Reading rmgeometry.rwr](Reading%20rmgeometry.rwr.md)
[Stage by Stage Whittling Down of Intermediate Results](Stage%20by%20Stage%20Whittling%20Down%20of%20Intermediate%20Results.md)

## Episode 2
[Fix Missing Rhombus](Fix%20Missing%20Rhombus.md)
[Rnets](Rnets.md)
[Revised Results from Stages 1 and 5](Revised%20Results%20from%20Stages%201%20and%205.md)
[Sanity Checking the Results from Stage 5](Sanity%20Checking%20the%20Results%20from%20Stage%205.md)
[Loading Stage 5 Results Into SWIPL](Loading%20Stage%205%20Results%20Into%20SWIPL.md)
[commas](commas.md)
[Reformatting Results for SWIPL](Reformatting%20Results%20for%20SWIPL.md)
[Simpler Sanity Check](Simpler%20Sanity%20Check.md)
[Revise rnet2swipl Rewriter](Revise%20rnet2swipl%20Rewriter.md)
[Querying The Factbase](Querying%20The%20Factbase.md)

## Episode 3
[Considering The Flat Factbase Option](Considering%20The%20Flat%20Factbase%20Option.md)
[Normalization](Normalization.md)
[Flattening the Grammar and Rewrite Rules](Flattening%20the%20Grammar%20and%20Rewrite%20Rules.md)

---
Progress up to Feb 22, 2026.

Nothing much beyond this point, yet...

--------------------
# Episode 4 - Building the Template Dictionary - The Loader
- converting `helloworldpy.rnet` to `helloworldpy.json`

I choose to use JSON as the intermediate form, because I believe that JSON can be read in using just about modern language. This might provide inspiration on how to use this stuff in other ways.

### Begin Using A Meta-Language
I use a meta-language to describe these next pieces of code. That way, we can generate the pieces in various languages, like Python, Javascript, Common Lisp.

I will generate Python for now on the assumption that everybody can read it and isn't as allergic to it as Javascript or Common Lisp.

During development, I continue to use /bin/bash to script builds. Bash isn't as portable as Python, but bash has a more concise syntax for scripting. I have successfully converted some bash scripts to Python using an LLM (Claude), so I know that I could regenerate all of the scripts in Python to make everything here more portable. At present bash scripts run on MacOS and on Linux, but Python versions are the preferred way to build scripts that are also usable on Windows.

- loading the json to create a template dictionary of Container parts
- loading the python Leaf node code to add to the dictionary (can Python code be hot-loaded? or must we compile the code and only register function names into the dictionary?)

# Building the Instantiator

# Running the Generated Code


