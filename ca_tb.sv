`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2023 10:18:43 AM
// Design Name: 
// Module Name: ca_tb
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


module ca_tb();
    
    logic clk,valid,ready,miss,wr_en;
    logic [31:0] addr, data_out,data_in;
    TopModule test(.clk(clk),.addr(addr),.data_out(data_out),.valid(valid),.ready(ready),.miss(miss),.wr_en(wr_en),.data_in(data_in));
    initial begin               //initialize variables
    clk = 1'b0;
    addr = 0;
    wr_en=0;
    data_in=0;
    $display("Starting the simulation for CA Project");
    end
    initial begin
//    #100 addr =1;
//    $display("addr = %d",addr);
//    $display("data = %d",data_out);
    #100 ;
    data_in=255;
    addr=1;
    
    #100 wr_en=0;
    addr= 6;
    
    #100 addr = 64;
//    data_in=20;
//    #200 wr_en=1;
//    addr = 5;
//    data_in = 15;
//    #100 wr_en=0;
//    addr = 9;
    
//    #100 wr_en =1;
//    addr=128;
//    data_in=42;
//    #100 wr_en = 0;
////    addr=0;

//    $display("addr = %d",addr);
//    $display("data = %d",data_out);
//    #50 addr = 80;
//    $display("addr = %d",addr);
//    $display("data = %d",data_out);
//    #50 addr = 255;
//    $display("addr = %d",addr);
//    $display("data = %d",data_out);
    
    #200 $finish;
   
    
    
    
    
    end
    always #5 clk = ~clk;
endmodule
