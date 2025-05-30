module lcg2(
    input wire clk,
    input wire rst,
    input wire [63:0] seed2,    // New input
    output reg [63:0] random_out
);

    // Constants for LCG
    localparam [63:0] MULTIPLIER = 64'h5851F42D4C957F2D;
    localparam [63:0] INCREMENT  = 64'h14057B7EF767814F;

    // Internal state register
    reg [63:0] state;

    // Next state calculation
    wire [127:0] mult_result;
    wire [63:0] next_state;

    assign mult_result = state * MULTIPLIER;
    assign next_state = mult_result[63:0] + INCREMENT;

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
            random_out <= 64'h0;
        end
    end

endmodule
