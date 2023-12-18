`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 11:18:05 AM
// Design Name: 
// Module Name: L1D_Cache
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


module L1D_Cache(
    input logic clk,
    input logic [31:0] addr,     // Address input
    output logic [31:0] data_out,
    output logic miss,
    output logic valid,
    input logic ready,
    input logic [255:0]DatfromMem,
    input logic [31:7] Tag,
    output logic [31:0] memaddr,
    input logic sent,
    input logic wr_en,
    input logic [31:0] data_in,
    input logic decompressedvalid
    );
    parameter OFFSET_SIZE = 3;
    parameter INDEX_SIZE = 4;
    parameter TAG_SIZE = 25;
    parameter CACHE_SIZE = 2048;
    parameter ASSOC = 4;
    parameter LINE_SIZE = 32;
    parameter WORDS = LINE_SIZE/4;
    parameter SETS = CACHE_SIZE/(LINE_SIZE*ASSOC);          //16 sets 
    
    logic[TAG_SIZE-1:0] addrTag;
    logic[INDEX_SIZE-1:0] addrIndex;
    logic[OFFSET_SIZE-1:0] addrOffset;
    logic hit,filled,fill;
    int x;
    typedef struct {
        logic linevalid;
        logic[TAG_SIZE-1:0] tag;
        logic [255:0] data;   // 32 bytes = 8 words
    } cache_line;

    cache_line cache[SETS-1:0][ASSOC-1:0]; // 4-way set associative, 16 sets
    
    initial begin
        
        for(int i = 0; i< SETS ; i=i+1) begin
            for( int j =0;j<ASSOC;j=j+1) begin
                cache[i][j].linevalid = 0;
                cache[i][j].tag = 0;
                cache[i][j].data = 0;
            end                
        end
end
    
    
        assign addrTag = addr[31:32-TAG_SIZE];
        assign addrIndex = addr[32-TAG_SIZE-1:OFFSET_SIZE];
        assign addrOffset = addr[OFFSET_SIZE-1:0];
    
    always_ff @(posedge clk) begin
    if(wr_en) begin
        for (int i=0;i<ASSOC;i=i+1) begin
            if(cache[addrIndex][i].linevalid && cache[addrIndex][i].tag==addrTag) begin
                x= int'(addrOffset)<<5;
                cache[addrIndex][i].data[255 - x -: 32]<= data_in;
                $display("data updated in cache");
            end
        end
        end
    end
    always_ff @(posedge clk) begin
        for(int i = 0;i<ASSOC;i=i+1) begin
        if(cache[addrIndex][i].linevalid && cache[addrIndex][i].tag==addrTag) begin
            hit<=1;
            miss<=0;
            x= int'(addrOffset)<<5;
            data_out <= cache[addrIndex][i].data[255 - x -: 32];
            break;
        end
        else begin
        hit<=0;
        end 
        end
    end
    
    always_ff @(posedge clk) begin
    if(!hit)begin
        miss <= 1;
        valid <= 1;
    end
    
    
    end
    
    always_ff @(posedge clk) begin
    if(ready) begin
        memaddr <= addr;
    end
    end
    
    always_ff @(posedge clk) begin
    if(sent) begin
        valid <=0;
        filled <= 0;
        
        
        for(int i = 0;i<ASSOC;i=i+1) begin
        if(!cache[addrIndex][i].linevalid && decompressedvalid) begin
            cache[addrIndex][i].tag <= Tag;
            cache[addrIndex][i].data <= DatfromMem;
            cache[addrIndex][i].linevalid <=1;
            filled<=1;
            break;
        end
        end        
    end
    end
    always_ff @(posedge clk) begin
    if(sent && !filled && decompressedvalid)begin
        fill = $random%ASSOC;
        cache[addrIndex][fill].tag <= Tag;
        cache[addrIndex][fill].data <= DatfromMem;
        cache[addrIndex][fill].linevalid <=1;
        filled <=1;
    
    end
    end
    
    

endmodule
