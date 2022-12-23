module mem_tb();
integer i;
reg [31:0] RD [3:0]; 

initial
begin
    #10;
    $readmemb("D:\\8200434\\data.txt", RD);
   
    for (i=0; i < 4; i = i + 1)
    begin
        $display("%b", RD[i]);
    end
    #10
    $finish;
 end


endmodule