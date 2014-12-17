(set-option :produce-models true)
(set-option :EMATCHING false)

;(set-logic UFLIA)

(declare-datatypes () ((T t0 t1 t2 t3 t4 t5 t6 t7 t8 t9)))
(define-fun tok ((state T)) Bool 
(not (= state t0))
)
(declare-fun locked (T) Bool)

(declare-fun hmastlock (T) Bool)

(declare-fun decide (T) Bool)

(declare-fun hmaster (T) Bool)

(declare-fun hgrant (T) Bool)

(declare-fun start (T) Bool)

(declare-fun sends (T) Bool)

(declare-fun tau (Bool Bool Bool Bool Bool Bool T) T)

(declare-datatypes () ((LQ lq_T0_S11 lq_accept_S10 lq_T5_S31 lq_T4_S8 lq_T6_S3 lq_accept_all lq_T2_S10 lq_T4_S20 lq_accept_S19 lq_T1_S10 lq_T0_init lq_T10_S2 lq_T5_S27 lq_T9_S6 lq_T1_S19 lq_T5_S25 lq_T5_S23 lq_accept_S21 lq_T8_S5 lq_T0_S9 lq_T1_S21 lq_T7_S4 lq_T3_S19 lq_T5_S29)))
(declare-fun laBl (LQ T) Bool)

(declare-fun laCl (LQ T) Int)

(define-fun env_ass ((hburst0_0 Bool) (hburst1_0 Bool) (hbusreq_0 Bool) (hlock_0 Bool)) Bool 
(and (and (and hburst0_0 hburst1_0) (=> hbusreq_0 hlock_0)) (=> hlock_0 hbusreq_0))
)
(define-fun sys_gua ((decideNext_0 Bool) (decide_0 Bool) (hgrantNext_0 Bool) (hgrant_0 Bool) (hlockNext_0 Bool) (hlock_0 Bool) (hmasterNext_0 Bool) (hmaster_0 Bool) (hmastlockNext_0 Bool) (hmastlock_0 Bool) (hreadyNext_0 Bool) (hready_0 Bool) (lockedNext_0 Bool) (locked_0 Bool) (startNext_0 Bool) (start_0 Bool) (tokNext_0 Bool) (tok_0 Bool)) Bool 
(and (and (and (and (and (and (and (and (=> (and (not decide_0)  true ) (= locked_0 lockedNext_0)) (=> (and hready_0  true ) (= locked_0 hmastlockNext_0))) (=> (and hready_0  true ) (= hgrant_0 hmasterNext_0))) (=> (not startNext_0) (= hmaster_0 hmasterNext_0))) (=> hmaster_0 tok_0)) (=> (and (not hready_0)  true ) (not startNext_0))) (=> (and (and decide_0  true ) hgrantNext_0) (= hlock_0 lockedNext_0))) (=> (not startNext_0) (= hmastlock_0 hmastlockNext_0))) (=> (and (not decide_0)  true ) (= hgrant_0 hgrantNext_0)))
)
(assert (tok t1))

(assert (not (tok t0)))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t0) (not (sends t0))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t0)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t0) (tok t0))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t0) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t0))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t0))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t0)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t0))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t1) (not (sends t1))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t1)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t1) (tok t1))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t1) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t1))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t1))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t1)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t1))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t2) (not (sends t2))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t2)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t2) (tok t2))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t2) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t2))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t2))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t2)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t2))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t3) (not (sends t3))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t3)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t3) (tok t3))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t3) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t3))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t3))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t3)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t3))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t4) (not (sends t4))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t4)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t4) (tok t4))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t4) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t4))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t4))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t4)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t4))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t5) (not (sends t5))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t5)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t5) (tok t5))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t5) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t5))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t5))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t5)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t5))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t6) (not (sends t6))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t6)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t6) (tok t6))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t6) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t6))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t6))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t6)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t6))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t7) (not (sends t7))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t7)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t7) (tok t7))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t7) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t7))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t7))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t7)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t7))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t8) (not (sends t8))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t8)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t8) (tok t8))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t8) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t8))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t8))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t8)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t8))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t9) (not (sends t9))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t9)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t9) (tok t9))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t9) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t9))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t9))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t9)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t9))))))

(assert (laBl lq_T0_init t1))

