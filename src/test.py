import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):

    CONSTANT_CURRENT = 180 # For example, injecting some current
    
    dut._log.info("start simulation")

    # initialize clock
    clock = Clock(dut.clk, 1, units="ns")
    cocotb.start_soon(clock.start())

    #reset the circuit
    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10) #wait a few cycles. Here we're waiting 10 cycles and then apply some inputs. 
    dut.rst_n.value = 1 # take out of reset 

    #initialize the inputs (apply some inputs)
    dut.ui_in.value = CONSTANT_CURRENT
    dut.ena.value = 1 # enable design 

    #
    for _ in range(100):  # run for 100 clock cycles
        await RisingEdge(dut.clk)
    
    dut._log.info("Finished test!")