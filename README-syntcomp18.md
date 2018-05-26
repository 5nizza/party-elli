# Synthesizer `kid_hoa` for track TLSF:realizability

This is re-implementation of the tool `kid_aiger` submitted to SYNTCOMP'17.
Recall that `kid_aiger` implements the game based variant of bounded synthesis
(see [Schewe and Finkbeiner](https://www.react.uni-saarland.de/publications/atva07.pdf) and
 [Kupferman](http://www.cse.huji.ac.il/~ornak/publications/lics06c.pdf))
that works as follows:

```
translate LTL into UCW

for k in range(max_bound):
  translate UCW to universal safety automaton (where a bad state is visited max k times)
  convert the safety automaton to a game (*)
  is_real = solve_the_game()
  if is_real=True:
    return "realizable"

return "unknown"
```

Running two such procedures---for the original and for the dual specifications---gives the decision procedure for synthesis.

The difference of `kid_hoa` with `kid_aiger` is in the line labeled `(*)`:
`kid_aiger` created a verilog model representing the automaton (with one latch per automaton state),
then translated the verilog file into aiger using tool `yosys`,
and finally solved the resulting game specifiction (in AIGER format) using tool `sdf`.
This intermediate translation into verilog is not necessary;
at that moment it was the easiest way to implement the approach.
As experiments showed, the translation via verilog, namely tool `yosys`, takes much time.
Thus, the tool `kid_hoa` avoids this unnecessary step and passes the safety automaton
directly to a game solver that converts it into BDD representation (with one variable per state),
and then solves the game using adapted [`sdf`](https://github.com/5nizza/sdf-hoa).


## System Requirements

I tested it on Ubuntu 16.04 with python3.5.2, but it should work with others.
It might need the following python packages: `sympy`, `python-graph-core`, `python-graph-dot`, `typing`
(install them using `pip3`).
The tool also assumes `syfco` can be called with `syfco` (tested on version 1.1.0.11).


## Installation

From the tool root directory:

```
cd additional-tools/sdf-hoa
./build.sh
```

This will build:

- cudd
- spot
- sdf-hoa

In the end you should see something like:
```
executable was created in binary/
```

The script also removes intermediate compilation files of spot,
which take a lot of space.
(This also implies:
 if `./build.sh` succeeded and you decided to run it again,
 then the compilation again will take a lot of time.)


## To Run

To run the tool, call
```
./run_kid_hoa.sh <tlsf_spec>
```

The shell script first modifies `PYTHONPATH` to point to spot libraries,
and then runs `rally_kid_hoa.py`.

The tool conforms to the SYNTCOMP format, _except it can output the result `UNKNOWN`_ (with return code `30`).
`UNKNOWN` means that the tool reached reasonable limits on parameters.
You should not see such case happening, but if it happens, please let me know
(and simply treat it as if the tool could not solve the problem).

For __debugging__ purposes, you can call the tool with `-v` (or `-vv`), which will output rich logs.
There are other parameters, try `--help`.

Note that the tool does realizability checking only (no models are printed)
(I did not have time to implement conversion of BDD models into AIGER).


## Notes

Other tools in the framework should also work, but they need more dependencies (like `z3` and `yosys`).

For emails, use gmail address: ayrat.khalimov

