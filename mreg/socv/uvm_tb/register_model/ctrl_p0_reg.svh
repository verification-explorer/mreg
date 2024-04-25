`ifndef ctrl_p0_reg_sv
`define ctrl_p0_reg_sv
class ctrl_p0_reg extends uvm_reg;
    
    rand uvm_reg_field en_port;
    rand uvm_reg_field climit;
    rand uvm_reg_field vlimit;
    rand uvm_reg_field unused;

    // rand uvm_reg_field_ext en_port;
    // rand uvm_reg_field_ext climit;
    // rand uvm_reg_field_ext vlimit;
    // rand uvm_reg_field_ext unused;
    
    `uvm_object_utils(ctrl_p0_reg)
    
    function new (string name="ctrl_p0_reg");
        super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
        // en_port = uvm_reg_field_ext::type_id::create( "en_port" );
        en_port = uvm_reg_field::type_id::create( "en_port" );
        en_port.configure( 
        .parent                 ( this ),
        .size                   ( 1    ),
        .lsb_pos                ( 0    ),
        .access                 ( "RW" ),
        .volatile               ( 0    ),
        .reset                  ( 1    ),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
        
        climit = uvm_reg_field::type_id::create( "climit" );
        climit.configure( 
        .parent                 ( this ),
        .size                   ( 2    ),
        .lsb_pos                ( 1    ),
        .access                 ( "RW" ),
        .volatile               ( 0    ),
        .reset                  ( 2'b11),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
        
        vlimit = uvm_reg_field::type_id::create( "vlimit" );
        vlimit.configure( 
        .parent                 ( this ),
        .size                   ( 2    ),
        .lsb_pos                ( 3    ),
        .access                 ( "RW" ),
        .volatile               ( 0    ),
        .reset                  ( 2'b11),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
        
        unused = uvm_reg_field::type_id::create( "unused" );
        unused.configure( 
        .parent                 ( this ),
        .size                   ( 3    ),
        .lsb_pos                ( 5    ),
        .access                 ( "RW" ),
        .volatile               ( 0    ),
        .reset                  ( 3'b000),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
        
    endfunction

    // task pre_read(uvm_reg_item rw);
    //     `uvm_info(get_name(), $sformatf("pre_read hook was activate in register %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    // endtask

    // task post_read(uvm_reg_item rw);
    //     `uvm_info(get_name(), $sformatf("post_read hook was activate in register %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    // endtask
    
    // task pre_write(uvm_reg_item rw);
    //     `uvm_info(get_name(), $sformatf("pre_write hook was activate in register %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    // endtask

    // task post_write(uvm_reg_item rw);
    //     `uvm_info(get_name(), $sformatf("post_write hook was activate in register %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    // endtask

    function string convert2string();
        string s="";
        $sformat(s,"%s values for register %s", s, get_name());
        $sformat(s,"%s en_port=%0b", s, en_port);
        $sformat(s,"%s climit=%0b", s, climit);
        $sformat(s,"%s vlimit=%0b", s, vlimit);
        $sformat(s,"%s unused=%0b", s, unused);
        return s;
    endfunction

endclass: ctrl_p0_reg


`endif //ctrl_p0_reg_sv






