Again, the goal is to whittle this information down stage by stage so that by the final stage, the result is fairly small and contains only semantically interesting information. The bulk of the above text contains `style="..."` information. Much of that information is related only to graphical rendering and can be removed without losing semantic information.

This staged whittling is an iterative process. At first, I don't know what should be deleted and what should be kept. During the iterative design process, I looked at the intermediate results and saw patterns that could be rearranged and information the could be discarded. Although I didn't know what the next steps would be, at the outset, we "brainstormed" as I iterated. The intermediate results gave me inspiration of what to modify next. The intermediate results are not nicely formatted for human consumption, but, the use of balanced brace brackets allowed me to use off-the-shelf formatters (emacs' javascript-mode in my case) that allowed me to view the intermediate results and to gain inspiration about how to proceed.

## Length of `helloworldpy.drawio`
The original `helloworldpy.drawio` is 99 lines, but contains some really long `style=...` attributes that contain many attributes, most of which have little semantic meaning.

## Length of Stage 1 Output
The output from stage 1 (rmGeometry) is 184 lines, but, the `mxGeometry` attributes have been removed and most remaining attributes have been moved to separate lines.

## Length of Stage 5 Output
The output from stage 5 (after the pipeline rmGeometry | cull | rmdiv | rmspan | unhtml) is 115 lines, where, again, most of the remaining attributes occupy separate lines.

The intermediate output after stage 5 is less of an eye-sore than the original `helloworldpy.drawio` file. I format it using emacs' *javascript-mode* and begin looking for patterns.

The intermediate output after stage 5 is:
```
group {
    diagram {
        id="o9M2tmKP6ZUbm1JD93Ax" 
        cell {
            id="n8kg52j3blKjJ06txv2A-1"
            parent="1"
            value=""}
        cell {
            id="n8kg52j3blKjJ06txv2A-2"
            parent="1"
            value=""}
        cell {
            id="n8kg52j3blKjJ06txv2A-24"
            parent="1"
            value="1→2"}
        cell {
            id="n8kg52j3blKjJ06txv2A-25"
            parent="n8kg52j3blKjJ06txv2A-24"
            value="2"}
        cell {
            id="n8kg52j3blKjJ06txv2A-26"
            parent="n8kg52j3blKjJ06txv2A-24"
            value="1"}
        cell {
            id="n8kg52j3blKjJ06txv2A-27"
            parent="n8kg52j3blKjJ06txv2A-24"
            value="1"}
        cell {
            id="n8kg52j3blKjJ06txv2A-28"
            parent="n8kg52j3blKjJ06txv2A-24"
            value="2"}
        cell {
            id="n8kg52j3blKjJ06txv2A-29"
            parent="1"
            source="n8kg52j3blKjJ06txv2A-26"
            kind="edge"
            target="n8kg52j3blKjJ06txv2A-2"}
        cell {
            id="n8kg52j3blKjJ06txv2A-30"
            parent="1"
            source="n8kg52j3blKjJ06txv2A-28"
            kind="edge"
            target="n8kg52j3blKjJ06txv2A-2"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-1"
            parent="1"
            value="World"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-2"
            parent="wK0F3og9NH9Dy6XDwJbj-1"
            value=""}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-3"
            parent="wK0F3og9NH9Dy6XDwJbj-1"
            value=""}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-4"
            parent="wK0F3og9NH9Dy6XDwJbj-1"
            value="✗"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-5"
            parent="1"
            value="Hello"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-6"
            parent="wK0F3og9NH9Dy6XDwJbj-5"
            value=""}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-7"
            parent="wK0F3og9NH9Dy6XDwJbj-5"
            value=""}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-8"
            parent="wK0F3og9NH9Dy6XDwJbj-5"
            value="✗"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-9"
            parent="1"
            source="n8kg52j3blKjJ06txv2A-1"
            kind="edge"
            target="wK0F3og9NH9Dy6XDwJbj-2"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-10"
            parent="1"
            source="n8kg52j3blKjJ06txv2A-1"
            kind="edge"
            target="wK0F3og9NH9Dy6XDwJbj-6"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-11"
            parent="1"
            source="wK0F3og9NH9Dy6XDwJbj-3"
            kind="edge"
            target="n8kg52j3blKjJ06txv2A-25"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-12"
            parent="1"
            source="wK0F3og9NH9Dy6XDwJbj-7"
            kind="edge"
            target="n8kg52j3blKjJ06txv2A-27"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-13"
            parent="1"
            value="✗"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-14"
            parent="1"
            source="wK0F3og9NH9Dy6XDwJbj-4"
            kind="edge"
            target="wK0F3og9NH9Dy6XDwJbj-13"}
        cell {
            id="wK0F3og9NH9Dy6XDwJbj-15"
            parent="1"
            source="wK0F3og9NH9Dy6XDwJbj-8"
            kind="edge"
            target="wK0F3og9NH9Dy6XDwJbj-13"}}}
```

What I see is that drawio gives information about which edges connect cells to other cells. Cells without `kind="edge"` are rounded rectangles. We don't yet know if the rectangles represent parts or represent ports.

Edges are directed (arrows) that contain source and target. I see that input/output ports and gates can be inferred by the direction of arrows
- nodes that are the source of edges are "outputs"
- node that are the target of edges are "inputs"
- gates that are the source of edges are "down" inputs (down from gate to inputs ports of children)
- gates that are the target of edges are "up" outputs (up from output ports of children)
- wires that connect source gates to target gates are "through" wires.
- "parent" information on edges (wires) is not meaningful - the wires belong to the top-level diagram
- "parent" information for rounded rectangles that are either input or output ports is significant. Such "parent" information ties the port rectangles to their parent parts.

Wouldn't it be nice to write these connection rules out in a notation that was suited to representing these kinds of relationships? Prolog and its successors are meant for expressing these kinds of relationships. You *can* express these relationships in standard "general purpose" languages, but, you have to resort to writing loops within loops and putting up with numerous implementation bugs. Using "general purpose" languages for this kind of thing is very low-level, like using assembler instead of "C".

I see that rhombuses (gates - in/out ports that connect to the higher levels) are missing. This means that one of the earlier stages is not picking off information that should have been kept. Probably the `cull` stage.

First, I need to fix the missing rhombuses. Then, I can try to inference information about input and output ports.

