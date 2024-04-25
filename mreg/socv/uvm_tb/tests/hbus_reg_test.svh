`ifndef hbus_reg_test_sv
`define hbus_reg_test_sv
class my_reg_cbs extends uvm_reg_cbs;

    `uvm_object_utils(my_reg_cbs)

    function new (string name="ctrl_p0_cbs");
        super.new(name);
    endfunction

    task pre_read(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("pre_read callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    task post_read(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("post_read callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask
    
    task pre_write(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("pre_write callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    task post_write(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("post_write callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask
    
endclass: my_reg_cbs

class my_field_cbs extends uvm_reg_cbs;

    `uvm_object_utils(my_field_cbs)

    function new (string name="my_field_cbs");
        super.new(name);
    endfunction

    task pre_read(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("pre_read callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    task post_read(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("post_read callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask
    
    task pre_write(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("pre_write callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    task post_write(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("post_write callback was activate in %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    function void post_predict (
        input uvm_reg_field fld,
        input uvm_reg_data_t previous,
        inout uvm_reg_data_t value,
        input uvm_predict_e kind,
        input uvm_path_e path,
        input uvm_reg_map map
    );
    `uvm_info(get_name(), $sformatf("post_predict callback was activate in field %s", get_name()), UVM_MEDIUM)
    `uvm_info(get_name(), $sformatf("fld %s,previous %0h, value %0h, kind %s\n",fld.convert2string(), previous, value, kind.name), UVM_MEDIUM)
    endfunction
endclass

class hbus_reg_test extends hbus_base_test;

    // hbus_write_ctrl_p0 write_ctrl_p0;

    hbus_reg_block hbus_rm;

    uvm_status_e status;

    bit [7:0] value;

    my_field_cbs field_cbs;
    my_reg_cbs reg_cbs;
    my_reg_cbs reg_cbs_2nd;

    `uvm_component_utils(hbus_reg_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        // write_ctrl_p0=hbus_write_ctrl_p0::type_id::create("write_ctrl_p0");
        field_cbs=my_field_cbs::type_id::create("field_cbs");
        reg_cbs=my_reg_cbs::type_id::create("reg_cbs");
        reg_cbs_2nd=my_reg_cbs::type_id::create("reg_cbs_2nd");
    endfunction

    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);

        // uvm_callbacks#(uvm_reg_field, uvm_reg_cbs)::add(env.hbus_rm.ctrl_p0.en_port,field_cbs);
        uvm_reg_field_cb::add(env.hbus_rm.ctrl_p0.en_port,field_cbs);

        // uvm_callbacks#(uvm_reg, uvm_reg_cbs)::add(env.hbus_rm.ctrl_p0,reg_cbs);
        uvm_reg_cb::add(env.hbus_rm.ctrl_p0,reg_cbs);
        uvm_reg_cb::add(env.hbus_rm.ctrl_p0,reg_cbs_2nd,UVM_PREPEND);


        @ (posedge env.agnt_main.drv.m_hbus_if.rstn);
        @ (posedge env.agnt_main.drv.m_hbus_if.clk);
        
        $display(head);
        `uvm_info(get_name(), "Start write transaction on register ctrl_p0", UVM_NONE)
        $display(head);
        hbus_rm.ctrl_p0.write(status,8'hAA);

        $display(head);
        `uvm_info(get_name(), "Start read transaction on register ctrl_p0", UVM_NONE)
        $display(head);
        hbus_rm.ctrl_p0.read(status,value);

        // write_ctrl_p0.start(env.agnt_main.seqr);
        repeat (2) @ (posedge env.agnt_main.drv.m_hbus_if.clk);
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_reg_test_sv