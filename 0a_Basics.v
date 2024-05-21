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

