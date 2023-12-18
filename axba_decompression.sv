`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 08:59:15 PM
// Design Name: 
// Module Name: axba_decompression
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Decompression module to decompress the compressed data
module axba_decompression (
    input logic clk,
    input logic reset,
    input logic [31:0] compressed_data [7:0], // Compressed data input
    input logic compressed_valid, // Validity of compressed data
    output logic [255:0] decompressed_data, // Decompressed data output
    output logic decompressed_valid // Indicates validity of decompressed data
);

    int i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            decompressed_valid <= 1'b0;
            decompressed_data <= 256'b0;
        end else if (compressed_valid) begin
            for (i = 0; i < 8; i++) begin
                decompressed_data[i*32+:32] <= compressed_data[i];
            end
            decompressed_valid <= 1'b1;
        end
    end

endmodule