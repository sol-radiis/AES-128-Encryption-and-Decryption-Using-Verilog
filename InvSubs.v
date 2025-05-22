
module InvSubstitutionMatrix(
    input  [127:0] Data,
    output [127:0] Data_out
);

    reg [7:0] InvSBox [0:255];
    reg [7:0] substituted [0:15];
    wire [7:0] data_bytes [0:15];
    integer i;

    // Split 128-bit input into 16 bytes
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : split_input
            assign data_bytes[j] = Data[8*(15 - j) +: 8];
        end
    endgenerate

    // Perform substitution in a combinational block
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            substituted[i] = InvSBox[data_bytes[i]];
        end
    end

    // Concatenate output
    assign Data_out = {
        substituted[0], substituted[1], substituted[2], substituted[3],
        substituted[4], substituted[5], substituted[6], substituted[7],
        substituted[8], substituted[9], substituted[10], substituted[11],
        substituted[12], substituted[13], substituted[14], substituted[15]
    };

    // Initialize Inverse S-Box
    initial begin
        InvSBox[0] = 8'h52; InvSBox[1] = 8'h09; InvSBox[2] = 8'h6A; InvSBox[3] = 8'hD5;
        InvSBox[4] = 8'h30; InvSBox[5] = 8'h36; InvSBox[6] = 8'hA5; InvSBox[7] = 8'h38;
        InvSBox[8] = 8'hBF; InvSBox[9] = 8'h40; InvSBox[10] = 8'hA3; InvSBox[11] = 8'h9E;
        InvSBox[12] = 8'h81; InvSBox[13] = 8'hF3; InvSBox[14] = 8'hD7; InvSBox[15] = 8'hFB;
        InvSBox[16] = 8'h7C; InvSBox[17] = 8'hE3; InvSBox[18] = 8'h39; InvSBox[19] = 8'h82;
        InvSBox[20] = 8'h9B; InvSBox[21] = 8'h2F; InvSBox[22] = 8'hFF; InvSBox[23] = 8'h87;
        InvSBox[24] = 8'h34; InvSBox[25] = 8'h8E; InvSBox[26] = 8'h43; InvSBox[27] = 8'h44;
        InvSBox[28] = 8'hC4; InvSBox[29] = 8'hDE; InvSBox[30] = 8'hE9; InvSBox[31] = 8'hCB;
        InvSBox[32] = 8'h54; InvSBox[33] = 8'h7B; InvSBox[34] = 8'h94; InvSBox[35] = 8'h32;
        InvSBox[36] = 8'hA6; InvSBox[37] = 8'hC2; InvSBox[38] = 8'h23; InvSBox[39] = 8'h3D;
        InvSBox[40] = 8'hEE; InvSBox[41] = 8'h4C; InvSBox[42] = 8'h95; InvSBox[43] = 8'h0B;
        InvSBox[44] = 8'h42; InvSBox[45] = 8'hFA; InvSBox[46] = 8'hC3; InvSBox[47] = 8'h4E;
        InvSBox[48] = 8'h08; InvSBox[49] = 8'h2E; InvSBox[50] = 8'hA1; InvSBox[51] = 8'h66;
        InvSBox[52] = 8'h28; InvSBox[53] = 8'hD9; InvSBox[54] = 8'h24; InvSBox[55] = 8'hB2;
        InvSBox[56] = 8'h76; InvSBox[57] = 8'h5B; InvSBox[58] = 8'hA2; InvSBox[59] = 8'h49;
        InvSBox[60] = 8'h6D; InvSBox[61] = 8'h8B; InvSBox[62] = 8'hD1; InvSBox[63] = 8'h25;
        InvSBox[64] = 8'h72; InvSBox[65] = 8'hF8; InvSBox[66] = 8'hF6; InvSBox[67] = 8'h64;
        InvSBox[68] = 8'h86; InvSBox[69] = 8'h68; InvSBox[70] = 8'h98; InvSBox[71] = 8'h16;
        InvSBox[72] = 8'hD4; InvSBox[73] = 8'hA4; InvSBox[74] = 8'h5C; InvSBox[75] = 8'hCC;
        InvSBox[76] = 8'h5D; InvSBox[77] = 8'h65; InvSBox[78] = 8'hB6; InvSBox[79] = 8'h92;
        InvSBox[80] = 8'h6C; InvSBox[81] = 8'h70; InvSBox[82] = 8'h48; InvSBox[83] = 8'h50;
        InvSBox[84] = 8'hFD; InvSBox[85] = 8'hED; InvSBox[86] = 8'hB9; InvSBox[87] = 8'hDA;
        InvSBox[88] = 8'h5E; InvSBox[89] = 8'h15; InvSBox[90] = 8'h46; InvSBox[91] = 8'h57;
        InvSBox[92] = 8'hA7; InvSBox[93] = 8'h8D; InvSBox[94] = 8'h9D; InvSBox[95] = 8'h84;
        InvSBox[96] = 8'h90; InvSBox[97] = 8'hD8; InvSBox[98] = 8'hAB; InvSBox[99] = 8'h00;
        InvSBox[100] = 8'h8C; InvSBox[101] = 8'hBC; InvSBox[102] = 8'hD3; InvSBox[103] = 8'h0A;
        InvSBox[104] = 8'hF7; InvSBox[105] = 8'hE4; InvSBox[106] = 8'h58; InvSBox[107] = 8'h05;
        InvSBox[108] = 8'hB8; InvSBox[109] = 8'hB3; InvSBox[110] = 8'h45; InvSBox[111] = 8'h06;
        InvSBox[112] = 8'hD0; InvSBox[113] = 8'h2C; InvSBox[114] = 8'h1E; InvSBox[115] = 8'h8F;
        InvSBox[116] = 8'hCA; InvSBox[117] = 8'h3F; InvSBox[118] = 8'h0F; InvSBox[119] = 8'h02;
        InvSBox[120] = 8'hC1; InvSBox[121] = 8'hAF; InvSBox[122] = 8'hBD; InvSBox[123] = 8'h03;
        InvSBox[124] = 8'h01; InvSBox[125] = 8'h13; InvSBox[126] = 8'h8A; InvSBox[127] = 8'h6B;
        InvSBox[128] = 8'h3A; InvSBox[129] = 8'h91; InvSBox[130] = 8'h11; InvSBox[131] = 8'h41;
        InvSBox[132] = 8'h4F; InvSBox[133] = 8'h67; InvSBox[134] = 8'hDC; InvSBox[135] = 8'hEA;
        InvSBox[136] = 8'h97; InvSBox[137] = 8'hF2; InvSBox[138] = 8'hCF; InvSBox[139] = 8'hCE;
        InvSBox[140] = 8'hF0; InvSBox[141] = 8'hB4; InvSBox[142] = 8'hE6; InvSBox[143] = 8'h73;
        InvSBox[144] = 8'h96; InvSBox[145] = 8'hAC; InvSBox[146] = 8'h74; InvSBox[147] = 8'h22;
        InvSBox[148] = 8'hE7; InvSBox[149] = 8'hAD; InvSBox[150] = 8'h35; InvSBox[151] = 8'h85;
        InvSBox[152] = 8'hE2; InvSBox[153] = 8'hF9; InvSBox[154] = 8'h37; InvSBox[155] = 8'hE8;
        InvSBox[156] = 8'h1C; InvSBox[157] = 8'h75; InvSBox[158] = 8'hDF; InvSBox[159] = 8'h6E;
        InvSBox[160] = 8'h47; InvSBox[161] = 8'hF1; InvSBox[162] = 8'h1A; InvSBox[163] = 8'h71;
        InvSBox[164] = 8'h1D; InvSBox[165] = 8'h29; InvSBox[166] = 8'hC5; InvSBox[167] = 8'h89;
        InvSBox[168] = 8'h6F; InvSBox[169] = 8'hB7; InvSBox[170] = 8'h62; InvSBox[171] = 8'h0E;
        InvSBox[172] = 8'hAA; InvSBox[173] = 8'h18; InvSBox[174] = 8'hBE; InvSBox[175] = 8'h1B;
        InvSBox[176] = 8'hFC; InvSBox[177] = 8'h56; InvSBox[178] = 8'h3E; InvSBox[179] = 8'h4B;
        InvSBox[180] = 8'hC6; InvSBox[181] = 8'hD2; InvSBox[182] = 8'h79; InvSBox[183] = 8'h20;
        InvSBox[184] = 8'h9A; InvSBox[185] = 8'hDB; InvSBox[186] = 8'hC0; InvSBox[187] = 8'hFE;
        InvSBox[188] = 8'h78; InvSBox[189] = 8'hCD; InvSBox[190] = 8'h5A; InvSBox[191] = 8'hF4;
        InvSBox[192] = 8'h1F; InvSBox[193] = 8'hDD; InvSBox[194] = 8'hA8; InvSBox[195] = 8'h33;
        InvSBox[196] = 8'h88; InvSBox[197] = 8'h07; InvSBox[198] = 8'hC7; InvSBox[199] = 8'h31;
        InvSBox[200] = 8'hB1; InvSBox[201] = 8'h12; InvSBox[202] = 8'h10; InvSBox[203] = 8'h59;
        InvSBox[204] = 8'h27; InvSBox[205] = 8'h80; InvSBox[206] = 8'hEC; InvSBox[207] = 8'h5F;
        InvSBox[208] = 8'h60; InvSBox[209] = 8'h51; InvSBox[210] = 8'h7F; InvSBox[211] = 8'hA9;
        InvSBox[212] = 8'h19; InvSBox[213] = 8'hB5; InvSBox[214] = 8'h4A; InvSBox[215] = 8'h0D;
        InvSBox[216] = 8'h2D; InvSBox[217] = 8'hE5; InvSBox[218] = 8'h7A; InvSBox[219] = 8'h9F;
        InvSBox[220] = 8'h93; InvSBox[221] = 8'hC9; InvSBox[222] = 8'h9C; InvSBox[223] = 8'hEF;
        InvSBox[224] = 8'hA0; InvSBox[225] = 8'hE0; InvSBox[226] = 8'h3B; InvSBox[227] = 8'h4D;
        InvSBox[228] = 8'hAE; InvSBox[229] = 8'h2A; InvSBox[230] = 8'hF5; InvSBox[231] = 8'hB0;
        InvSBox[232] = 8'hC8; InvSBox[233] = 8'hEB; InvSBox[234] = 8'hBB; InvSBox[235] = 8'h3C;
        InvSBox[236] = 8'h83; InvSBox[237] = 8'h53; InvSBox[238] = 8'h99; InvSBox[239] = 8'h61;
        InvSBox[240] = 8'h17; InvSBox[241] = 8'h2B; InvSBox[242] = 8'h04; InvSBox[243] = 8'h7E;
        InvSBox[244] = 8'hBA; InvSBox[245] = 8'h77; InvSBox[246] = 8'hD6; InvSBox[247] = 8'h26;
        InvSBox[248] = 8'hE1; InvSBox[249] = 8'h69; InvSBox[250] = 8'h14; InvSBox[251] = 8'h63;
        InvSBox[252] = 8'h55; InvSBox[253] = 8'h21; InvSBox[254] = 8'h0C; InvSBox[255] = 8'h7D;

    end

endmodule
