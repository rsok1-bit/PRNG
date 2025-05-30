module lcg2(
    input wire clk,
    input wire rst,
    input wire [127:0] seed2,    // New input
    output reg [127:0] random_out
);

    // Constants for LCG
    localparam [127:0] MULTIPLIER = 128'h23F1BC8A9D05E7164459A7C6D83E0912;
    localparam [127:0] INCREMENT  = 128'h7ACED3401B2F980CDD662B9EA4E8D53F;

    // Internal state register
    reg [127:0] state;

    // Next state calculation
    wire [255:0] mult_result;
    wire [127:0] next_state;

    assign mult_result = state * MULTIPLIER;
    assign next_state = mult_result[127:0] + INCREMENT;

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
            random_out <= 128'h0;
        end
    end

endmodule
