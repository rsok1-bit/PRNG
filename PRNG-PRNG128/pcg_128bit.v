module pcg_128bit(
    input wire clk,
    input wire rst,
    input wire [127:0] seedloop,
    output wire [127:0] random_out
);
    // Internal signals
    wire [63:0] seed1;
    wire [63:0] seed2;
    wire [63:0] pcg1_out;
    wire [63:0] pcg2_out;

    // Instantiate seed generator
    ADC_Seed_Generator128 seed_gen(
        .clk(clk),
        .rst(rst),
	.seedloop(seedloop),
        .seed1(seed1),
        .seed2(seed2)
    );

    // Instantiate PCG1 with seed1
    pcg1 pcg1_inst(
        .clk(clk),
        .rst(rst),
        .seed1(seed1),      // Connect to seed1
        .random_out(pcg1_out)
    );

    // Instantiate PCG2 with seed2
    pcg2 pcg2_inst(
        .clk(clk),
        .rst(rst),
        .seed2(seed2),      // Connect to seed2
        .random_out(pcg2_out)
    );

    // Combine outputs
    assign random_out = {pcg1_out, pcg2_out};

endmodule
