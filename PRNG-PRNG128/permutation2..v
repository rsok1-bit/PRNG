module permutation2(
    input wire clk,
    input wire rst,
    input wire [63:0] data_in,    // Input from LCG
    output reg [63:0] data_out    // Permuted output
);

    // Internal signals
    wire [63:0] right_shifted;    // For 6-bit right shift
    wire [63:0] xor_result;       // After XOR operation
    wire [5:0] rotation_amount;   // Amount to rotate (top 6 bits)
    wire [63:0] rotated_result;   // After rotation
    
    // Step 1: Right shift by 6
    assign right_shifted = data_in >> 6;
    
    // Step 2: XOR with original
    assign xor_result = data_in ^ right_shifted;
    
    // Step 3: Get rotation amount from high bits
    assign rotation_amount = data_in[63:58];
    
    // Step 4: Perform rotation
    // Barrel shifter implementation
    assign rotated_result = (xor_result >> rotation_amount) | (xor_result << (64 - rotation_amount));
    
    // Register output
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_out <= rotated_result;
        end else begin
            data_out <= 64'h0;
        end
    end

endmodule
