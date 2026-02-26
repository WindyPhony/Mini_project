module booth_encoder (
  input [2:0] booth_enc_in,
  output reg booth_enc_neg,
  output reg booth_enc_A,
  output reg booth_enc_2A
);

  always @(*) begin
    case (booth_enc_in) 
      3'b0: begin 
          booth_enc_neg = 0;
          booth_enc_A = 0;
          booth_enc_2A = 0;
      end
      3'b001: begin 
          booth_enc_neg = 0;
          booth_enc_A = 1;
          booth_enc_2A = 0;
      end
      3'b010: begin 
          booth_enc_neg = 0;
          booth_enc_A = 1;
          booth_enc_2A = 0;
      end
      3'b011: begin 
          booth_enc_neg = 0;
          booth_enc_A = 0;
          booth_enc_2A = 1;
      end
      3'b100: begin 
          booth_enc_neg = 1;
          booth_enc_A = 0;
          booth_enc_2A = 1;
      end
      3'b101: begin 
          booth_enc_neg = 1;
          booth_enc_A = 1;
          booth_enc_2A = 0;
      end
      3'b110: begin 
          booth_enc_neg = 1;
          booth_enc_A = 1;
          booth_enc_2A = 0;
      end
      3'b111: begin 
          booth_enc_neg = 0;
          booth_enc_A = 0;
          booth_enc_2A = 0;
      end
  endcase
 end 
endmodule