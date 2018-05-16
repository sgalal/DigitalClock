/// @param clk100khz System clock 100 kHz
/// @param digits Value of the 6 digits
/// @param mode_flag Current mode. Including 4 states, normal mode,
/// setting second, setting minute, setting hour
/// @param scan The digitron to scan. Encoded in one hot
/// @param dout Scan data of digitron
module LedOutput
(
	input clk100khz,
	input [3: 0] digits[6],
	input [1: 0] mode_flag,
	output wire [5: 0] scan,
	output wire [7: 0] dout
);

	localparam bit [7: 0] led_num[10] =
	'{
		8'b00111111, 8'b00000110, 8'b01011011, 8'b01001111,  /* 0-3 */
		8'b01100110, 8'b01101101, 8'b01111101, 8'b00000111,  /* 4-7 */
		8'b01111111, 8'b01101111                             /* 8-9 */
	};

	reg [2: 0] led_choice = 0;
	reg [36: 0] state_cnt = 0;

	enum bit [1: 0] {SHOW_0, SHOW_1, HIDE} state = SHOW_0;

	wire [7: 0] rawDigit = led_num[digits[led_choice]];
	wire shouldPutDot = led_choice == 3'd1 || led_choice == 3'd3;
	wire shouldHideDigit = state == HIDE && mode_flag == ~led_choice[2: 1];
	wire [7: 0] hidedDigit = shouldHideDigit ? 8'b0 : rawDigit;

	assign scan = 6'h20 >> led_choice;
	assign dout = shouldPutDot ? hidedDigit | 8'h80 /* output dot */ : hidedDigit;

	always@(posedge clk100khz)
	begin
		if(state_cnt == 37'd33333)  // 6 Hz
		begin
			state <=
				state == SHOW_0 ? SHOW_1 :
				state == SHOW_1 ? HIDE :
				SHOW_0;
			state_cnt <= 0;
		end
		else
			state_cnt <= state_cnt + 1'b1;

		led_choice <= led_choice == 3'd5 ? 3'b0 : led_choice + 1'b1;
	end

endmodule: LedOutput
