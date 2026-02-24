# Begin Using A Meta-Language
The following source code is used to specify the Loader which builds up a dictionary of part templates.

I use a meta-language to describe these next pieces of code. That way, we can generate the pieces in various languages, like Python, Javascript, Common Lisp.

I will generate Python for now on the assumption that everybody can read it and isn't as allergic to it as Javascript or Common Lisp.

During development, I continue to use /bin/bash to script builds. Bash isn't as portable as Python, but bash has a more concise syntax for scripting. I have successfully converted some bash scripts to Python using an LLM (Claude), so I know that I could regenerate all of the scripts in Python to make everything here more portable. At present bash scripts run on MacOS and on Linux, but Python versions are the preferred way to build scripts that are also usable on Windows.



