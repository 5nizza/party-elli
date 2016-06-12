# Party ('elli')

SMT based Bounded Synthesis, an implementation of the approach of 
[Schewe and Finkbeiner](https://www.react.uni-saarland.de/publications/atva07.pdf).
This is the fork of tool [PARTY](https://github.com/5nizza/Party),
whose main point was 
[parameterized synthesis of token rings](http://link.springer.com/chapter/10.1007/978-3-642-39799-8_66).
But this version is significantly cleaner,
it supports only monolithic synthesis (no token rings!), 
and contains tool `query_elli.py` to generate SMT queries without solving them.
The functionality might be slightly smaller compared to the original Party,
but this is the version I support and update.

## Requirements
- Ubuntu 14.04 (likely to work with others)
- python3 (tested with version 3.4)
- Z3 (tested with version 4.3.2 and 4.4.1)
- ltl3ba (tested with versions 1.1.2 and 1.0.2)
- python packages: sympy, pygraph, typing

## To configure
Modify `src/config.py` to provide absolute paths to executables `z3` and `ltl3ba`
(other tools are used by `elli_rally.py` only, which is for SYNTCOMP)

If you plan to develop smth then you might want to ignore future changes to config.py, to do so run:
	
	git update-index --assume-unchanged src/config.py

`.gitignore` is not enough.
(i know, not optimal)

## To run
`./elli.py` to run the synthesizer

`./query_elli.py` to generate SMT queries without running the solver

`./elli_rally.py` to run the SYNTCOMP version (deps on many things!)

## To test
Run `run_tests.py` for functional tests, and `nosetests3 ./` -- for unit tests.

## Questions
Submit here or to ayrat.khalimov(gmail)

## Authors
Ayrat Khalimov; at early stages participated:
Roderick Bloem, Swen Jacobs, Robert Koenighoffer, Bettina Koenighoffer, Florian Lorber.

## License
MIT licence: free for any use if you attribute the author. 
For citing, check bibtex at http://link.springer.com/chapter/10.1007%2F978-3-642-39799-8_66
