# PARTY

SMT-based and AIGER-based bounded synthesizers,
based on [Schewe and Finkbeiner](https://www.react.uni-saarland.de/publications/atva07.pdf).


## System Requirements

I tested on the following machine,
but it likely workas with other configurations:

- Ubuntu 16.04
- python3 (version 3.5)
- Z3 (version 4.5.0: [downlink](https://github.com/Z3Prover/z3/releases))
- SPOT (version 2.3.2: [downlink](https://www.lrde.epita.fr/dload/spot/spot-2.3.2.tar.gz))
- python packages: sympy, python-graph-core, python-graph-dot, typing
  (install them for example using `pip3`)
- SDF synthesizer, included in sub-folder `additional-tools/sdf`. See its readme, build it by calling `build.sh`.
- yosys, included in the sub-folder `additional-tools/yosys`. See its readme on how to build it.
- other dependencies like syfco, combine-aiger, etc. (see `config.py`)

As for SPOT:
I use it via python bindings and it is installed system-wide on my machine,
but it can also be installed locally (would need some path tweakings).

Once you installed all dependencies, configure PARTY.


## To Configure
Call `./configure.py` and then modify the created file `config.py` with necessary paths.


## To Run
In the context of SYNTCOMP, you need only:

- `rally_elli_int.py`: pretty standard Bounded Synthesis with integer ranking functions
- `rally_elli_bool.py`: Bounded Synthesis with no ranking functions (only reachability functions), reduces UCWs into universal co-reachability automata (i.e., limit of number bad visits).
- `rally_kid_aiger.py`: Bounded Synthesis via reduction to safety games and solving them using SDF
- `rally_portfolio.py`: portfolio of those solvers.

All the tools except the last one participate in 'single-threaded' synth&real TLSF tracks.
The last one `rally_portfolio.py` participates in the 'parallel' synth&real tracks.

All the tools conform to the SYNTCOMP format, _except that they can print UNKNOWN_.
_UNKNOWN_ means that the tool reached reasonable limits on parameters (like system `size` or number `k` of bad visits).
In principle, you should not see such happening, but if it happens, it means I misconfigured the parameters,
so treat it as the tool could not solve the problem
(all the tools are sound/complete, if bounds are loosened)

For __debugging__, provide `-v` (or `-vv`) to the tool, it will start logging info.
For more details, also run them with `--help`.

For emails use gmail address: ayrat.khalimov


## Final Notes

My tools disagree on the status of `load_balancer_unreal2.tlsf`:
they find it realizable.
