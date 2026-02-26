module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter WL= 3'b000, WR = 3'b001, WLF= 3'b010,WRF= 3'b011, WLD =3'b100, WRD =3'b101;
    
    reg [2:0] state, next;
    reg [4:0] cnt;    
    always @(*)begin 
        case(state)
            WL: if(ground)begin 
                	if(dig)begin 
                		next  = WLD;
                    end else begin 
                        next = (bump_left) ? WR : WL;
                    end
            	end else begin 
                    next = WLF;
                end
            WR: if(ground)begin 
                	if(dig)begin 
                		next  = WRD;
                    end else begin 
                        next = (bump_right) ? WL : WR;
                    end
            	end else begin 
                    next = WRF;
                end
            WLF: if(ground)begin 
                	next = WL;
            	end else begin 
                    next = WLF;
                end
            WRF: if(ground)begin 
                	next = WR;
            	end else begin 
                    next = WRF;
                end
            WLD: if(ground)begin 
                	next = WLD;
            	end else begin 
                    next = WLF;
                end
            WRD: if(ground)begin 
                	next = WRD;
            	end else begin 
                    next = WRF;
                end
        endcase
    end 
    reg dead;
    
        always @(posedge clk or posedge areset) begin 
            if(areset)begin 
            	state <=  WL ;
            end else begin 
            	state <= next ;
                if(state == WLF | state == WRF)begin 
                    cnt <= cnt +1;
                    if(cnt == 4'd21)begin 
                        dead <= 1;
                    end else begin
                        dead <= 0;
                    end
                end
            end
        end
        
        always @(*)begin 
            if(dead)begin 
                walk_left =0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                
            end else begin 
                walk_left = (state == WL);
                walk_right = (state == WR);
                aaah = (state == WLF | state == WRF);
                digging = (state == WLD | state == WRD);
            end
        end

    
endmodule