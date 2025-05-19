`timescale 1ns/1ns
// parameter num_of_words = 16;
// parameter bits_of_words = 16;
// parameter address_bits = 4;

module Input_memory #(parameter num_of_words = 16, parameter bits_of_words = 16,parameter address_bits = 4)(address, word);
    input [address_bits - 1:0] address;
    output [bits_of_words - 1:0] word;

    reg [bits_of_words - 1:0] input_memory [0:num_of_words - 1];

    
    initial $readmemb("data_input.txt", input_memory);

    assign word = input_memory[address];
endmodule