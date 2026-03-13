module fifo_mem #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
)(
    output reg  [DSIZE-1:0] rdata,
    input  wire [DSIZE-1:0] wdata,
    input  wire [ASIZE-1:0] waddr,
    input  wire [ASIZE-1:0] raddr,
    input  wire             wclken,
    input  wire             wfull,
    input  wire             wclk
);

    // Memory array
    reg [DSIZE-1:0] mem [(1<<ASIZE)-1:0];

    // Synchronous write
    always @(posedge wclk) begin
        if (wclken && !wfull)
            mem[waddr] <= wdata;
    end

    // Asynchronous read
    assign rdata = mem[raddr];

endmodule
