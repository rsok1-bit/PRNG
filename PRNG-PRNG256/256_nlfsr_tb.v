module nlfsr_256_tb;
    
    reg clk;
    reg rst;
    wire [255:0] prng_output;
    integer i;
    integer file;
    
    // Instantiate the NLFSR module
    nlfsr_256 uut (
        .clk(clk),
        .rst(rst),
        .prng_output(prng_output)
    );
    
    // Clock generation (10ns period -> 100MHz)
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        file = $fopen("prng_output.txt", "w");
        
        // Apply reset
        #20 rst = 0;
        
        // Generate 1,000,000 bits (approx. 7813 cycles for 128-bit outputs)
        for (i = 0; i < 3907; i = i + 1) begin
            @(posedge clk);
            $fwrite(file, "%h\n", prng_output);
	    $monitor("%b", prng_output);
        end
        
        // Close file and end simulation
        $fclose(file);
        $finish;
    end

endmodule

