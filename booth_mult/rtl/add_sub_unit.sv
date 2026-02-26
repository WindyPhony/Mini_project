module add_sub_unit #(parameter WIDTH = 24)(
  input  [WIDTH:0] A,
  input  [WIDTH:0] B,
  input          SnA,   
  output [WIDTH:0]  S
);
  
  assign S = A + (B ^ {(WIDTH+1){SnA}} )+ SnA;
endmodule