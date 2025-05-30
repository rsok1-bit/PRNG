module lcg1(
    input wire clk,
    input wire rst,
    input wire [31:0] seed1,    // New input
    output reg [31:0] random_out
);

    // Constants for LCG
    localparam [31:0] MULTIPLIER = 32'h3E8A91CF;
    localparam [31:0] INCREMENT  = 32'hD4721B60;

    // Internal state register
    reg [31:0] state;

    // Next state calculation
    wire [63:0] mult_result;
    wire [31:0] next_state;

    assign mult_result = state * MULTIPLIER;
    assign next_state = mult_result[31:0] + INCREMENT;

    // Sequential logic for state update
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= seed1;  // Use seed input instead of hardcoded value
        end else begin
            state <= next_state;
        end
    end

    // Output logic remains the same
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            random_out <= state;
        end else begin
            random_out <= 32'h0;
        end
    end

endmodule
