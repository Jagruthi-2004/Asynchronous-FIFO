module wptr_full #(
    parameter ASIZE = 4
)(
    output reg              wfull,
    output wire [ASIZE-1:0] waddr,
    output reg  [ASIZE:0]   wptr,
    input  wire [ASIZE:0]   wq2_rptr,
    input  wire             winc,
    input  wire             wclk,
    input  wire             wrst_n
);

    reg  [ASIZE:0] wbin;
    wire [ASIZE:0] wgraynext, wbinnext;

    // Binary counter
    assign wbinnext  = wbin + (winc & ~wfull);
    // Gray code conversion
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            {wbin, wptr} <= 0;
        else
            {wbin, wptr} <= {wbinnext, wgraynext};
    end

    // Write address (lower bits of binary counter)
    assign waddr = wbin[ASIZE-1:0];

    // Full condition:
    // wptr matches synchronized rptr with MSBs inverted
    wire wfull_val = (wgraynext == {~wq2_rptr[ASIZE:ASIZE-1],
                                     wq2_rptr[ASIZE-2:0]});

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            wfull <= 1'b0;
        else
            wfull <= wfull_val;
    end

endmodule
