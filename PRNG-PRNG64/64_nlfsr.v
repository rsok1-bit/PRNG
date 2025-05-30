module nlfsr_64 (input wire clk, 
input wire rst, 
output reg [63:0] prng_output);

reg [63:0] nlfsr_reg;
wire [63:0]random_out;
//64-bit outputs from PCGs
pcg_64bit pcg_inst(
	.clk(clk),
        .rst(rst),  // Convert active-high reset to active-low
	.seedloop(nlfsr_reg), //nlfsr value used for seed
        .random_out(random_out)
);

// Define feedback logic (Example: XOR, AND, OR combinations)
wire [63:0] new_bit;
assign new_bit = (nlfsr_reg[63] & nlfsr_reg[62] & nlfsr_reg[60] & nlfsr_reg[58]) ^ nlfsr_reg[57] ^ 
                 (nlfsr_reg[55] & nlfsr_reg[53] & nlfsr_reg[50]) ^ nlfsr_reg[48] ^ nlfsr_reg[47] ^ 
                 nlfsr_reg[45] ^ nlfsr_reg[43] ^ nlfsr_reg[41] ^ nlfsr_reg[40] ^ 
                 (nlfsr_reg[38] & nlfsr_reg[37] & nlfsr_reg[36]) ^ nlfsr_reg[33] ^ nlfsr_reg[31] ^ 
                 nlfsr_reg[29] ^ nlfsr_reg[27] ^ (nlfsr_reg[25] & nlfsr_reg[23]) ^ nlfsr_reg[22] ^ 
                 nlfsr_reg[20] ^ nlfsr_reg[18] ^ (nlfsr_reg[16] & nlfsr_reg[14]) ^ nlfsr_reg[12] ^ 
                 nlfsr_reg[10] ^ (nlfsr_reg[8] & nlfsr_reg[6]) ^ nlfsr_reg[4] ^ nlfsr_reg[2] ^ nlfsr_reg[1];


always @(posedge clk or negedge rst) begin
    if (!rst) begin
	nlfsr_reg <= {new_bit, random_out[63:0]}; 
    end else begin  
        nlfsr_reg <= ~nlfsr_reg;  // Re-seed with inverted previous state
    end
  
end


always @(posedge clk) begin
    prng_output <= nlfsr_reg; // Output full register state
end

endmodule
