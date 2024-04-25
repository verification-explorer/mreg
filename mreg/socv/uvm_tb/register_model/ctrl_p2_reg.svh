`ifndef ctrl_p2_reg_sv
`define ctrl_p2_reg_sv
class ctrl_p2_reg extends uvm_reg;
    
    rand uvm_reg_field en_port;
    rand uvm_reg_field climit;
    rand uvm_reg_field vlimit;
    rand uvm_reg_field unused;
    
    `uvm_object_utils(ctrl_p2_reg)
    
    function new (string name="ctrl_p2_reg");
        super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
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
    
endclass: ctrl_p2_reg


`endif //ctrl_p2_reg_sv






