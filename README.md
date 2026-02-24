I want to clean up and simplify the implementation of the PBP (0D) kernel.

I am going to try to write down my thoughts as I go through this process. We'll see how long I last at doing this. I find it much easier to just write the code. Writing down my thoughts is much harder and takes a lot more time.

I started writing the new PBP kernel in a forth-like stack language (actually one stack for every data-type or object-type, plus another stack for control flow). It's looking even more trivial than the Python version of the kernel,,, but,

I bumped into the fact that I needed to describe how to load part templates into an in-memory database (hash table, dictionary, palette) which requires me to back up and redefine what Container parts look like. And, how to generate Container parts from diagrammatic source code. All of this is fairly straight forward in my mind, but, it takes a lot of time to write down what I'm thinking. This seems to be a kind of 'twitch' in written form.

The "first episode" of this effort has been pushed to [github](https://github.com/guitarvydas/eh2). If interested, begin by looking at `Contents.md`

In this "episode" I grab the `helloworldpy.drawio` file and begin parsing and rewriting it using my `t2t` tools. If I pushed all of the right buttons, it should all be up on github and completely reproducible and runnable.

Feel free to join in, comment, or whatever. This should give you the idea of how to compile diagrams to code and - eventually - how to build a PBP kernel. It should be dead simple - if it isn't then, it's my fault for not explaining something...

# Overview
![Overview](Overview.md)
## Update 
I've finished episode 3 and am beginning episode 4.

This creates `helloworldpy.rnet` from `helloworld.drawio`.

The first part of this series is done.

I developed a way to use multiple languages in this project. 

I use /bin/bash scripts to create the build. @make contains boilerplate and calls @makec to perform custom build steps for this project.

The goal is to allow building a project with @make and @makec, while allowing it to be used as a "black box" in other projects. Hence, the separations into @make and @makec and, hence, the `if` stuff at the beginning of @make.

This project uses `t2t`, `swipl` (a modern, free Prolog), OhmJS and several shell commands.

I have included the necessary code for `t2t` in `./pbp`, so (theoretically) it should just work after git cloning the project.

Now, I move on to compiling `helloworldpy.rnet` into some kind of file (JSON?) that can be pulled into a loader.

After loading and instantiating, we want to run the code

# Usage
`./@make`

This creates `helloworldpy.rnet` from `helloworld.drawio`.

@make is mostly boilerplate bash code. It calls a custom bash script @makec to perform actions specific to this project.

In the process, the script leaves intermediate files in ./intermediate. These files can be examined. The `stage*.txt` files are not needed by the process and the @makec can be modified to skip the process of producing them, although it seems to take very little extra time.
