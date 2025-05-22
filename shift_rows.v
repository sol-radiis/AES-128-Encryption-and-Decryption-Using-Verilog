module shift_rows (
    input  wire [127:0] in,
    output wire [127:0] out
);
    wire [7:0] state [0:15];

    // Unpack 128-bit input into bytes
    assign state[0]  = in[127:120];  // Row 0, Col 0
    assign state[1]  = in[119:112];
    assign state[2]  = in[111:104];
    assign state[3]  = in[103:96];

    assign state[4]  = in[95:88];    // Row 1, Col 0
    assign state[5]  = in[87:80];
    assign state[6]  = in[79:72];
    assign state[7]  = in[71:64];

    assign state[8]  = in[63:56];    // Row 2, Col 0
    assign state[9]  = in[55:48];
    assign state[10] = in[47:40];
    assign state[11] = in[39:32];

    assign state[12] = in[31:24];    // Row 3, Col 0
    assign state[13] = in[23:16];
    assign state[14] = in[15:8];
    assign state[15] = in[7:0];

    // Perform ShiftRows
    assign out[127:120] = state[0];    // Row 0: no shift
    assign out[119:112] = state[5];    // Row 1: shift left 1
    assign out[111:104] = state[10];
    assign out[103:96]  = state[15];

    assign out[95:88]   = state[4];    // Row 1
    assign out[87:80]   = state[9];
    assign out[79:72]   = state[14];
    assign out[71:64]   = state[3];

    assign out[63:56]   = state[8];    // Row 2: shift left 2
    assign out[55:48]   = state[13];
    assign out[47:40]   = state[2];
    assign out[39:32]   = state[7];

    assign out[31:24]   = state[12];   // Row 3: shift left 3
    assign out[23:16]   = state[1];
    assign out[15:8]    = state[6];
    assign out[7:0]     = state[11];
endmodule