`ifndef hbus_bitwise_and_test_sv
`define hbus_bitwise_and_test_sv
class hbus_bitwise_and_test extends hbus_base_test;

    hbus_reg_block hbus_rm;

    uvm_status_e status;

    bit [7:0] value;

    uvm_reg bitwise_and;

    `uvm_component_utils(hbus_bitwise_and_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
        bitwise_and=hbus_rm.bitwise_and;
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);

        @ (posedge env.agnt_main.drv.m_hbus_if.rstn);
        @ (posedge env.agnt_main.drv.m_hbus_if.clk);
        
        $display(head);
        `uvm_info(get_name(), "Start write transaction on register bitwise_and_reg", UVM_MEDIUM)
        $display(head);
        hbus_rm.bitwise_and.write(status,8'hAA);
        hbus_rm.bitwise_and.write(status,8'h55);
        `uvm_info("BITWISE VALUE", $sformatf("bitwise mirrored value before read transaction %0h", bitwise_and.get_mirrored_value()), UVM_MEDIUM)
        hbus_rm.bitwise_and.read(status,value);
        `uvm_info("BITWISE VALUE", $sformatf("bitwise mirrored value after read transaction %0h", bitwise_and.get_mirrored_value()), UVM_MEDIUM)
        `uvm_info("BITWISE VALUE", $sformatf("bitwise read value %0h", value), UVM_MEDIUM)

        repeat (2) @ (posedge env.agnt_main.drv.m_hbus_if.clk);
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_bitwise_and_test_sv