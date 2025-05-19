module controller(clk, rst, stall, start, elco, end_of_row, wfco, done , wfen , dsen, feen, ldreg, lddc, ferst, woen, wfrst, rst_dp, sel_next);
    input clk, rst, stall, start, elco, end_of_row, wfco;
    output reg done , wfen , dsen, feen, ldreg, lddc, ferst, woen, wfrst, rst_dp, sel_next;

    reg [3:0] ps, ns;
    parameter [4:0] Idle = 0, wait_for_start = 1, check_status = 2, next_filter_element = 3, load_mult_result = 4, next_window = 5, done_one_window = 6,
                    go_to_next_filter = 7, go_to_next_filter_temp = 8, wait_for_result = 9, done_all_filter = 10, after_done_all_filter = 11, go_to_next_row = 12;
    
    always @(*) begin
        ns = Idle;
        case (ps)
            Idle: ns = (start) ? wait_for_start : Idle;

            wait_for_start: ns = (start) ? wait_for_start : check_status;

            check_status: begin
                if (stall) 
                    ns = check_status;
                else if (!stall && wfco && end_of_row) // چپ 
                    ns = done_all_filter;
                else if (!stall && end_of_row && !wfco) // وسط
                    ns = go_to_next_filter;
                else if (!stall && !elco) // state = 3 = بالا
                    ns = next_filter_element;
                else if (!stall && elco)  // راستی
                    ns = next_window;
                else 
                    ns = check_status;
            end

            next_filter_element: ns = check_status;

            load_mult_result: ns = check_status;

            next_window: ns = done_one_window;

            done_one_window: ns = check_status;

            go_to_next_filter: ns = wait_for_result;
            
            go_to_next_filter_temp: ns = wait_for_result;

            wait_for_result: ns = check_status;

            done_all_filter: ns = after_done_all_filter;

            after_done_all_filter: ns = go_to_next_row;

            go_to_next_row: ns = check_status;


            default: ns = Idle;
        endcase
    end


    always @(*) begin
        {done , wfen , dsen, feen, lddc, ferst, woen, wfrst, ldreg, rst_dp, sel_next} = 11'b00000000100;
        case (ps)
            Idle: begin

            end

            wait_for_start: begin
                rst_dp = 1'b1;
            end
            
            check_status: begin
                ldreg = 1'b0;
            end

            next_filter_element: begin
                feen = 1'b1;
            end

            next_window: begin
                feen = 1'b1;
                dsen = 1'b1;
            end

            done_one_window: begin
                done = 1'b1;

            end

            go_to_next_filter: begin
                lddc = 1'b1;
                wfen = 1'b1;
                ferst = 1'b1;
            end

            done_all_filter: begin
                woen = 1'b1;
            end

            after_done_all_filter: begin
                done = 1'b1;
            end

            go_to_next_row: begin
                wfrst = 1'b1;
                ferst = 1'b1;
                lddc = 1'b1;
                sel_next = 1'b1;
            end

            load_mult_result: begin

            end

            wait_for_result: begin
                done = 1'b1;
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= Idle;
        else
            ps <= ns;
    end
endmodule
