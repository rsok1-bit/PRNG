module ADC_Seed_Generator256 ( 
    input wire clk,           // System clock
    input wire rst,           // Reset signal
    input wire [255:0] seedloop,      //nlfsr value used for seed
    output reg [127:0] seed1,   // 128-bit random seed output
    output reg [127:0] seed2
);

// Internal registers
reg [127:0] adc_sample;   // Simulated 16-bit ADC output
reg [127:0] entropy_pool; // Storage for 8 ADC samples
reg [1:0] sample_count;

// Step 1: Simulated ADC entropy source (randomized values) 
always @(posedge clk or posedge rst) begin
    if (rst) begin
        adc_sample <= 128'h3F72C91E5A6BD4FA8937CE1204B1DA6E;  // Initial random seed
    end else begin
 	adc_sample <= seedloop[191:64];
        adc_sample <= adc_sample ^ (adc_sample >> 1) ^ (adc_sample << 3); // Simple randomness model
    end
end

// Step 2: Collect ADC samples and apply XOR mixing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        entropy_pool <= 128'b0;
        sample_count <= 0;
    end else begin
        // Shift left 16 bits and XOR in the new 32-bit ADC sample
        entropy_pool <= (entropy_pool << 16) ^ adc_sample;  
        sample_count <= sample_count + 1;

        // Once 8 samples are collected (16-bit * 8 = 128-bit), finalize seed
        if (sample_count == 8) begin
            sample_count <= 0;
            // Optionally signal that seed is ready here
        end
    end
end

// Step 3: Assign final seed output
always @(posedge clk) begin
    seed1 <= entropy_pool ^ 128'hA8B2F3C01D9E6A3774CCE0B83F91AD24; // Direct output (can be passed to SHA-256)
    seed2 <= ~entropy_pool ^ 128'h6E1A9D2B44A7F80C2C913E5B7D34AC10;   // Second seed (inverted and XORed)
end

endmodule
