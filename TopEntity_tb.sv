`timescale 1us/100ns

module TopEntity_tb();

	reg clk100khz = 0;
	reg mode_set_o = 1;
	reg inc_o = 1;
	reg dec_o = 1;

	wire [5: 0] scan;
	wire [7: 0] dout;

	TopEntity topEntity(.*);

	always
		#5 clk100khz = ~clk100khz;

endmodule: TopEntity_tb
