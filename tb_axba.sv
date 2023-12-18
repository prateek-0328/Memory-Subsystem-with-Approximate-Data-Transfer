`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 09:02:05 PM
// Design Name: 
// Module Name: tb_axba
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


// Testbench for AxBA compression and decompression
module tb_axba;

    logic clk;
    logic reset;
    logic [255:0] data_in;
    logic [31:0] error_margin;
    logic [31:0] compressed_data [7:0];
    logic compressed_valid;
    logic [255:0] decompressed_data;
    logic decompressed_valid;

    axba_compression compression (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .error_margin(error_margin),
        .compressed_data(compressed_data),
        .compressed_valid(compressed_valid)
    );

    axba_decompression decompression (
        .clk(clk),
        .reset(reset),
        .compressed_data(compressed_data),
        .compressed_valid(compressed_valid),
        .decompressed_data(decompressed_data),
        .decompressed_valid(decompressed_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        clk = 0;
        reset = 1;
        error_margin = 32'h00000010; // Example error margin
        data_in = {32'hAABBCCDD, 32'hAACBCCDE, 32'hAABBCCDF, 32'hAABBCCD0,
                   32'hAABBCCD1, 32'hAABBCCD2, 32'hAABBCCD3, 32'hAABBCCD4};
        #10;
        reset = 0;
        #10;
        
        // Wait for compression and decompression
        #100;

        // Finish the simulation
        $finish;
    end

endmodule