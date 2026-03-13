`timescale 1ns/1ps

module tb_async_fifo;

    parameter DSIZE = 8;
    parameter ASIZE = 4;

    // Write domain signals
    reg             wclk, wrst_n, winc;
    reg  [DSIZE-1:0] wdata;
    wire            wfull;

    // Read domain signals
    reg             rclk, rrst_n, rinc;
    wire [DSIZE-1:0] rdata;
    wire            rempty;

    // Instantiate DUT
    async_fifo #(DSIZE, ASIZE) dut (
        .wclk   (wclk),
        .wrst_n (wrst_n),
        .winc   (winc),
        .wdata  (wdata),
        .wfull  (wfull),
        .rclk   (rclk),
        .rrst_n (rrst_n),
        .rinc   (rinc),
        .rdata  (rdata),
        .rempty (rempty)
    );

    // Write clock: 10ns period (100MHz)
    initial wclk = 0;
    always #5 wclk = ~wclk;

    // Read clock: 14ns period (~71MHz) — different from write clock
    initial rclk = 0;
    always #7 rclk = ~rclk;

    // Write task
    task write_fifo(input [DSIZE-1:0] data);
        @(posedge wclk);
        if (!wfull) begin
            winc  = 1;
            wdata = data;
        end else begin
            $display("[WARN] FIFO Full! Cannot write %0h", data);
            winc = 0;
        end
        @(posedge wclk);
        winc = 0;
    endtask

    // Read task
    task read_fifo;
        @(posedge rclk);
        if (!rempty) begin
            rinc = 1;
        end else begin
            $display("[WARN] FIFO Empty! Cannot read");
            rinc = 0;
        end
        @(posedge rclk);
        rinc = 0;
    endtask

    integer i;

    initial begin
        // Initialize
        wrst_n = 0; rrst_n = 0;
        winc   = 0; rinc   = 0;
        wdata  = 0;

        // Release reset
        #20;
        wrst_n = 1; rrst_n = 1;

        // --- Test 1: Write until FULL ---
        $display("\n--- Test 1: Writing until FULL ---");
        for (i = 0; i < 16; i = i + 1)
            write_fifo(i * 2 + 8'hAA);

        if (wfull)
            $display("[PASS] FIFO is FULL as expected");
        else
            $display("[FAIL] FIFO should be FULL");

        // --- Test 2: Read until EMPTY ---
        $display("\n--- Test 2: Reading until EMPTY ---");
        for (i = 0; i < 16; i = i + 1) begin
            read_fifo;
            $display("  Read data: %0h", rdata);
        end

        if (rempty)
            $display("[PASS] FIFO is EMPTY as expected");
        else
            $display("[FAIL] FIFO should be EMPTY");

        // --- Test 3: Simultaneous Read/Write ---
        $display("\n--- Test 3: Simultaneous Read & Write ---");
        fork
            begin
                for (i = 0; i < 8; i = i + 1)
                    write_fifo(8'hF0 + i);
            end
            begin
                #30;
                for (i = 0; i < 8; i = i + 1) begin
                    read_fifo;
                    $display("  Simultaneous Read: %0h", rdata);
                end
            end
        join

        #100;
        $display("\n--- Simulation Complete ---");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, tb_async_fifo);
    end

endmodule
