// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.3
// dassign1_3.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of the given stubs

/* Arrays for convenience

  | abcdefghijklmnopqrstuvwxyz  <-- letter
__|___________________________
G | 11111111001001111111000111
F | 11001111001100011010101010
E | 11111101011111110100110001
D | 01111010011100100010111111
C | 11010011110011101011110010
B | 10010011110000011001101011
A | 10001110000010011010000101
^-- display segment
~~~

  | GFEDCBA <-- display segment
__|________
a | 1110111
b | 1111100
c | 1011000
d | 1011110
e | 1111001
f | 1110001
g | 1101111
h | 1110110
i | 0000110
j | 0011110
k | 1111000
l | 0111000
m | 0010101
n | 1010100
o | 1011100
p | 1110011
q | 1100111
r | 1010000
s | 1101101
t | 1000110
u | 0111110
v | 0011100
w | 0101010
x | 1001001
y | 1101110
z | 1011011
^-- letter
*/

// Display driver (procedural verilog)
// IMPORTANT: Do not change module or port names
module display_rom (letter, display);
    input   [4:0] letter;
    output  [6:0] display;
  
  	// reassign wires as regs for ROMs
  	reg [6:0] display;

  	// your code here
    // do not use any delays!
  	always @ (letter) 	
      begin
    	case(letter)
          	5'd00: assign display = 7'b1110111; //a
      		5'd01: assign display = 7'b1111100; //b
      		5'd02: assign display = 7'b1011000; //c
      		5'd03: assign display = 7'b1011110; //d
      		5'd04: assign display = 7'b1111001; //e
      		5'd05: assign display = 7'b1110001; //f
      		5'd06: assign display = 7'b1101111; //g
      		5'd07: assign display = 7'b1110110; //h
      		5'd08: assign display = 7'b0000110; //i
      		5'd09: assign display = 7'b0011110; //j
      		5'd10: assign display = 7'b1111000; //k
      		5'd11: assign display = 7'b0111000; //l
      		5'd12: assign display = 7'b0010101; //m
      		5'd13: assign display = 7'b1010100; //n
      		5'd14: assign display = 7'b1011100; //o
      		5'd15: assign display = 7'b1110011; //p
      		5'd16: assign display = 7'b1100111; //q
      		5'd17: assign display = 7'b1010000; //r
      		5'd18: assign display = 7'b1101101; //s
      		5'd19: assign display = 7'b1000110; //t
      		5'd20: assign display = 7'b0111110; //u
      		5'd21: assign display = 7'b0011100; //v
      		5'd22: assign display = 7'b0101010; //w
      		5'd23: assign display = 7'b1001001; //x
      		5'd24: assign display = 7'b1101110; //y
      		5'd25: assign display = 7'b1011011; //z
      		default: assign display = 7'b1000000; // anything else
    	endcase
      end
endmodule

