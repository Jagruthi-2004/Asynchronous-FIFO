module async_fifo #(
    parameter DSIZE = 8,   // Data width
    parameter ASIZE = 4    // Address width (depth = 2^ASIZE)
)(
    // Write domain
    input  wire             wclk,
    input  wire             wrst_n,
    input  wire             winc,
    input  wire [DSIZE-1:0] wdata,
    output wire             wfull,

    // Read domain
    input  wire             rclk,
    input  wire             rrst_n,
    input  wire             rinc,
    output wire [DSIZE-1:0] rdata,
    output wire             rempty
);

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0]   wptr, rptr, wq2_rptr, rq2_wptr;

    // Synchronizer: rptr -> write domain
    sync_r2w #(ASIZE) sync_r2w_inst (
        .wq2_rptr  (wq2_rptr),
        .rptr      (rptr),
        .wclk      (wclk),
        .wrst_n    (wrst_n)
    );

    // Synchronizer: wptr -> read domain
    sync_w2r #(ASIZE) sync_w2r_inst (
        .rq2_wptr  (rq2_wptr),
        .wptr      (wptr),
        .rclk      (rclk),
        .rrst_n    (rrst_n)
    );

    // Dual-port FIFO memory
    fifo_mem #(DSIZE, ASIZE) fifo_mem_inst (
        .rdata     (rdata),
        .wdata     (wdata),
        .waddr     (waddr),
        .raddr     (raddr),
        .wclken    (winc),
        .wfull     (wfull),
        .wclk      (wclk)
    );

    // Write pointer and full logic
    wptr_full #(ASIZE) wptr_full_inst (
        .waddr     (waddr),
        .wfull     (wfull),
        .wptr      (wptr),
        .wq2_rptr  (wq2_rptr),
        .winc      (winc),
        .wclk      (wclk),
        .wrst_n    (wrst_n)
    );

    // Read pointer and empty logic
    rptr_empty #(ASIZE) rptr_empty_inst (
        .raddr     (raddr),
        .rempty    (rempty),
        .rptr      (rptr),
        .rq2_wptr  (rq2_wptr),
        .rinc      (rinc),
        .rclk      (rclk),
        .rrst_n    (rrst_n)
    );

endmodule
