module ADC_Seed_Generator128 ( 
    input wire clk,           // System clock
    input wire rst,           // Reset signal
    input wire [127:0] seedloop,      //nlfsr value used for seed
    output reg [63:0] seed1,   // 128-bit random seed output
    output reg [63:0] seed2
);

// Internal registers
reg [63:0] adc_sample;   // Simulated 16-bit ADC output
reg [63:0] entropy_pool; // Storage for 8 ADC samples
reg [1:0] sample_count;

// Step 1: Simulated ADC entropy source (randomized values) 
always @(posedge clk or posedge rst) begin
    if (rst) begin
        adc_sample <= 64'hA3F7C9D5826B4E1D;  // Initial random seed
    end else begin
 	adc_sample <= seedloop[95:32];
        adc_sample <= adc_sample ^ (adc_sample >> 1) ^ (adc_sample << 3); // Simple randomness model
    end
end

// Step 2: Collect ADC samples and apply XOR mixing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        entropy_pool <= 64'b0;
        sample_count <= 0;
    end else begin
        entropy_pool <= (entropy_pool << 16) ^ adc_sample;  
        sample_count <= sample_count + 1;

        // Once 4 samples are collected (16-bit * 4 = 64-bit), finalize seed
        if (sample_count == 4) begin
            sample_count <= 0;
        end
    end
end

// Step 3: Assign final seed output
always @(posedge clk) begin
    seed1 <= entropy_pool ^ 64'h7729CEBAF02D3D20; // Direct output (can be passed to SHA-256)
    seed2 <= ~entropy_pool ^ 64'hE7B4D2A9853C6F19;   // Second seed (inverted and XORed)
end

endmodule
