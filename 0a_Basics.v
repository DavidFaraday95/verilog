--------------------------------
--      Not Gate              --
--------------------------------

module not1_gate(
  input a,    // 2-Input
  output y    // Output
);  

  not (y, a); // " Gate Primitive "

endmodule

module not1_dataflow(
  input a,    -- 2-Input
  output y  -- Output 
);

  assign y = ~a;  // "Contineous Assigment " Statement
  
endmodule

module not1_behavioral(
  input a,
  output reg y
);
// always block with " Non-Blocking Procedural Assignment "  Statement
  always @(a)  begin 
    y = ~a;
  end
  
endmodule

--------------------------------
--      Nand4 Gate              --
--------------------------------

module nand4_gate(
  input a,b,c,d, // 4-input
  output y
);

  nand (y, a,b,c,d); // Gate primitive

end module
    
module nand4_dataflow(
  input a,b,c,d, // 4-input
  output y
);

  assign y = ~ a & b & c & d); // Dataflow, Contineous Assignment Statement

end module


module nand4_behavioral(
input a,b,c,d, // 4-input
output y
);

  always @ (a or b or c or d) begin

    y = ~ a & b & c & d); 
  end
  
end module
  
