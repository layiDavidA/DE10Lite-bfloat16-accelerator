module nr_unit(
input clk,
input reset,
input [15:0] x,
input [1:0] key,

output reg [31:0] arg_q,
input [31:0] recip_seed,
input [31:0] rsqrt_seed,

output reg [31:0] out_mant_q,
output reg signed [9:0] final_exp,
output reg done
);
	
 //pipelined_qmul uut8 (.clk(clk), .a(qmul_a), .b(qmul_b), .qmul(qmul));



localparam [31:0] ONE_Q = 32'd65536; // 1.0 in Q16.16 fixed-point (1 * 2^16)
localparam [31:0] TWO_Q = 32'd131072; // 2.0 in Q16.16 fixed-point (2 * 2^16)
localparam [31:0] THREE_Q = 32'd196608; // 3.0 in Q16.16 fixed-point (3 * 2^16)
localparam [3:0] IDLE = 4'd0;
localparam [3:0] UNPACK = 4'd1;
localparam [3:0] PREP = 4'd2;
localparam [3:0] SEED = 4'd3;
//localparam [3:0] ITER1 = 4'd4;
//localparam [3:0] ITER2 = 4'd7;
localparam [3:0] FINAL = 4'd10;
localparam [3:0] DONE_S = 4'd11;
localparam [3:0] ITER1_A = 4'd4;
localparam [3:0] ITER1_B = 4'd5;
localparam [3:0] ITER1_C = 4'd6;
localparam [3:0] ITER2_A = 4'd7;
localparam [3:0] ITER2_B = 4'd8;
localparam [3:0] ITER2_C = 4'd9;
localparam [3:0] SEED_WAIT = 4'd12;		



reg [31:0] state1_reg;
reg [31:0] state2_reg;
//reg [31:0] qmul_a;
//reg [31:0] qmul_b;
//wire [31:0] qmul;




reg [3:0] state;
reg [15:0] x_reg;
reg op_sqrt;
reg op_rsqrt;
reg signed [9:0] exp_in;
reg signed [9:0] exp_work;
reg [31:0] mant_q;
reg [31:0] seed_q;
reg [31:0] y_q;
reg [31:0] term_q;
reg [31:0] factor_q;
reg [31:0] y_sq_q;


function [31:0] qmul;
	input [31:0] a;
	input [31:0] b;
	reg [63:0] prod, prod_lsb;
	begin
		// multiply
		prod = a * b;
		
		
		
		// round
		prod_lsb = prod + 32'h8000; // add half LSB
		
		
		
		
		qmul = prod_lsb[47:16]; // truncate
	end
endfunction

always @(posedge clk or negedge reset) begin // do negedge reset
	if (!reset) begin
		state <= IDLE;
		x_reg <= 16'd0;
		op_sqrt <= 1'b0;
		exp_in <= 10'sd0;
		exp_work <= 10'sd0;
		mant_q <= 32'd0;
		arg_q <= 32'd0;
		seed_q <= 32'd0;
		y_q <= 32'd0;
		done <= 1'b0;
		out_mant_q <= 32'd0;
		final_exp <= 10'd0;

	end else begin
		done <= 1'b0;
		
		
case (state)
	IDLE: begin
		if ((key == 2'b01) || (key == 2'b10) || (key == 2'b11)) begin
			x_reg <= x;
			op_sqrt <= (key == 2'b01);
			op_rsqrt <= (key == 2'b11);
			state <= UNPACK;
		end
	end
	
UNPACK: begin
exp_in <=  x_reg [14:7] - 127;
mant_q <= {15'd0, 1'b1, x_reg[6:0], 9'd0};
state <= PREP;
// set exp_in and mant_q
end

PREP: begin
if (op_sqrt || op_rsqrt) begin
	if ( (exp_in[0] ) == 1'b1) begin //  exp_in[0]
	exp_work <= exp_in - 1;
	arg_q <= mant_q << 1;
	end

	else begin
	arg_q <= mant_q;
	exp_work <= exp_in;
	end 
end

else if ( key == 2'b10) begin
arg_q <= mant_q;
exp_work <= -exp_in;
end

state <= SEED_WAIT;
end
// set arg_q and exp_work


SEED_WAIT: begin
 state <= SEED;
end


SEED: begin
if (op_sqrt || op_rsqrt) begin
seed_q <= rsqrt_seed;
state <= ITER1_A;
end else begin
seed_q <= recip_seed;
state <= ITER1_A; //
// set seed_q
end
end


ITER1_A: begin
if (op_sqrt || op_rsqrt) begin
state1_reg <= qmul(seed_q, seed_q);
state   <= ITER1_B;
end else begin
state1_reg <= qmul(arg_q, seed_q);
 state <= ITER1_C;
 end
 end
 

ITER1_B: begin
state2_reg <= qmul(arg_q, state1_reg);
state      <= ITER1_C;
end

ITER1_C: begin
if (op_sqrt || op_rsqrt) begin
y_q   <= qmul(seed_q, (THREE_Q - state2_reg)) >> 1;
end else begin
y_q   <= qmul(seed_q, (TWO_Q - state1_reg));
end
state <= ITER2_A;
end

 

 

 ITER2_A: begin
if (op_sqrt || op_rsqrt) begin
 state1_reg <= qmul(y_q, y_q); // Reciprocal square root:
 state <= ITER2_B;
 
 end else begin
 state1_reg <= qmul(arg_q, y_q);
  state <= ITER2_C;
 end
 end
 
 ITER2_B: begin
 state2_reg <= qmul(arg_q, state1_reg); // Reciprocal square root:
 state <= ITER2_C;
 end
 
 ITER2_C: begin
if (op_sqrt || op_rsqrt) begin
 y_q <= qmul(y_q, (THREE_Q - state2_reg)) >> 1; // Reciprocal square root:
 
 if (op_sqrt)
exp_work <= exp_work >>1;
else
 exp_work <= -(exp_work >>1);
 
 
 end else begin
 y_q <= qmul(y_q, (TWO_Q - state1_reg));
 end
  state <= FINAL;
 end 

FINAL: begin
// For square root: multiply argument by reciprocal square root estimate
// For reciprocal: conditionally normalize mantissa if it falls below 1.0 .  // For both: output out_mant_q and final_exp for pack_bfloat16 module
if (op_sqrt) 
 y_q = qmul(arg_q, y_q); // Reciprocal square root: c=arg_q y2= y_q

 if(op_rsqrt)
 out_mant_q = y_q;

 

 
 

if (y_q [31:16] != 16'd0) begin
out_mant_q <= y_q;
final_exp <= exp_work;
state <= DONE_S;
end else begin
y_q <= y_q << 1;
exp_work <= exp_work - 1;
state <= FINAL;

end

end

DONE_S: begin
done <= 1'b1;
state <= IDLE;
end

default: begin
state <= IDLE;
end
endcase


end
end
endmodule