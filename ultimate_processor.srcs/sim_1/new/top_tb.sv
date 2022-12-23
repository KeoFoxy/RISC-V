`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.12.2022 13:18:11
// Design Name: 
// Module Name: top_tb
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


module top_tb();

    bit clk, rst_n;
    
    int CLK_PERIOD = 10;

    
risc_v dut
(
    .CLK(clk), 
    .RST(rst_n)
);
    
    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end
    
    initial begin
        rst_n = '0;
        
        repeat(10) @(posedge clk);
        #(2);
        rst_n = '1;
        
        repeat(1000) @(posedge clk);
        $finish;
    
    end
    
endmodule
