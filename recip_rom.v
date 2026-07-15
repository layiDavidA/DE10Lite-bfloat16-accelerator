module recip_rom (

  input [31:0] in_q,

  output reg [31:0] recip_seed

);



localparam [31:0] ONE_Q = 32'd65536;

localparam [31:0] TWO_Q = 32'd131072;

localparam [31:0] THREE_Q = 32'd196608;



wire [4:0] recip_idx;

assign recip_idx = in_q[15:11];  




always @ (recip_idx) begin

  case (recip_idx)

    5'd0: recip_seed = 32'd64528;

    5'd1: recip_seed = 32'd62602;

    5'd2: recip_seed = 32'd60787;

    5'd3: recip_seed = 32'd59075;

    5'd4: recip_seed = 32'd57456;

    5'd5: recip_seed = 32'd55924;

    5'd6: recip_seed = 32'd54471;

    5'd7: recip_seed = 32'd53092;

    5'd8: recip_seed = 32'd51782;

    5'd9: recip_seed = 32'd50534;

    5'd10: recip_seed = 32'd49345;

    5'd11: recip_seed = 32'd48210;

    5'd12: recip_seed = 32'd47127;

    5'd13: recip_seed = 32'd46091;

    5'd14: recip_seed = 32'd45100;

    5'd15: recip_seed = 32'd44151;

    5'd16: recip_seed = 32'd43240;

    5'd17: recip_seed = 32'd42367;

    5'd18: recip_seed = 32'd41528;

    5'd19: recip_seed = 32'd40721;

    5'd20: recip_seed = 32'd39946;

    5'd21: recip_seed = 32'd39199;

    5'd22: recip_seed = 32'd38480;

    5'd23: recip_seed = 32'd37787;

    5'd24: recip_seed = 32'd37118;

    5'd25: recip_seed = 32'd36472;

    5'd26: recip_seed = 32'd35849;

    5'd27: recip_seed = 32'd35246;

    5'd28: recip_seed = 32'd34664;

    5'd29: recip_seed = 32'd34100;

    5'd30: recip_seed = 32'd33554;

    5'd31: recip_seed = 32'd33026;

    default: recip_seed = 32'd33026;

  endcase

end

endmodule
