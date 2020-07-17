`include "mipsmulti.v"
module controllertest_tb;
        reg        clk, reset;
        reg  [5:0] op, funct;
        reg        zero;
        wire       pcen, memwrite, irwrite, regwrite;
        wire       alusrca, iord, memtoreg, regdst;
        wire [1:0] alusrcb, pcsrc;
        wire [3:0] alucontrol;

    initial
    begin
        clk = 1'b1;
        forever
            #5 clk = ~clk;
    end

    initial
    begin
        #0 reset = 1'b1; #1 reset = 1'b0;
        //------------------------------------------------- 
        op = 6'b100011; funct = 6'bxxxxxx; zero = 1'bx; #50 //LW: fetch decode memadr memrd memwb
        op = 6'b101011; funct = 6'bxxxxxx; zero = 1'bx; #40 //SW: memwr
        op = 6'b000000; funct = 6'b100000; zero = 1'bx; #40 //R-type: rtypeEx rtypewb
        op = 6'b000100; funct = 6'bxxxxxx; zero = 1'b1; #30 //BEQ: beqex
        op = 6'b001000; funct = 6'bxxxxxx; zero = 1'bx; #40 //ADDI: addiex addiwb
        op = 6'b000010; funct = 6'bxxxxxx; zero = 1'bx; #30 //J: jex
        
        $finish;
    end
    controller c(clk, reset, op, funct, zero,
               pcen, memwrite, irwrite, regwrite,
               alusrca, iord, memtoreg, regdst, 
               alusrcb, pcsrc, alucontrol);

    initial begin
        $dumpfile ("controllertest.vcd");
        $dumpvars;
    end
endmodule