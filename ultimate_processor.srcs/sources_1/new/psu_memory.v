`timescale 1ns / 1ps

module psu_memory(A, CLK, RD);
input CLK;
input [31:0] A;
reg [31:0] DATA [0:255];
output [31:0] RD;  

initial
begin
    $readmemh("i_ram.txt", DATA);
end

assign RD = DATA[A[31:2]];

 

endmodule

