module eif_neuron (
    input wire [7:0] current,
    input wire clk,
    input wire rst_n,
    input wire adaptive_threshold,  // enable adaptive threshold (enable when = 1, disable when = 0)
    output reg [7:0] state,
    output wire spike
);

    wire [7:0] next_state;
    reg [7:0] threshold;

    parameter ADAPTIVE_INCREMENT = 295;  // adaptive increment factor
    parameter ADAPTIVE_DECREMENT = 250;  // adaptive decrement factor

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 100;  // initial threshold 100
        end else begin
            if (spike) begin
                state <= 0;
                if (adaptive_threshold && (threshold < 220))  // avoiding overflow 255
                    threshold <= threshold * ADAPTIVE_INCREMENT >> 8;  // increase threshold
            end else begin
                state <= next_state;
                if (adaptive_threshold && (threshold > 32))  // avoiding being too low
                    threshold <= threshold * ADAPTIVE_DECREMENT >> 8;  // decrease threshold
            end
        end
    end

    // next_state logic and spiking logic for IF
    assign spike = (state >= threshold);
    assign next_state = (spike ? 0 : (state + current)) - (spike ? threshold : 0);
endmodule
