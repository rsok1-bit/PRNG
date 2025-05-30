// pcg1.v and pcg2.v would have the same code:
module pcg1(
    input wire clk,
    input wire rst,
    input wire [63:0] seed1,
    output wire [63:0] random_out
);

    wire [63:0] lcg_to_perm;

    // Instantiate LCG
    // Inside pcg module
    lcg1 lcg_inst(
       .clk(clk),
       .rst(rst),
       .seed1(seed1),         // Connect seed
       .random_out(lcg_to_perm)
);

    // Instantiate permutation function
    permutation1 perm_inst(
        .clk(clk),
        .rst(rst),
        .data_in(lcg_to_perm),
        .data_out(random_out)
    );

endmodule