(assert (laBl lq_T0_init t0))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0) (and (not (hmastlock t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1) (and (not (hmastlock t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2) (and (not (hmastlock t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3) (and (not (hmastlock t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4) (and (not (hmastlock t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5) (and (not (hmastlock t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6) (and (not (hmastlock t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7) (and (not (hmastlock t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8) (and (not (hmastlock t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9) (and (not (hmastlock t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T0_S11
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t0) (and (not (hmaster t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t0) (and (not (hmaster t0)) (not (tok t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t1) (and (not (hmaster t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t1) (and (not (hmaster t1)) (not (tok t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t2) (and (not (hmaster t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t2) (and (not (hmaster t2)) (not (tok t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t3) (and (not (hmaster t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t3) (and (not (hmaster t3)) (not (tok t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t4) (and (not (hmaster t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t4) (and (not (hmaster t4)) (not (tok t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t5) (and (not (hmaster t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t5) (and (not (hmaster t5)) (not (tok t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t6) (and (not (hmaster t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t6) (and (not (hmaster t6)) (not (tok t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t7) (and (not (hmaster t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t7) (and (not (hmaster t7)) (not (tok t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t8) (and (not (hmaster t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t8) (and (not (hmaster t8)) (not (tok t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t9) (and (not (hmaster t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t9) (and (not (hmaster t9)) (not (tok t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S10 t9))) )))

; encoded spec state lq_accept_S10
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S31
(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (not (sends t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmastlock t0) (hmaster t0) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmastlock t0) (hmaster t0) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (not (hmaster t0)) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (not (sends t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmastlock t1) (hmaster t1) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmastlock t1) (hmaster t1) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (not (hmaster t1)) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (not (sends t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmastlock t2) (hmaster t2) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmastlock t2) (hmaster t2) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (not (hmaster t2)) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (not (sends t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmastlock t3) (hmaster t3) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmastlock t3) (hmaster t3) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (not (hmaster t3)) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (not (sends t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmastlock t4) (hmaster t4) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmastlock t4) (hmaster t4) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (not (hmaster t4)) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (not (sends t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmastlock t5) (hmaster t5) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmastlock t5) (hmaster t5) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (not (hmaster t5)) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (not (sends t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmastlock t6) (hmaster t6) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmastlock t6) (hmaster t6) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (not (hmaster t6)) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (not (sends t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmastlock t7) (hmaster t7) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmastlock t7) (hmaster t7) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (not (hmaster t7)) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (not (sends t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmastlock t8) (hmaster t8) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmastlock t8) (hmaster t8) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (not (hmaster t8)) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (not (sends t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmastlock t9) (hmaster t9) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmastlock t9) (hmaster t9) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (not (hmaster t9)) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T4_S8
(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t0) (and (hmastlock t0) (start t0)) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t1) (and (hmastlock t1) (start t1)) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t2) (and (hmastlock t2) (start t2)) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t3) (and (hmastlock t3) (start t3)) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t4) (and (hmastlock t4) (start t4)) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t5) (and (hmastlock t5) (start t5)) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t6) (and (hmastlock t6) (start t6)) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t7) (and (hmastlock t7) (start t7)) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t8) (and (hmastlock t8) (start t8)) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t9) (and (hmastlock t9) (start t9)) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T6_S3
(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_accept_all
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t0) (and (not (hmaster t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T2_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t0) (and (not (hmaster t0)) (not (tok t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T2_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t1) (and (not (hmaster t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T2_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t1) (and (not (hmaster t1)) (not (tok t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T2_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t2) (and (not (hmaster t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T2_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t2) (and (not (hmaster t2)) (not (tok t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T2_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t3) (and (not (hmaster t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T2_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t3) (and (not (hmaster t3)) (not (tok t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T2_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t4) (and (not (hmaster t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T2_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t4) (and (not (hmaster t4)) (not (tok t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T2_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t5) (and (not (hmaster t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T2_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t5) (and (not (hmaster t5)) (not (tok t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T2_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t6) (and (not (hmaster t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T2_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t6) (and (not (hmaster t6)) (not (tok t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T2_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t7) (and (not (hmaster t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T2_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t7) (and (not (hmaster t7)) (not (tok t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T2_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t8) (and (not (hmaster t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T2_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t8) (and (not (hmaster t8)) (not (tok t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T2_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t9) (and (not (hmaster t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T2_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t9) (and (not (hmaster t9)) (not (tok t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T2_S10 t9))) )))

; encoded spec state lq_T2_S10
(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (hmastlock t0)) (hmaster t0) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (hmastlock t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (sends t0)) (hmaster t0) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (hmaster t0)) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (hmastlock t1)) (hmaster t1) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (hmastlock t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (sends t1)) (hmaster t1) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (hmaster t1)) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (hmastlock t2)) (hmaster t2) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (hmastlock t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (sends t2)) (hmaster t2) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (hmaster t2)) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (hmastlock t3)) (hmaster t3) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (hmastlock t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (sends t3)) (hmaster t3) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (hmaster t3)) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (hmastlock t4)) (hmaster t4) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (hmastlock t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (sends t4)) (hmaster t4) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (hmaster t4)) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (hmastlock t5)) (hmaster t5) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (hmastlock t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (sends t5)) (hmaster t5) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (hmaster t5)) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (hmastlock t6)) (hmaster t6) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (hmastlock t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (sends t6)) (hmaster t6) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (hmaster t6)) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (hmastlock t7)) (hmaster t7) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (hmastlock t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (sends t7)) (hmaster t7) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (hmaster t7)) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (hmastlock t8)) (hmaster t8) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (hmastlock t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (sends t8)) (hmaster t8) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (hmaster t8)) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (hmastlock t9)) (hmaster t9) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (hmastlock t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (sends t9)) (hmaster t9) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (hmaster t9)) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T4_S20
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

; encoded spec state lq_accept_S19
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t0) (and (not (hmaster t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t0) (and (not (hmaster t0)) (not (tok t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t1) (and (not (hmaster t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t1) (and (not (hmaster t1)) (not (tok t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t2) (and (not (hmaster t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t2) (and (not (hmaster t2)) (not (tok t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t3) (and (not (hmaster t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t3) (and (not (hmaster t3)) (not (tok t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t4) (and (not (hmaster t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t4) (and (not (hmaster t4)) (not (tok t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t5) (and (not (hmaster t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t5) (and (not (hmaster t5)) (not (tok t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t6) (and (not (hmaster t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t6) (and (not (hmaster t6)) (not (tok t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t7) (and (not (hmaster t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t7) (and (not (hmaster t7)) (not (tok t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t8) (and (not (hmaster t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t8) (and (not (hmaster t8)) (not (tok t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t9) (and (not (hmaster t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t9) (and (not (hmaster t9)) (not (tok t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S10 t9))) )))

; encoded spec state lq_T1_S10
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (not (hmastlock t0)) (hgrant t0) (not (hmaster t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (not (hmastlock t0)) (not (hgrant t0)) (not (hmaster t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (tok t0) (not (hmastlock t0)) (not (hmaster t0)) (not (hgrant t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (hmastlock t0) (not (hmaster t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (not (hmastlock t1)) (hgrant t1) (not (hmaster t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (not (hmastlock t1)) (not (hgrant t1)) (not (hmaster t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (tok t1) (not (hmastlock t1)) (not (hmaster t1)) (not (hgrant t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (hmastlock t1) (not (hmaster t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (not (hmastlock t2)) (hgrant t2) (not (hmaster t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (not (hmastlock t2)) (not (hgrant t2)) (not (hmaster t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (tok t2) (not (hmastlock t2)) (not (hmaster t2)) (not (hgrant t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (hmastlock t2) (not (hmaster t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (not (hmastlock t3)) (hgrant t3) (not (hmaster t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (not (hmastlock t3)) (not (hgrant t3)) (not (hmaster t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (tok t3) (not (hmastlock t3)) (not (hmaster t3)) (not (hgrant t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (hmastlock t3) (not (hmaster t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (not (hmastlock t4)) (hgrant t4) (not (hmaster t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (not (hmastlock t4)) (not (hgrant t4)) (not (hmaster t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (tok t4) (not (hmastlock t4)) (not (hmaster t4)) (not (hgrant t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (hmastlock t4) (not (hmaster t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (not (hmastlock t5)) (hgrant t5) (not (hmaster t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (not (hmastlock t5)) (not (hgrant t5)) (not (hmaster t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (tok t5) (not (hmastlock t5)) (not (hmaster t5)) (not (hgrant t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (hmastlock t5) (not (hmaster t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (not (hmastlock t6)) (hgrant t6) (not (hmaster t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (not (hmastlock t6)) (not (hgrant t6)) (not (hmaster t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (tok t6) (not (hmastlock t6)) (not (hmaster t6)) (not (hgrant t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (hmastlock t6) (not (hmaster t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (not (hmastlock t7)) (hgrant t7) (not (hmaster t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (not (hmastlock t7)) (not (hgrant t7)) (not (hmaster t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (tok t7) (not (hmastlock t7)) (not (hmaster t7)) (not (hgrant t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (hmastlock t7) (not (hmaster t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (not (hmastlock t8)) (hgrant t8) (not (hmaster t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (not (hmastlock t8)) (not (hgrant t8)) (not (hmaster t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (tok t8) (not (hmastlock t8)) (not (hmaster t8)) (not (hgrant t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (hmastlock t8) (not (hmaster t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (not (hmastlock t9)) (hgrant t9) (not (hmaster t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (not (hmastlock t9)) (not (hgrant t9)) (not (hmaster t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false)) (and (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (tok t9) (not (hmastlock t9)) (not (hmaster t9)) (not (hgrant t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (hmastlock t9) (not (hmaster t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false false))   false  )))

; encoded spec state lq_T0_init
(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t0) (and (hmastlock t0) (start t0)) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t1) (and (hmastlock t1) (start t1)) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t2) (and (hmastlock t2) (start t2)) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t3) (and (hmastlock t3) (start t3)) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t4) (and (hmastlock t4) (start t4)) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t5) (and (hmastlock t5) (start t5)) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t6) (and (hmastlock t6) (start t6)) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t7) (and (hmastlock t7) (start t7)) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t8) (and (hmastlock t8) (start t8)) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t9) (and (hmastlock t9) (start t9)) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T10_S2
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S27
(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t0)  (not (hgrant t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t1)  (not (hgrant t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t2)  (not (hgrant t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t3)  (not (hgrant t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t4)  (not (hgrant t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t5)  (not (hgrant t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t6)  (not (hgrant t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t7)  (not (hgrant t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t8)  (not (hgrant t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t9)  (not (hgrant t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T9_S6
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

; encoded spec state lq_T1_S19
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S25
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S23
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

; encoded spec state lq_accept_S21
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t0)  (hgrant t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t0)  (not (hgrant t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t1)  (hgrant t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t1)  (not (hgrant t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t2)  (hgrant t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t2)  (not (hgrant t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t3)  (hgrant t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t3)  (not (hgrant t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t4)  (hgrant t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t4)  (not (hgrant t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t5)  (hgrant t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t5)  (not (hgrant t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t6)  (hgrant t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t6)  (not (hgrant t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t7)  (hgrant t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t7)  (not (hgrant t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t8)  (hgrant t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t8)  (not (hgrant t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t9)  (hgrant t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t9)  (not (hgrant t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T8_S5
(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0) (and (hmaster t0) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1) (and (hmaster t1) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2) (and (hmaster t2) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3) (and (hmaster t3) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4) (and (hmaster t4) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5) (and (hmaster t5) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6) (and (hmaster t6) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7) (and (hmaster t7) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8) (and (hmaster t8) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9) (and (hmaster t9) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T0_S9
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

; encoded spec state lq_T1_S21
(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t0) (and (hmastlock t0) (start t0)) (not (and (tok t0) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t1) (and (hmastlock t1) (start t1)) (not (and (tok t1) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t2) (and (hmastlock t2) (start t2)) (not (and (tok t2) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t3) (and (hmastlock t3) (start t3)) (not (and (tok t3) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t4) (and (hmastlock t4) (start t4)) (not (and (tok t4) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t5) (and (hmastlock t5) (start t5)) (not (and (tok t5) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t6) (and (hmastlock t6) (start t6)) (not (and (tok t6) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t7) (and (hmastlock t7) (start t7)) (not (and (tok t7) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t8) (and (hmastlock t8) (start t8)) (not (and (tok t8) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t9) (and (hmastlock t9) (start t9)) (not (and (tok t9) ?prev_0)) (env_ass false true ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

; encoded spec state lq_T7_S4
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (not (sends t0)) (not (hmastlock t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (not (sends t1)) (not (hmastlock t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (not (sends t2)) (not (hmastlock t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (not (sends t3)) (not (hmastlock t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (not (sends t4)) (not (hmastlock t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (not (sends t5)) (not (hmastlock t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (not (sends t6)) (not (hmastlock t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (not (sends t7)) (not (hmastlock t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (not (sends t8)) (not (hmastlock t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true true false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 false false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false true false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (not (sends t9)) (not (hmastlock t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 true false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

; encoded spec state lq_T3_S19
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S29
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t0) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (decide t0) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (hgrant t0) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (hmaster t0) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (hmastlock t0) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (locked t0) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (start t0) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (tok t0)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t1) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (decide t1) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (hgrant t1) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (hmaster t1) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (hmastlock t1) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (locked t1) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (start t1) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (tok t1)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t2) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (decide t2) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (hgrant t2) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (hmaster t2) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (hmastlock t2) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (locked t2) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (start t2) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (tok t2)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t3) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (decide t3) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (hgrant t3) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (hmaster t3) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (hmastlock t3) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (locked t3) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (start t3) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (tok t3)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t4) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (decide t4) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (hgrant t4) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (hmaster t4) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (hmastlock t4) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (locked t4) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (start t4) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (tok t4)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t5) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (decide t5) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (hgrant t5) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (hmaster t5) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (hmastlock t5) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (locked t5) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (start t5) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (tok t5)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t6) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (decide t6) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (hgrant t6) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (hmaster t6) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (hmastlock t6) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (locked t6) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (start t6) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (tok t6)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t7) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (decide t7) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (hgrant t7) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (hmaster t7) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (hmastlock t7) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (locked t7) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (start t7) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (tok t7)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t8) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (decide t8) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (hgrant t8) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (hmaster t8) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (hmastlock t8) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (locked t8) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (start t8) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (tok t8)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0) (env_ass ?hburst0Next_0 ?hburst1Next_0 ?hbusreqNext_0 ?hlockNext_0) (=> (tok t9) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (decide t9) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (hgrant t9) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (hmaster t9) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (hmastlock t9) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (locked t9) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (start t9) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (tok t9)))))

(check-sat-using (then qe smt))
(get-value ((tau true true true true true true t0)))
(get-value ((tau true true true true true true t1)))
(get-value ((tau true true true true true true t2)))
(get-value ((tau true true true true true true t3)))
(get-value ((tau true true true true true true t4)))
(get-value ((tau true true true true true true t5)))
(get-value ((tau true true true true true true t6)))
(get-value ((tau true true true true true true t7)))
(get-value ((tau true true true true true true t8)))
(get-value ((tau true true true true true true t9)))
(get-value ((tau true true true true true false t0)))
(get-value ((tau true true true true true false t1)))
(get-value ((tau true true true true true false t2)))
(get-value ((tau true true true true true false t3)))
(get-value ((tau true true true true true false t4)))
(get-value ((tau true true true true true false t5)))
(get-value ((tau true true true true true false t6)))
(get-value ((tau true true true true true false t7)))
(get-value ((tau true true true true true false t8)))
(get-value ((tau true true true true true false t9)))
(get-value ((tau true true true true false true t0)))
(get-value ((tau true true true true false true t1)))
(get-value ((tau true true true true false true t2)))
(get-value ((tau true true true true false true t3)))
(get-value ((tau true true true true false true t4)))
(get-value ((tau true true true true false true t5)))
(get-value ((tau true true true true false true t6)))
(get-value ((tau true true true true false true t7)))
(get-value ((tau true true true true false true t8)))
(get-value ((tau true true true true false true t9)))
(get-value ((tau true true true true false false t0)))
(get-value ((tau true true true true false false t1)))
(get-value ((tau true true true true false false t2)))
(get-value ((tau true true true true false false t3)))
(get-value ((tau true true true true false false t4)))
(get-value ((tau true true true true false false t5)))
(get-value ((tau true true true true false false t6)))
(get-value ((tau true true true true false false t7)))
(get-value ((tau true true true true false false t8)))
(get-value ((tau true true true true false false t9)))
(get-value ((tau true true true false true true t0)))
(get-value ((tau true true true false true true t1)))
(get-value ((tau true true true false true true t2)))
(get-value ((tau true true true false true true t3)))
(get-value ((tau true true true false true true t4)))
(get-value ((tau true true true false true true t5)))
(get-value ((tau true true true false true true t6)))
(get-value ((tau true true true false true true t7)))
(get-value ((tau true true true false true true t8)))
(get-value ((tau true true true false true true t9)))
(get-value ((tau true true true false true false t0)))
(get-value ((tau true true true false true false t1)))
(get-value ((tau true true true false true false t2)))
(get-value ((tau true true true false true false t3)))
(get-value ((tau true true true false true false t4)))
(get-value ((tau true true true false true false t5)))
(get-value ((tau true true true false true false t6)))
(get-value ((tau true true true false true false t7)))
(get-value ((tau true true true false true false t8)))
(get-value ((tau true true true false true false t9)))
(get-value ((tau true true true false false true t0)))
(get-value ((tau true true true false false true t1)))
(get-value ((tau true true true false false true t2)))
(get-value ((tau true true true false false true t3)))
(get-value ((tau true true true false false true t4)))
(get-value ((tau true true true false false true t5)))
(get-value ((tau true true true false false true t6)))
(get-value ((tau true true true false false true t7)))
(get-value ((tau true true true false false true t8)))
(get-value ((tau true true true false false true t9)))
(get-value ((tau true true true false false false t0)))
(get-value ((tau true true true false false false t1)))
(get-value ((tau true true true false false false t2)))
(get-value ((tau true true true false false false t3)))
(get-value ((tau true true true false false false t4)))
(get-value ((tau true true true false false false t5)))
(get-value ((tau true true true false false false t6)))
(get-value ((tau true true true false false false t7)))
(get-value ((tau true true true false false false t8)))
(get-value ((tau true true true false false false t9)))
(get-value ((tau true true false true true true t0)))
(get-value ((tau true true false true true true t1)))
(get-value ((tau true true false true true true t2)))
(get-value ((tau true true false true true true t3)))
(get-value ((tau true true false true true true t4)))
(get-value ((tau true true false true true true t5)))
(get-value ((tau true true false true true true t6)))
(get-value ((tau true true false true true true t7)))
(get-value ((tau true true false true true true t8)))
(get-value ((tau true true false true true true t9)))
(get-value ((tau true true false true true false t0)))
(get-value ((tau true true false true true false t1)))
(get-value ((tau true true false true true false t2)))
(get-value ((tau true true false true true false t3)))
(get-value ((tau true true false true true false t4)))
(get-value ((tau true true false true true false t5)))
(get-value ((tau true true false true true false t6)))
(get-value ((tau true true false true true false t7)))
(get-value ((tau true true false true true false t8)))
(get-value ((tau true true false true true false t9)))
(get-value ((tau true true false true false true t0)))
(get-value ((tau true true false true false true t1)))
(get-value ((tau true true false true false true t2)))
(get-value ((tau true true false true false true t3)))
(get-value ((tau true true false true false true t4)))
(get-value ((tau true true false true false true t5)))
(get-value ((tau true true false true false true t6)))
(get-value ((tau true true false true false true t7)))
(get-value ((tau true true false true false true t8)))
(get-value ((tau true true false true false true t9)))
(get-value ((tau true true false true false false t0)))
(get-value ((tau true true false true false false t1)))
(get-value ((tau true true false true false false t2)))
(get-value ((tau true true false true false false t3)))
(get-value ((tau true true false true false false t4)))
(get-value ((tau true true false true false false t5)))
(get-value ((tau true true false true false false t6)))
(get-value ((tau true true false true false false t7)))
(get-value ((tau true true false true false false t8)))
(get-value ((tau true true false true false false t9)))
(get-value ((tau true true false false true true t0)))
(get-value ((tau true true false false true true t1)))
(get-value ((tau true true false false true true t2)))
(get-value ((tau true true false false true true t3)))
(get-value ((tau true true false false true true t4)))
(get-value ((tau true true false false true true t5)))
(get-value ((tau true true false false true true t6)))
(get-value ((tau true true false false true true t7)))
(get-value ((tau true true false false true true t8)))
(get-value ((tau true true false false true true t9)))
(get-value ((tau true true false false true false t0)))
(get-value ((tau true true false false true false t1)))
(get-value ((tau true true false false true false t2)))
(get-value ((tau true true false false true false t3)))
(get-value ((tau true true false false true false t4)))
(get-value ((tau true true false false true false t5)))
(get-value ((tau true true false false true false t6)))
(get-value ((tau true true false false true false t7)))
(get-value ((tau true true false false true false t8)))
(get-value ((tau true true false false true false t9)))
(get-value ((tau true true false false false true t0)))
(get-value ((tau true true false false false true t1)))
(get-value ((tau true true false false false true t2)))
(get-value ((tau true true false false false true t3)))
(get-value ((tau true true false false false true t4)))
(get-value ((tau true true false false false true t5)))
(get-value ((tau true true false false false true t6)))
(get-value ((tau true true false false false true t7)))
(get-value ((tau true true false false false true t8)))
(get-value ((tau true true false false false true t9)))
(get-value ((tau true true false false false false t0)))
(get-value ((tau true true false false false false t1)))
(get-value ((tau true true false false false false t2)))
(get-value ((tau true true false false false false t3)))
(get-value ((tau true true false false false false t4)))
(get-value ((tau true true false false false false t5)))
(get-value ((tau true true false false false false t6)))
(get-value ((tau true true false false false false t7)))
(get-value ((tau true true false false false false t8)))
(get-value ((tau true true false false false false t9)))
(get-value ((tau true false true true true true t0)))
(get-value ((tau true false true true true true t1)))
(get-value ((tau true false true true true true t2)))
(get-value ((tau true false true true true true t3)))
(get-value ((tau true false true true true true t4)))
(get-value ((tau true false true true true true t5)))
(get-value ((tau true false true true true true t6)))
(get-value ((tau true false true true true true t7)))
(get-value ((tau true false true true true true t8)))
(get-value ((tau true false true true true true t9)))
(get-value ((tau true false true true true false t0)))
(get-value ((tau true false true true true false t1)))
(get-value ((tau true false true true true false t2)))
(get-value ((tau true false true true true false t3)))
(get-value ((tau true false true true true false t4)))
(get-value ((tau true false true true true false t5)))
(get-value ((tau true false true true true false t6)))
(get-value ((tau true false true true true false t7)))
(get-value ((tau true false true true true false t8)))
(get-value ((tau true false true true true false t9)))
(get-value ((tau true false true true false true t0)))
(get-value ((tau true false true true false true t1)))
(get-value ((tau true false true true false true t2)))
(get-value ((tau true false true true false true t3)))
(get-value ((tau true false true true false true t4)))
(get-value ((tau true false true true false true t5)))
(get-value ((tau true false true true false true t6)))
(get-value ((tau true false true true false true t7)))
(get-value ((tau true false true true false true t8)))
(get-value ((tau true false true true false true t9)))
(get-value ((tau true false true true false false t0)))
(get-value ((tau true false true true false false t1)))
(get-value ((tau true false true true false false t2)))
(get-value ((tau true false true true false false t3)))
(get-value ((tau true false true true false false t4)))
(get-value ((tau true false true true false false t5)))
(get-value ((tau true false true true false false t6)))
(get-value ((tau true false true true false false t7)))
(get-value ((tau true false true true false false t8)))
(get-value ((tau true false true true false false t9)))
(get-value ((tau true false true false true true t0)))
(get-value ((tau true false true false true true t1)))
(get-value ((tau true false true false true true t2)))
(get-value ((tau true false true false true true t3)))
(get-value ((tau true false true false true true t4)))
(get-value ((tau true false true false true true t5)))
(get-value ((tau true false true false true true t6)))
(get-value ((tau true false true false true true t7)))
(get-value ((tau true false true false true true t8)))
(get-value ((tau true false true false true true t9)))
(get-value ((tau true false true false true false t0)))
(get-value ((tau true false true false true false t1)))
(get-value ((tau true false true false true false t2)))
(get-value ((tau true false true false true false t3)))
(get-value ((tau true false true false true false t4)))
(get-value ((tau true false true false true false t5)))
(get-value ((tau true false true false true false t6)))
(get-value ((tau true false true false true false t7)))
(get-value ((tau true false true false true false t8)))
(get-value ((tau true false true false true false t9)))
(get-value ((tau true false true false false true t0)))
(get-value ((tau true false true false false true t1)))
(get-value ((tau true false true false false true t2)))
(get-value ((tau true false true false false true t3)))
(get-value ((tau true false true false false true t4)))
(get-value ((tau true false true false false true t5)))
(get-value ((tau true false true false false true t6)))
(get-value ((tau true false true false false true t7)))
(get-value ((tau true false true false false true t8)))
(get-value ((tau true false true false false true t9)))
(get-value ((tau true false true false false false t0)))
(get-value ((tau true false true false false false t1)))
(get-value ((tau true false true false false false t2)))
(get-value ((tau true false true false false false t3)))
(get-value ((tau true false true false false false t4)))
(get-value ((tau true false true false false false t5)))
(get-value ((tau true false true false false false t6)))
(get-value ((tau true false true false false false t7)))
(get-value ((tau true false true false false false t8)))
(get-value ((tau true false true false false false t9)))
(get-value ((tau true false false true true true t0)))
(get-value ((tau true false false true true true t1)))
(get-value ((tau true false false true true true t2)))
(get-value ((tau true false false true true true t3)))
(get-value ((tau true false false true true true t4)))
(get-value ((tau true false false true true true t5)))
(get-value ((tau true false false true true true t6)))
(get-value ((tau true false false true true true t7)))
(get-value ((tau true false false true true true t8)))
(get-value ((tau true false false true true true t9)))
(get-value ((tau true false false true true false t0)))
(get-value ((tau true false false true true false t1)))
(get-value ((tau true false false true true false t2)))
(get-value ((tau true false false true true false t3)))
(get-value ((tau true false false true true false t4)))
(get-value ((tau true false false true true false t5)))
(get-value ((tau true false false true true false t6)))
(get-value ((tau true false false true true false t7)))
(get-value ((tau true false false true true false t8)))
(get-value ((tau true false false true true false t9)))
(get-value ((tau true false false true false true t0)))
(get-value ((tau true false false true false true t1)))
(get-value ((tau true false false true false true t2)))
(get-value ((tau true false false true false true t3)))
(get-value ((tau true false false true false true t4)))
(get-value ((tau true false false true false true t5)))
(get-value ((tau true false false true false true t6)))
(get-value ((tau true false false true false true t7)))
(get-value ((tau true false false true false true t8)))
(get-value ((tau true false false true false true t9)))
(get-value ((tau true false false true false false t0)))
(get-value ((tau true false false true false false t1)))
(get-value ((tau true false false true false false t2)))
(get-value ((tau true false false true false false t3)))
(get-value ((tau true false false true false false t4)))
(get-value ((tau true false false true false false t5)))
(get-value ((tau true false false true false false t6)))
(get-value ((tau true false false true false false t7)))
(get-value ((tau true false false true false false t8)))
(get-value ((tau true false false true false false t9)))
(get-value ((tau true false false false true true t0)))
(get-value ((tau true false false false true true t1)))
(get-value ((tau true false false false true true t2)))
(get-value ((tau true false false false true true t3)))
(get-value ((tau true false false false true true t4)))
(get-value ((tau true false false false true true t5)))
(get-value ((tau true false false false true true t6)))
(get-value ((tau true false false false true true t7)))
(get-value ((tau true false false false true true t8)))
(get-value ((tau true false false false true true t9)))
(get-value ((tau true false false false true false t0)))
(get-value ((tau true false false false true false t1)))
(get-value ((tau true false false false true false t2)))
(get-value ((tau true false false false true false t3)))
(get-value ((tau true false false false true false t4)))
(get-value ((tau true false false false true false t5)))
(get-value ((tau true false false false true false t6)))
(get-value ((tau true false false false true false t7)))
(get-value ((tau true false false false true false t8)))
(get-value ((tau true false false false true false t9)))
(get-value ((tau true false false false false true t0)))
(get-value ((tau true false false false false true t1)))
(get-value ((tau true false false false false true t2)))
(get-value ((tau true false false false false true t3)))
(get-value ((tau true false false false false true t4)))
(get-value ((tau true false false false false true t5)))
(get-value ((tau true false false false false true t6)))
(get-value ((tau true false false false false true t7)))
(get-value ((tau true false false false false true t8)))
(get-value ((tau true false false false false true t9)))
(get-value ((tau true false false false false false t0)))
(get-value ((tau true false false false false false t1)))
(get-value ((tau true false false false false false t2)))
(get-value ((tau true false false false false false t3)))
(get-value ((tau true false false false false false t4)))
(get-value ((tau true false false false false false t5)))
(get-value ((tau true false false false false false t6)))
(get-value ((tau true false false false false false t7)))
(get-value ((tau true false false false false false t8)))
(get-value ((tau true false false false false false t9)))
(get-value ((tau false true true true true true t0)))
(get-value ((tau false true true true true true t1)))
(get-value ((tau false true true true true true t2)))
(get-value ((tau false true true true true true t3)))
(get-value ((tau false true true true true true t4)))
(get-value ((tau false true true true true true t5)))
(get-value ((tau false true true true true true t6)))
(get-value ((tau false true true true true true t7)))
(get-value ((tau false true true true true true t8)))
(get-value ((tau false true true true true true t9)))
(get-value ((tau false true true true true false t0)))
(get-value ((tau false true true true true false t1)))
(get-value ((tau false true true true true false t2)))
(get-value ((tau false true true true true false t3)))
(get-value ((tau false true true true true false t4)))
(get-value ((tau false true true true true false t5)))
(get-value ((tau false true true true true false t6)))
(get-value ((tau false true true true true false t7)))
(get-value ((tau false true true true true false t8)))
(get-value ((tau false true true true true false t9)))
(get-value ((tau false true true true false true t0)))
(get-value ((tau false true true true false true t1)))
(get-value ((tau false true true true false true t2)))
(get-value ((tau false true true true false true t3)))
(get-value ((tau false true true true false true t4)))
(get-value ((tau false true true true false true t5)))
(get-value ((tau false true true true false true t6)))
(get-value ((tau false true true true false true t7)))
(get-value ((tau false true true true false true t8)))
(get-value ((tau false true true true false true t9)))
(get-value ((tau false true true true false false t0)))
(get-value ((tau false true true true false false t1)))
(get-value ((tau false true true true false false t2)))
(get-value ((tau false true true true false false t3)))
(get-value ((tau false true true true false false t4)))
(get-value ((tau false true true true false false t5)))
(get-value ((tau false true true true false false t6)))
(get-value ((tau false true true true false false t7)))
(get-value ((tau false true true true false false t8)))
(get-value ((tau false true true true false false t9)))
(get-value ((tau false true true false true true t0)))
(get-value ((tau false true true false true true t1)))
(get-value ((tau false true true false true true t2)))
(get-value ((tau false true true false true true t3)))
(get-value ((tau false true true false true true t4)))
(get-value ((tau false true true false true true t5)))
(get-value ((tau false true true false true true t6)))
(get-value ((tau false true true false true true t7)))
(get-value ((tau false true true false true true t8)))
(get-value ((tau false true true false true true t9)))
(get-value ((tau false true true false true false t0)))
(get-value ((tau false true true false true false t1)))
(get-value ((tau false true true false true false t2)))
(get-value ((tau false true true false true false t3)))
(get-value ((tau false true true false true false t4)))
(get-value ((tau false true true false true false t5)))
(get-value ((tau false true true false true false t6)))
(get-value ((tau false true true false true false t7)))
(get-value ((tau false true true false true false t8)))
(get-value ((tau false true true false true false t9)))
(get-value ((tau false true true false false true t0)))
(get-value ((tau false true true false false true t1)))
(get-value ((tau false true true false false true t2)))
(get-value ((tau false true true false false true t3)))
(get-value ((tau false true true false false true t4)))
(get-value ((tau false true true false false true t5)))
(get-value ((tau false true true false false true t6)))
(get-value ((tau false true true false false true t7)))
(get-value ((tau false true true false false true t8)))
(get-value ((tau false true true false false true t9)))
(get-value ((tau false true true false false false t0)))
(get-value ((tau false true true false false false t1)))
(get-value ((tau false true true false false false t2)))
(get-value ((tau false true true false false false t3)))
(get-value ((tau false true true false false false t4)))
(get-value ((tau false true true false false false t5)))
(get-value ((tau false true true false false false t6)))
(get-value ((tau false true true false false false t7)))
(get-value ((tau false true true false false false t8)))
(get-value ((tau false true true false false false t9)))
(get-value ((tau false true false true true true t0)))
(get-value ((tau false true false true true true t1)))
(get-value ((tau false true false true true true t2)))
(get-value ((tau false true false true true true t3)))
(get-value ((tau false true false true true true t4)))
(get-value ((tau false true false true true true t5)))
(get-value ((tau false true false true true true t6)))
(get-value ((tau false true false true true true t7)))
(get-value ((tau false true false true true true t8)))
(get-value ((tau false true false true true true t9)))
(get-value ((tau false true false true true false t0)))
(get-value ((tau false true false true true false t1)))
(get-value ((tau false true false true true false t2)))
(get-value ((tau false true false true true false t3)))
(get-value ((tau false true false true true false t4)))
(get-value ((tau false true false true true false t5)))
(get-value ((tau false true false true true false t6)))
(get-value ((tau false true false true true false t7)))
(get-value ((tau false true false true true false t8)))
(get-value ((tau false true false true true false t9)))
(get-value ((tau false true false true false true t0)))
(get-value ((tau false true false true false true t1)))
(get-value ((tau false true false true false true t2)))
(get-value ((tau false true false true false true t3)))
(get-value ((tau false true false true false true t4)))
(get-value ((tau false true false true false true t5)))
(get-value ((tau false true false true false true t6)))
(get-value ((tau false true false true false true t7)))
(get-value ((tau false true false true false true t8)))
(get-value ((tau false true false true false true t9)))
(get-value ((tau false true false true false false t0)))
(get-value ((tau false true false true false false t1)))
(get-value ((tau false true false true false false t2)))
(get-value ((tau false true false true false false t3)))
(get-value ((tau false true false true false false t4)))
(get-value ((tau false true false true false false t5)))
(get-value ((tau false true false true false false t6)))
(get-value ((tau false true false true false false t7)))
(get-value ((tau false true false true false false t8)))
(get-value ((tau false true false true false false t9)))
(get-value ((tau false true false false true true t0)))
(get-value ((tau false true false false true true t1)))
(get-value ((tau false true false false true true t2)))
(get-value ((tau false true false false true true t3)))
(get-value ((tau false true false false true true t4)))
(get-value ((tau false true false false true true t5)))
(get-value ((tau false true false false true true t6)))
(get-value ((tau false true false false true true t7)))
(get-value ((tau false true false false true true t8)))
(get-value ((tau false true false false true true t9)))
(get-value ((tau false true false false true false t0)))
(get-value ((tau false true false false true false t1)))
(get-value ((tau false true false false true false t2)))
(get-value ((tau false true false false true false t3)))
(get-value ((tau false true false false true false t4)))
(get-value ((tau false true false false true false t5)))
(get-value ((tau false true false false true false t6)))
(get-value ((tau false true false false true false t7)))
(get-value ((tau false true false false true false t8)))
(get-value ((tau false true false false true false t9)))
(get-value ((tau false true false false false true t0)))
(get-value ((tau false true false false false true t1)))
(get-value ((tau false true false false false true t2)))
(get-value ((tau false true false false false true t3)))
(get-value ((tau false true false false false true t4)))
(get-value ((tau false true false false false true t5)))
(get-value ((tau false true false false false true t6)))
(get-value ((tau false true false false false true t7)))
(get-value ((tau false true false false false true t8)))
(get-value ((tau false true false false false true t9)))
(get-value ((tau false true false false false false t0)))
(get-value ((tau false true false false false false t1)))
(get-value ((tau false true false false false false t2)))
(get-value ((tau false true false false false false t3)))
(get-value ((tau false true false false false false t4)))
(get-value ((tau false true false false false false t5)))
(get-value ((tau false true false false false false t6)))
(get-value ((tau false true false false false false t7)))
(get-value ((tau false true false false false false t8)))
(get-value ((tau false true false false false false t9)))
(get-value ((tau false false true true true true t0)))
(get-value ((tau false false true true true true t1)))
(get-value ((tau false false true true true true t2)))
(get-value ((tau false false true true true true t3)))
(get-value ((tau false false true true true true t4)))
(get-value ((tau false false true true true true t5)))
(get-value ((tau false false true true true true t6)))
(get-value ((tau false false true true true true t7)))
(get-value ((tau false false true true true true t8)))
(get-value ((tau false false true true true true t9)))
(get-value ((tau false false true true true false t0)))
(get-value ((tau false false true true true false t1)))
(get-value ((tau false false true true true false t2)))
(get-value ((tau false false true true true false t3)))
(get-value ((tau false false true true true false t4)))
(get-value ((tau false false true true true false t5)))
(get-value ((tau false false true true true false t6)))
(get-value ((tau false false true true true false t7)))
(get-value ((tau false false true true true false t8)))
(get-value ((tau false false true true true false t9)))
(get-value ((tau false false true true false true t0)))
(get-value ((tau false false true true false true t1)))
(get-value ((tau false false true true false true t2)))
(get-value ((tau false false true true false true t3)))
(get-value ((tau false false true true false true t4)))
(get-value ((tau false false true true false true t5)))
(get-value ((tau false false true true false true t6)))
(get-value ((tau false false true true false true t7)))
(get-value ((tau false false true true false true t8)))
(get-value ((tau false false true true false true t9)))
(get-value ((tau false false true true false false t0)))
(get-value ((tau false false true true false false t1)))
(get-value ((tau false false true true false false t2)))
(get-value ((tau false false true true false false t3)))
(get-value ((tau false false true true false false t4)))
(get-value ((tau false false true true false false t5)))
(get-value ((tau false false true true false false t6)))
(get-value ((tau false false true true false false t7)))
(get-value ((tau false false true true false false t8)))
(get-value ((tau false false true true false false t9)))
(get-value ((tau false false true false true true t0)))
(get-value ((tau false false true false true true t1)))
(get-value ((tau false false true false true true t2)))
(get-value ((tau false false true false true true t3)))
(get-value ((tau false false true false true true t4)))
(get-value ((tau false false true false true true t5)))
(get-value ((tau false false true false true true t6)))
(get-value ((tau false false true false true true t7)))
(get-value ((tau false false true false true true t8)))
(get-value ((tau false false true false true true t9)))
(get-value ((tau false false true false true false t0)))
(get-value ((tau false false true false true false t1)))
(get-value ((tau false false true false true false t2)))
(get-value ((tau false false true false true false t3)))
(get-value ((tau false false true false true false t4)))
(get-value ((tau false false true false true false t5)))
(get-value ((tau false false true false true false t6)))
(get-value ((tau false false true false true false t7)))
(get-value ((tau false false true false true false t8)))
(get-value ((tau false false true false true false t9)))
(get-value ((tau false false true false false true t0)))
(get-value ((tau false false true false false true t1)))
(get-value ((tau false false true false false true t2)))
(get-value ((tau false false true false false true t3)))
(get-value ((tau false false true false false true t4)))
(get-value ((tau false false true false false true t5)))
(get-value ((tau false false true false false true t6)))
(get-value ((tau false false true false false true t7)))
(get-value ((tau false false true false false true t8)))
(get-value ((tau false false true false false true t9)))
(get-value ((tau false false true false false false t0)))
(get-value ((tau false false true false false false t1)))
(get-value ((tau false false true false false false t2)))
(get-value ((tau false false true false false false t3)))
(get-value ((tau false false true false false false t4)))
(get-value ((tau false false true false false false t5)))
(get-value ((tau false false true false false false t6)))
(get-value ((tau false false true false false false t7)))
(get-value ((tau false false true false false false t8)))
(get-value ((tau false false true false false false t9)))
(get-value ((tau false false false true true true t0)))
(get-value ((tau false false false true true true t1)))
(get-value ((tau false false false true true true t2)))
(get-value ((tau false false false true true true t3)))
(get-value ((tau false false false true true true t4)))
(get-value ((tau false false false true true true t5)))
(get-value ((tau false false false true true true t6)))
(get-value ((tau false false false true true true t7)))
(get-value ((tau false false false true true true t8)))
(get-value ((tau false false false true true true t9)))
(get-value ((tau false false false true true false t0)))
(get-value ((tau false false false true true false t1)))
(get-value ((tau false false false true true false t2)))
(get-value ((tau false false false true true false t3)))
(get-value ((tau false false false true true false t4)))
(get-value ((tau false false false true true false t5)))
(get-value ((tau false false false true true false t6)))
(get-value ((tau false false false true true false t7)))
(get-value ((tau false false false true true false t8)))
(get-value ((tau false false false true true false t9)))
(get-value ((tau false false false true false true t0)))
(get-value ((tau false false false true false true t1)))
(get-value ((tau false false false true false true t2)))
(get-value ((tau false false false true false true t3)))
(get-value ((tau false false false true false true t4)))
(get-value ((tau false false false true false true t5)))
(get-value ((tau false false false true false true t6)))
(get-value ((tau false false false true false true t7)))
(get-value ((tau false false false true false true t8)))
(get-value ((tau false false false true false true t9)))
(get-value ((tau false false false true false false t0)))
(get-value ((tau false false false true false false t1)))
(get-value ((tau false false false true false false t2)))
(get-value ((tau false false false true false false t3)))
(get-value ((tau false false false true false false t4)))
(get-value ((tau false false false true false false t5)))
(get-value ((tau false false false true false false t6)))
(get-value ((tau false false false true false false t7)))
(get-value ((tau false false false true false false t8)))
(get-value ((tau false false false true false false t9)))
(get-value ((tau false false false false true true t0)))
(get-value ((tau false false false false true true t1)))
(get-value ((tau false false false false true true t2)))
(get-value ((tau false false false false true true t3)))
(get-value ((tau false false false false true true t4)))
(get-value ((tau false false false false true true t5)))
(get-value ((tau false false false false true true t6)))
(get-value ((tau false false false false true true t7)))
(get-value ((tau false false false false true true t8)))
(get-value ((tau false false false false true true t9)))
(get-value ((tau false false false false true false t0)))
(get-value ((tau false false false false true false t1)))
(get-value ((tau false false false false true false t2)))
(get-value ((tau false false false false true false t3)))
(get-value ((tau false false false false true false t4)))
(get-value ((tau false false false false true false t5)))
(get-value ((tau false false false false true false t6)))
(get-value ((tau false false false false true false t7)))
(get-value ((tau false false false false true false t8)))
(get-value ((tau false false false false true false t9)))
(get-value ((tau false false false false false true t0)))
(get-value ((tau false false false false false true t1)))
(get-value ((tau false false false false false true t2)))
(get-value ((tau false false false false false true t3)))
(get-value ((tau false false false false false true t4)))
(get-value ((tau false false false false false true t5)))
(get-value ((tau false false false false false true t6)))
(get-value ((tau false false false false false true t7)))
(get-value ((tau false false false false false true t8)))
(get-value ((tau false false false false false true t9)))
(get-value ((tau false false false false false false t0)))
(get-value ((tau false false false false false false t1)))
(get-value ((tau false false false false false false t2)))
(get-value ((tau false false false false false false t3)))
(get-value ((tau false false false false false false t4)))
(get-value ((tau false false false false false false t5)))
(get-value ((tau false false false false false false t6)))
(get-value ((tau false false false false false false t7)))
(get-value ((tau false false false false false false t8)))
(get-value ((tau false false false false false false t9)))
(get-value ((locked t0)))
(get-value ((locked t1)))
(get-value ((locked t2)))
(get-value ((locked t3)))
(get-value ((locked t4)))
(get-value ((locked t5)))
(get-value ((locked t6)))
(get-value ((locked t7)))
(get-value ((locked t8)))
(get-value ((locked t9)))
(get-value ((start t0)))
(get-value ((start t1)))
(get-value ((start t2)))
(get-value ((start t3)))
(get-value ((start t4)))
(get-value ((start t5)))
(get-value ((start t6)))
(get-value ((start t7)))
(get-value ((start t8)))
(get-value ((start t9)))
(get-value ((sends t0)))
(get-value ((sends t1)))
(get-value ((sends t2)))
(get-value ((sends t3)))
(get-value ((sends t4)))
(get-value ((sends t5)))
(get-value ((sends t6)))
(get-value ((sends t7)))
(get-value ((sends t8)))
(get-value ((sends t9)))
(get-value ((hgrant t0)))
(get-value ((hgrant t1)))
(get-value ((hgrant t2)))
(get-value ((hgrant t3)))
(get-value ((hgrant t4)))
(get-value ((hgrant t5)))
(get-value ((hgrant t6)))
(get-value ((hgrant t7)))
(get-value ((hgrant t8)))
(get-value ((hgrant t9)))
(get-value ((hmaster t0)))
(get-value ((hmaster t1)))
(get-value ((hmaster t2)))
(get-value ((hmaster t3)))
(get-value ((hmaster t4)))
(get-value ((hmaster t5)))
(get-value ((hmaster t6)))
(get-value ((hmaster t7)))
(get-value ((hmaster t8)))
(get-value ((hmaster t9)))
(get-value ((tok t0)))
(get-value ((tok t1)))
(get-value ((tok t2)))
(get-value ((tok t3)))
(get-value ((tok t4)))
(get-value ((tok t5)))
(get-value ((tok t6)))
(get-value ((tok t7)))
(get-value ((tok t8)))
(get-value ((tok t9)))
(get-value ((decide t0)))
(get-value ((decide t1)))
(get-value ((decide t2)))
(get-value ((decide t3)))
(get-value ((decide t4)))
(get-value ((decide t5)))
(get-value ((decide t6)))
(get-value ((decide t7)))
(get-value ((decide t8)))
(get-value ((decide t9)))
(get-value ((hmastlock t0)))
(get-value ((hmastlock t1)))
(get-value ((hmastlock t2)))
(get-value ((hmastlock t3)))
(get-value ((hmastlock t4)))
(get-value ((hmastlock t5)))
(get-value ((hmastlock t6)))
(get-value ((hmastlock t7)))
(get-value ((hmastlock t8)))
(get-value ((hmastlock t9)))
(exit)
