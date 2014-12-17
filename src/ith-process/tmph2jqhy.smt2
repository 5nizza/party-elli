(set-option :produce-models true)
(set-option :EMATCHING false)

;(set-logic UFLIA)

(declare-datatypes () ((T t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13)))
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

(declare-datatypes () ((LQ lq_T8_S5 lq_T0_S9 lq_T6_S3 lq_T1_S19 lq_T3_S19 lq_T5_S29 lq_T0_S11 lq_accept_S10 lq_T5_S31 lq_T4_S8 lq_accept_all lq_T2_S10 lq_T4_S20 lq_accept_S19 lq_T1_S21 lq_T1_S10 lq_T0_init lq_T10_S2 lq_T5_S27 lq_T9_S6 lq_T7_S4 lq_T5_S25 lq_T5_S23 lq_accept_S21)))
(declare-fun laBl (LQ T) Bool)

(declare-fun laCl (LQ T) Int)

(define-fun env_ass ((hbusreq_0 Bool) (hlock_0 Bool)) Bool 
(=> hlock_0 hbusreq_0)
)
(define-fun sys_gua ((decideNext_0 Bool) (decide_0 Bool) (hgrantNext_0 Bool) (hgrant_0 Bool) (hlockNext_0 Bool) (hlock_0 Bool) (hmasterNext_0 Bool) (hmaster_0 Bool) (hmastlockNext_0 Bool) (hmastlock_0 Bool) (hreadyNext_0 Bool) (hready_0 Bool) (lockedNext_0 Bool) (locked_0 Bool) (startNext_0 Bool) (start_0 Bool) (tokNext_0 Bool) (tok_0 Bool)) Bool 
(and (and (and (and (and (and (and (and (=> (and (not decide_0)  true ) (= locked_0 lockedNext_0)) (=> (and hready_0  true ) (= locked_0 hmastlockNext_0))) (=> (and hready_0  true ) (= hgrant_0 hmasterNext_0))) (=> (not startNext_0) (= hmaster_0 hmasterNext_0))) (=> (and (not hready_0)  true ) (not startNext_0))) (=> (and (and decide_0  true ) hgrantNext_0) (= hlock_0 lockedNext_0))) (=> (not startNext_0) (= hmastlock_0 hmastlockNext_0))) (=> hgrant_0 tok_0)) (=> (and (not decide_0)  true ) (= hgrant_0 hgrantNext_0)))
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

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t10) (not (sends t10))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t10)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t10) (tok t10))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t10) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t10))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t10))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t10)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t10))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t11) (not (sends t11))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t11)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t11) (tok t11))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t11) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t11))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t11))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t11)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t11))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t12) (not (sends t12))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t12)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t12) (tok t12))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t12) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t12))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t12))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t12)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t12))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (and (tok t13) (not (sends t13))) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t13)))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t13) (tok t13))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (sends t13) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t13))))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 true t13))))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool) (?hlock_0 Bool)) (=> (not (tok t13)) (not (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 false t13))))))

(assert (laBl lq_T0_init t1))

