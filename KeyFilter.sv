/// @param clk100khz System clock 100 kHz
/// @param mode_set_o Raw Mode Set Button signal
/// @param inc_o Raw Increase Button signal
/// @param dec_o Raw Decrease Button signal
/// @param mode_set Mode Set Button
/// @param inc Increase Button
/// @param dec Decrease Button
module KeyFilter
(
	input clk100khz,
	input mode_set_o,
	input inc_o,
	input dec_o,
	output reg mode_set,
	output reg inc,
	output reg dec
);

	initial begin
		mode_set = 1;
		inc = 1;
		dec = 1;
	end

	reg mode_set_buff = 1;
	reg inc_buff = 1;
	reg dec_buff = 1;
	reg [8: 0] clk100hz_cnt = 0;

	always@(posedge clk100khz)
	begin
		if(clk100hz_cnt == 9'd500)
		begin
			clk100hz_cnt <= 0;

			mode_set <= mode_set_buff;
			inc <= inc_buff;
			dec <= dec_buff;

			mode_set_buff <= 1;
			inc_buff <= 1;
			dec_buff <= 1;
		end
		else
		begin
			clk100hz_cnt <= clk100hz_cnt + 1'b1;

			mode_set_buff <= mode_set_buff & mode_set_o;
			inc_buff <= inc_buff & inc_o;
			dec_buff <= dec_buff & dec_o;
		end
	end

endmodule: KeyFilter
