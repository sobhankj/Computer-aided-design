`timescale 1ns/1ns

// parameter input_memory_word_size = 16;
// parameter input_address = 4;
// parameter output_memory_word_size = 32;
// parameter output_address = 3;

// parameter in_buf = 16;
// parameter shift_reg_out = 8;
// parameter out_buf = 32;
// parameter input_mult = 8;
// parameter output_mult = 16;
// parameter up_down_counter = 4;
// parameter up_counter = 3;

module datapath #(parameter input_memory_word_size = 16 ,parameter input_address = 4 ,parameter output_memory_word_size = 32 ,
                parameter output_address = 3 , parameter in_buf = 16, parameter shift_reg_out = 8, parameter out_buf = 32
                ,parameter input_mult = 8, parameter output_mult = 16 ,parameter up_down_counter = 4 ,parameter up_counter = 3)
                (clk, rst, in_add_inc, in_add_init, in_add_cout, shift_en_A, load_en_A,
                shift_en_B, load_en_B, shift_en_result, load_en_result, init_result,
                inc_cnt_round, init_cnt_round, cout_round, dec_cnt_ud, inc_cnt_ud, init_cnt_ud,
                zero_ud, inc_cnt_fo, init_cnt_fo, cout_fo, w_en_out_mem, out_add_inc, out_add_init,
                out_add_cout, A_last_element, B_last_element);

input clk, rst;

//is about A & B shift register
input shift_en_A, load_en_A; 
input shift_en_B, load_en_B; 
wire [in_buf - 1:0] A_out, B_out;

//is about multiplier
wire [(2*input_mult) - 1:0] A_mult_B;

//is about result shift register
input shift_en_result, load_en_result, init_result;
wire [(4*input_mult) - 1:0] final_result;

//is about input memory and its address_counter
wire [input_memory_word_size - 1:0] input_word;
input in_add_inc, in_add_init;
output in_add_cout;
wire[input_address - 1 : 0] in_add_cnt;

//is about round counter
input inc_cnt_round, init_cnt_round;
output cout_round;

//is about up-down counter
input dec_cnt_ud, inc_cnt_ud, init_cnt_ud;
output zero_ud;

//is about find-one counter
input inc_cnt_fo, init_cnt_fo;
output cout_fo;

//is about output memory
input w_en_out_mem;
input out_add_inc, out_add_init;
output out_add_cout;
wire[output_address - 1 : 0] out_add_cnt;

output A_last_element, B_last_element;
//these are last element of Areg and Breg
assign A_last_element = A_out[in_buf - 1];
assign B_last_element = B_out[in_buf - 1];
wire [input_mult - 1 : 0]A_upper8 , B_upper8;



Input_memory input_memory(.address(in_add_cnt), .word(input_word));
up_counter_16 in_mem_add_counter(.clk(clk), .rst(rst), .inc_cnt(in_add_inc), .init_cnt(in_add_init), .cout(in_add_cout), .cnt_out(in_add_cnt));


shift_register_inbuf A_shreg(.reg_in(input_word), .shift_en(shift_en_A), .load_en(load_en_A), .clk(clk), .rst(rst), .reg_out(A_out) , .up_8(A_upper8));
shift_register_inbuf B_shreg(.reg_in(input_word), .shift_en(shift_en_B), .load_en(load_en_B), .clk(clk), .rst(rst), .reg_out(B_out) , .up_8(B_upper8));

multiplier multiplier(.A(A_upper8), .B(B_upper8), .result(A_mult_B));

shift_register_outbuf result_shreg(.reg_in(A_mult_B), .shift_en(shift_en_result), .load_en(load_en_result), .init(init_result), .clk(clk), .rst(rst), .reg_out(final_result));

up_counter_8 round_counter(.clk(clk), .rst(rst), .inc_cnt(inc_cnt_round), .init_cnt(init_cnt_round), .cout(cout_round), .cnt_out());
up_down_counter ud_counter(.clk(clk), .rst(rst), .dec_cnt(dec_cnt_ud), .inc_cnt(inc_cnt_ud), .init_cnt(init_cnt_ud), .zero(zero_ud));
up_counter_8 find_one_counter(.clk(clk), .rst(rst), .inc_cnt(inc_cnt_fo), .init_cnt(init_cnt_fo), .cout(cout_fo), .cnt_out());

Output_memory output_memory(.clk(clk), .address(out_add_cnt), .write_enable(w_en_out_mem), .word(final_result));
up_counter_8 out_mem_add_counter(.clk(clk), .rst(rst), .inc_cnt(out_add_inc), .init_cnt(out_add_init), .cout(out_add_cout), .cnt_out(out_add_cnt));

endmodule