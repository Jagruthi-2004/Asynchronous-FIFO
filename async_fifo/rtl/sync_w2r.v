module sync_w2r #(
    parameter ASIZE = 4
)(
    output reg  [ASIZE:0] rq2_wptr,
    input  wire [ASIZE:0] wptr,
    input  wire           rclk,
    input  wire           rrst_n
);

    reg [ASIZE:0] rq1_wptr;

    // 2-FF synchronizer
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            {rq2_wptr, rq1_wptr} <= 0;
        else
            {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
    end

endmodule
