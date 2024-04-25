`ifndef top_sv
`define top_sv
module top;
    import uvm_pkg::*;
    import hbus_types_pkg::*;
    import sys_pkg::*;

    logic clk, rstn;
    
    hbus_if m_hbus_if_main(.clk(clk),.rstn(rstn));
    hbus_if m_hbus_if_secondary(.clk(clk),.rstn(rstn));
    hbus_rx dut(m_hbus_if_main, m_hbus_if_secondary);
    
    initial begin
        uvm_config_db#(virtual hbus_if)::set(uvm_root::get(), "uvm_test_top", "m_hbus_if_main", m_hbus_if_main);
        uvm_config_db#(virtual hbus_if)::set(uvm_root::get(), "uvm_test_top", "m_hbus_if_secondary", m_hbus_if_secondary);
        run_test();
    end
    
    initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn <= 0;
        repeat(4) @ (posedge clk);
        @ (negedge clk);
        rstn <= 1;
    end
    
endmodule
`endif //top_sv