(assert (laBl lq_T0_init t0))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t0)  (hgrant t0)  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t0)  (not (hgrant t0))  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t1)  (hgrant t1)  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t1)  (not (hgrant t1))  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t2)  (hgrant t2)  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t2)  (not (hgrant t2))  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t3)  (hgrant t3)  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t3)  (not (hgrant t3))  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t4)  (hgrant t4)  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t4)  (not (hgrant t4))  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t5)  (hgrant t5)  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t5)  (not (hgrant t5))  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t6)  (hgrant t6)  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t6)  (not (hgrant t6))  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t7)  (hgrant t7)  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t7)  (not (hgrant t7))  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t8)  (hgrant t8)  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t8)  (not (hgrant t8))  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t9)  (hgrant t9)  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t9)  (not (hgrant t9))  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t10)  (hgrant t10)  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t10)  (not (hgrant t10))  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t11)  (hgrant t11)  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t11)  (not (hgrant t11))  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t12)  (hgrant t12)  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t12)  (not (hgrant t12))  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t13)  (hgrant t13)  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T8_S5 t13)  (not (hgrant t13))  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T8_S5
(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t0) (and (hmaster t0) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t1) (and (hmaster t1) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t2) (and (hmaster t2) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t3) (and (hmaster t3) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t4) (and (hmaster t4) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t5) (and (hmaster t5) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t6) (and (hmaster t6) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t7) (and (hmaster t7) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t8) (and (hmaster t8) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t9) (and (hmaster t9) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t10)  (hmaster t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t10) (and (hmaster t10) (hmastlock t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t10) (and (hmaster t10) (hmastlock t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t10) (and (hmaster t10) (not (hmastlock t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t11)  (hmaster t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t11) (and (hmaster t11) (hmastlock t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t11) (and (hmaster t11) (hmastlock t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t11) (and (hmaster t11) (not (hmastlock t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t12)  (hmaster t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t12) (and (hmaster t12) (hmastlock t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t12) (and (hmaster t12) (hmastlock t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t12) (and (hmaster t12) (not (hmastlock t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t13)  (hmaster t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t13) (and (hmaster t13) (hmastlock t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t13) (and (hmaster t13) (hmastlock t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S11 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S9 t13) (and (hmaster t13) (not (hmastlock t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T0_S9 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T0_S9
(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t0) (and (hmastlock t0) (start t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t1) (and (hmastlock t1) (start t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t2) (and (hmastlock t2) (start t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t3) (and (hmastlock t3) (start t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t4) (and (hmastlock t4) (start t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t5) (and (hmastlock t5) (start t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t6) (and (hmastlock t6) (start t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t7) (and (hmastlock t7) (start t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t8) (and (hmastlock t8) (start t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t9) (and (hmastlock t9) (start t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t10) (and (hmastlock t10) (start t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t11) (and (hmastlock t11) (start t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t12) (and (hmastlock t12) (start t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T6_S3 t13) (and (hmastlock t13) (start t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T6_S3 t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T6_S3
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10)  (not (sends t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (not (hmastlock t10)) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (not (hmastlock t10)) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10)  (not (sends t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t10) (and (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11)  (not (sends t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (not (hmastlock t11)) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (not (hmastlock t11)) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11)  (not (sends t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t11) (and (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12)  (not (sends t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (not (hmastlock t12)) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (not (hmastlock t12)) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12)  (not (sends t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t12) (and (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13)  (not (sends t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (not (hmastlock t13)) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (not (hmastlock t13)) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13)  (not (sends t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S19 t13) (and (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S19 t13))) )))

; encoded spec state lq_T1_S19
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t0) (and (not (sends t0)) (not (hmastlock t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T3_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t1) (and (not (sends t1)) (not (hmastlock t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T3_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t2) (and (not (sends t2)) (not (hmastlock t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T3_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t3) (and (not (sends t3)) (not (hmastlock t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T3_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t4) (and (not (sends t4)) (not (hmastlock t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T3_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t5) (and (not (sends t5)) (not (hmastlock t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T3_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t6) (and (not (sends t6)) (not (hmastlock t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T3_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t7) (and (not (sends t7)) (not (hmastlock t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T3_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t8) (and (not (sends t8)) (not (hmastlock t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T3_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t9) (and (not (sends t9)) (not (hmastlock t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T3_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t10)  (not (sends t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T3_S19 t10))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t10)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T3_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t10) (and (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T3_S19 t10))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t10)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T3_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T3_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t10) (and (not (sends t10)) (not (hmastlock t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T3_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t11)  (not (sends t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T3_S19 t11))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t11)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T3_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t11) (and (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T3_S19 t11))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t11)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T3_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T3_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t11) (and (not (sends t11)) (not (hmastlock t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T3_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t12)  (not (sends t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T3_S19 t12))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t12)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T3_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t12) (and (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T3_S19 t12))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t12)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T3_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T3_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t12) (and (not (sends t12)) (not (hmastlock t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T3_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t13)  (not (sends t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T3_S19 t13))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t13)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T3_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t13) (and (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T3_S19 t13))) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t13)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T3_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T3_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T3_S19 t13) (and (not (sends t13)) (not (hmastlock t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T3_S19 t13))) )))

; encoded spec state lq_T3_S19
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t10)  (start t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t11)  (start t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t12)  (start t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S29 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S29 t13)  (start t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S29
(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0) (and (not (hmastlock t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t0)  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1) (and (not (hmastlock t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t1)  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2) (and (not (hmastlock t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t2)  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3) (and (not (hmastlock t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t3)  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4) (and (not (hmastlock t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t4)  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5) (and (not (hmastlock t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t5)  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6) (and (not (hmastlock t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t6)  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7) (and (not (hmastlock t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t7)  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8) (and (not (hmastlock t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t8)  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9) (and (not (hmastlock t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t9)  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t10) (and (hmastlock t10) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t10) (and (hmastlock t10) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t10) (and (not (hmastlock t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t10)  (hmaster t10)  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t10)  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t11) (and (hmastlock t11) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t11) (and (hmastlock t11) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t11) (and (not (hmastlock t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t11)  (hmaster t11)  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t11)  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t12) (and (hmastlock t12) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t12) (and (hmastlock t12) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t12) (and (not (hmastlock t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t12)  (hmaster t12)  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t12)  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t13) (and (hmastlock t13) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S11 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t13) (and (hmastlock t13) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t13) (and (not (hmastlock t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t13)  (hmaster t13)  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_S11 t13)  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T0_S11 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T0_S11
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t0) (and (not (hmaster t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t0) (and (not (hmaster t0)) (not (tok t0))) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t1) (and (not (hmaster t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t1) (and (not (hmaster t1)) (not (tok t1))) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t2) (and (not (hmaster t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t2) (and (not (hmaster t2)) (not (tok t2))) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t3) (and (not (hmaster t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t3) (and (not (hmaster t3)) (not (tok t3))) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t4) (and (not (hmaster t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t4) (and (not (hmaster t4)) (not (tok t4))) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t5) (and (not (hmaster t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t5) (and (not (hmaster t5)) (not (tok t5))) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t6) (and (not (hmaster t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t6) (and (not (hmaster t6)) (not (tok t6))) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t7) (and (not (hmaster t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t7) (and (not (hmaster t7)) (not (tok t7))) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t8) (and (not (hmaster t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t8) (and (not (hmaster t8)) (not (tok t8))) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t9) (and (not (hmaster t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t9) (and (not (hmaster t9)) (not (tok t9))) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t10) (and (not (hmaster t10)) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t10) (and (not (hmaster t10)) (not (tok t10))) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t11) (and (not (hmaster t11)) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t11) (and (not (hmaster t11)) (not (tok t11))) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t12) (and (not (hmaster t12)) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t12) (and (not (hmaster t12)) (not (tok t12))) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S10 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t13) (and (not (hmaster t13)) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S10 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S10 t13) (and (not (hmaster t13)) (not (tok t13))) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S10 t13))) )))

; encoded spec state lq_accept_S10
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t10)  (start t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t11)  (start t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t12)  (start t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S31 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S31 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S31 t13)  (start t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S31
(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (hmastlock t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (not (sends t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmastlock t0) (hmaster t0) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmastlock t0) (hmaster t0) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (hmaster t0) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t0) (and (not (hmaster t0)) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (hmastlock t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (not (sends t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmastlock t1) (hmaster t1) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmastlock t1) (hmaster t1) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (hmaster t1) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t1) (and (not (hmaster t1)) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (hmastlock t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (not (sends t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmastlock t2) (hmaster t2) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmastlock t2) (hmaster t2) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (hmaster t2) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t2) (and (not (hmaster t2)) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (hmastlock t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (not (sends t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmastlock t3) (hmaster t3) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmastlock t3) (hmaster t3) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (hmaster t3) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t3) (and (not (hmaster t3)) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (hmastlock t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (not (sends t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmastlock t4) (hmaster t4) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmastlock t4) (hmaster t4) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (hmaster t4) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t4) (and (not (hmaster t4)) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (hmastlock t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (not (sends t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmastlock t5) (hmaster t5) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmastlock t5) (hmaster t5) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (hmaster t5) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t5) (and (not (hmaster t5)) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (hmastlock t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (not (sends t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmastlock t6) (hmaster t6) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmastlock t6) (hmaster t6) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (hmaster t6) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t6) (and (not (hmaster t6)) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (hmastlock t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (not (sends t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmastlock t7) (hmaster t7) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmastlock t7) (hmaster t7) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (hmaster t7) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t7) (and (not (hmaster t7)) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (hmastlock t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (not (sends t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmastlock t8) (hmaster t8) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmastlock t8) (hmaster t8) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (hmaster t8) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t8) (and (not (hmaster t8)) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (hmastlock t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (not (sends t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmastlock t9) (hmaster t9) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmastlock t9) (hmaster t9) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (hmaster t9) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t9) (and (not (hmaster t9)) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmaster t10) (hmastlock t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmaster t10) (hmastlock t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmaster t10) (not (sends t10)) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmastlock t10) (hmaster t10) (tok t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmastlock t10) (hmaster t10) (tok t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmaster t10) (not (sends t10)) (not (hmastlock t10)) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10)  (hmaster t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (hmaster t10) (not (hmastlock t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t10) (and (not (hmaster t10)) (tok t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmaster t11) (hmastlock t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmaster t11) (hmastlock t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmaster t11) (not (sends t11)) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmastlock t11) (hmaster t11) (tok t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmastlock t11) (hmaster t11) (tok t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmaster t11) (not (sends t11)) (not (hmastlock t11)) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11)  (hmaster t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (hmaster t11) (not (hmastlock t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t11) (and (not (hmaster t11)) (tok t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmaster t12) (hmastlock t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmaster t12) (hmastlock t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmaster t12) (not (sends t12)) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmastlock t12) (hmaster t12) (tok t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmastlock t12) (hmaster t12) (tok t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmaster t12) (not (sends t12)) (not (hmastlock t12)) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12)  (hmaster t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (hmaster t12) (not (hmastlock t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t12) (and (not (hmaster t12)) (tok t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmaster t13) (hmastlock t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S20 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmaster t13) (hmastlock t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmaster t13) (not (sends t13)) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmastlock t13) (hmaster t13) (tok t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmastlock t13) (hmaster t13) (tok t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S19 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmaster t13) (not (sends t13)) (not (hmastlock t13)) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13)  (hmaster t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (hmaster t13) (not (hmastlock t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T4_S8 t13) (and (not (hmaster t13)) (tok t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T4_S8
(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_accept_all t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_accept_all
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t0) (and (not (hmaster t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T2_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t0) (and (not (hmaster t0)) (not (tok t0))) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) (laCl lq_T2_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t1) (and (not (hmaster t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T2_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t1) (and (not (hmaster t1)) (not (tok t1))) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) (laCl lq_T2_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t2) (and (not (hmaster t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T2_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t2) (and (not (hmaster t2)) (not (tok t2))) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) (laCl lq_T2_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t3) (and (not (hmaster t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T2_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t3) (and (not (hmaster t3)) (not (tok t3))) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) (laCl lq_T2_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t4) (and (not (hmaster t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T2_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t4) (and (not (hmaster t4)) (not (tok t4))) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) (laCl lq_T2_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t5) (and (not (hmaster t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T2_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t5) (and (not (hmaster t5)) (not (tok t5))) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) (laCl lq_T2_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t6) (and (not (hmaster t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T2_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t6) (and (not (hmaster t6)) (not (tok t6))) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) (laCl lq_T2_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t7) (and (not (hmaster t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T2_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t7) (and (not (hmaster t7)) (not (tok t7))) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) (laCl lq_T2_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t8) (and (not (hmaster t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T2_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t8) (and (not (hmaster t8)) (not (tok t8))) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) (laCl lq_T2_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t9) (and (not (hmaster t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T2_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t9) (and (not (hmaster t9)) (not (tok t9))) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) (laCl lq_T2_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t10) (and (not (hmaster t10)) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T2_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t10) (and (not (hmaster t10)) (not (tok t10))) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) (laCl lq_T2_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t11) (and (not (hmaster t11)) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T2_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t11) (and (not (hmaster t11)) (not (tok t11))) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) (laCl lq_T2_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t12) (and (not (hmaster t12)) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T2_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t12) (and (not (hmaster t12)) (not (tok t12))) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) (laCl lq_T2_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t13) (and (not (hmaster t13)) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T2_S10 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T2_S10 t13) (and (not (hmaster t13)) (not (tok t13))) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) (laCl lq_T2_S10 t13))) )))

; encoded spec state lq_T2_S10
(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (hmastlock t0)) (hmaster t0) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (hmastlock t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (sends t0)) (hmaster t0) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0)  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (not (hmaster t0)) (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (tok t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (hmastlock t1)) (hmaster t1) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (hmastlock t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (sends t1)) (hmaster t1) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1)  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (not (hmaster t1)) (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (tok t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (hmastlock t2)) (hmaster t2) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (hmastlock t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (sends t2)) (hmaster t2) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2)  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (not (hmaster t2)) (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (tok t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (hmastlock t3)) (hmaster t3) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (hmastlock t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (sends t3)) (hmaster t3) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3)  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (not (hmaster t3)) (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (tok t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (hmastlock t4)) (hmaster t4) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (hmastlock t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (sends t4)) (hmaster t4) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4)  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (not (hmaster t4)) (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (tok t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (hmastlock t5)) (hmaster t5) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (hmastlock t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (sends t5)) (hmaster t5) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5)  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (not (hmaster t5)) (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (tok t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (hmastlock t6)) (hmaster t6) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (hmastlock t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (sends t6)) (hmaster t6) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6)  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (not (hmaster t6)) (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (tok t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (hmastlock t7)) (hmaster t7) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (hmastlock t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (sends t7)) (hmaster t7) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7)  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (not (hmaster t7)) (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (tok t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (hmastlock t8)) (hmaster t8) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (hmastlock t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (sends t8)) (hmaster t8) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8)  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (not (hmaster t8)) (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (tok t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (hmastlock t9)) (hmaster t9) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (hmastlock t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (sends t9)) (hmaster t9) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9)  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (not (hmaster t9)) (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (tok t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (not (hmastlock t10)) (hmaster t10) (tok t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (not (hmastlock t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (hmastlock t10) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10)  (hmaster t10)  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (not (sends t10)) (hmaster t10) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10)  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (hmastlock t10) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (not (hmaster t10)) (tok t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (tok t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (not (hmastlock t11)) (hmaster t11) (tok t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (not (hmastlock t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (hmastlock t11) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11)  (hmaster t11)  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (not (sends t11)) (hmaster t11) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11)  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (hmastlock t11) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (not (hmaster t11)) (tok t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (tok t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (not (hmastlock t12)) (hmaster t12) (tok t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (not (hmastlock t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (hmastlock t12) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12)  (hmaster t12)  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (not (sends t12)) (hmaster t12) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12)  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (hmastlock t12) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (not (hmaster t12)) (tok t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (tok t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (not (hmastlock t13)) (hmaster t13) (tok t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (not (hmastlock t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (hmastlock t13) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau true true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13)  (hmaster t13)  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (not (sends t13)) (hmaster t13) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13)  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T4_S20 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (hmastlock t13) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T4_S20 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (not (hmaster t13)) (tok t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (tok t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_accept_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T4_S20 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_accept_S19 (tau false true false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T4_S20
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (hmastlock t0)) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (hmastlock t0) (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0)  (not (sends t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t0) (and (not (sends t0)) (hmaster t0)) (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S19 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (hmastlock t1)) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (hmastlock t1) (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1)  (not (sends t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t1) (and (not (sends t1)) (hmaster t1)) (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S19 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (hmastlock t2)) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (hmastlock t2) (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2)  (not (sends t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t2) (and (not (sends t2)) (hmaster t2)) (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S19 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (hmastlock t3)) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (hmastlock t3) (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3)  (not (sends t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t3) (and (not (sends t3)) (hmaster t3)) (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S19 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (hmastlock t4)) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (hmastlock t4) (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4)  (not (sends t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t4) (and (not (sends t4)) (hmaster t4)) (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S19 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (hmastlock t5)) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (hmastlock t5) (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5)  (not (sends t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t5) (and (not (sends t5)) (hmaster t5)) (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S19 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (hmastlock t6)) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (hmastlock t6) (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6)  (not (sends t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t6) (and (not (sends t6)) (hmaster t6)) (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S19 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (hmastlock t7)) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (hmastlock t7) (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7)  (not (sends t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t7) (and (not (sends t7)) (hmaster t7)) (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S19 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (hmastlock t8)) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (hmastlock t8) (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8)  (not (sends t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t8) (and (not (sends t8)) (hmaster t8)) (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S19 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (hmastlock t9)) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (hmastlock t9) (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9)  (not (sends t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t9) (and (not (sends t9)) (hmaster t9)) (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S19 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10)  (not (sends t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (not (hmastlock t10)) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (not (hmastlock t10)) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (hmastlock t10) (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10)  (not (sends t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t10) (and (not (sends t10)) (hmaster t10)) (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S19 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11)  (not (sends t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (not (hmastlock t11)) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (not (hmastlock t11)) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (hmastlock t11) (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11)  (not (sends t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t11) (and (not (sends t11)) (hmaster t11)) (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S19 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12)  (not (sends t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (not (hmastlock t12)) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (not (hmastlock t12)) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (hmastlock t12) (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12)  (not (sends t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t12) (and (not (sends t12)) (hmaster t12)) (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S19 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13)  (not (sends t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S19 (tau false true false ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S19 (tau false true false ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false false ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau true true false ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (not (hmastlock t13)) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true false ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (not (hmastlock t13)) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true false ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (hmastlock t13) (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau true true false ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13)  (not (sends t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (>= (laCl lq_T3_S19 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S19 t13) (and (not (sends t13)) (hmaster t13)) (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false false ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S19 t13))) )))

; encoded spec state lq_accept_S19
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmaster t10) (not (sends t10)) (not (hmastlock t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t10) (and (hmaster t10) (not (sends t10)) (not (hmastlock t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmaster t11) (not (sends t11)) (not (hmastlock t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t11) (and (hmaster t11) (not (sends t11)) (not (hmastlock t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmaster t12) (not (sends t12)) (not (hmastlock t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t12) (and (hmaster t12) (not (sends t12)) (not (hmastlock t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmaster t13) (not (sends t13)) (not (hmastlock t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S21 t13) (and (hmaster t13) (not (sends t13)) (not (hmastlock t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S21 t13))) )))

; encoded spec state lq_T1_S21
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t0)  (not (hmaster t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t0)) (laCl lq_T1_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t0) (and (not (hmaster t0)) (tok t0)) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t0) (and (not (hmaster t0)) (not (tok t0))) (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t0)) (laCl lq_T1_S10 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t1)  (not (hmaster t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t1)) (laCl lq_T1_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t1) (and (not (hmaster t1)) (tok t1)) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t1) (and (not (hmaster t1)) (not (tok t1))) (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t1)) (laCl lq_T1_S10 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t2)  (not (hmaster t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t2)) (laCl lq_T1_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t2) (and (not (hmaster t2)) (tok t2)) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t2) (and (not (hmaster t2)) (not (tok t2))) (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t2)) (laCl lq_T1_S10 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t3)  (not (hmaster t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t3)) (laCl lq_T1_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t3) (and (not (hmaster t3)) (tok t3)) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t3) (and (not (hmaster t3)) (not (tok t3))) (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t3)) (laCl lq_T1_S10 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t4)  (not (hmaster t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t4)) (laCl lq_T1_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t4) (and (not (hmaster t4)) (tok t4)) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t4) (and (not (hmaster t4)) (not (tok t4))) (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t4)) (laCl lq_T1_S10 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t5)  (not (hmaster t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t5)) (laCl lq_T1_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t5) (and (not (hmaster t5)) (tok t5)) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t5) (and (not (hmaster t5)) (not (tok t5))) (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t5)) (laCl lq_T1_S10 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t6)  (not (hmaster t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t6)) (laCl lq_T1_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t6) (and (not (hmaster t6)) (tok t6)) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t6) (and (not (hmaster t6)) (not (tok t6))) (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t6)) (laCl lq_T1_S10 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t7)  (not (hmaster t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t7)) (laCl lq_T1_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t7) (and (not (hmaster t7)) (tok t7)) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t7) (and (not (hmaster t7)) (not (tok t7))) (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t7)) (laCl lq_T1_S10 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t8)  (not (hmaster t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t8)) (laCl lq_T1_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t8) (and (not (hmaster t8)) (tok t8)) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t8) (and (not (hmaster t8)) (not (tok t8))) (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t8)) (laCl lq_T1_S10 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t9)  (not (hmaster t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t9)) (laCl lq_T1_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t9) (and (not (hmaster t9)) (tok t9)) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t9) (and (not (hmaster t9)) (not (tok t9))) (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t9)) (laCl lq_T1_S10 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t10)  (not (hmaster t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t10)) (laCl lq_T1_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t10) (and (not (hmaster t10)) (tok t10)) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t10) (and (not (hmaster t10)) (not (tok t10))) (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t10)) (laCl lq_T1_S10 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t11)  (not (hmaster t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t11)) (laCl lq_T1_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t11) (and (not (hmaster t11)) (tok t11)) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t11) (and (not (hmaster t11)) (not (tok t11))) (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t11)) (laCl lq_T1_S10 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t12)  (not (hmaster t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t12)) (laCl lq_T1_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t12) (and (not (hmaster t12)) (tok t12)) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t12) (and (not (hmaster t12)) (not (tok t12))) (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t12)) (laCl lq_T1_S10 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t13)  (not (hmaster t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 false ?prev_0 t13)) (laCl lq_T1_S10 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t13) (and (not (hmaster t13)) (tok t13)) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S10 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T1_S10 t13) (and (not (hmaster t13)) (not (tok t13))) (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (and (laBl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (>= (laCl lq_T2_S10 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 true ?prev_0 t13)) (laCl lq_T1_S10 t13))) )))

; encoded spec state lq_T1_S10
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (not (hmastlock t0)) (hgrant t0) (not (hmaster t0))) (not (and (tok t0) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (not (hmastlock t0)) (not (hgrant t0)) (not (hmaster t0))) (not (and (tok t0) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0)  (hmaster t0)  (not (and (tok t0) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (tok t0) (not (hmastlock t0)) (not (hmaster t0)) (not (hgrant t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t0) (and (hmastlock t0) (not (hmaster t0))) (not (and (tok t0) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (not (hmastlock t1)) (hgrant t1) (not (hmaster t1))) (not (and (tok t1) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (not (hmastlock t1)) (not (hgrant t1)) (not (hmaster t1))) (not (and (tok t1) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1)  (hmaster t1)  (not (and (tok t1) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (tok t1) (not (hmastlock t1)) (not (hmaster t1)) (not (hgrant t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t1) (and (hmastlock t1) (not (hmaster t1))) (not (and (tok t1) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (not (hmastlock t2)) (hgrant t2) (not (hmaster t2))) (not (and (tok t2) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (not (hmastlock t2)) (not (hgrant t2)) (not (hmaster t2))) (not (and (tok t2) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2)  (hmaster t2)  (not (and (tok t2) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (tok t2) (not (hmastlock t2)) (not (hmaster t2)) (not (hgrant t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t2) (and (hmastlock t2) (not (hmaster t2))) (not (and (tok t2) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (not (hmastlock t3)) (hgrant t3) (not (hmaster t3))) (not (and (tok t3) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (not (hmastlock t3)) (not (hgrant t3)) (not (hmaster t3))) (not (and (tok t3) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3)  (hmaster t3)  (not (and (tok t3) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (tok t3) (not (hmastlock t3)) (not (hmaster t3)) (not (hgrant t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t3) (and (hmastlock t3) (not (hmaster t3))) (not (and (tok t3) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (not (hmastlock t4)) (hgrant t4) (not (hmaster t4))) (not (and (tok t4) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (not (hmastlock t4)) (not (hgrant t4)) (not (hmaster t4))) (not (and (tok t4) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4)  (hmaster t4)  (not (and (tok t4) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (tok t4) (not (hmastlock t4)) (not (hmaster t4)) (not (hgrant t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t4) (and (hmastlock t4) (not (hmaster t4))) (not (and (tok t4) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (not (hmastlock t5)) (hgrant t5) (not (hmaster t5))) (not (and (tok t5) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (not (hmastlock t5)) (not (hgrant t5)) (not (hmaster t5))) (not (and (tok t5) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5)  (hmaster t5)  (not (and (tok t5) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (tok t5) (not (hmastlock t5)) (not (hmaster t5)) (not (hgrant t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t5) (and (hmastlock t5) (not (hmaster t5))) (not (and (tok t5) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (not (hmastlock t6)) (hgrant t6) (not (hmaster t6))) (not (and (tok t6) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (not (hmastlock t6)) (not (hgrant t6)) (not (hmaster t6))) (not (and (tok t6) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6)  (hmaster t6)  (not (and (tok t6) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (tok t6) (not (hmastlock t6)) (not (hmaster t6)) (not (hgrant t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t6) (and (hmastlock t6) (not (hmaster t6))) (not (and (tok t6) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (not (hmastlock t7)) (hgrant t7) (not (hmaster t7))) (not (and (tok t7) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (not (hmastlock t7)) (not (hgrant t7)) (not (hmaster t7))) (not (and (tok t7) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7)  (hmaster t7)  (not (and (tok t7) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (tok t7) (not (hmastlock t7)) (not (hmaster t7)) (not (hgrant t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t7) (and (hmastlock t7) (not (hmaster t7))) (not (and (tok t7) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (not (hmastlock t8)) (hgrant t8) (not (hmaster t8))) (not (and (tok t8) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (not (hmastlock t8)) (not (hgrant t8)) (not (hmaster t8))) (not (and (tok t8) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8)  (hmaster t8)  (not (and (tok t8) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (tok t8) (not (hmastlock t8)) (not (hmaster t8)) (not (hgrant t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t8) (and (hmastlock t8) (not (hmaster t8))) (not (and (tok t8) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (not (hmastlock t9)) (hgrant t9) (not (hmaster t9))) (not (and (tok t9) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (not (hmastlock t9)) (not (hgrant t9)) (not (hmaster t9))) (not (and (tok t9) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9)  (hmaster t9)  (not (and (tok t9) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (tok t9) (not (hmastlock t9)) (not (hmaster t9)) (not (hgrant t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t9) (and (hmastlock t9) (not (hmaster t9))) (not (and (tok t9) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t10) (and (not (hmastlock t10)) (hgrant t10) (not (hmaster t10))) (not (and (tok t10) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t10) (and (not (hmastlock t10)) (not (hgrant t10)) (not (hmaster t10))) (not (and (tok t10) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t10)  (hmaster t10)  (not (and (tok t10) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t10) (and (tok t10) (not (hmastlock t10)) (not (hmaster t10)) (not (hgrant t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t10) (and (hmastlock t10) (not (hmaster t10))) (not (and (tok t10) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t11) (and (not (hmastlock t11)) (hgrant t11) (not (hmaster t11))) (not (and (tok t11) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t11) (and (not (hmastlock t11)) (not (hgrant t11)) (not (hmaster t11))) (not (and (tok t11) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t11)  (hmaster t11)  (not (and (tok t11) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t11) (and (tok t11) (not (hmastlock t11)) (not (hmaster t11)) (not (hgrant t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t11) (and (hmastlock t11) (not (hmaster t11))) (not (and (tok t11) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t12) (and (not (hmastlock t12)) (hgrant t12) (not (hmaster t12))) (not (and (tok t12) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t12) (and (not (hmastlock t12)) (not (hgrant t12)) (not (hmaster t12))) (not (and (tok t12) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t12)  (hmaster t12)  (not (and (tok t12) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t12) (and (tok t12) (not (hmastlock t12)) (not (hmaster t12)) (not (hgrant t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t12) (and (hmastlock t12) (not (hmaster t12))) (not (and (tok t12) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t13) (and (not (hmastlock t13)) (hgrant t13) (not (hmaster t13))) (not (and (tok t13) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t13) (and (not (hmastlock t13)) (not (hgrant t13)) (not (hmaster t13))) (not (and (tok t13) ?prev_0)) (env_ass false false)) (and (laBl lq_T4_S8 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) (laBl lq_T6_S3 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) (laBl lq_T0_S9 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13))))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t13)  (hmaster t13)  (not (and (tok t13) ?prev_0)) (env_ass false false))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t13) (and (tok t13) (not (hmastlock t13)) (not (hmaster t13)) (not (hgrant t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass false false))  (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 false false false ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T0_init t13) (and (hmastlock t13) (not (hmaster t13))) (not (and (tok t13) ?prev_0)) (env_ass false false))   false  )))

; encoded spec state lq_T0_init
(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t0) (and (hmastlock t0) (start t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t1) (and (hmastlock t1) (start t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t2) (and (hmastlock t2) (start t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t3) (and (hmastlock t3) (start t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t4) (and (hmastlock t4) (start t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t5) (and (hmastlock t5) (start t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t6) (and (hmastlock t6) (start t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t7) (and (hmastlock t7) (start t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t8) (and (hmastlock t8) (start t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t9) (and (hmastlock t9) (start t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t10) (and (hmastlock t10) (start t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t11) (and (hmastlock t11) (start t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t12) (and (hmastlock t12) (start t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T10_S2 t13) (and (hmastlock t13) (start t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T10_S2 t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T10_S2 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T10_S2
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t10)  (start t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t11)  (start t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t12)  (start t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S27 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S29 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S27 t13)  (start t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S27
(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t0)  (not (hgrant t0))  (not (and (tok t0) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t1)  (not (hgrant t1))  (not (and (tok t1) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t2)  (not (hgrant t2))  (not (and (tok t2) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t3)  (not (hgrant t3))  (not (and (tok t3) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t4)  (not (hgrant t4))  (not (and (tok t4) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t5)  (not (hgrant t5))  (not (and (tok t5) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t6)  (not (hgrant t6))  (not (and (tok t6) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t7)  (not (hgrant t7))  (not (and (tok t7) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t8)  (not (hgrant t8))  (not (and (tok t8) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t9)  (not (hgrant t9))  (not (and (tok t9) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t10)  (not (hgrant t10))  (not (and (tok t10) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t11)  (not (hgrant t11))  (not (and (tok t11) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t12)  (not (hgrant t12))  (not (and (tok t12) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T9_S6 t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T9_S6 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T9_S6 t13)  (not (hgrant t13))  (not (and (tok t13) ?prev_0)) (env_ass false ?hlock_0))  (laBl lq_T8_S5 (tau ?hburst0_0 ?hburst1_0 false ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T9_S6
(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t0) (and (hmastlock t0) (start t0)) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t1) (and (hmastlock t1) (start t1)) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t2) (and (hmastlock t2) (start t2)) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t3) (and (hmastlock t3) (start t3)) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t4) (and (hmastlock t4) (start t4)) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t5) (and (hmastlock t5) (start t5)) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t6) (and (hmastlock t6) (start t6)) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t7) (and (hmastlock t7) (start t7)) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t8) (and (hmastlock t8) (start t8)) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t9) (and (hmastlock t9) (start t9)) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t10) (and (hmastlock t10) (start t10)) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t11) (and (hmastlock t11) (start t11)) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t12) (and (hmastlock t12) (start t12)) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hready_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T7_S4 t13) (and (hmastlock t13) (start t13)) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S23 (tau false true ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T7_S4 t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T7_S4 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) )))

; encoded spec state lq_T7_S4
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t10)  (start t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t11)  (start t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t12)  (start t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S25 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_T5_S25 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (laBl lq_T5_S27 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S25 t13)  (start t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S25
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t0)  (not (start t0))  (not (and (tok t0) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t0)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t0)  (start t0)  (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t1)  (not (start t1))  (not (and (tok t1) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t1)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t1)  (start t1)  (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t2)  (not (start t2))  (not (and (tok t2) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t2)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t2)  (start t2)  (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t3)  (not (start t3))  (not (and (tok t3) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t3)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t3)  (start t3)  (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t4)  (not (start t4))  (not (and (tok t4) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t4)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t4)  (start t4)  (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t5)  (not (start t5))  (not (and (tok t5) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t5)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t5)  (start t5)  (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t6)  (not (start t6))  (not (and (tok t6) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t6)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t6)  (start t6)  (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t7)  (not (start t7))  (not (and (tok t7) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t7)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t7)  (start t7)  (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t8)  (not (start t8))  (not (and (tok t8) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t8)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t8)  (start t8)  (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t9)  (not (start t9))  (not (and (tok t9) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t9)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t9)  (start t9)  (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t10)  (not (start t10))  (not (and (tok t10) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t10)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t10)  (start t10)  (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t11)  (not (start t11))  (not (and (tok t11) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t11)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t11)  (start t11)  (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t12)  (not (start t12))  (not (and (tok t12) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t12)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t12)  (start t12)  (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hready_0 Bool) (?hlock_0 Bool) (?prev_0 Bool)) (=> (and (laBl lq_T5_S23 t13)  (not (start t13))  (not (and (tok t13) ?prev_0)) (env_ass true ?hlock_0))  (laBl lq_T5_S23 (tau ?hburst0_0 ?hburst1_0 true ?hlock_0 ?hready_0 ?prev_0 t13)) )))

(assert (forall ((?hburst1_0 Bool) (?hlock_0 Bool) (?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hready_0 Bool)) (=> (and (laBl lq_T5_S23 t13)  (start t13)  (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))   false  )))

; encoded spec state lq_T5_S23
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmastlock t0) (hmaster t0) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (not (hmaster t0)) (not (sends t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t0) (and (hmaster t0) (not (sends t0)) (not (hmastlock t0))) (not (and (tok t0) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t0)) (laCl lq_accept_S21 t0))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmastlock t1) (hmaster t1) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (not (hmaster t1)) (not (sends t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t1) (and (hmaster t1) (not (sends t1)) (not (hmastlock t1))) (not (and (tok t1) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t1)) (laCl lq_accept_S21 t1))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmastlock t2) (hmaster t2) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (not (hmaster t2)) (not (sends t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t2) (and (hmaster t2) (not (sends t2)) (not (hmastlock t2))) (not (and (tok t2) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t2)) (laCl lq_accept_S21 t2))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmastlock t3) (hmaster t3) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (not (hmaster t3)) (not (sends t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t3) (and (hmaster t3) (not (sends t3)) (not (hmastlock t3))) (not (and (tok t3) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t3)) (laCl lq_accept_S21 t3))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmastlock t4) (hmaster t4) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (not (hmaster t4)) (not (sends t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t4) (and (hmaster t4) (not (sends t4)) (not (hmastlock t4))) (not (and (tok t4) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t4)) (laCl lq_accept_S21 t4))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmastlock t5) (hmaster t5) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (not (hmaster t5)) (not (sends t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t5) (and (hmaster t5) (not (sends t5)) (not (hmastlock t5))) (not (and (tok t5) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t5)) (laCl lq_accept_S21 t5))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmastlock t6) (hmaster t6) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (not (hmaster t6)) (not (sends t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t6) (and (hmaster t6) (not (sends t6)) (not (hmastlock t6))) (not (and (tok t6) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t6)) (laCl lq_accept_S21 t6))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmastlock t7) (hmaster t7) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (not (hmaster t7)) (not (sends t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t7) (and (hmaster t7) (not (sends t7)) (not (hmastlock t7))) (not (and (tok t7) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t7)) (laCl lq_accept_S21 t7))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmastlock t8) (hmaster t8) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (not (hmaster t8)) (not (sends t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t8) (and (hmaster t8) (not (sends t8)) (not (hmastlock t8))) (not (and (tok t8) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t8)) (laCl lq_accept_S21 t8))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmastlock t9) (hmaster t9) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (not (hmaster t9)) (not (sends t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t9) (and (hmaster t9) (not (sends t9)) (not (hmastlock t9))) (not (and (tok t9) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t9)) (laCl lq_accept_S21 t9))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmaster t10) (not (sends t10)) (not (hmastlock t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmastlock t10) (hmaster t10) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (not (hmaster t10)) (not (sends t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t10) (and (hmaster t10) (not (sends t10)) (not (hmastlock t10))) (not (and (tok t10) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t10)) (laCl lq_accept_S21 t10))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmaster t11) (not (sends t11)) (not (hmastlock t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmastlock t11) (hmaster t11) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (not (hmaster t11)) (not (sends t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t11) (and (hmaster t11) (not (sends t11)) (not (hmastlock t11))) (not (and (tok t11) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t11)) (laCl lq_accept_S21 t11))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmaster t12) (not (sends t12)) (not (hmastlock t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmastlock t12) (hmaster t12) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (not (hmaster t12)) (not (sends t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t12) (and (hmaster t12) (not (sends t12)) (not (hmastlock t12))) (not (and (tok t12) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t12)) (laCl lq_accept_S21 t12))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau true true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 false ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S19 (tau false true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau true true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmaster t13) (not (sends t13)) (not (hmastlock t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (> (laCl lq_accept_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmastlock t13) (hmaster t13) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (>= (laCl lq_T3_S19 (tau false true ?hbusreq_0 ?hlock_0 true ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (not (hmaster t13)) (not (sends t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

(assert (forall ((?hburst0_0 Bool) (?prev_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool)) (=> (and (laBl lq_accept_S21 t13) (and (hmaster t13) (not (sends t13)) (not (hmastlock t13))) (not (and (tok t13) ?prev_0)) (env_ass ?hbusreq_0 ?hlock_0))  (and (laBl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (>= (laCl lq_T1_S21 (tau ?hburst0_0 true ?hbusreq_0 ?hlock_0 false ?prev_0 t13)) (laCl lq_accept_S21 t13))) )))

; encoded spec state lq_accept_S21
(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t0) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (decide t0) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (hgrant t0) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (hmaster t0) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (hmastlock t0) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (locked t0) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (start t0) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)) (tok t0)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t1) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (decide t1) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (hgrant t1) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (hmaster t1) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (hmastlock t1) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (locked t1) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (start t1) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)) (tok t1)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t2) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (decide t2) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (hgrant t2) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (hmaster t2) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (hmastlock t2) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (locked t2) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (start t2) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)) (tok t2)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t3) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (decide t3) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (hgrant t3) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (hmaster t3) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (hmastlock t3) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (locked t3) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (start t3) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)) (tok t3)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t4) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (decide t4) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (hgrant t4) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (hmaster t4) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (hmastlock t4) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (locked t4) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (start t4) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)) (tok t4)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t5) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (decide t5) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (hgrant t5) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (hmaster t5) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (hmastlock t5) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (locked t5) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (start t5) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)) (tok t5)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t6) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (decide t6) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (hgrant t6) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (hmaster t6) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (hmastlock t6) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (locked t6) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (start t6) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)) (tok t6)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t7) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (decide t7) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (hgrant t7) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (hmaster t7) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (hmastlock t7) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (locked t7) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (start t7) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)) (tok t7)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t8) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (decide t8) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (hgrant t8) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (hmaster t8) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (hmastlock t8) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (locked t8) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (start t8) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)) (tok t8)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t9) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (decide t9) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (hgrant t9) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (hmaster t9) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (hmastlock t9) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (locked t9) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (start t9) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)) (tok t9)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t10) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (decide t10) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (hgrant t10) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (hmaster t10) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (hmastlock t10) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (locked t10) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (start t10) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)) (tok t10)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t11) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (decide t11) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (hgrant t11) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (hmaster t11) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (hmastlock t11) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (locked t11) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (start t11) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)) (tok t11)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t12) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (decide t12) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (hgrant t12) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (hmaster t12) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (hmastlock t12) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (locked t12) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (start t12) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)) (tok t12)))))

(assert (forall ((?hburst0_0 Bool) (?hburst1_0 Bool) (?hbusreq_0 Bool) (?hlock_0 Bool) (?hready_0 Bool) (?prev_0 Bool) (?hburst0Next_0 Bool) (?hburst1Next_0 Bool) (?hbusreqNext_0 Bool) (?hlockNext_0 Bool) (?hreadyNext_0 Bool) (?prevNext_0 Bool)) (=> (and (env_ass ?hbusreq_0 ?hlock_0) (env_ass ?hbusreqNext_0 ?hlockNext_0) (=> (tok t13) (not ?prev_0))) (sys_gua (decide (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (decide t13) (hgrant (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (hgrant t13) ?hlockNext_0 ?hlock_0 (hmaster (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (hmaster t13) (hmastlock (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (hmastlock t13) ?hreadyNext_0 ?hready_0 (locked (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (locked t13) (start (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (start t13) (tok (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t13)) (tok t13)))))

(define-fun tok_old ((state T)) Bool
(not (= state t0))
)
(define-fun tau_old ((x!1 Bool)
(x!2 Bool)
(x!3 Bool)
(x!4 Bool)
(x!5 Bool)
(x!6 Bool)
(x!7 T)) T
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t7
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t0))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t6
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t6
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t4
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t4
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t8
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t2
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t8
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t2
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t5
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t5
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t5
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t5
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t4
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t4
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t7
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t5
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t5
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t2
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t2
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t2
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t2
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t9
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t8
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t9
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t8
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t9
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t3
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t3
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t9
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t1))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t8
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t2
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t5
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t5
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t7
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t4
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t5
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t6))
t0
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t2
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t2
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t9
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t8
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t3
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t9
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t10
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t10
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t10
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t12
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t12
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t12
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t4
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t11
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t6
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t10
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t10
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t10
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 false)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t11
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t11
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t0))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t1))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t2))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t3))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t4))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t5))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t6))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t7))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t8))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t9))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t10))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t11))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 true)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 true)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 true)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 true)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 true)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
(ite (and (= x!1 false)
(= x!2 false)
(= x!3 false)
(= x!4 false)
(= x!5 false)
(= x!6 true)
(= x!7 t12))
t1
t1)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
(define-fun hmaster_old ((x!1 T)) Bool
(ite (= x!1 t0) false
(ite (= x!1 t1) false
(ite (= x!1 t2) true
(ite (= x!1 t3) true
(ite (= x!1 t4) false
(ite (= x!1 t5) true
(ite (= x!1 t6) false
(ite (= x!1 t7) true
(ite (= x!1 t8) true
(ite (= x!1 t9) true
(ite (= x!1 t10) true
(ite (= x!1 t11) false
(ite (= x!1 t12) true
true))))))))))))))
(define-fun start_old ((x!1 T)) Bool
(ite (= x!1 t0) false
(ite (= x!1 t1) true
(ite (= x!1 t2) false
(ite (= x!1 t3) false
(ite (= x!1 t4) false
(ite (= x!1 t5) false
(ite (= x!1 t6) false
(ite (= x!1 t7) true
(ite (= x!1 t8) false
(ite (= x!1 t9) false
(ite (= x!1 t10) false
(ite (= x!1 t11) false
(ite (= x!1 t12) true
false))))))))))))))
(define-fun hgrant_old ((x!1 T)) Bool
(ite (= x!1 t0) false
(ite (= x!1 t1) false
(ite (= x!1 t2) true
(ite (= x!1 t3) true
(ite (= x!1 t4) true
(ite (= x!1 t5) false
(ite (= x!1 t6) false
(ite (= x!1 t7) true
(ite (= x!1 t8) true
(ite (= x!1 t9) true
(ite (= x!1 t10) false
(ite (= x!1 t11) true
(ite (= x!1 t12) false
true))))))))))))))
(define-fun decide_old ((x!1 T)) Bool
(ite (= x!1 t1) false
(ite (= x!1 t2) false
(ite (= x!1 t3) true
(ite (= x!1 t4) false
(ite (= x!1 t5) false
(ite (= x!1 t6) false
(ite (= x!1 t7) false
(ite (= x!1 t8) false
(ite (= x!1 t9) false
(ite (= x!1 t10) true
(ite (= x!1 t11) true
(ite (= x!1 t12) false
(ite (= x!1 t0) true
false))))))))))))))
(define-fun hmastlock_old ((x!1 T)) Bool
(ite (= x!1 t0) false
(ite (= x!1 t1) false
(ite (= x!1 t2) true
(ite (= x!1 t3) true
(ite (= x!1 t4) false
(ite (= x!1 t5) true
(ite (= x!1 t6) false
(ite (= x!1 t7) true
(ite (= x!1 t8) true
(ite (= x!1 t9) true
(ite (= x!1 t10) false
(ite (= x!1 t11) false
(ite (= x!1 t12) false
false))))))))))))))
(define-fun sends_old ((x!1 T)) Bool
(ite (= x!1 t0) false
(ite (= x!1 t1) true
(ite (= x!1 t2) false
(ite (= x!1 t3) false
(ite (= x!1 t4) false
(ite (= x!1 t5) false
(ite (= x!1 t6) true
(ite (= x!1 t7) false
(ite (= x!1 t8) false
(ite (= x!1 t9) false
(ite (= x!1 t10) false
(ite (= x!1 t11) false
(ite (= x!1 t12) false
false))))))))))))))
(define-fun locked_old ((x!1 T)) Bool
(ite (= x!1 t1) false
(ite (= x!1 t0) false
(ite (= x!1 t2) true
(ite (= x!1 t8) true
(ite (= x!1 t3) true
(ite (= x!1 t5) false
(ite (= x!1 t4) true
(ite (= x!1 t7) true
(ite (= x!1 t6) false
(ite (= x!1 t9) true
(ite (= x!1 t10) false
(ite (= x!1 t11) false
(ite (= x!1 t12) false
false))))))))))))))
(define-fun prev0 ((_hburst0 Bool) (_hburst1 Bool) (_hbusreq Bool) (_hlock Bool) (_hready Bool)) Bool 
(and _hburst0 _hburst1)
)
(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t0)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t1)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t2)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t3)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t4)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t5)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t6)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t7)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t8)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t9)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t10)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t11)))))

(assert (forall ((?hlock_0 Bool) (?hready_0 Bool) (?hbusreq_0 Bool) (?prev_0 Bool) (?hburst0_0 Bool) (?hburst1_0 Bool)) (=> (prev0 ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0) (= (tau ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12) (tau_old ?hburst0_0 ?hburst1_0 ?hbusreq_0 ?hlock_0 ?hready_0 ?prev_0 t12)))))

(assert (and (= (tok_old t0) (tok t0)) (= (tok_old t1) (tok t1)) (= (tok_old t2) (tok t2)) (= (tok_old t3) (tok t3)) (= (tok_old t4) (tok t4)) (= (tok_old t5) (tok t5)) (= (tok_old t6) (tok t6)) (= (tok_old t7) (tok t7)) (= (tok_old t8) (tok t8)) (= (tok_old t9) (tok t9)) (= (tok_old t10) (tok t10)) (= (tok_old t11) (tok t11)) (= (tok_old t12) (tok t12))))

(assert (and (= (locked_old t0) (locked t0)) (= (locked_old t1) (locked t1)) (= (locked_old t2) (locked t2)) (= (locked_old t3) (locked t3)) (= (locked_old t4) (locked t4)) (= (locked_old t5) (locked t5)) (= (locked_old t6) (locked t6)) (= (locked_old t7) (locked t7)) (= (locked_old t8) (locked t8)) (= (locked_old t9) (locked t9)) (= (locked_old t10) (locked t10)) (= (locked_old t11) (locked t11)) (= (locked_old t12) (locked t12))))

(assert (and (= (hmastlock_old t0) (hmastlock t0)) (= (hmastlock_old t1) (hmastlock t1)) (= (hmastlock_old t2) (hmastlock t2)) (= (hmastlock_old t3) (hmastlock t3)) (= (hmastlock_old t4) (hmastlock t4)) (= (hmastlock_old t5) (hmastlock t5)) (= (hmastlock_old t6) (hmastlock t6)) (= (hmastlock_old t7) (hmastlock t7)) (= (hmastlock_old t8) (hmastlock t8)) (= (hmastlock_old t9) (hmastlock t9)) (= (hmastlock_old t10) (hmastlock t10)) (= (hmastlock_old t11) (hmastlock t11)) (= (hmastlock_old t12) (hmastlock t12))))

(assert (and (= (decide_old t0) (decide t0)) (= (decide_old t1) (decide t1)) (= (decide_old t2) (decide t2)) (= (decide_old t3) (decide t3)) (= (decide_old t4) (decide t4)) (= (decide_old t5) (decide t5)) (= (decide_old t6) (decide t6)) (= (decide_old t7) (decide t7)) (= (decide_old t8) (decide t8)) (= (decide_old t9) (decide t9)) (= (decide_old t10) (decide t10)) (= (decide_old t11) (decide t11)) (= (decide_old t12) (decide t12))))

(assert (and (= (hmaster_old t0) (hmaster t0)) (= (hmaster_old t1) (hmaster t1)) (= (hmaster_old t2) (hmaster t2)) (= (hmaster_old t3) (hmaster t3)) (= (hmaster_old t4) (hmaster t4)) (= (hmaster_old t5) (hmaster t5)) (= (hmaster_old t6) (hmaster t6)) (= (hmaster_old t7) (hmaster t7)) (= (hmaster_old t8) (hmaster t8)) (= (hmaster_old t9) (hmaster t9)) (= (hmaster_old t10) (hmaster t10)) (= (hmaster_old t11) (hmaster t11)) (= (hmaster_old t12) (hmaster t12))))

(assert (and (= (hgrant_old t0) (hgrant t0)) (= (hgrant_old t1) (hgrant t1)) (= (hgrant_old t2) (hgrant t2)) (= (hgrant_old t3) (hgrant t3)) (= (hgrant_old t4) (hgrant t4)) (= (hgrant_old t5) (hgrant t5)) (= (hgrant_old t6) (hgrant t6)) (= (hgrant_old t7) (hgrant t7)) (= (hgrant_old t8) (hgrant t8)) (= (hgrant_old t9) (hgrant t9)) (= (hgrant_old t10) (hgrant t10)) (= (hgrant_old t11) (hgrant t11)) (= (hgrant_old t12) (hgrant t12))))

(assert (and (= (start_old t0) (start t0)) (= (start_old t1) (start t1)) (= (start_old t2) (start t2)) (= (start_old t3) (start t3)) (= (start_old t4) (start t4)) (= (start_old t5) (start t5)) (= (start_old t6) (start t6)) (= (start_old t7) (start t7)) (= (start_old t8) (start t8)) (= (start_old t9) (start t9)) (= (start_old t10) (start t10)) (= (start_old t11) (start t11)) (= (start_old t12) (start t12))))

(assert (and (= (sends_old t0) (sends t0)) (= (sends_old t1) (sends t1)) (= (sends_old t2) (sends t2)) (= (sends_old t3) (sends t3)) (= (sends_old t4) (sends t4)) (= (sends_old t5) (sends t5)) (= (sends_old t6) (sends t6)) (= (sends_old t7) (sends t7)) (= (sends_old t8) (sends t8)) (= (sends_old t9) (sends t9)) (= (sends_old t10) (sends t10)) (= (sends_old t11) (sends t11)) (= (sends_old t12) (sends t12))))

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
(get-value ((tau true true true true true true t10)))
(get-value ((tau true true true true true true t11)))
(get-value ((tau true true true true true true t12)))
(get-value ((tau true true true true true true t13)))
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
(get-value ((tau true true true true true false t10)))
(get-value ((tau true true true true true false t11)))
(get-value ((tau true true true true true false t12)))
(get-value ((tau true true true true true false t13)))
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
(get-value ((tau true true true true false true t10)))
(get-value ((tau true true true true false true t11)))
(get-value ((tau true true true true false true t12)))
(get-value ((tau true true true true false true t13)))
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
(get-value ((tau true true true true false false t10)))
(get-value ((tau true true true true false false t11)))
(get-value ((tau true true true true false false t12)))
(get-value ((tau true true true true false false t13)))
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
(get-value ((tau true true true false true true t10)))
(get-value ((tau true true true false true true t11)))
(get-value ((tau true true true false true true t12)))
(get-value ((tau true true true false true true t13)))
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
(get-value ((tau true true true false true false t10)))
(get-value ((tau true true true false true false t11)))
(get-value ((tau true true true false true false t12)))
(get-value ((tau true true true false true false t13)))
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
(get-value ((tau true true true false false true t10)))
(get-value ((tau true true true false false true t11)))
(get-value ((tau true true true false false true t12)))
(get-value ((tau true true true false false true t13)))
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
(get-value ((tau true true true false false false t10)))
(get-value ((tau true true true false false false t11)))
(get-value ((tau true true true false false false t12)))
(get-value ((tau true true true false false false t13)))
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
(get-value ((tau true true false true true true t10)))
(get-value ((tau true true false true true true t11)))
(get-value ((tau true true false true true true t12)))
(get-value ((tau true true false true true true t13)))
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
(get-value ((tau true true false true true false t10)))
(get-value ((tau true true false true true false t11)))
(get-value ((tau true true false true true false t12)))
(get-value ((tau true true false true true false t13)))
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
(get-value ((tau true true false true false true t10)))
(get-value ((tau true true false true false true t11)))
(get-value ((tau true true false true false true t12)))
(get-value ((tau true true false true false true t13)))
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
(get-value ((tau true true false true false false t10)))
(get-value ((tau true true false true false false t11)))
(get-value ((tau true true false true false false t12)))
(get-value ((tau true true false true false false t13)))
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
(get-value ((tau true true false false true true t10)))
(get-value ((tau true true false false true true t11)))
(get-value ((tau true true false false true true t12)))
(get-value ((tau true true false false true true t13)))
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
(get-value ((tau true true false false true false t10)))
(get-value ((tau true true false false true false t11)))
(get-value ((tau true true false false true false t12)))
(get-value ((tau true true false false true false t13)))
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
(get-value ((tau true true false false false true t10)))
(get-value ((tau true true false false false true t11)))
(get-value ((tau true true false false false true t12)))
(get-value ((tau true true false false false true t13)))
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
(get-value ((tau true true false false false false t10)))
(get-value ((tau true true false false false false t11)))
(get-value ((tau true true false false false false t12)))
(get-value ((tau true true false false false false t13)))
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
(get-value ((tau true false true true true true t10)))
(get-value ((tau true false true true true true t11)))
(get-value ((tau true false true true true true t12)))
(get-value ((tau true false true true true true t13)))
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
(get-value ((tau true false true true true false t10)))
(get-value ((tau true false true true true false t11)))
(get-value ((tau true false true true true false t12)))
(get-value ((tau true false true true true false t13)))
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
(get-value ((tau true false true true false true t10)))
(get-value ((tau true false true true false true t11)))
(get-value ((tau true false true true false true t12)))
(get-value ((tau true false true true false true t13)))
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
(get-value ((tau true false true true false false t10)))
(get-value ((tau true false true true false false t11)))
(get-value ((tau true false true true false false t12)))
(get-value ((tau true false true true false false t13)))
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
(get-value ((tau true false true false true true t10)))
(get-value ((tau true false true false true true t11)))
(get-value ((tau true false true false true true t12)))
(get-value ((tau true false true false true true t13)))
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
(get-value ((tau true false true false true false t10)))
(get-value ((tau true false true false true false t11)))
(get-value ((tau true false true false true false t12)))
(get-value ((tau true false true false true false t13)))
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
(get-value ((tau true false true false false true t10)))
(get-value ((tau true false true false false true t11)))
(get-value ((tau true false true false false true t12)))
(get-value ((tau true false true false false true t13)))
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
(get-value ((tau true false true false false false t10)))
(get-value ((tau true false true false false false t11)))
(get-value ((tau true false true false false false t12)))
(get-value ((tau true false true false false false t13)))
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
(get-value ((tau true false false true true true t10)))
(get-value ((tau true false false true true true t11)))
(get-value ((tau true false false true true true t12)))
(get-value ((tau true false false true true true t13)))
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
(get-value ((tau true false false true true false t10)))
(get-value ((tau true false false true true false t11)))
(get-value ((tau true false false true true false t12)))
(get-value ((tau true false false true true false t13)))
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
(get-value ((tau true false false true false true t10)))
(get-value ((tau true false false true false true t11)))
(get-value ((tau true false false true false true t12)))
(get-value ((tau true false false true false true t13)))
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
(get-value ((tau true false false true false false t10)))
(get-value ((tau true false false true false false t11)))
(get-value ((tau true false false true false false t12)))
(get-value ((tau true false false true false false t13)))
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
(get-value ((tau true false false false true true t10)))
(get-value ((tau true false false false true true t11)))
(get-value ((tau true false false false true true t12)))
(get-value ((tau true false false false true true t13)))
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
(get-value ((tau true false false false true false t10)))
(get-value ((tau true false false false true false t11)))
(get-value ((tau true false false false true false t12)))
(get-value ((tau true false false false true false t13)))
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
(get-value ((tau true false false false false true t10)))
(get-value ((tau true false false false false true t11)))
(get-value ((tau true false false false false true t12)))
(get-value ((tau true false false false false true t13)))
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
(get-value ((tau true false false false false false t10)))
(get-value ((tau true false false false false false t11)))
(get-value ((tau true false false false false false t12)))
(get-value ((tau true false false false false false t13)))
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
(get-value ((tau false true true true true true t10)))
(get-value ((tau false true true true true true t11)))
(get-value ((tau false true true true true true t12)))
(get-value ((tau false true true true true true t13)))
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
(get-value ((tau false true true true true false t10)))
(get-value ((tau false true true true true false t11)))
(get-value ((tau false true true true true false t12)))
(get-value ((tau false true true true true false t13)))
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
(get-value ((tau false true true true false true t10)))
(get-value ((tau false true true true false true t11)))
(get-value ((tau false true true true false true t12)))
(get-value ((tau false true true true false true t13)))
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
(get-value ((tau false true true true false false t10)))
(get-value ((tau false true true true false false t11)))
(get-value ((tau false true true true false false t12)))
(get-value ((tau false true true true false false t13)))
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
(get-value ((tau false true true false true true t10)))
(get-value ((tau false true true false true true t11)))
(get-value ((tau false true true false true true t12)))
(get-value ((tau false true true false true true t13)))
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
(get-value ((tau false true true false true false t10)))
(get-value ((tau false true true false true false t11)))
(get-value ((tau false true true false true false t12)))
(get-value ((tau false true true false true false t13)))
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
(get-value ((tau false true true false false true t10)))
(get-value ((tau false true true false false true t11)))
(get-value ((tau false true true false false true t12)))
(get-value ((tau false true true false false true t13)))
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
(get-value ((tau false true true false false false t10)))
(get-value ((tau false true true false false false t11)))
(get-value ((tau false true true false false false t12)))
(get-value ((tau false true true false false false t13)))
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
(get-value ((tau false true false true true true t10)))
(get-value ((tau false true false true true true t11)))
(get-value ((tau false true false true true true t12)))
(get-value ((tau false true false true true true t13)))
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
(get-value ((tau false true false true true false t10)))
(get-value ((tau false true false true true false t11)))
(get-value ((tau false true false true true false t12)))
(get-value ((tau false true false true true false t13)))
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
(get-value ((tau false true false true false true t10)))
(get-value ((tau false true false true false true t11)))
(get-value ((tau false true false true false true t12)))
(get-value ((tau false true false true false true t13)))
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
(get-value ((tau false true false true false false t10)))
(get-value ((tau false true false true false false t11)))
(get-value ((tau false true false true false false t12)))
(get-value ((tau false true false true false false t13)))
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
(get-value ((tau false true false false true true t10)))
(get-value ((tau false true false false true true t11)))
(get-value ((tau false true false false true true t12)))
(get-value ((tau false true false false true true t13)))
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
(get-value ((tau false true false false true false t10)))
(get-value ((tau false true false false true false t11)))
(get-value ((tau false true false false true false t12)))
(get-value ((tau false true false false true false t13)))
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
(get-value ((tau false true false false false true t10)))
(get-value ((tau false true false false false true t11)))
(get-value ((tau false true false false false true t12)))
(get-value ((tau false true false false false true t13)))
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
(get-value ((tau false true false false false false t10)))
(get-value ((tau false true false false false false t11)))
(get-value ((tau false true false false false false t12)))
(get-value ((tau false true false false false false t13)))
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
(get-value ((tau false false true true true true t10)))
(get-value ((tau false false true true true true t11)))
(get-value ((tau false false true true true true t12)))
(get-value ((tau false false true true true true t13)))
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
(get-value ((tau false false true true true false t10)))
(get-value ((tau false false true true true false t11)))
(get-value ((tau false false true true true false t12)))
(get-value ((tau false false true true true false t13)))
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
(get-value ((tau false false true true false true t10)))
(get-value ((tau false false true true false true t11)))
(get-value ((tau false false true true false true t12)))
(get-value ((tau false false true true false true t13)))
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
(get-value ((tau false false true true false false t10)))
(get-value ((tau false false true true false false t11)))
(get-value ((tau false false true true false false t12)))
(get-value ((tau false false true true false false t13)))
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
(get-value ((tau false false true false true true t10)))
(get-value ((tau false false true false true true t11)))
(get-value ((tau false false true false true true t12)))
(get-value ((tau false false true false true true t13)))
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
(get-value ((tau false false true false true false t10)))
(get-value ((tau false false true false true false t11)))
(get-value ((tau false false true false true false t12)))
(get-value ((tau false false true false true false t13)))
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
(get-value ((tau false false true false false true t10)))
(get-value ((tau false false true false false true t11)))
(get-value ((tau false false true false false true t12)))
(get-value ((tau false false true false false true t13)))
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
(get-value ((tau false false true false false false t10)))
(get-value ((tau false false true false false false t11)))
(get-value ((tau false false true false false false t12)))
(get-value ((tau false false true false false false t13)))
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
(get-value ((tau false false false true true true t10)))
(get-value ((tau false false false true true true t11)))
(get-value ((tau false false false true true true t12)))
(get-value ((tau false false false true true true t13)))
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
(get-value ((tau false false false true true false t10)))
(get-value ((tau false false false true true false t11)))
(get-value ((tau false false false true true false t12)))
(get-value ((tau false false false true true false t13)))
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
(get-value ((tau false false false true false true t10)))
(get-value ((tau false false false true false true t11)))
(get-value ((tau false false false true false true t12)))
(get-value ((tau false false false true false true t13)))
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
(get-value ((tau false false false true false false t10)))
(get-value ((tau false false false true false false t11)))
(get-value ((tau false false false true false false t12)))
(get-value ((tau false false false true false false t13)))
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
(get-value ((tau false false false false true true t10)))
(get-value ((tau false false false false true true t11)))
(get-value ((tau false false false false true true t12)))
(get-value ((tau false false false false true true t13)))
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
(get-value ((tau false false false false true false t10)))
(get-value ((tau false false false false true false t11)))
(get-value ((tau false false false false true false t12)))
(get-value ((tau false false false false true false t13)))
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
(get-value ((tau false false false false false true t10)))
(get-value ((tau false false false false false true t11)))
(get-value ((tau false false false false false true t12)))
(get-value ((tau false false false false false true t13)))
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
(get-value ((tau false false false false false false t10)))
(get-value ((tau false false false false false false t11)))
(get-value ((tau false false false false false false t12)))
(get-value ((tau false false false false false false t13)))
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
(get-value ((locked t10)))
(get-value ((locked t11)))
(get-value ((locked t12)))
(get-value ((locked t13)))
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
(get-value ((start t10)))
(get-value ((start t11)))
(get-value ((start t12)))
(get-value ((start t13)))
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
(get-value ((sends t10)))
(get-value ((sends t11)))
(get-value ((sends t12)))
(get-value ((sends t13)))
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
(get-value ((hgrant t10)))
(get-value ((hgrant t11)))
(get-value ((hgrant t12)))
(get-value ((hgrant t13)))
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
(get-value ((hmaster t10)))
(get-value ((hmaster t11)))
(get-value ((hmaster t12)))
(get-value ((hmaster t13)))
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
(get-value ((tok t10)))
(get-value ((tok t11)))
(get-value ((tok t12)))
(get-value ((tok t13)))
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
(get-value ((decide t10)))
(get-value ((decide t11)))
(get-value ((decide t12)))
(get-value ((decide t13)))
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
(get-value ((hmastlock t10)))
(get-value ((hmastlock t11)))
(get-value ((hmastlock t12)))
(get-value ((hmastlock t13)))
(exit)
