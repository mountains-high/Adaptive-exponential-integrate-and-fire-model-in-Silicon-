
/*
    First-order integrate-and-fire neuron model.
    Input is assumed to be a current injection.
    
    For :math:`U[T] > U_{\\rm thr} ⇒ S[T+1] = 1`.

    If `reset_mechanism = "subtract"`, then :math:`U[t+1]` will have
    `threshold` subtracted from it whenever the neuron emits a spike:

    .. math::

            U[t+1] = U[t] + I_{\\rm in}[t+1] - RU_{\\rm thr}

    If `reset_mechanism = "zero"`, then :math:`U[t+1]` will be set to `0`
    whenever the neuron emits a spike:

    .. math::

            U[t+1] = U[t] + I_{\\rm syn}[t+1] - R(U[t] + I_{\\rm in}[t+1])

      :math:`I_{\\rm in}` - Input current
      :math:`U` - Membrane potential
      :math:`U_{\\rm thr}` - Membrane threshold
      :math:`R` - Reset mechanism: if active, :math:`R = 1`, otherwise \
      :math:`R = 0`
    
*/
`default_nettype none

module eif_neuron ( 
    
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [7:0] state
);
    reg  [7:0] threshold;
    wire [7:0] next_state;

    parameter Delta_T = 1.0;    // Sharpness parameter
    parameter tau = 1.0;        // Membrane time constant

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 200;
        end else begin
            state <= next_state;
        end
    end

    // Exponential Integrate-and-Fire model differential equation
    always @* begin
        if (state >= threshold) begin
            next_state = 0; // Reset the membrane potential
            spike = 1;      // Generate spike
        end else begin
            next_state = state - (state - u_rest) + Delta_T * exp((state - theta_rh) / Delta_T) + current * tau; // Equation (5.6)
            spike = 0;      // No spike
        end
    end

endmodule

