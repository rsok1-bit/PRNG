module nlfsr_256 (input wire clk, 
input wire rst, 
output reg [255:0] prng_output);

reg [255:0] nlfsr_reg;
wire [255:0]random_out;
//64-bit outputs from PCGs
pcg_256bit pcg_inst(
	.clk(clk),
        .rst(rst),  // Convert active-high reset to active-low
	.seedloop(nlfsr_reg), //nlfsr value used for seed
        .random_out(random_out)
);

// Define feedback logic (Example: XOR, AND, OR combinations)
wire [255:0] new_bit;
assign new_bit = (nlfsr_reg[255] & nlfsr_reg[254] & nlfsr_reg[250] & nlfsr_reg[248] & nlfsr_reg[245]) ^ nlfsr_reg[243] ^
    (nlfsr_reg[240] & nlfsr_reg[237] & nlfsr_reg[230] & nlfsr_reg[225] & nlfsr_reg[220]) ^ nlfsr_reg[218] ^ nlfsr_reg[213] ^
    nlfsr_reg[207] ^ nlfsr_reg[204] ^ nlfsr_reg[200] ^ nlfsr_reg[198] ^
    (nlfsr_reg[195] & nlfsr_reg[192] & nlfsr_reg[190]) ^ nlfsr_reg[188] ^ nlfsr_reg[183] ^
    nlfsr_reg[177] ^ nlfsr_reg[175] ^ (nlfsr_reg[170] & nlfsr_reg[168]) ^
    nlfsr_reg[165] ^ nlfsr_reg[160] ^ nlfsr_reg[156] ^
    (nlfsr_reg[150] & nlfsr_reg[147] & nlfsr_reg[145]) ^ nlfsr_reg[140] ^ nlfsr_reg[138] ^
    nlfsr_reg[135] ^ nlfsr_reg[128] ^ (nlfsr_reg[122] & nlfsr_reg[120]) ^ nlfsr_reg[115] ^
    (nlfsr_reg[111] & nlfsr_reg[109]) ^ nlfsr_reg[104] ^ nlfsr_reg[101] ^
    nlfsr_reg[97] ^ (nlfsr_reg[92] & nlfsr_reg[89]) ^ nlfsr_reg[85] ^
    nlfsr_reg[80] ^ nlfsr_reg[76] ^ (nlfsr_reg[70] & nlfsr_reg[67]) ^
    nlfsr_reg[64] ^ nlfsr_reg[59] ^ nlfsr_reg[56] ^ nlfsr_reg[50] ^
    (nlfsr_reg[48] & nlfsr_reg[45]) ^ nlfsr_reg[41] ^ nlfsr_reg[38] ^
    (nlfsr_reg[33] & nlfsr_reg[31]) ^ nlfsr_reg[27] ^ nlfsr_reg[23] ^
    (nlfsr_reg[18] & nlfsr_reg[15]) ^ nlfsr_reg[10] ^ nlfsr_reg[7] ^
    (nlfsr_reg[6] & nlfsr_reg[3]) ^ nlfsr_reg[2] ^ nlfsr_reg[1];

always @(posedge clk or negedge rst) begin
    if (!rst) begin
	nlfsr_reg <= {new_bit, random_out[255:0]}; 
    end else begin  
        nlfsr_reg <= ~nlfsr_reg;  // Re-seed with inverted previous state
    end
  
end


always @(posedge clk) begin
    prng_output <= nlfsr_reg; // Output full register state
end

endmodule
