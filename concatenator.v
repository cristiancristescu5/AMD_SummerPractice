module concatenator1( a, b, c, d, e, out);
  input[7:0] a;
  input[7:0] b;
  input[7:0] c;
  input[3:0] d;
  input[3:0] e;
  
  output[31:0] out;
  assign out = {e, d, c, b, a};
endmodule
