module booth_mult (clk, rst_n, load, A, B, P);
  parameter A_WIDTH = 24;
  parameter B_WIDTH = 8;
  parameter P_WIDTH = A_WIDTH + B_WIDTH;
  // 
  input clk;
  input rst_n;
  input load;
  input [A_WIDTH-1:0] A;
  input [B_WIDTH-1:0] B;
  output [P_WIDTH-1:0] P;
  // 
  //Declare internal signal
 
  reg [A_WIDTH:0] A_reg;
  reg [P_WIDTH:0] P_B_reg;
  wire [P_WIDTH:0] P_B_reg_sra_1;
  wire [A_WIDTH:0] adder_S;
  wire [A_WIDTH:0] adder_A;
  wire [A_WIDTH:0] adder_B;
// 
  wire booth_enc_A;
  wire booth_enc_2A;
  wire booth_enc_neg;
// 
  //A_WIDTH-bit Register for Multiplicand A

  always @(posedge clk or negedge rst_n)begin 
    if(~rst_n)begin 
      A_reg <= 0;
      P_B_reg <= 0 ;
    end 
    else if (load) begin
      A_reg <= {A[A_WIDTH-1],A};
      P_B_reg <= { {A_WIDTH{1'b0}}, B, 1'b0 }; 
    end else begin 
      A_reg <= A_reg;
      P_B_reg <= {adder_S[A_WIDTH],adder_S,P_B_reg_sra_1[B_WIDTH-1:1]};
    end
  end
  //  
  //(A_WIDTH + B_WIDTH + 1)-bit Register for Product (P) and Multiplier (B)

  // 
  //Booth encoder

  booth_encoder be (
    .booth_enc_in(P_B_reg[2:0]),
    .booth_enc_A(booth_enc_A),
    .booth_enc_2A(booth_enc_2A),
    .booth_enc_neg(booth_enc_neg)
  );
  //Shift Right Arithmetic

  assign P_B_reg_sra_1 = $signed(P_B_reg) >>> 1; 
  //Add_sub_unit

  assign adder_B =  (booth_enc_2A) ? {A_reg} << 1:
                    (booth_enc_A)  ? {A_reg}     :
                                     0;
  assign adder_A = P_B_reg_sra_1[P_WIDTH:B_WIDTH];
  add_sub_unit   #(.WIDTH(A_WIDTH)) add (
    .A(adder_A),
    .B(adder_B),
  
    .SnA(booth_enc_neg),
    .S(adder_S)
  );
  //Determine output P

  assign P = P_B_reg[P_WIDTH:1];
endmodule