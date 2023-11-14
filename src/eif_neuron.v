`default_nettype none

module eif_neuron ( 
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,

    input wire Delta_T = 1.0,    // Sharpness parameter
    input wire tau = 1.0,         // Membrane time constant

    output reg       spike,
    output reg [7:0] state
);
    reg  [7:0] threshold;
    reg  [7:0] u_rest = 50; // Set the resting potential value, adjust as needed
    reg  [7:0] theta_rh;    // Add missing declaration
    reg  [7:0] next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 200;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (state >= threshold) begin
            next_state = u_rest; // Reset the membrane potential to resting potential
            spike = 1;           // Generate spike
        end else begin
            next_state = state + Delta_T * exp((state - threshold) / Delta_T) + current * tau; // Exponential Integrate-and-Fire equation
            spike = 0;           // No spike
        end
    end
endmodule
