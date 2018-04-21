# PARTY

Implementation of the [SMT based Bounded Synthesis](https://www.react.uni-saarland.de/publications/atva07.pdf) and its friends.
The framework contains several tools related to the bounded synthesis:

- `elli.py`: Bounded Synthesis Tool
- `query_elli.py`: produce SMT queries generated by Elli
- `rally_elli_int.py` and `rally_elli_bool.py`: two Elli variations for [SYNTCOMP](http://syntcomp.org/)
- `star.py`: Bounded Synthesis for CTL* based on our CAV'17 paper
- `ctl_to_ltl.py`: translator of CTL* specifications to LTL (works for synthesis only), based on our SYNT'17 paper
- `kid.py`: non-SMT based Bounded Synthesis (also from Schewe/Finkbeiner [paper](https://www.react.uni-saarland.de/publications/atva07.pdf))
- `rally_kid_aiger.py`: version of kid for [SYNTCOMP](http://syntcomp.org/) that won 2017 competition.
- `ltl_to_aiger.py`: converter of the LTL specification into AIGER specification (the same as used by kid)
- and a few other scripts.

This readme has general information.
CAV'17 and SYNT'17 specific information is in [CAV-readme](experiments-for-cav/README.md) and [SYNT-readme](experiments-for-synt/README.md).


## System Requirements

I tested on the following machine,
but it likely works with other configurations:

- Ubuntu 16.04
- python 3 (version 3.5)
- Z3 (version 4.5.1: [link](https://github.com/Z3Prover/z3/releases))
- SPOT (version 2.5.1: [link](https://spot.lrde.epita.fr/install.html))
- python packages: sympy, python-graph-core, python-graph-dot, typing
  (install them for example using `pip3`)
- There are many other dependencies, they will become clear later.

As for SPOT:
I use it via python bindings and it is installed system-wide on my machine,
but it can also be installed locally (would need some path tweaking).


## To Configure

Once you installed all dependencies, configure PARTY.
Call `./configure.py` and then modify the created file `config.py` with necessary paths.
There are many dependencies.


## To Run

This depends on what you want to run.

To run an LTL synthesizer:
```
./elli.py --help
```

The input format is Acacia+ and TLSF for most of the tools.


## Tests

The test scripts start with `test_`.
Also run `nosetests3`.
All tests should pass.


## Notes

- The encoder for LTL is in `synthesis/buchi_cobuchi_encoder.py` and `synthesis/cobuchi_encoder.py`.


## Citing

- `elli.py`: [bibtex](https://5nizza.github.io/homepage/pubs/bibtex/PARTY.bib)
- `star.py`: [bibtex](https://5nizza.github.io/homepage/pubs/bibtex/bounded_ctlstar.bib)
- `ctl_to_ltl.py`: [bibtex](https://5nizza.github.io/homepage/pubs/bibtex/ctl_via_ltl.bib)

As for other tools, choose the closest, in your opinion, match.


## Authors and Contacts

Ayrat Khalimov.\\
Also thanks to: Roderick Bloem and Swen Jacobs.\\

Please report bugs here or directly gmail me at ayrat.khalimov.
