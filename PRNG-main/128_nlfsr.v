module nlfsr_128 (input clk, input reset, output reg [127:0] prng_output);

reg [127:0] nlfsr_reg;

//64-bit outputs from PCGs
wire [127:0] pcg_output;
pcg_128bit pcg_inst(
	.clk(clk),
        .rst_n(~reset),  // Convert active-high reset to active-low
        .random_out(pcg_output)
);

// Define feedback logic (Example: XOR, AND, OR combinations)
wire new_bit;
assign new_bit = (nlfsr_reg[126] & nlfsr_reg[125] & nlfsr_reg[122] & nlfsr_reg[120] & nlfsr_reg[117]) ^ nlfsr_reg[115] ^ 
		 (nlfsr_reg[112] & nlfsr_reg[109] & nlfsr_reg[101] & nlfsr_reg[98] & nlfsr_reg[96]) ^ nlfsr_reg[94] ^ nlfsr_reg[93] ^ nlfsr_reg[86] ^ nlfsr_reg[84]
		 ^ nlfsr_reg[83] ^ nlfsr_reg[81] ^ nlfsr_reg[80] ^ (nlfsr_reg[77] & nlfsr_reg[76] & nlfsr_reg[75] & nlfsr_reg[74]) ^ nlfsr_reg[70] ^ nlfsr_reg[69]
		 ^ nlfsr_reg[65] ^ nlfsr_reg[61] ^ nlfsr_reg[58] ^ (nlfsr_reg[55] & nlfsr_reg[51] & nlfsr_reg[50]) ^ nlfsr_reg[49] ^ nlfsr_reg[46] ^ nlfsr_reg[45]
		 ^ nlfsr_reg[41] ^ nlfsr_reg[39] ^ (nlfsr_reg[36] & nlfsr_reg[32]) ^ nlfsr_reg[29] ^ (nlfsr_reg[28] & nlfsr_reg[25]) ^ nlfsr_reg[20] 
		 ^ (nlfsr_reg[18] & nlfsr_reg[15]) ^ nlfsr_reg[10] ^ nlfsr_reg[7] ^ (nlfsr_reg[6] & nlfsr_reg[3]) ^ nlfsr_reg[2] ^ nlfsr_reg[1];

always @(posedge clk or posedge reset) begin
    if (reset)
        nlfsr_reg <= pcg_output; 
    else if (nlfsr_reg == 128'b0)  // Prevents zero lock-up
        nlfsr_reg <= ~nlfsr_reg;  // Re-seed with inverted previous state
    else
        nlfsr_reg <= {new_bit, nlfsr_reg[127:1]};  
end

assign prng_output = nlfsr_reg; // Output full register state

endmodule
