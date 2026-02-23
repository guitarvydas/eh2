There are still too many lines of code for me to review the results manually. I can perform more automated rewrites and reduce the amount of stuff that I need to look at, on the assumption that the results are correct. I can change my mind later and backtrack and fix things, if I discover things that are wrong or missing. 

# Prolog?
Another possibility for checking the results is to build or use some sort of automated tool to give me summaries of what the results are. An existing tool might be SWIPL - a modern Prolog. Prolog is a query language, SWIPL extends Prolog queries to allow for structured facts instead of using only a flat factbase.

It seems like it would be worth a short attempt to load this into SWIPL. By "short" I mean something like a half hour or an hour. It should be possible, in only a few minutes, to find out if loading this code into SWIPL is impossible, or leads to a deep, time-wasting rathole. If I determine that this is a bad idea, I will just backtrack and think of some other way to test, or simply move on and test later.
