module ADC_Seed_Generator64 ( 
    input wire clk,           // System clock
    input wire rst,           // Reset signal
    input wire [63:0] seedloop,      //nlfsr value used for seed
    output reg [31:0] seed1,   // 128-bit random seed output
    output reg [31:0] seed2
);

// Internal registers
reg [31:0] adc_sample;   // Simulated 16-bit ADC output
reg [31:0] entropy_pool; // Storage for 8 ADC samples
reg [1:0] sample_count;

// Step 1: Simulated ADC entropy source (randomized values) 
always @(posedge clk or posedge rst) begin
    if (rst) begin
        adc_sample <= 32'hA7F3C91E;  // Initial random seed
    end else begin
 	adc_sample <= seedloop[47:16];
        adc_sample <= adc_sample ^ (adc_sample >> 1) ^ (adc_sample << 3); // Simple randomness model
    end
end

// Step 2: Collect ADC samples and apply XOR mixing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        entropy_pool <= 32'b0;
        sample_count <= 0;
    end else begin
        entropy_pool <= (entropy_pool << 16) ^ adc_sample;  
        sample_count <= sample_count + 1;

        // Once 2 samples are collected (16-bit * 2 = 32-bit), finalize seed
        if (sample_count == 2) begin
            sample_count <= 0;
        end
    end
end

// Step 3: Assign final seed output
always @(posedge clk) begin
    seed1 <= entropy_pool ^ 32'h8F2D4A77; // Direct output (can be passed to SHA-256)
    seed2 <= ~entropy_pool ^ 32'h1B93E6C0;   // Second seed (inverted and XORed)
end

endmodule
