# Party

SMT based Bounded Synthesis, an implementation of the approach of 
[Schewe and Finkbeiner](https://www.react.uni-saarland.de/publications/atva07.pdf).

This is README file for `star.py` --- synthesizer from CTL*
(a prototype implementing the approach submitted to TACAS)


## Requirements
- Ubuntu 16.04 (likely to work with others)
- python3 (tested with version 3.5)
- Z3 (tested with version 4.3.2 and 4.4.1)
- ltl3ba (tested with versions 1.1.2 and 1.0.2)
- python packages: sympy, python3-pygraph, typing


## To configure
Modify `src/config.py` to provide absolute paths to executables `z3` and `ltl3ba`


## To run
`./star.py` to run the synthesizer from CTL*


## Input format

See `example.py` in the project root directoty.
The format should adhere to python syntax,
since instead of parsing it, I import it and let python to parse it.

