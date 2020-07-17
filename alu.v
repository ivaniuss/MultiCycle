module muxDos (d0, d1, s, y);
    input [31:0] d0, d1;
    input s;
    output [31:0] y;

    assign y = s ? d1 : d0;

endmodule

module muxCuatro (d0, d1, d2, d3, s, y);
    input [31:0] d0, d1, d2, d3;
    input [1:0] s;
    output [31:0] y;

    wire [31:0] n0, n1;

    muxDos mm0 (d0, d1, s[0], n0);
    muxDos mm1 (d2, d3, s[0], n1);

    muxDos mmm (n0, n1, s[1], y);

endmodule

//-------------------------------------------------------------

module Adder (Sa, Sb, Sum);
    input [31:0] Sa, Sb;
    output [31:0] Sum;

    wire [32:0] Aux;

    assign Aux = Sa + Sb;

    assign Sum = Aux[31:0];

endmodule

//-------------------------------------------------------------

module zeroExt (bitIn, wordOut);
    input bitIn;
    output [31:0] wordOut;

    assign wordOut = {31'b0, bitIn};

endmodule

//-------------------------------------------------------------

module alu (AluOp, A, B, Result, Zero);
    input [3:0] AluOp;
    input [31:0] A, B;
    output [31:0] Result;
    output Zero;

    wire [31:0] minusB, selB, AplusB, AlessthanB, selArit, AandB, AorB, AxorB, selLog;

    //Parte Aritmetica
    assign minusB = ~B + 1;

    muxDos mxB (B, minusB, AluOp[1], selB);

    Adder apb (A, selB, AplusB);

    zeroExt slt (AplusB[31], AlessthanB);

    muxDos mxArit (AplusB, AlessthanB, AluOp[3], selArit);


    //Parte Logica
    assign AandB = A & B;

    assign AorB = A | B;

    assign AxorB = A ^ B;

    muxCuatro mxLog (AandB, AorB, AxorB, ~AorB, AluOp[1:0], selLog);


    //Parte final
    muxDos mxfinal (selArit, selLog, AluOp[2], Result);

    assign Zero = ~( | Result);

endmodule