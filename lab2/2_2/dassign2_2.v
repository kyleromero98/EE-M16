// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.2
// dassign2_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs

`include "constants2_2.vh"

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

// 4-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux4(a, b, c, d, sel, y);
    parameter width = 1;
    input [width-1:0] a, b, c, d;
    input [1:0] sel;
    output [width-1:0] y;
    reg [width-1:0] y;

    always @(*) begin
        case (sel)
            2'b00:    y <= #3 a;
            2'b01:    y <= #3 b;
            2'b10:    y <= #3 c;
            default:  y <= #3 d;
        endcase
    end
endmodule

// ****************
// Blocks to design
// ****************

// Evaluates incoming pulses/gaps 
// Use any combination of declarative or structural verilog
// IMPORTANT: Do not change module or port names
module pulse_width(clk, in, pwidth, long, type, new);
    parameter width = 8;
    input clk, in;
    output [width-1:0] pwidth;
    output long, type, new;
  
  // your code here
  // do not use any delays!
  
  // type is just in delayed by 1
  dreg #(1) typeholder(clk, in, type);
  // xor last with current to see if it changed
  assign new = type ^ in;
  
  wire [width-1:0] resetcounter;
  wire [width-1:0] sum;
  
  // accumulate the running signal
  mux2 #(width)resetcountermux(pwidth, 1'b0, new, resetcounter);
  adder addone(resetcounter, 1'b1, sum);
  dreg #(width) counter(clk, sum, pwidth);
  
  // assign long if accumulated value is greater and signal has
  // just ended
  assign long = (pwidth > `THRESHOLD) & new;
  
endmodule

// Four valued shift-register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module shift4(clk, in, cmd, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input [`CMD_WIDTH-1:0] cmd;
    output [width-1:0] out3, out2, out1, out0;

    // your code here
    // do not use any delays!
  wire [width-1:0] muxzero_out, muxone_out, muxtwo_out, muxthree_out;
  
  // stores each of the values
  dreg #(width) regzero(clk, muxzero_out, out0);
  dreg #(width) regone(clk, muxone_out, out1);
  dreg #(width) regtwo(clk, muxtwo_out, out2);
  dreg #(width) regthree(clk, muxthree_out, out3);
  
  // reassigns the values according to cmd input
  mux4 #(width) muxone({1'b0}, in, out0, {1'b0}, cmd, muxzero_out);
  mux4 #(width) muxtwo({1'b0}, out0, out1, {1'b0}, cmd, muxone_out);
  mux4 #(width) muxthree({1'b0}, out1, out2, {1'b0}, cmd, muxtwo_out);
  mux4 #(width) muxfour({1'b0}, out2, out3, {1'b0}, cmd, muxthree_out);

endmodule

// Control FSM for shift register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module control_fsm(clk, long, type, cmd, done);
    input clk, long, type;
    output [`CMD_WIDTH-1:0] cmd;
    output done;

    // your code here
    // do not use any delays!
  
  // basically, if high at all then a valid signal and hold
  assign cmd[0] = type;
  // low and not long means hold because still transmitting letter
  assign cmd[1] = ~type & ~long;
  // if we get a low signal that is long then we need to clear,
  // this is accounted for in above
  
  // we are done if we get long low signal
  assign done = ~type & long;  
endmodule

// Input de-serializer
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module deserializer(clk, in, out3, out2, out1, out0, done);
    parameter width = 8;
    input clk, in;
    output [width-1:0] out3, out2, out1, out0;
    output done;
  
   // your code here
    // do not use any delays!
  
  wire [width-1:0] pwidth;
  wire long, type, new, done_out;
  wire [`CMD_WIDTH-1:0] cmd, cmd_ctrl;

  // basically just wire everything together
  pulse_width #(width) pulser (clk, in, pwidth, long, type, new);
  control_fsm control(clk, long, type, cmd_ctrl, done_out);
  
  // here we need to select to only change when new signal
  mux2 #(`CMD_WIDTH) cmd_mux(`CMD_HOLD, cmd_ctrl, new, cmd);
  mux2 done_mux(1'b0, done_out, new, done);
  
  shift4 #(width) shift(clk, pwidth, cmd, out3, out2, out1, out0);

endmodule

module adder(a, b, sum);
  parameter width = 8;
  input [width-1:0] a, b;
  output [width-1:0] sum;

    assign sum = a+b;
endmodule
