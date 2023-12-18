`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 11:19:18 AM
// Design Name: 
// Module Name: MainMemory
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


module MainMemory(
    input logic clk,
    input logic valid,
    output logic ready,
    input logic [31:0] addr,
    output logic [31:0] data_out,
    output logic [255:0] DatfromMem,
    output logic [31:7] Tag,
    output logic sent,
    input logic wr_en,
    input logic [31:0] data_in
);

    parameter MAIN_MEMORY_SIZE = 8192;
    parameter LINE_SIZE = 32;
    parameter LINES = MAIN_MEMORY_SIZE/LINE_SIZE;           //256 BLOCKS

    logic [7:0] memory[MAIN_MEMORY_SIZE-1:0];
    logic [31:0] read_data;
    logic [12:0] word_begin_addr; //word addressable 
    logic [31:0] start;
    int x;

    initial begin
        for (int i = 8'd0; i < MAIN_MEMORY_SIZE; i = i + 8'd1) begin
            memory[i] = i%10;
        end
    end
    
    
    always_ff @(posedge clk) begin
        // Default assignments
        ready <= 0;
        data_out <= read_data;
        sent <= 0;
        
        if(wr_en) begin
            word_begin_addr <= addr[10:0]<<2;
        x = word_begin_addr;
            
            memory[x]=data_in[31:24];
            memory[x+1]=data_in[23:16];
            memory[x+2]=data_in[15:8];
            memory[x+3]=data_in[7:0];
            
            $display("memory updated");
        end
        // FSM for handling inputs
        if (valid) begin
            ready <= 1;
//            word_begin_addr <= addr[10:0]<<2;
            read_data <= {memory[word_begin_addr], memory[word_begin_addr+1], memory[word_begin_addr+2], memory[word_begin_addr+3]};
            start = (addr >> 3) << 5;
            Tag <= addr[31:7];
            DatfromMem <= {memory[start],memory[start+1],memory[start+2],memory[start+3],memory[start+4],memory[start+5],memory[start+6],memory[start+7],memory[start+8],memory[start+9],memory[start+10],memory[start+11],memory[start+12],memory[start+13],memory[start+14],memory[start+15],memory[start+16],memory[start+17],memory[start+18],memory[start+19],memory[start+20],memory[start+21],memory[start+22],memory[start+23],memory[start+24],memory[start+25],memory[start+26],memory[start+27],memory[start+28],memory[start+29],memory[start+30],memory[start+31]};
           $display("addr = %d DatfromMem = %h", addr,DatfromMem);
            sent <= 1;
        end
    end

endmodule