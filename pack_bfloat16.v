module pack_bfloat16 ( input [7:0] exp_unbiased, input [31:0] mantissa_q, output [15:0] packed_out);

wire [32:0] prod_mantissa;
wire [6:0] mant;
wire [7:0] temp;
assign temp = 8'd127 + exp_unbiased;

 assign prod_mantissa = mantissa_q + 32'h0100;
 assign mant = prod_mantissa[15:9];


assign packed_out = {1'b0, temp , mant};

endmodule

	


