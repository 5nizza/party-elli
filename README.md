# PARTY: CAV17 edition

This branch has two CTL* solvers implemented for CAV'17 paper
"Bounded Synthesis Streett, Rabin, and CTL*"
and a translator from CTL* to LTL for SYNT'17 paper
"CTL* synthesis via LTL synthesis".

This readme has some general information on how to install the tool etc.
CAV- and SYNT- specific information is in [CAV-readme](experiments-for-cav/README.md) and [SYNT-readme](experiments-for-synt/README.md).


## System Requirements

I tested on the following machine,
but it likely workas with other configurations:

- Ubuntu 16.04 (likely to work with others)
- python3 (tested with version 3.5)
- Z3 (version 4.5.0: [downlink](https://github.com/Z3Prover/z3/releases))
- SPOT (version 2.3.2: [downlink](https://www.lrde.epita.fr/dload/spot/spot-2.3.2.tar.gz))
- python packages: sympy, python-graph-core, python-graph-dot, typing
  (install them for example using `pip3`)

As for SPOT:
I use it via python bindings and it is installed system-wide on my machine,
but it can also be installed locally (would need some path tweakings).

Once you installed all dependencies, configure PARTY.


## To Configure
Call `./configure.py` and then modify the created file `config.py` with necessary paths.


## To Run

This depends on what you want to run.

To run an LTL synthesizer (which implementats Schewe/Finkbeiner bounded synthesis approach):
```
./elli.py --help
```

There are many other runnable tools (depends on your version).
Check out the root directory and see executable scripts.


## Notes

- The encoder for LTL is in `synthesis/cobuchi_smt_encoder.py` and `buchi_cobuchi_encoder.py`


## Input Format

For LTL: acacia input format (which itself is derived from lily).
`elli.py` also supports TLSF input format.
