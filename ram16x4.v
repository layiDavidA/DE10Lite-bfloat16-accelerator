//32x16
module ram_16x4(input clk, input [4:0] addr, input mwr, input [15:0] mdi, output reg [15:0] mdo);

reg [15:0] memory [31:0] /* synthesis ramstyle = "M9K" ram_init_file = "lab5.mif"*/;
always @ (posedge clk) begin
if (mwr) memory[addr] <= mdi; //write mem
mdo <= memory[addr]; // read mem
end
endmodule