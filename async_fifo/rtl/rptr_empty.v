module rptr_empty #(
    parameter ASIZE = 4
)(
    output reg              rempty,
    output wire [ASIZE-1:0] raddr,
    output reg  [ASIZE:0]   rptr,
    input  wire [ASIZE:0]   rq2_wptr,
    input  wire             rinc,
    input  wire             rclk,
    input  wire             rrst_n
);

    reg  [ASIZE:0] rbin;
    wire [ASIZE:0] rgraynext, rbinnext;

    // Binary counter
    assign rbinnext  = rbin + (rinc & ~rempty);
    // Gray code conversion
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            {rbin, rptr} <= 0;
        else
            {rbin, rptr} <= {rbinnext, rgraynext};
    end

    // Read address (lower bits of binary counter)
    assign raddr = rbin[ASIZE-1:0];

    // Empty condition:
    // rptr matches synchronized wptr exactly
    wire rempty_val = (rgraynext == rq2_wptr);

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            rempty <= 1'b1;
        else
            rempty <= rempty_val;
    end

endmodule
