`ifndef hbus_reg_block_sv
`define hbus_reg_block_sv
class hbus_reg_block extends uvm_reg_block;
    
    // Main registers
    rand ctrl_p0_reg ctrl_p0;
    rand ctrl_p1_reg ctrl_p1;
    rand ctrl_p2_reg ctrl_p2;
    rand ctrl_p3_reg ctrl_p3;
    ro_reg ro;
    status_reg status;
    id_register_reg id_register;
    bitwise_and_reg bitwise_and;
    
    // Secondary registers
    rand gp_one_reg gp_one;
    shadow_reg shadow;
    
    uvm_reg_map hbus_reg_block_main_map;
    uvm_reg_map hbus_reg_block_secondary_map;
    
    `uvm_object_utils(hbus_reg_block)
    
    function new (string name="hbus_reg_block");
        super.new(name, build_coverage(UVM_NO_COVERAGE));
    endfunction
    
    function void build();
        ctrl_p0=ctrl_p0_reg::type_id::create("ctrl_p0");
        ctrl_p0.configure(this);
        ctrl_p0.build();
        
        ctrl_p1=ctrl_p1_reg::type_id::create("ctrl_p1");
        ctrl_p1.configure(this);
        ctrl_p1.build();
        
        ctrl_p2=ctrl_p2_reg::type_id::create("ctrl_p2");
        ctrl_p2.configure(this);
        ctrl_p2.build();
        
        ctrl_p3=ctrl_p3_reg::type_id::create("ctrl_p3");
        ctrl_p3.configure(this);
        ctrl_p3.build();
        
        ro=ro_reg::type_id::create("ro");
        ro.configure(this);
        ro.build();
        
        status=status_reg::type_id::create("status");
        status.configure(this);
        status.build();
        
        id_register=id_register_reg::type_id::create("id_register");
        id_register.configure(this);
        id_register.build();
        
        bitwise_and=bitwise_and_reg::type_id::create("bitwise_and");
        bitwise_and.configure(this);
        bitwise_and.build();

        gp_one=gp_one_reg::type_id::create("gp_one");
        gp_one.configure(this);
        gp_one.build();

        shadow=shadow_reg::type_id::create("shadow");
        shadow.configure(this);
        shadow.build();
        
        hbus_reg_block_main_map=create_map(
        .name("hbus_reg_block_main_map"),
        .base_addr('h0),
        .n_bytes(1),
        .endian(UVM_LITTLE_ENDIAN),
        .byte_addressing(1)
        );

        hbus_reg_block_secondary_map=create_map(
        .name("hbus_reg_block_secondary_map"),
        .base_addr('h0),
        .n_bytes(1),
        .endian(UVM_LITTLE_ENDIAN),
        .byte_addressing(1)
        );
        
        default_map=hbus_reg_block_main_map;
        
        hbus_reg_block_main_map.add_reg(ctrl_p0,'h0,"RW");
        hbus_reg_block_main_map.add_reg(ctrl_p1,'h1,"RW");
        hbus_reg_block_main_map.add_reg(ctrl_p2,'h2,"RW");
        hbus_reg_block_main_map.add_reg(ctrl_p3,'h3,"RW");
        hbus_reg_block_main_map.add_reg(status,'h4,"RO");
        hbus_reg_block_main_map.add_reg(id_register,'h5,"RW");
        hbus_reg_block_main_map.add_reg(ro,'h6,"RO");
        hbus_reg_block_main_map.add_reg(bitwise_and,'h7,"RW");

        hbus_reg_block_secondary_map.add_reg(gp_one,'h0,"RW");
        hbus_reg_block_secondary_map.add_reg(ctrl_p0,'h1,"RW");
        hbus_reg_block_secondary_map.add_reg(shadow,'h2,"RO");
        
        set_hdl_path_root(.path("top.dut"));

        ctrl_p0.add_hdl_path_slice(.name("ctrl_p0_reg"),.offset(0),.size(8));
        // ctrl_p0.add_hdl_path_slice(.name("ctrl_p1_reg"),.offset(0),.size(8));
        ctrl_p1.add_hdl_path_slice(.name("ctrl_p1_reg"),.offset(0),.size(8));
        ctrl_p2.add_hdl_path_slice(.name("ctrl_p2_reg"),.offset(0),.size(8));
        ctrl_p3.add_hdl_path_slice(.name("ctrl_p3_reg"),.offset(0),.size(8));
        status.add_hdl_path_slice(.name("status_reg"),.offset(0),.size(4));
        id_register.add_hdl_path_slice(.name("id_reg_value_current"),.offset(0),.size(8));
        ro.add_hdl_path_slice(.name("ro_reg"),.offset(0),.size(8));
        bitwise_and.add_hdl_path_slice(.name("bitwise_and_reg"),.offset(0),.size(8));

        gp_one.add_hdl_path_slice(.name("gp_one_reg"),.offset(0),.size(8));
        shadow.add_hdl_path_slice(.name("shadow_reg"),.offset(0),.size(8));
        
        lock_model();
        
    endfunction
    
endclass
`endif //hbus_reg_block_sv