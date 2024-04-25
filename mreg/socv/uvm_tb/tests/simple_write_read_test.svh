`ifndef simple_write_read_test_test_sv
`define simple_write_read_test_test_sv
class simple_write_read_test extends hbus_base_test;
    
    hbus_reg_block hbus_rm;
    
    uvm_status_e status;
    rand bit [7:0] exp_value;
    rand bit [7:0] real_value;
    
    uvm_reg ctrl_p0;
    
    
    `uvm_component_utils(simple_write_read_test)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
        ctrl_p0=hbus_rm.ctrl_p0;
    endfunction
    
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        
        ctrl_p0.write(status,exp_value);
        ctrl_p0.read(status,real_value);
                
        phase.drop_objection(this);
    endtask
endclass
`endif //simple_write_read_test_test_sv
