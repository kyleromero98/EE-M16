// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.1
// dassign1_1.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// CMOS gates (declarative Verilog)
// Includes propagation delay t_PD = 1
module inverter(a,y);
    input a;
    output y;

    assign #1 y = ~a;
endmodule

module fa_gate_1(a,b,c,y);
    input a,b,c;
    output y;

    assign #1 y = ~((a&b) | (c&(b|a)));
endmodule

module fa_gate_2(a,b,c,m,y);
    input a,b,c,m;
    output y;

    assign #1 y = ~((a&b&c) | ((a|b|c)&m));
endmodule

// Full adder (structural Verilog)
module fa(a,b,ci,co,s);
    input a,b,ci;
    output s,co;

    wire nco, ns;

    fa_gate_1   fa_gate_1_1(a,b,ci, nco);
    fa_gate_2   fa_gate_2_1(a,b,ci,nco, ns);
    inverter    inverter_1(nco, co); 
    inverter    inverter_2(ns, s);
endmodule

// 5+2 input full adder (structural Verilog)
// IMPORTANT: Do not change module or port names
module fa5 (a,b,c,d,e,ci0,ci1, 
            co1,co0,s);

    input a,b,c,d,e,ci0,ci1;
    output co1, co0, s;
    // your code here
    // do not use any delays!
  
  // sums up 3 bits
  wire carryabc, sumabc;
  fa fa1(a, b, c, carryabc, sumabc);
  
  // sums remaining 2 bits and carry
  wire carrydec, sumdec;
  fa fa2(d, e, ci0, carrydec, sumdec);
  
  // sums sums and remaining carry
  wire carrywire;
  fa fa3(sumabc, sumdec, ci1, carrywire, s);
  // sums the carrys
  fa fa4(carryabc, carrydec, carrywire, co1, co0);
endmodule

// 5-input 4-bit ripple-carry adder (structural Verilog)
// IMPORTANT: Do not change module or port names
module adder5 (a,b,c,d,e, sum);
    input [3:0] a,b,c,d,e;
    // your code here
    // do not use any delays!
  output [6:0] sum;
  
  // feed each one in to the next and one two after
  wire zero2one, zero2two;
  fa5 fa5_0(a[0], b[0], c[0], d[0], e[0], 
            1'b0, 1'b0, zero2two, zero2one, sum[0]);
  
  wire one2two, one2three;
  fa5 fa5_1(a[1], b[1], c[1], d[1], e[1],
            1'b0, zero2one, one2three, one2two, sum[1]);
  
  wire two2three, two2four;
  fa5 fa5_2(a[2], b[2], c[2], d[2], e[2],
            zero2two, one2two, two2FA1, two2three, sum[2]);
  
  wire three2FA2, three2FA1;
  fa5 fa5_3(a[3], b[3], c[3], d[3], e[3],
            one2three, two2three, three2FA2, three2FA1, sum[3]);
  
  // add the 2 FA on the end to account for overflow
  wire carry1;
  fa fa1(two2FA1, three2FA1, 1'b0, carry1, sum[4]);
  
  fa fa2(three2FA2, carry1, 1'b0, sum[6], sum[5]);
  
endmodule