module eightToOneMux (values, sel, o); 
  input [7:0] values; 
  input [2:0] sel; 
  output o; 
  reg    o; 
 
  always @(values or sel) 
  begin 
    if (sel == 3'b111) 
      o = values[0]; 
    else if (sel == 3'b110) 
      o = values[1]; 
    else if (sel == 3'b101) 
      o = values[2]; 
    else if (sel == 3'b100)              
      o = values[3]; 
    else if (sel == 3'b011)              
      o = values[4];
    else if (sel == 3'b010)              
      o = values[5];
    else if (sel == 3'b001)              
      o = values[6];
    else if (sel == 3'b000)              
      o = values[7];
  end 
endmodule

module fourToOneMux (values, sel, o); 
  input [3:0] values; 
  input [1:0] sel; 
  output o; 
  reg    o; 
 
  always @(values or sel) 
  begin 
    if (sel == 2'b00) 
      o = values[3]; 
    else if (sel == 2'b01) 
      o = values[2]; 
    else if (sel == 2'b10) 
      o = values[1]; 
    else if (sel == 2'b11)              
      o = values[0]; 
  end 
endmodule

// Display driver (declarative verilog)
// IMPORTANT: Do not change module or port names
module display_mux (letter, g,f,e,d,c,b,a);
    input   [4:0] letter;
    output  g,f,e,d,c,b,a;
  
  	// your code here
    // do not use any delays!
  
  // Codes for each segment of display
  reg [31:0]g_input = 32'b11111111001001111111000111111111;
  reg [31:0]f_input = 32'b11001111001100011010101010000000;
  reg [31:0]e_input = 32'b11111101011111110100110001000000;
  reg [31:0]d_input = 32'b01111010011100100010111111000000;
  reg [31:0]c_input = 32'b11010011110011101011110010000000;
  reg [31:0]b_input = 32'b10010011110000011001101011000000;
  reg [31:0]a_input = 32'b10001110000010011010000101000000;
  
  // Combine and determine g output
  wire [3:0] g_wires;
  eightToOneMux g1(g_input[7:0], letter[2:0], g_wires[0]);
  eightToOneMux g2(g_input[15:8], letter[2:0], g_wires[1]);
  eightToOneMux g3(g_input[23:16], letter[2:0], g_wires[2]);
  eightToOneMux g4(g_input[31:24], letter[2:0], g_wires[3]);
  fourToOneMux g5(g_wires, letter[4:3], g);
  
  // Combine and determine f output
  wire [3:0] f_wires;
  eightToOneMux f1(f_input[7:0], letter[2:0], f_wires[0]);
  eightToOneMux f2(f_input[15:8], letter[2:0], f_wires[1]);
  eightToOneMux f3(f_input[23:16], letter[2:0], f_wires[2]);
  eightToOneMux f4(f_input[31:24], letter[2:0], f_wires[3]);
  fourToOneMux f5(f_wires, letter[4:3], f);
  
  // Combine and determine e output
  wire [3:0] e_wires;
  eightToOneMux e1(e_input[7:0], letter[2:0], e_wires[0]);
  eightToOneMux e2(e_input[15:8], letter[2:0], e_wires[1]);
  eightToOneMux e3(e_input[23:16], letter[2:0], e_wires[2]);
  eightToOneMux e4(e_input[31:24], letter[2:0], e_wires[3]);
  fourToOneMux e5(e_wires, letter[4:3], e);
  
  // Combine and determine d output
  wire [3:0] d_wires;
  eightToOneMux d1(d_input[7:0], letter[2:0], d_wires[0]);
  eightToOneMux d2(d_input[15:8], letter[2:0], d_wires[1]);
  eightToOneMux d3(d_input[23:16], letter[2:0], d_wires[2]);
  eightToOneMux d4(d_input[31:24], letter[2:0], d_wires[3]);
  fourToOneMux d5(d_wires, letter[4:3], d);
  
  // Combine and determine c output
  wire [3:0] c_wires;
  eightToOneMux c1(c_input[7:0], letter[2:0], c_wires[0]);
  eightToOneMux c2(c_input[15:8], letter[2:0], c_wires[1]);
  eightToOneMux c3(c_input[23:16], letter[2:0], c_wires[2]);
  eightToOneMux c4(c_input[31:24], letter[2:0], c_wires[3]);
  fourToOneMux c5(c_wires, letter[4:3], c);
    
  // Combine and determine b output
  wire [3:0] b_wires;
  eightToOneMux b1(b_input[7:0], letter[2:0], b_wires[0]);
  eightToOneMux b2(b_input[15:8], letter[2:0], b_wires[1]);
  eightToOneMux b3(b_input[23:16], letter[2:0], b_wires[2]);
  eightToOneMux b4(b_input[31:24], letter[2:0], b_wires[3]);
  fourToOneMux b5(b_wires, letter[4:3], b);
  
  // Combine and determine a output
  wire [3:0] a_wires;
  eightToOneMux a1(a_input[7:0], letter[2:0], a_wires[0]);
  eightToOneMux a2(a_input[15:8], letter[2:0], a_wires[1]);
  eightToOneMux a3(a_input[23:16], letter[2:0], a_wires[2]);
  eightToOneMux a4(a_input[31:24], letter[2:0], a_wires[3]);
  fourToOneMux a5(a_wires, letter[4:3], a);
  	
endmodule
