module rsqrt_rom (

  input [31:0] in_q,

  output reg [31:0] rsqrt_seed

);



localparam [31:0] ONE_Q = 32'd65536;

localparam [31:0] TWO_Q = 32'd131072;

localparam [31:0] THREE_Q = 32'd196608;



wire [4:0] rsqrt_idx;

assign rsqrt_idx = ((in_q - ONE_Q) >> 11) / 3;



always @ (rsqrt_idx) begin

  case (rsqrt_idx)

    5'd0: rsqrt_seed = 32'd64052;

    5'd1: rsqrt_seed = 32'd61363;

    5'd2: rsqrt_seed = 32'd58987;

    5'd3: rsqrt_seed = 32'd56867;

    5'd4: rsqrt_seed = 32'd54960;

    5'd5: rsqrt_seed = 32'd53233;

    5'd6: rsqrt_seed = 32'd51660;

    5'd7: rsqrt_seed = 32'd50218;

    5'd8: rsqrt_seed = 32'd48890;

    5'd9: rsqrt_seed = 32'd47663;

    5'd10: rsqrt_seed = 32'd46523;

    5'd11: rsqrt_seed = 32'd45462;

    5'd12: rsqrt_seed = 32'd44470;

    5'd13: rsqrt_seed = 32'd43540;

    5'd14: rsqrt_seed = 32'd42666;

    5'd15: rsqrt_seed = 32'd41843;

    5'd16: rsqrt_seed = 32'd41065;

    5'd17: rsqrt_seed = 32'd40330;

    5'd18: rsqrt_seed = 32'd39632;

    5'd19: rsqrt_seed = 32'd38970;

    5'd20: rsqrt_seed = 32'd38340;

    5'd21: rsqrt_seed = 32'd37739;

    5'd22: rsqrt_seed = 32'd37166;

    5'd23: rsqrt_seed = 32'd36618;

    5'd24: rsqrt_seed = 32'd36093;

    5'd25: rsqrt_seed = 32'd35591;

    5'd26: rsqrt_seed = 32'd35109;

    5'd27: rsqrt_seed = 32'd34646;

    5'd28: rsqrt_seed = 32'd34201;

    5'd29: rsqrt_seed = 32'd33772;

    5'd30: rsqrt_seed = 32'd33360;

    5'd31: rsqrt_seed = 32'd32962;

    default: rsqrt_seed = 32'd32962;

  endcase

end

endmodule
