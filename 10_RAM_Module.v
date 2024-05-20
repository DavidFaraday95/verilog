module Ram_sync(clk, addr, din, dout, we);
  parameter A = 10; // # of adress bits
  parameter D = 8;  // # of data bits

  input clk; 
  input [A-1:0] addr;
  input [D-1:0] din;
  output [D-1:0] dout;
  input we;

  reg [D-1:0] mem[0:(1<<A)-1];

  always @(posedge clk) begin
    if (we)                // if enabled
      mem[addr] <= din;    // write memory from din
    dout <= mem[addr];     // read memory from dout

  end

endmodule 
