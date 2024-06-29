module top_module(
    input[31:0] in,
    output[31:0] out,
);
    // Byte Size Order
//    assign out [4 * 8-1 -:8] = in [1*8-1 : 8];
//    assign out [3 * 8-1 -:8] = in [1*8-1 : 8];
//    assign out [2 * 8-1 -:8] = in [1*8-1 : 8];
//    assign out [1 * 8-1 -:8] = in [1*8-1 : 8];

    // scalable style
//    assign out[4* BYTE_SIZE-1 -: BYTE_SIZE] = in[1*BYTE_SIZE-1 - BYTE_SIZE];
//    assign out[3* BYTE_SIZE-1 -: BYTE_SIZE] = in[2*BYTE_SIZE-1 - BYTE_SIZE];
//    assign out[2* BYTE_SIZE-1 -: BYTE_SIZE] = in[3*BYTE_SIZE-1 - BYTE_SIZE];
//    assign out[1* BYTE_SIZE-1 -: BYTE_SIZE] = in[4*BYTE_SIZE-1 - BYTE_SIZE];

    // advanced Version

    localparam BYTE_SIZE = 8; // bits in a byte

    // Size gives number of bits in a vector
    localparam NUM_BYTES  = $size(in)/BYTE_SIZE;

    // Generate Variable
    genvar i;
    generate
        for (i = 1; i<= NUM_BYTES; i++) begin : endian_switch_for // Loop Name

            assign out [i*BYTE_SIZE-1 -: BYTE_SIZE] = in[(NUM_BYTES-i+1)*BYTE_SIZE-1 -: BYTE_SIZE];
        end
    endgenerate

endmodule