module sync_r2w #(
    parameter ASIZE = 4
)(
    output reg  [ASIZE:0] wq2_rptr,
    input  wire [ASIZE:0] rptr,
    input  wire           wclk,
    input  wire           wrst_n
);

    reg [ASIZE:0] wq1_rptr;

    // 2-FF synchronizer
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            {wq2_rptr, wq1_rptr} <= 0;
        else
            {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
    end

endmodule
