`timescale 1ns / 1ps

module aes_encrypt_tb;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [127:0] plaintext;
    reg [127:0] key;
    reg encrypt;

    // Outputs
    wire [127:0] ciphertext;
    wire done;

    // Intermediate storage for output
    reg [127:0] enc_result;
    reg [127:0] dec_result;

   
    aes_128 uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .encrypt(encrypt),        // 1 for encrypt, 0 for decrypt
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz
    end

    // Test sequence
    initial begin
        // Initialize
        rst = 0;
        start = 0;
        encrypt = 1;  // start with encryption
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key =       128'h000102030405060708090a0b0c0d0e0f;

        // Reset pulse
        #10 rst = 1;
        #10 rst = 0;

        // Start encryption
        #10;
        start = 1;
        #10;
        start = 0;

        // Wait for encryption to complete
        wait (done == 1);
        enc_result = ciphertext;
        $display("Encrypted Ciphertext: %h", enc_result);

        // Start decryption using the ciphertext
        #20;
        encrypt = 0;  // switch to decryption
        plaintext = enc_result; // input is now ciphertext
        start = 1;
        #10;
        start = 0;

        // Wait for decryption to complete
        wait (done == 1);
        dec_result = ciphertext;
        $display("Decrypted Plaintext:  %h", dec_result);

        // Finish
        #20;
        $finish;
    end

endmodule
