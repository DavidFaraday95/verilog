module top_module(
input a,
input b,
input c,
input d,
output out,
output out_n);


wire out_i;

assign out_i = (a & b) | (c & d);

assign out = out_i;
assign out_n = ~out_i;

localparam ENABLE_DATASOURCE_B = 0;
localparam ENABLE_DATASOURCE_A = 1;
wire output_bus_z_valid;
wire[3:0] output_bus_z_data;

assign output_bus_z_valid = (a_valid  & ENABLE_DATASOURCE_A) | 
                                (b_valid  & ENABLE_DATASOURCE_B);

assign output_bus_z_data = ENABLE_DATASOURCE_A ? a_data :
                            ENABLE_DATASOURCE_B ? b_data :
                            0;

endmodule