// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.2
// dassign1_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of these stubs
module fcmp2 (a, b, ci, co);
  input [1:0] a;
  input [1:0] b;
  input ci;
  output co;
  
  // function from pset
  assign co = ((~a[1] & ~a[0] & ci) |
                  (b[1] & b[0] & ci) |
                  (~a[0] & b[1] & ci) |
                  (~a[1] & b[0] & ci) |
                  (~a[0] & b[1] & b[0]) |
                  (b[0] & ~a[1] & ~a[0]) |
                  (b[1] & ~a[1]));
endmodule

// compares two 8-bit numbers
module fcmp8 (a, b, co);
  input[7:0] a, b;
  output co;
  
  // Uses 4 2-bit comparators
  wire carry1;
  fcmp2 fcmp2_1(a[1:0], b[1:0], 1'b1, carry1);
  wire carry2;
  fcmp2 fcmp2_2(a[3:2], b[3:2], carry1, carry2);
  wire carry3;
  fcmp2 fcmp2_3(a[5:4], b[5:4], carry2, carry3);

  fcmp2 fcmp2_4(a[7:6], b[7:6], carry3, co);
endmodule

// selects 8 value bits from two sets of 8
module sixteentoeightmux (A, B, sel, out);
  input [7:0] B, A;
  input sel;
  output [7:0] out;
  assign out = (sel) ? B : A; 
endmodule

// Selects 5 value bits from two sets of 5
module tentofivemux (A, B, sel, out);
  input [4:0] B, A;
  input sel;
  output [4:0] out;
  assign out = (sel) ? B : A; 
endmodule

// Max/argmax (declarative verilog)
// IMPORTANT: Do not change module or port names
module mam (in1_value, in1_label, in2_value, in2_label, out_value, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [7:0] out_value;
    output  [4:0] out_label;
    // your code here
    // do not use any delays!
  wire out;
  fcmp8 fcmp8_1(in1_value, in2_value, out);
  
  sixteentoeightmux valmux(in1_value, in2_value, out, out_value);
  tentofivemux labelmux(in1_label, in2_label, out, out_label);
endmodule

// Maximum index (structural verilog)
// IMPORTANT: Do not change module or port names
module maxindex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
    // your code here
    // do not use any delays!
  
  // first level of tree
  wire [7:0] out1val;
  wire [4:0] out1label;
  mam mam_1(a, 5'd00, b, 5'd01, out1val, out1label);
  
  wire [7:0] out2val;
  wire [4:0] out2label;
  mam mam_2(c, 5'd02, d, 5'd03, out2val, out2label);	
  
  wire [7:0] out3val;
  wire [4:0] out3label;
  mam mam_3(e, 5'd04, f, 5'd05, out3val, out3label);	
  
  wire [7:0] out4val;
  wire [4:0] out4label;
  mam mam_4(g, 5'd06, h, 5'd07, out4val, out4label);	
  
  wire [7:0] out5val;
  wire [4:0] out5label;
  mam mam_5(i, 5'd08, j, 5'd09, out5val, out5label);	
  
  wire [7:0] out6val;
  wire [4:0] out6label;
  mam mam_6(k, 5'd10, l, 5'd11, out6val, out6label);	
  
  wire [7:0] out7val;
  wire [4:0] out7label;
  mam mam_7(m, 5'd12, n, 5'd13, out7val, out7label);	
  
  wire [7:0] out8val;
  wire [4:0] out8label;
  mam mam_8(o, 5'd14, p, 5'd15, out8val, out8label);	
  
  wire [7:0] out9val;
  wire [4:0] out9label;
  mam mam_9(q, 5'd16, r, 5'd17, out9val, out9label);	
  
  wire [7:0] out10val;
  wire [4:0] out10label;
  mam mam_10(s, 5'd18, t, 5'd19, out10val, out10label);	
  
  wire [7:0] out11val;
  wire [4:0] out11label;
  mam mam_11(u, 5'd20, v, 5'd21, out11val, out11label);	
  
  wire [7:0] out12val;
  wire [4:0] out12label;
  mam mam_12(w, 5'd22, x, 5'd23, out12val, out12label);	
  
  wire [7:0] out13val;
  wire [4:0] out13label;
  mam mam_13(y, 5'd24, z, 5'd25, out13val, out13label);	
  
  // Second level of tree
  wire [7:0] out14val;
  wire [4:0] out14label;
  mam mam_14(out1val, out1label, out2val, out2label, out14val, out14label);
  
  wire [7:0] out15val;
  wire [4:0] out15label;
  mam mam_15(out3val, out3label, out4val, out4label, out15val, out15label);	
  
  wire [7:0] out16val;
  wire [4:0] out16label;
  mam mam_16(out5val, out5label, out6val, out6label, out16val, out16label);
  
  wire [7:0] out17val;
  wire [4:0] out17label;
  mam mam_17(out7val, out7label, out8val, out8label, out17val, out17label);
  
  wire [7:0] out18val;
  wire [4:0] out18label;
  mam mam_18(out9val, out9label, out10val, out10label, 
             out18val, out18label);
  
  wire [7:0] out19val;
  wire [4:0] out19label;
  mam mam_19(out11val, out11label, out12val, out12label, 
             out19val, out19label);
  
  // level 3 of tree
  wire [7:0] out20val;
  wire [4:0] out20label;
  mam mam_20(out14val, out14label, out15val, out15label, 
             out20val, out20label);
  
  wire [7:0] out21val;
  wire [4:0] out21label;
  mam mam_21(out16val, out16label, out17val, out17label, 
             out21val, out21label);
  
  wire [7:0] out22val;
  wire [4:0] out22label;
  mam mam_22(out18val, out18label, out19val, out19label, 
             out22val, out22label);
  
  // level 4
  wire [7:0] out23val;
  wire [4:0] out23label;
  mam mam_23(out20val, out20label, out21val, out21label, 
             out23val, out23label);
  
  wire [7:0] out24val;
  wire [4:0] out24label;
  mam mam_24(out22val, out22label, out13val, out13label, 
             out24val, out24label);
  
  // level five - finally
  wire [7:0] out25val;
  mam mam_25(out23val, out23label, out24val, out24label, 
             out25val, out);
endmodule
