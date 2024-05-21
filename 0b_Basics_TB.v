`timescale 1ns / 100ps // time-unit = 1 ns, precision = 100 ps

˚`include 0a_Basics.v

module NOT1_TB;

    // DATA TYPES - DECLARE REGISTERS AND WIRES (PROBES)
    reg             A;
    wire            Y_gate, Y_data, Y_beh;
    integer         i;

    // FOR TESTING  
    reg             TICK;
    reg [31:0]      VECTORCOUNT, ERRORS;
    reg             YEXPECTED;
    integer         FD, COUNT;
    reg [8*32-1:0]  COMMENT;

    // UNIT UNDER TEST (gate)
    not1_gate UUT_not1_gate(
        .a(A),
        .y(Y_gate)
    );

    // UNIT UNDER TEST (dataflow)
    not1_dataflow UUT_not1_dataflow(
        .a(A),
        .y(Y_data)
    );

    // UNIT UNDER TEST (behavioral)
    not1_behavioral UUT_not1_behavioral(
        .a(A),
        .y(Y_beh)
    );
/*
    // UNIT UNDER TEST (gate)
    nor2_gate UUT_nor2_gate(
        .a(A), .b(B),
        .y(Y_gate)
    );

    // UNIT UNDER TEST (dataflow)
    nor2_dataflow UUT_nor2_dataflow(
        .a(A), .b(B),
        .y(Y_data)
    );

    // UNIT UNDER TEST (behavioral)
    nor2_behavioral UUT_nor2_behavioral(
        .a(A), .b(B),
        .y(Y_beh)
    );
    
*/
    
/*
    // UNIT UNDER TEST (gate)
    nand4_gate UUT_nand4_gate(
        .a(A), .b(B), .c(C), .d(D),
        .y(Y_gate)
    );

    // UNIT UNDER TEST (dataflow)
    nand4_dataflow UUT_nand4_dataflow(
        .a(A), .b(B), .c(C), .d(D),
        .y(Y_data)
    );

    // UNIT UNDER TEST (behavioral)
    nand4_behavioral UUT_nand4_behavioral(
        .a(A), .b(B), .c(C), .d(D),
        .y(Y_beh)
    );
*/ 

    
    // SAVE EVERYTHING FROM TOP TB MODULE IN A DUMP FILE
    initial begin
        $dumpfile("not1_tb.vcd");
        $dumpvars(0, NOT1_TB);
      //  $dumpfile("nor2_tb.vcd");
      //  $dumpvars(0, NOR2_TB);
      //  $dumpfile("nand4_tb.vcd");
      //  $dumpvars(0, NAND4_TB);
    end

    // TICK PERIOD
    localparam TICKPERIOD = 20;

    // TICK
    always begin
        #(TICKPERIOD/2) TICK = ~TICK;
    end

    // INITIALIZE TESTBENCH
    initial begin

        // OPEN VECTOR FILE - THROW AWAY FIRST LINE
        FD=$fopen("not1_tb.tv","r");
        // FD=$fopen("nor2_tb.tv","r");
        // FD=$fopen("nand4_tb.tv","r");
        COUNT = $fscanf(FD, "%s", COMMENT);
        // $display ("FIRST LINE IS: %s", COMMENT);

        

        
        // INIT TESTBENCH
        COUNT = $fscanf(FD, "%s %b %b", COMMENT, A, YEXPECTED); //  Not1
        // COUNT = $fscanf(FD, "%s %b %b %b", COMMENT, A, YEXPECTED); //  Nor2
        //  COUNT = $fscanf(FD, "%s %b %b %b %b %b", COMMENT, A, B, C, D, YEXPECTED); //  Nand4
        
        TICK = 0;
        VECTORCOUNT = 1;
        ERRORS = 0;

        // DISPAY OUTPUT AND MONITOR
        $display();
        $display("TEST START --------------------------------");
        $display();
        $display("                                     GATE  DATA   BEH");
        $display("                 | TIME(ns) | A |  Y  |  Y  |  Y  |");
        //  $display("                 | TIME(ns) | A |  B |  Y  |  Y  |  Y  |");
        //  $display("                 | TIME(ns) | A |  B | C | D | Y  |  Y  |  Y  |");
        $display("                 ----------------------------------");
        // $monitor("%4d  %10s | %8d | %1d |  %1d  |  %1d  |  %1d  |", VECTORCOUNT, COMMENT, $time, A, Y_gate, Y_data, Y_beh);
        // $monitor("%4d  %10s | %8d | %1d |  %1d  |  %1d  |  %1d  | %1d  |", VECTORCOUNT, COMMENT, $time, A, B, Y_gate, Y_data, Y_beh);
        // $monitor("%4d  %10s | %8d | %1d | %1d | %1d | %1d |  %1d  |  %1d  |  %1d  |", VECTORCOUNT, COMMENT, $time, A, B, C, D, Y_gate, Y_data, Y_beh);


      // APPLY TEST VECTORS ON NEG EDGE TICK (ADD DELAY)
      always @(negedge TICK) begin
        
        #5; // wait a bit (after check)

        // get vectors from TB file
        COUNT = $fscanf(FD, "%s %b %b", COMMENT, A, YEXPECTED);

        // Check if EOF - PRINT SUMMARY, CLOSE VECTOR FILES AND FINISH TB
        if (COUNT == -1) begin
          $fclose(FD);
          $display();
          $display(" VECTORS: %4d", VECTORCOUNT);
          $display(" ERRORS: %4d", ERRORS);
          $display();
          $display("TEST END --------------------------------");
          $display();
          $finish;
        end

        // get another vector
        VECTORCOUNT = VECTORCOUNT + 1;

      end 

      // CHECK TEST VECTORS ON POS EDGE TICK
      always @(posedge TICK) begin
        #5   // WAIT A BIT
    
        // DISPLAY TEST VECTORS ON POS EDGE TICK
        $display("%4d %10s | %8d | %1d | %1d | %1d | %1d |", VECTORCOUNT, COMMENT, $time, A, Y_GATE, Y_data, Y_beh); 
        // $display("%4d %10s | %8d | %1d | %1d | %1d | %1d | %1d |", VECTORCOUNT, COMMENT, $time, A, Y_GATE, Y_data, Y_beh); 
        // $display("%4d  %10s | %8d | %1d | %1d | %1d | %1d |  %1d  |  %1d  |  %1d  |", VECTORCOUNT, COMMENT, $time, A, B, C, D, Y_gate, Y_data, Y_beh);

        //Check each Vector result
        if (Y_gate != YEXPECTED) begin
          $display("***ERROR (gate) - Expected Y = %b", YEXPECTED);
          ERRORS = ERRORS + 1;
        end
        
        //Check each Vector result
        if (Y_data != YEXPECTED) begin
          $display("***ERROR (dataflow) - Expected Y = %b", YEXPECTED);
          ERRORS = ERRORS + 1;
        end

        //Check each Vector result
        if (Y_beh != YEXPECTED) begin
          $display("***ERROR (behavioral) - Expected Y = %b", YEXPECTED);
          ERRORS = ERRORS + 1;
        end
      end

endmodule
