// EEM16 - Logic Design
// Design Assignment #3.1
// dassign3_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************

// 3.1a) Rectified linear unit
// out = max(0, in/4)
// 16 bit signed input
// 8 bit unsigned output
module relu(in, out);
    input [15:0] in;
    output [7:0] out;
  
  // your code here
  // combinational logic and shifting
  assign out = in[15] ? 8'b0 : in[9:2];
  
endmodule

// 3.1b) Pipelined 5 input ripple-carry adder
// 16 bit signed inputs
// 1 bit input: valid (when the other inputs are useful numbers)
// 16 bit signed output (truncated)
// 1 bit output: ready (when the output is the sum of valid inputs)
module piped_adder(clk, a, b, c, d, e, valid, sum, ready);
    input clk, valid;
    input [15:0] a, b, c, d, e;
    output [15:0] sum;
    output ready;
  
    // your code here 
  // first adder
  wire [2:0] co1, ci1;
  wire [3:0] sum1;
  adder5carry adder1 (a[3:0], b[3:0], c[3:0], d[3:0], e[3:0],1'b0, 1'b0, 1'b0, co1[0], co1[1], co1[2], sum1);
  
  // first pipeline
  wire [7:0] sum2;
  wire ready1;
  wire [11:0] awire1, bwire1, cwire1, dwire1, ewire1;
  dreg #(4) sumreg1 (clk, sum1, sum2[3:0]);
  dreg #(1) readyreg1 (clk, valid, ready1);
  dreg #(3) carryreg1 (clk, co1, ci1);
  dreg #(12) areg1 (clk, a[15:4], awire1);
  dreg #(12) breg1 (clk, b[15:4], bwire1);
  dreg #(12) creg1 (clk, c[15:4], cwire1);
  dreg #(12) dreg1 (clk, d[15:4], dwire1);
  dreg #(12) ereg1 (clk, e[15:4], ewire1);
  
  // second adder
  wire [2:0] ci2, co2;
  adder5carry adder2 (awire1[3:0], bwire1[3:0], cwire1[3:0], dwire1[3:0], ewire1[3:0], ci1[0], ci1[1], ci1[2], co2[0], co2[1], co2[2], sum2[7:4]);
  
  // second pipeline
  wire [11:0] sum3;
  wire ready2;
  wire [7:0] awire2, bwire2, cwire2, dwire2, ewire2;
  dreg #(8) sumreg2 (clk, sum2, sum3[7:0]);
  dreg #(1) readyreg2 (clk, ready1, ready2);
  dreg #(3) carryreg2 (clk, co2, ci2);
  dreg #(8) areg2 (clk, awire1[11:4], awire2);
  dreg #(8) breg2 (clk, bwire1[11:4], bwire2);
  dreg #(8) creg2 (clk, cwire1[11:4], cwire2);
  dreg #(8) dreg2 (clk, dwire1[11:4], dwire2);
  dreg #(8) ereg2 (clk, ewire1[11:4], ewire2);
  
  // third adder
  wire [2:0] ci3, co3;
  adder5carry adder3 (awire2[3:0], bwire2[3:0], cwire2[3:0], dwire2[3:0], ewire2[3:0], ci2[0], ci2[1], ci2[2], co3[0], co3[1], co3[2], sum3[11:8]);
  
  // third pipeline
  wire [15:0] sum4;
  wire ready3;
  wire [3:0] awire3, bwire3, cwire3, dwire3, ewire3;
  dreg #(12) sumreg3 (clk, sum3, sum4[11:0]);
  dreg #(1) readyreg3 (clk, ready2, ready3);
  dreg #(3) carryreg3 (clk, co3, ci3);
  dreg #(4) areg3 (clk, awire2[7:4], awire3);
  dreg #(4) breg3 (clk, bwire2[7:4], bwire3);
  dreg #(4) creg3 (clk, cwire2[7:4], cwire3);
  dreg #(4) dreg3 (clk, dwire2[7:4], dwire3);
  dreg #(4) ereg3 (clk, ewire2[7:4], ewire3);
  
  // last adder
  wire [2:0] co4;
  adder5carry adder4 (awire3, bwire3, cwire3, dwire3, ewire3, ci3[0], ci3[1], ci3[2], co4[0], co4[1], co4[2], sum4[15:12]);
  
  dreg #(16) sumreg4(clk, sum4, sum);
  dreg #(1) readyreg4(clk, ready3, ready);
 
endmodule

// 3.1c) Pipelined neuron
// 8 bit signed weights, bias (constant)
// 8 bit unsigned inputs 
// 1 bit input: new (when a set of inputs are available)
// 8 bit unsigned output 
// 1 bit output: ready (when the output is valid)
module neuron(clk, w1, w2, w3, w4, b, x1, x2, x3, x4, new, y, ready);
    input clk;
    input [7:0] w1, w2, w3, w4, b;  // signed 2s complement
    input [7:0] x1, x2, x3, x4;     // unsigned
    input new;
    output [7:0] y;                 // unsigned
    output ready;

    // your code here
  wire [3:0] readymult;
  
  // four multipliers for weights and values
  wire [15:0] result1;
  multiply seqmult1 (clk, w1, x1, new, result1, readymult[0]);
  
  wire [15:0] result2;
  multiply seqmult2 (clk, w2, x2, new, result2, readymult[1]);
  
  wire [15:0] result3;
  multiply seqmult3 (clk, w3, x3, new, result3, readymult[2]);
  
  wire [15:0] result4;
  multiply seqmult4 (clk, w4, x4, new, result4, readymult[3]);
  
  // make sure to sign extend the bias
  wire [15:0] signextendedbias;
  assign signextendedbias = {{8{b[7]}},b};
  
  // adder
  wire [15:0] sumresult;
  piped_adder adder (clk, result1, result2, result3, result4, signextendedbias, &readymult[3:0], sumresult, ready);
  
  // relu
  relu rectifier (sumresult, y);
endmodule

