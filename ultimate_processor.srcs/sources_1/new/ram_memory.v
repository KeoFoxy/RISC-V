`timescale 1ns / 1ps

module ram_memory(CLK, A1, A2, A3, WD3, WE3, RD1, RD2);
//integer i;
//reg data_getted;
input CLK;
input [4:0] A1;
input [4:0] A2;
input [4:0] A3;
input [31:0] WD3;
reg [31:0] data [0:31];

//initial
//begin
//for (i = 0; i < 32; i = i + 1) begin
//    data[i] = 32'b0;
//end
//data_getted = 0;
//end

input WE3;
output [31:0] RD1;
output [31:0] RD2;

assign RD1 = (A1 == 5'b0) ? 32'b0 : data[A1];
assign RD2 = (A2 == 5'b0) ? 32'b0 : data[A2];


always @(posedge CLK)
if (WE3)
    data[A3] <= WD3;



endmodule