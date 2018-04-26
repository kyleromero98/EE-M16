// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.1
// dassign2_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// ***************
// Building blocks
// ***************

// D-register (flipflop).  Width set via parameter.
// Includes propagation delay t_PD = 3
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= #3 d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux2(a, b, sel, y);
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign #3 y = sel ? b : a;
endmodule

// Left-shifter
// No propagation delay, it's just wires really
module shl(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {a[width-2:0], 1'b0};
endmodule

// Right-shifter
// more wires 
module shr(a, y);
    parameter width = 1;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {1'b0, a[width-1:1]};
endmodule

// 16-bit adder (declarative Verilog)
// Includes propagation delay t_PD = 3n = 48
module adder16(a, b, sum);
    input [15:0] a, b;
    output [15:0] sum;

    assign #48 sum = a+b;
endmodule

// ****************
// Blocks to design
// ****************

// Lowest order partial product of two inputs 
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module partial_product (a, b, pp);
  // your code here
  // Include a propagation delay of #1
  // assign #1 pp = ... ;
  output [15:0] pp;
  input [15:0] a;
  input [7:0] b;
  
  // compute the partial product by ANDing verything
  // in b with a[0]
  assign #1 pp[15:0] = {a[15]&b[0],
                        a[14]&b[0],
                        a[13]&b[0],
                        a[12]&b[0],
                        a[11]&b[0],
                        a[10]&b[0],
                        a[9]&b[0],
                        a[8]&b[0],
                        a[7]&b[0],
                        a[6]&b[0],
                        a[5]&b[0],
                        a[4]&b[0],
                        a[3]&b[0],
                        a[2]&b[0],
                        a[1]&b[0],
                        a[0]&b[0]};
endmodule

// Determine if multiplication is complete
// Use declarative verilog only
// IMPORTANT: Do not change module or port names
module is_done (a, b, done);
  // your code here
    // Include a propagation delay of #4
    // assign #4 done = ... ;
  input [15:0]a;
  input [7:0]b;
  output done; 
  
  // we are done if either number is all 0s
  assign #4 done = (~| a[15:0]) | (~| b[7:0]);

endmodule

// 8 bit unsigned multiply 
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module multiply (clk, ain, bin, reset, prod, ready);
  // your code here
  // do not use any delays!
    input clk;
    input [7:0] ain, bin;
    input reset;
    output [15:0] prod;
    output ready;
  
  // a reg and reset selecting
  wire [7:0]bregin;
  wire [7:0]bregout;
  wire [7:0]bshifted;
  // compute a shifter right 1
  shr #(8) bshifter(bregout, bshifted);
  // select for new ain or shifted ain from last iteration
  mux2 #(8) breset(bshifted, bin, reset, bregin);
  // store values and feedback
  dreg #(8) breg(clk, bregin, bregout);
  
  // b reg and reset selecting; same structure as a block
  wire [15:0]aregin;
  wire [15:0]aregout;
  wire [15:0]ashifted;
  shl #(16) ashifter(aregout, ashifted);
  mux2 #(16) areset(ashifted, {8'b00000000, ain[7:0]}, reset, aregin);
  dreg #(16) areg(clk, aregin, aregout);
  
  // computer the partial product
  wire [15:0]partialproduct;
  partial_product multiplier(aregout, bregout, partialproduct);
  
  // add the partial product to the current stored sum
  wire [15:0]sum;
  adder16 adder(partialproduct, prod, sum);
  
  // reset sets all to 0s and not reset passes in accumulated value
  wire [15:0]sumresetwire;
  mux2 #(16) accumreset(sum, 16'b0000000000000000, reset, sumresetwire);
  dreg #(16) accumulator(clk, sumresetwire, prod);
  
  // flag that we are done
  is_done isdone(aregout, bregout, ready);
    
endmodule

// Clock generation.  Period set via parameter:
//   clock changes every half_period ticks
//   full clock period = 2*half_period
// Replace half_period parameter with desired value
module clock_gen(clk);
    parameter half_period = 30; // REPLACE half_period HERE
    output clk;
    reg    clk;

    initial clk = 0;
    always #half_period clk = ~clk;
endmodule
