module CounterGrp
(
	input clk100khz,
	input mode_set,
	input inc,
	input dec,
	output [3: 0] msb_h,
	output [3: 0] lsb_h,
	output [3: 0] msb_m,
	output [3: 0] lsb_m,
	output [3: 0] msb_s,
	output [3: 0] lsb_s,
	output reg [1: 0] mode_flag
);

	initial
		mode_flag = 0;

	reg clk1hz = 0;
	reg [15: 0] clk1hz_cnt = 0;

	wire c_m, c_s;
	wire inc_h_real = (mode_flag == 2'd3 && ~inc) | c_m;
	wire inc_m_real = (mode_flag == 2'd2 && ~inc) | c_s;
	wire inc_s_real = (mode_flag == 2'd1 && ~inc) | clk1hz;
	wire dec_h_real = mode_flag == 2'd3 && ~dec;
	wire dec_m_real = mode_flag == 2'd2 && ~dec;
	wire dec_s_real = mode_flag == 2'd1 && ~dec;

	Counter #(.max_num(23)) ch(.*, .inc(inc_h_real), .dec(dec_h_real), .msb(msb_h), .lsb(lsb_h), .c());
	Counter #(.max_num(59)) cm(.*, .inc(inc_m_real), .dec(dec_m_real), .msb(msb_m), .lsb(lsb_m), .c(c_m));
	Counter #(.max_num(59)) cs(.*, .inc(inc_s_real), .dec(dec_s_real), .msb(msb_s), .lsb(lsb_s), .c(c_s));

	always@(posedge clk100khz)
		if(clk1hz_cnt == 16'd50000)
		begin
			clk1hz_cnt <= 0;
			clk1hz <= ~clk1hz;
		end
		else
			clk1hz_cnt <= clk1hz_cnt + 1'b1;

	always@(negedge mode_set)
		mode_flag <= mode_flag + 1'b1;

endmodule: CounterGrp

module Counter
	#(parameter int max_num)
(
	input clk100khz,
	input inc,
	input dec,
	output reg [3: 0] msb,
	output reg [3: 0] lsb,
	output reg c
);

	parameter [3: 0] max_msb = 4'(max_num / 10);
	parameter [3: 0] max_lsb = 4'(max_num % 10);

	initial
	begin
		msb = 0;
		lsb = 0;
		c = 0;
	end

	reg inc_pre = 0;
	reg dec_pre = 0;

	always@(posedge clk100khz)
	begin
		if(inc && !inc_pre)  // posedge inc
		begin
			if(msb == max_msb && lsb == max_lsb)
			begin
				msb <= 0;
				lsb <= 0;
				c <= 1;
			end
			else if(lsb == 4'd9)
			begin
				lsb <= 0;
				msb <= msb + 1'b1;
				c <= 0;
			end
			else
			begin
				lsb <= lsb + 1'b1;
				c <= 0;
			end
		end
		else if(dec && !dec_pre)  // posedge dec
		begin
			if(msb == 4'b0 && lsb == 4'b0)
			begin
				msb <= max_msb;
				lsb <= max_lsb;
			end
			else if(lsb == 4'b0)
			begin
				msb <= msb - 1'b1;
				lsb <= 4'd9;
			end
			else
				lsb <= lsb - 1'b1;
			c <= 0;
		end

		inc_pre <= inc;
		dec_pre <= dec;
	end

endmodule: Counter
