`default_nettype none

module eif_neuron ( 
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [7:0] state,
    output reg [7:0] threshold
);
    
    wire [7:0] next_state;
    reg        spike_history;



    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 200;
            spike_history <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Spiking logic for IF
    assign spike = (state >= threshold);
    
    // Adaptive threshold update based on spiking history
    always @(posedge clk) begin
        if (!rst_n) begin
            spike_history <= 0;
        end else begin
            spike_history <= spike;
            // Adjust the threshold based on spiking history
            if (spike_history) begin
                threshold <= threshold - 10; // You can adjust the update logic
            end else begin
                threshold <= threshold + 1;  // You can adjust the update logic
            end
        end
    end

    // Update the membrane potential
    assign next_state = (spike ? 0 : (state + current)) - (spike ? threshold : 0);

endmodule
