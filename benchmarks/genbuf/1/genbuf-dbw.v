//Note that the DBW for G7 works only for two receivers.
module DBW7(stateG7_1_n, stateG7_0_n, stateG7_1_p, stateG7_0_p, BtoR_REQ0_p, BtoR_REQ1_p);
	input  stateG7_1_p, stateG7_0_p, BtoR_REQ0_p, BtoR_REQ1_p;
	output stateG7_1_n, stateG7_0_n;
	wire    stateG7_1_p, stateG7_0_p, BtoR_REQ0_p, BtoR_REQ1_p;
	wire    stateG7_1_n, stateG7_0_n;

	assign  stateG7_1_n = (!stateG7_1_p && !BtoR_REQ0_p &&  BtoR_REQ1_p)||
	                      ( stateG7_1_p && !BtoR_REQ0_p && !BtoR_REQ1_p)||
	                      ( stateG7_1_p && !stateG7_0_p && !BtoR_REQ0_p && BtoR_REQ1_p);
	assign  stateG7_0_n = (!stateG7_1_p && !BtoR_REQ0_p && !BtoR_REQ1_p);
endmodule
module DBW12(stateG12_n, stateG12_p, EMPTY_p, DEQ_p);
	input  stateG12_p, EMPTY_p, DEQ_p;
	output stateG12_n;
	wire    stateG12_n, stateG12_p, EMPTY_p, DEQ_p;

	assign  stateG12_n = (!stateG12_p && !DEQ_p && !EMPTY_p)||
	                     ( stateG12_p && !DEQ_p);
endmodule
