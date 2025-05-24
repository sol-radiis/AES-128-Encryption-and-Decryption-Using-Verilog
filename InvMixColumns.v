
module InvMixColumns(
    input  [127:0] state_in,
    output [127:0] state_out
);
    // Internal registers
    reg [7:0] s [0:15];
    reg [7:0] r [0:15];
    integer c;

    // Output register
    reg [127:0] state_out_reg;
    assign state_out = state_out_reg;

    // GF(2^8) multiply: p = a · b
    function [7:0] gmul;
        input [7:0] a;
        input [7:0] b;
        reg   [7:0] x, y, p;
        integer     i;
        begin
            x = a;
            y = b;
            p = 8'h00;
            for (i = 0; i < 8; i = i + 1) begin
                if (y[0])       p = p ^ x;
                if (x[7])       x = (x << 1) ^ 8'h1b;
                else            x = x << 1;
                y = y >> 1;
            end
            gmul = p;
        end
    endfunction

    // Main transformation
    always @(*) begin
        // 1) Unpack input into byte array s
        for (c = 0; c < 16; c = c + 1) begin
            s[c] = state_in[8*(15 - c) +: 8];
        end

        // 2) Apply inverse MixColumns transformation
        for (c = 0; c < 4; c = c + 1) begin
            r[4*c + 0] = gmul(8'he, s[4*c + 0]) ^ gmul(8'hb, s[4*c + 1]) ^
                         gmul(8'hd, s[4*c + 2]) ^ gmul(8'h9, s[4*c + 3]);
            r[4*c + 1] = gmul(8'h9, s[4*c + 0]) ^ gmul(8'he, s[4*c + 1]) ^
                         gmul(8'hb, s[4*c + 2]) ^ gmul(8'hd, s[4*c + 3]);
            r[4*c + 2] = gmul(8'hd, s[4*c + 0]) ^ gmul(8'h9, s[4*c + 1]) ^
                         gmul(8'he, s[4*c + 2]) ^ gmul(8'hb, s[4*c + 3]);
            r[4*c + 3] = gmul(8'hb, s[4*c + 0]) ^ gmul(8'hd, s[4*c + 1]) ^
                         gmul(8'h9, s[4*c + 2]) ^ gmul(8'he, s[4*c + 3]);
        end

        // 3) Pack back into 128-bit output
        for (c = 0; c < 16; c = c + 1) begin
            state_out_reg[8*(15 - c) +: 8] = r[c];
        end
    end

endmodule
