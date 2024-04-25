`ifndef hbus_reg_api_test_sv
`define hbus_reg_api_test_sv
class hbus_reg_api_test extends hbus_base_test;
    
    hbus_reg_block hbus_rm;
    
    uvm_status_e status;
    rand bit [7:0] exp_value;
    rand bit [7:0] real_value;
    
    uvm_reg ctrl_p0;
    uvm_reg ctrl_p1;
    uvm_reg ctrl_p2;
    uvm_reg ctrl_p3;
    uvm_reg ro; // read only ref
    uvm_reg temp_reg;
    
    uvm_reg temp_regs[$];
    
    bit ok;
    
    `uvm_component_utils(hbus_reg_api_test)
    
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
        ctrl_p1=hbus_rm.ctrl_p1;
        ctrl_p2=hbus_rm.ctrl_p2;
        ctrl_p3=hbus_rm.ctrl_p3;
        ro=hbus_rm.ro;
    endfunction
    
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        
        // Check the read value against the the mirrored value in the register model
        hbus_rm.hbus_reg_block_main_map.set_check_on_read(1);
        
        // Write-Read frontdoor
        ok=std::randomize(exp_value);
        if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
        ctrl_p0.write(status,exp_value);
        ctrl_p0.read(status,real_value);
        compare_regs(exp_value,real_value,"Testing write read via frontdoor access");
        
        // Write backdoor - read frontdoor
        ok=std::randomize(exp_value);
        if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
        ctrl_p0.write(status,exp_value,UVM_BACKDOOR);
        ctrl_p0.read(status,real_value);
        compare_regs(exp_value,real_value,"Testing write via backdoor read via frontdoor access");
        
        // Write frontdoor - read backdoor
        ok=std::randomize(exp_value);
        if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
        ctrl_p0.write(status,exp_value);
        ctrl_p0.read(status,real_value,UVM_BACKDOOR);
        compare_regs(exp_value,real_value,"Testing write via frontdoor read via backdoor access");
        
        // Write backdoor - read backdoor
        ok=std::randomize(exp_value);
        if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
        ctrl_p0.write(status,exp_value,UVM_BACKDOOR);
        ctrl_p0.read(status,real_value,UVM_BACKDOOR);
        compare_regs(exp_value,real_value,"Testing write via backdoor read via backdoor access");
        
        // poke(only backdoor) read frontdoor
        ok=std::randomize(exp_value);
        if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
        ro.poke(status,exp_value);
        ro.read(status,real_value,UVM_FRONTDOOR);
        compare_regs(exp_value,real_value,"Testing poke (backdoor) read via front access on read only register");
        ro.peek(status,real_value);
        compare_regs(exp_value,real_value,"Testing peek (backdoor) read via front access on read only register");
        
        // Get mirror value
        ok=std::randomize(exp_value);
        if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
        ctrl_p0.write(status,exp_value);
        real_value=ctrl_p0.get_mirrored_value();
        compare_regs(exp_value,real_value,"Testing get_mirrored_value");
        
        // Get/set
        $display(head);
        for (int idx=0; idx<4; idx++) begin
            ok=std::randomize(exp_value);
            if(!ok) `uvm_error(get_name(), "Failed to randomize expected value")
            case (idx)
                0: ctrl_p0.set(exp_value); 
                1: ctrl_p1.set(exp_value); 
                2: ctrl_p2.set(exp_value); 
                3: ctrl_p3.set(exp_value); 
            endcase
        end
        hbus_rm.update(status);
        
        // Mirror (same as read but with check capabilities)
        $display(head);
        ctrl_p0.write(status,8'h55);
        ctrl_p0.predict(8'hAA);
        `uvm_info(get_name(), $sformatf("ctrl_p0 desired value %0h", ctrl_p0.get()), UVM_MEDIUM)
        `uvm_info(get_name(), $sformatf("ctrl_p0 mirrored value %0h", ctrl_p0.get_mirrored_value()), UVM_MEDIUM)
        ctrl_p0.mirror(status, UVM_CHECK);
        
        // Get registers
        $display(head);
        hbus_rm.get_registers(temp_regs,UVM_HIER);
        foreach (temp_regs[idx]) begin
            `uvm_info(get_name(), $sformatf("register %s mirrored value is %0h",temp_regs[idx].get_name(), temp_regs[idx].get_mirrored_value), UVM_MEDIUM)
        end
        
        // Get register by name
        $display(head);
        for (int idx=0; idx<4; idx++) begin
            temp_reg=hbus_rm.get_reg_by_name($sformatf("ctrl_p%0d",idx));
            `uvm_info(get_name(), $sformatf("register %s mirrored value is %0h",temp_reg.get_name(), temp_reg.get_mirrored_value), UVM_MEDIUM)
        end
        
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_reg_api_test_sv