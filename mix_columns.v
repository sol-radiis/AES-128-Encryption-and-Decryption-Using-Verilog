module mix_columns (
    input  wire [127:0] in,
    output wire [127:0] out
);

    function [7:0] xtime;
        input [7:0] b;
        begin
            xtime = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
        end
    endfunction

    function [7:0] mul_by_2;
        input [7:0] b;
        begin
            mul_by_2 = xtime(b);
        end
    endfunction

    function [7:0] mul_by_3;
        input [7:0] b;
        begin
            mul_by_3 = xtime(b) ^ b;
        end
    endfunction

    integer i;
    reg [7:0] s [0:15];
    reg [7:0] m [0:15];

    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            s[i] = in[127 - i*8 -: 8];
        end

        for (i = 0; i < 4; i = i + 1) begin
            m[i*4 + 0] = mul_by_2(s[i*4 + 0]) ^ mul_by_3(s[i*4 + 1]) ^ s[i*4 + 2] ^ s[i*4 + 3];
            m[i*4 + 1] = s[i*4 + 0] ^ mul_by_2(s[i*4 + 1]) ^ mul_by_3(s[i*4 + 2]) ^ s[i*4 + 3];
            m[i*4 + 2] = s[i*4 + 0] ^ s[i*4 + 1] ^ mul_by_2(s[i*4 + 2]) ^ mul_by_3(s[i*4 + 3]);
            m[i*4 + 3] = mul_by_3(s[i*4 + 0]) ^ s[i*4 + 1] ^ s[i*4 + 2] ^ mul_by_2(s[i*4 + 3]);
        end
    end

    generate
        genvar j;
        for (j = 0; j < 16; j = j + 1) begin : output_assign
            assign out[127 - j*8 -: 8] = m[j];
        end
    endgenerate
endmodule