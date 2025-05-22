`timescale 1ns / 1ps

module InvShiftRows (
    input  [127:0] state_in,
    output [127:0] state_out
);
    wire [7:0] s [0:15];
    genvar i;

    // 1) Unpack state_in into bytes s[0]-s[15] in natural AES column-major order

    generate
        for (i = 0; i < 16; i = i + 1) begin : UNPACK
            assign s[i] = state_in[127 - 8*i -: 8];
        end
    endgenerate
    // 2) Apply the inverse ShiftRows transformation
    assign state_out = {
        // Column 0
        s[ 0], s[13], s[10], s[ 7],
        // Column 1
        s[ 4], s[ 1], s[14], s[11],
        // Column 2
        s[ 8], s[ 5], s[ 2], s[15],
        // Column 3
        s[12], s[ 9], s[ 6], s[ 3]
    };

endmodule
