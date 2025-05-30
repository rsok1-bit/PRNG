module pcg2(
    input wire clk,
    input wire rst,
    input wire [127:0] seed2,
    output wire [127:0] random_out  // 128-bit output
);

    // Internal connections
    wire [127:0] lcg_out;

    // Instantiate LCG
    lcg2 lcg_inst(
        .clk(clk),
        .rst(rst),
        .seed2(seed2),
        .random_out(lcg_out)
    );

    // Instantiate permutation function
    permutation2 perm_inst(
        .clk(clk),
        .rst(rst),
        .data_in(lcg_out),
        .data_out(random_out)
    );

endmodule
