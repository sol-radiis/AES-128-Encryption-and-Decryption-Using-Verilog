`timescale 1ns / 1ps

// This module implements the Inverse MixColumns transformation for AES.
// It takes a 128-bit input state and applies the inverse MixColumns transformation

module InvMixColumns(
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);
    // Local byte arrays
    logic [7:0] s [0:15];
    logic [7:0] r [0:15];
    integer     c;

    // GF(2^8) multiply: p = a · b
    function automatic [7:0] gmul (
        input logic [7:0] a,
        input logic [7:0] b
    );
        logic [7:0] x, y, p;
        integer     i;
        begin
            x = a;
            y = b;
            p = 8'h00;
            for (i = 0; i < 8; i = i + 1) begin
                if (y[0])       p = p ^ x;
                if (x[7])       x = (x << 1) ^ 8'h1b;
                else            x =  x << 1;
                y = y >> 1;
            end
            return p;
        end
    endfunction

    // Procedural block: unpack, transform, repack
    always_comb begin
        // 1) Unpack state_in into bytes s[0..15]
        for (c = 0; c < 16; c = c + 1) begin
            s[c] = state_in[8*(15 - c) +: 8];
        end

        // 2) For each of the 4 columns, apply the InvMixColumns matrix
        for (c = 0; c < 4; c = c + 1) begin
            r[4*c + 0] = gmul(8'he, s[4*c + 0]) ^ gmul(8'hb, s[4*c + 1])
                       ^ gmul(8'hd, s[4*c + 2]) ^ gmul(8'h9, s[4*c + 3]);
            r[4*c + 1] = gmul(8'h9, s[4*c + 0]) ^ gmul(8'he, s[4*c + 1])
                       ^ gmul(8'hb, s[4*c + 2]) ^ gmul(8'hd, s[4*c + 3]);
            r[4*c + 2] = gmul(8'hd, s[4*c + 0]) ^ gmul(8'h9, s[4*c + 1])
                       ^ gmul(8'he, s[4*c + 2]) ^ gmul(8'hb, s[4*c + 3]);
            r[4*c + 3] = gmul(8'hb, s[4*c + 0]) ^ gmul(8'hd, s[4*c + 1])
                       ^ gmul(8'h9, s[4*c + 2]) ^ gmul(8'he, s[4*c + 3]);
        end

        // 3) Pack result bytes r[0..15] back into state_out
        for (c = 0; c < 16; c = c + 1) begin
            state_out[8*(15 - c) +: 8] = r[c];
        end
    end

endmodule
