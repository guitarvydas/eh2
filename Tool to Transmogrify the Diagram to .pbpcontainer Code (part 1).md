To begin parsing the diagram, we use OhmJS and the ohm-editor.

I create a rough draft of the grammar, paste it into ohm-editor and see what it complains about.

When the typos have been cleaned out, the grammar passes and I paste `helloworldpy.drawio` into the examples window (bottom left).

I've chosen to build the transmogrifier in stages. The first five stages are called:
1. rmgeometry
2. cull
3. rmdiv
4. rmspan
5. unhtml

(for "remove geometry info", "cull unnecessary attributes", "remove divs inserted by drawio into the text", "remove spans inserted by drawio", "decode HTML symbols").

The 5 stages are piped together using a /bin/bash script. The main script, `@make`, consists of boilerplate bash code. It calls a much smaller script `@makec` that pipes the interesting parsing stages together.

Each transmogrifier stage invokes the `t2t` (text to text) tool with the name of the stage. Each such name refers to two rules files - grammar and rewrite rules. For example, there are two files for the first stage:
1. rmgeometry.ohm
2. rmgeometry.rwr.

We need to provide the full path to the `t2t` tool by writing `${PBP}/t2t`. Later, we will convert the bash script to a more-portable Python script. Bash syntax is more concise than that of Python, so I'll stick to bash for now (unless I get too many complaints).

