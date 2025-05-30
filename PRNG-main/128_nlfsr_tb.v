`timescale 1ns / 1ps

module nlfsr_128_tb;
    
    reg clk;
    reg reset;
    wire [127:0] prng_output;
    
    // Instantiate the NLFSR module
    nlfsr_128 uut (
        .clk(clk),
        .reset(reset),
        .prng_output(prng_output)
    );
    
    // Clock generation (10ns period -> 100MHz)
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        
        // Apply reset
        #20 reset = 0;
        
        // Run for a certain number of cycles
        #500;
        
        // End simulation
        $finish;
    end
    
    // Monitor PRNG output
    initial begin
        $monitor("%t: prng_output = %h", $time, prng_output);
    end
    
endmodule
