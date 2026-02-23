I've begun documenting (in a 'diary' manner, kind of like a written Twitch format) how I am building

- a diagram transmogrifier (`helloworldpy.drawio` -> `helloworldpy.rnet`)
- a transmogrifier from `helloworldpy.rnet` -> `helloworldpy.json`
- a template loader (The diagrams are templates of Container parts. Leaf parts are written in Python for now).
- a system instantiator
- running the code, including a simplified rewrite of `eh` the PBP kernel in a meta language.

The "real" goal of this project is to rewrite the PBP kernel in yet a simpler manner. I hope that this makes it easier to understand and much easier to use in projects.

README.md contains a brief overview of where this project is headed.

The documentation is in the doc/ directory, in markdown format, begin with `Contents.md`.

> git clone https://github.com/guitarvydas/eh2

comments greatly appreciated...
