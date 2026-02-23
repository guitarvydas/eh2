In the process, I discovered that I was using the wrong syntax for named fields in swipl.

Instead of `kind="edge"`, the code should read `kind:"edge"`.

That's an easy fix. I just change one rewrite rule `  Attr [name eq str] = ‛\n«name»:«str»,’

(The "«eq»" is changed to a hard-coded ":")

And, I discover that one "=" remains. I change the rule 
```
IDattr [_id eq str] = ‛\n«_id»:«str»,’
```

At this point, I will leave `rnet2swipl.rwr` alone and proceed. Later, when I need it again, I will make any further changes to it as needed.