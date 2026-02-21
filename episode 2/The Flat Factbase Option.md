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
