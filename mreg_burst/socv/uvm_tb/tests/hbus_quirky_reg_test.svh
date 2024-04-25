`ifndef hbus_quirky_reg_test_sv
`define hbus_quirky_reg_test_sv
class hbus_quirky_reg_test extends hbus_base_test;
    
    hbus_reg_block hbus_rm;
    
    uvm_status_e status;
    
    uvm_reg id_register;
    
    bit [7:0] reg_val;
    
    bit ok;
    
    `uvm_component_utils(hbus_quirky_reg_test)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
        id_register=hbus_rm.id_register;
    endfunction
    
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        
        for (int idx=0; idx<10; idx++) begin
            id_register.read(status,reg_val);
            `uvm_info("MIRRORED_VALUE", $sformatf("id_register mirrored value %0h", id_register.get_mirrored_value()), UVM_MEDIUM)
            `uvm_info("DESIRED_VALUE", $sformatf("id_register desired value %0h", id_register.get()), UVM_MEDIUM)
        end

        id_register.write(status,8'h3);  
        
        for (int idx=0; idx<3; idx++) begin
            id_register.read(status,reg_val);
            `uvm_info("MIRRORED_VALUE", $sformatf("id_register mirrored value %0h", id_register.get_mirrored_value()), UVM_MEDIUM)
            `uvm_info("DESIRED_VALUE", $sformatf("id_register desired value %0h", id_register.get()), UVM_MEDIUM)
        end
        
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_quirky_reg_test_sv