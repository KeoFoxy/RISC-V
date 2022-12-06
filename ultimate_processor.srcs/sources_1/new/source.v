`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2022 16:19:18
// Design Name: 
// Module Name: source
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


module source(
    input [6:0] SW,
    output [7:0] AN,
    output [6:0] HEX
    );

assign AN[0] = 1'b0;
assign AN[1] = 1'b0;
assign AN[2] = 1'b0;
assign AN[3] = 1'b0;

assign HEX[6:0] = SW[6:0];
   
endmodule
