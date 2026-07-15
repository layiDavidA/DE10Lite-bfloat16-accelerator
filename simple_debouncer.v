module simple_debouncer (
    input clk,            // 50 MHz clock
    input [9:0] button_in,      // Noisy switch input
    output reg [9:0] button_out // Clean output
);
    // 20-bit counter to divide the clock
    // 2^20 = 1,048,576
    // At 50 MHz, 1,000,000 cycles is exactly 20 milliseconds.
    reg [19:0] counter = 0;
    always @(posedge clk) begin
        counter <= counter + 1'b1;
        
        // Every 20ms, sample the raw input and update the output
        if (counter == 20'd1_000_000) begin
            button_out <= button_in;
            counter <= 0;
        end
    end
endmodule
