// Compression module that compresses data based on error margin
module axba_compression (
    input logic clk,
    input logic reset,
    input logic [255:0] data_in, // 256-bit input (8 words of 32 bits)
    input logic [31:0] error_margin, // Error margin for compression
    output logic [31:0] compressed_data [7:0], // Compressed data output
    output logic compressed_valid // Indicates validity of compressed data
);

    logic [31:0] base_word;
    logic [31:0] current_word;
    logic [2:0] state;
    int i;

    always_ff @(posedge clk or posedge reset) begin
    state <= 0;
            base_word <= 32'b0;
            compressed_valid <= 1'b0;
            for (i = 0; i < 8; i++) compressed_data[i] <= 32'b0;
        if (reset) begin
            state <= 0;
            base_word <= 32'b0;
            compressed_valid <= 1'b0;
            for (i = 0; i < 8; i++) compressed_data[i] <= 32'b0;
        end else begin
            case (state)
                0: begin
                    base_word <= data_in[31:0];
                    compressed_data[0] <= data_in[31:0];
                    state <= 1;
                end
                1: begin
                    for (i = 1; i < 8; i++) begin
                        current_word = data_in[i*32+:32]; // Extract 32-bit word
                        // Check if current word is within error margin of base word
                        if (abs(base_word - current_word) <= error_margin) begin
                            compressed_data[i] <= base_word; // Compress
                        end else begin
                            compressed_data[i] <= current_word; // Keep as is
                            base_word <= current_word; // Update base word
                        end
                    end
                    compressed_valid <= 1'b1;
                    state <= 0; // Reset state for next input
                end
            endcase
        end
    end

    // Function to calculate absolute value
    function [31:0] abs;
        input [31:0] a;
        begin
            abs = a[31] ? -a : a;
        end
    endfunction

endmodule