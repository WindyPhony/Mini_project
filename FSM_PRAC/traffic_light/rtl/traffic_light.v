module traffic_light #(
    parameter integer CLK_FREQ   = 50_000_000,  // input clock frequency in Hz
    parameter integer GREEN_SEC  = 20,
    parameter integer YELLOW_SEC = 3,
    parameter integer RED_SEC    = 3
)(
    input wire clk,
    input wire rst_n,
    output wire green, yellow, red 
);

    // khai bao trang thai
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;

    // bo dem 1 giay
    reg [31:0] tick_cnt; // Dem den 1 giay
    reg [31:0] sec_cnt;  // Dem giay de chuyen trang thai

    // Logic chuyen trang thai
    always @(*) begin
        case (state)
            S0:  next_state = S1;
            S1:  next_state = S2;
            S2:  next_state = S0;
            default :  next_state = S0;
        endcase
    end

    // thanh ghi trang thai
    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin 
            state     <= S0;
            tick_cnt  <= 0;         
            sec_cnt   <= GREEN_SEC; 
        end 
        else begin 
            // tao bo dem 1 giay
            if (tick_cnt + 1 == CLK_FREQ) begin
                tick_cnt <= 0;

                if (sec_cnt > 0)
                    sec_cnt <= sec_cnt - 1;
            end 
            else begin 
                tick_cnt <= tick_cnt + 1;
            end

            // het thoi gian chuyen trạng thái
            if (tick_cnt == 0 && sec_cnt == 0) begin 
                state <= next_state;        // cap nhat trang thai moi cua den giao thong
                tick_cnt <= 0;

                case (next_state)
                    S0: sec_cnt <= GREEN_SEC;
                    S1: sec_cnt <= YELLOW_SEC;
                    S2: sec_cnt <= RED_SEC;
                endcase
            end
        end
    end

    // Output logic
    assign green = (state == S0);
    assign yellow = (state == S1);
    assign red = (state == S2);
endmodule