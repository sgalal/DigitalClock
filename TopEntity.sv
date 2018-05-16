/// @param clk100khz System clock 100 kHz
/// @param mode_set_o Raw Mode Set Button signal
/// @param inc_o Raw Increase Button signal
/// @param dec_o Raw Decrease Button signal
/// @param scan The digitron to scan. Encoded in one hot
/// @param dout Scan data of digitron
module TopEntity
(
	input clk100khz,
	input mode_set_o,
	input inc_o,
	input dec_o,
	output wire [5: 0] scan,
	output wire [7: 0] dout
);

	wire mode_set, inc, dec;
	wire [3: 0] msb_h, lsb_h, msb_m, lsb_m, msb_s, lsb_s;
	wire [3: 0] digits[6];
	wire [1: 0] mode_flag;

	assign digits = '{msb_h, lsb_h, msb_m, lsb_m, msb_s, lsb_s};

	KeyFilter keyFilter(.*);
	CounterGrp CounterGrp(.*);
	LedOutput ledOutput(.*);

endmodule: TopEntity
