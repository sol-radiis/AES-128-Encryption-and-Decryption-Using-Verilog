module sub_bytes (
    input wire [127:0] in,
    output wire [127:0] out
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : byte_sub
            sbox sb (
                .in(in[8*i +: 8]),
                .out(out[8*i +: 8])
            );
        end
    endgenerate
endmodule