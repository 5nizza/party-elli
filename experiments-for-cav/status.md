Examples are too toy-ish.

- non_det_arbiter.py
  done

- postponed_arbiter.py
  done, but you can notice a flaw in the synthesis procedure
  The flaw is that we can get postponed for r1r2
  but not for ~r1 r2 (g2 gets granted next)
  We need ATL*.

- resettable_arbiter1.py
  done: the most basic one

- self_loop_arbiter.py
  4 states: explain why not 3.

- prolonged_full_arb.py
  done (5 states):
  it is the full arbiter spec with an additional property
  requiring three consecutive g1

- sender-receiver:
  around 40 minutes.
  the final result is in 3model...smt2
  (I tried three different specs, that is why it is called 3..)
