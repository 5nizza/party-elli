//Note that the DBW for G7 works only for two receivers.
module DBW7(stateG7_1_n, stateG7_0_n, stateG7_1_p, stateG7_0_p, b_to_r_req0_p, b_to_r_req1_p);
	input  stateG7_1_p, stateG7_0_p, b_to_r_req0_p, b_to_r_req1_p;
	output stateG7_1_n, stateG7_0_n;
	wire    stateG7_1_p, stateG7_0_p, b_to_r_req0_p, b_to_r_req1_p;
	wire    stateG7_1_n, stateG7_0_n;

	assign  stateG7_1_n = (!stateG7_1_p && !b_to_r_req0_p &&  b_to_r_req1_p)||
	                      ( stateG7_1_p && !b_to_r_req0_p && !b_to_r_req1_p)||
	                      ( stateG7_1_p && !stateG7_0_p && !b_to_r_req0_p && b_to_r_req1_p);
	assign  stateG7_0_n = (!stateG7_1_p && !b_to_r_req0_p && !b_to_r_req1_p);
endmodule
module DBW12(stateG12_n, stateG12_p, empty_p, deq_p);
	input  stateG12_p, empty_p, deq_p;
	output stateG12_n;
	wire    stateG12_n, stateG12_p, empty_p, deq_p;

	assign  stateG12_n = (!stateG12_p && !deq_p && !empty_p)||
	                     ( stateG12_p && !deq_p);
endmodule
