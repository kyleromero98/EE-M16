// EEM16 - Logic Design
// Design Assignment #3.2
// dassign3_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

// ****************
// Blocks to design
// ****************

// 3.2a) Inter-layer module
// four sets of inputs: 8 bit value, 1 bit input ready
// one 1 bit input new (from input layer of neurons)
// four sets of 8 bits output
// one 1 bit output ready
module interlayer(clk, new, in1, ready1, in2, ready2, in3, ready3, in4, ready4,
                  out1, out2, out3, out4, ready_out);
    input clk;
    input new;
    input [7:0] in1, in2, in3, in4;
    input ready1, ready2, ready3, ready4;
    output [7:0] out1, out2, out3, out4;
    output ready_out;

    // your code here
  wire pass;
  assign pass = (ready1&ready2&ready3&ready4);
  dreg #(8) outreg1 (pass, in1, out1);
  dreg #(8) outreg2 (pass, in2, out2);
  dreg #(8) outreg3 (pass, in3, out3);
  dreg #(8) outreg4 (pass, in4, out4);
  
  wire pass_out;
  dreg #(1) pass_reg (clk, pass, pass_out);
  
  assign ready_out = pass ^ pass_out;
 
endmodule
