module lcg2(
    input wire clk,
    input wire rst,
    input wire [31:0] seed2,    // New input
    output reg [31:0] random_out
);

    // Constants for LCG
    localparam [31:0] MULTIPLIER = 32'h6B9F42D3;
    localparam [31:0] INCREMENT  = 32'h1C37FA88;

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
            state <= seed2;  // Use seed input instead of hardcoded value
        end else begin
            state <= next_state;
        end
    end

    // Output logic remains the same
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            random_out <= state;
        end else begin
            random_out <= 31'h0;
        end
    end

endmodule
