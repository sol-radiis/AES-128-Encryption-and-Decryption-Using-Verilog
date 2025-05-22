

module aes_128 (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [127:0] plaintext,
    input  wire [127:0] key,
    input  wire         encrypt,   // 1: encrypt, 0: decrypt
    output reg  [127:0] ciphertext,
    output reg         done
);
    reg  [3:0]   round;
    reg  [127:0] state;
    reg          busy;

    // All round keys: 11 x 128 bits = 1408 bits
    wire [1407:0] round_keys;
    reg  [127:0]  round_key;

    // Encryption path wires
    wire [127:0] sub_bytes_out, shift_rows_out, mix_columns_out;

    // Decryption path wires
    wire [127:0] inv_shift_rows_out;
    wire [127:0] inv_sub_bytes_out;
    wire [127:0] after_key;
    wire [127:0] inv_mix_columns_out;

    // Key Expansion
    key_expansion key_exp (
        .key       (key),
        .round_keys(round_keys)
    );

    // --- Encryption modules ---
    sub_bytes    sb  (.in(state),         .out(sub_bytes_out));
    shift_rows   sr  (.in(sub_bytes_out),  .out(shift_rows_out));
    mix_columns  mc  (.in(shift_rows_out), .out(mix_columns_out));

    // --- Decryption modules ---
    InvShiftRows    isr (.state_in(state),           .state_out(inv_shift_rows_out));
    InvSubstitutionMatrix     isb (.Data(inv_shift_rows_out),     .Data_out(inv_sub_bytes_out));
    InvMixColumns   imc (.state_in(after_key),        .state_out(inv_mix_columns_out));

    // Compute after_key = InvSubBytes_out ^ round_key
    assign after_key = inv_sub_bytes_out ^ round_key;

    // Round-key selection
    always @(*) begin
        if (encrypt) begin
            // Encryption: round 0 uses key[0], round 1 key[1], ...
            round_key = round_keys[1407 - round*128 -: 128];
        end else begin
            // Decryption: round 1 uses key[10], round 2 key[9], ..., round 10 key[1]
             round_key = round_keys[1407 - (10 - round)*128 -: 128];
        end
    end

    // Main FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round      <= 0;
            state      <= 0;
            ciphertext <= 0;
            done       <= 0;
            busy       <= 0;
        end else if (start && !busy) begin
            busy  <= 1;
            done  <= 0;
            round <= 1;
            if (encrypt) begin
                // Initial AddRoundKey for encryption (use key[0])
                state <= plaintext ^ round_keys[1407 -: 128];
            end else begin
                // Initial AddRoundKey for decryption (use key[10])
                state <= plaintext ^ round_keys[127:0];
            end
        end else if (busy && round < 10) begin
            if (encrypt) begin
                // Encryption intermediate round: Sub→Shift→Mix→AddKey
                state <= mix_columns_out ^ round_key;
            end else begin
                // Decryption intermediate round: InvShift→InvSub→AddKey→InvMix
                state <= inv_mix_columns_out;
            end
            round <= round + 1;
        end else if (busy && round == 10) begin
            if (encrypt) begin
                // Encryption final round: Sub→Shift→AddKey 
                ciphertext <= shift_rows_out ^ round_key;
            end else begin
                // Decryption final round: InvShift→InvSub→AddKey 
                ciphertext <= after_key;
            end
            busy  <= 0;
            done  <= 1;
            round <= 0;
        end
    end
endmodule

