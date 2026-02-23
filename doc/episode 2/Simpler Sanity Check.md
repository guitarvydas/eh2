
I just want to know that the number of edges, rects and rhombuses are in the correct ballpark. 

I don't need to dig deeper just yet. If I want to make a change later, to fix something, it will be easy, since the whole pipeline is automated and repeatable.

So, for this simple sanity check, I can just use `grep`.

```
$ grep 'kind="edge"' swipl5.pl
		kind="edge",
		kind="edge",
		kind="edge",
		kind="edge",
		kind="edge",
		kind="edge",
		kind="edge",
		kind="edge",
$ grep 'kind="edge"' swipl5.pl | wc
       8       8     120
```
The test file contains 8 edges. That seems correct.

```
$ grep 'kind="rhombus"' swipl5.pl | wc -l
       3
```
3 rhombuses is correct, also (1 input gate, 2 output gates).

```
$ grep 'kind="rect"' swipl5.pl | wc -l
      13
```
13 rectangles total. 3 parts. 10 ports (input and output). 