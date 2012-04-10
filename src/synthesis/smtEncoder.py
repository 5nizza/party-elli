


  
def encodeUct(uct, inputs, outputs, bound):
    """ outputs: list of strings """
    #Just for testing      
    #smtStr = '(declare-sort Q 0)\n (declare-fun q_1 () Q)\n (declare-fun q_2 () Q)\n (assert (forall ((q Q)) (or (= q q_1) (= q q_2))))\n (declare-sort T 0)\n (declare-fun t_1 () T)\n (declare-fun t_2 () T)\n (assert (forall ((t T)) (or (= t t_1) (= t t_2))))\n (declare-sort Upsilon 0)\n (declare-fun i_R () Upsilon)\n (declare-fun i_not_R () Upsilon)\n (declare-fun tau (T Upsilon) T)\n (declare-fun fo_R (T) Bool)\n (declare-fun fo_G (T) Bool)\n (declare-fun lambda_B (Q T) Bool)\n (declare-fun lambda_sharp (Q T) Int)\n (assert (=> (lambda_B q_1 t_1) (and (lambda_B q_1 (tau t_1 i_R)) (>= (lambda_sharp q_1 (tau t_1 i_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (lambda_B q_1 t_2) (and (lambda_B q_1 (tau t_2 i_R)) (>= (lambda_sharp q_1 (tau t_2 i_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (lambda_B q_1 t_1) (and (lambda_B q_1 (tau t_1 i_not_R)) (>= (lambda_sharp q_1 (tau t_1 i_not_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (lambda_B q_1 t_2) (and (lambda_B q_1 (tau t_2 i_not_R)) (>= (lambda_sharp q_1 (tau t_2 i_not_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (and (lambda_B q_1 t_1) (or (and (fo_R t_1) (not (fo_G t_1) )) (and (not (fo_R t_1) ) (fo_G t_1)) )) (and (lambda_B q_2 (tau t_1 i_R)) (> (lambda_sharp q_2 (tau t_1 i_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (and (lambda_B q_1 t_2) (or (and (fo_R t_2) (not (fo_G t_2) )) (and (not (fo_R t_2) ) (fo_G t_2)) )) (and (lambda_B q_2 (tau t_2 i_R)) (> (lambda_sharp q_2 (tau t_2 i_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (and (lambda_B q_1 t_1) (or (and (fo_R t_1) (not (fo_G t_1) )) (and (not (fo_R t_1) ) (fo_G t_1)) )) (and (lambda_B q_2 (tau t_1 i_not_R)) (> (lambda_sharp q_2 (tau t_1 i_not_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (and (lambda_B q_1 t_2) (or (and (fo_R t_2) (not (fo_G t_2) )) (and (not (fo_R t_2) ) (fo_G t_2)) )) (and (lambda_B q_2 (tau t_2 i_not_R)) (> (lambda_sharp q_2 (tau t_2 i_not_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (lambda_B q_2 t_1) (and (lambda_B q_2 (tau t_1 i_R)) (> (lambda_sharp q_2 (tau t_1 i_R)) (lambda_sharp q_2 t_1) ) )))\n (assert (=> (lambda_B q_2 t_2) (and (lambda_B q_2 (tau t_2 i_R)) (> (lambda_sharp q_2 (tau t_2 i_R)) (lambda_sharp q_2 t_2) ) )))\n (assert (=> (lambda_B q_2 t_1) (and (lambda_B q_2 (tau t_1 i_not_R)) (> (lambda_sharp q_2 (tau t_1 i_not_R)) (lambda_sharp q_2 t_1) ) )))\n (assert (=> (lambda_B q_2 t_2) (and (lambda_B q_2 (tau t_2 i_not_R)) (> (lambda_sharp q_2 (tau t_2 i_not_R)) (lambda_sharp q_2 t_2) ) )))\n (assert (lambda_B q_1 t_1))\n (assert (and (fo_R (tau t_1 i_R)) (not (fo_R (tau t_1 i_not_R))) (fo_R (tau t_2 i_R)) (not (fo_R (tau t_2 i_not_R)))))\n (check-sat)\n (get-model)'

    head = ''

    declarations = []
    for o in outputs:
        declarations.append(declare_output(o))

    bound_asserts = ['; bounding', bound_assert(bound)]

    initial_asserts = ['; initial states']
    for s in uct.initial_state:
        initial.append(initial_assert(s))

    main_asserts = ['; main asserts']
    for s in uct.states:
        for label, dst in s.transitions:
            if is_rejecting(dst):
                a = main_assert(s, inputs, label, dst, True)
            else:
                a = main_assert(s, inputs, label, dst, False)
            main_asserts.append(a)

    tail = '(check-sat)...'

    smt = '\n'.join([head] + declarations + bound_asserts + initial_asserts + main_asserts + [tail])
    return smt

    smtStr = '(declare-const a Int)\n(declare-fun f (Int Bool) Int)\n(assert (> a 10))\n(assert (< (f a true) 100))\n(check-sat)\n(get-model)'
    return smtStr
