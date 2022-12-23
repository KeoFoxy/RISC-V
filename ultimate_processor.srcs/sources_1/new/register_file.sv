module register_file(
    input            CLK,
    input            WE3,       
    input  [4:0]       A1,
    input  [4:0]       A2,
    input  [4:0]       A3,
    input  [31:0]     WD3,
    output [31:0]     RD1,
    output [31:0]     RD2
);
    
logic [31:0] MEM [0:31];

assign RD1 = (A1 == 0) ? 32'b0 : MEM[A1];
assign RD2 = (A2 == 0) ? 32'b0 : MEM[A2];


always_ff @(posedge CLK) begin
        if(WE3) MEM[A3] <= WD3;
    end
endmodule