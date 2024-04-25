`ifndef gp_one_reg_sv
`define gp_one_reg_sv
class gp_one_reg extends uvm_reg;
    
    rand uvm_reg_field general;
    
    `uvm_object_utils(gp_one_reg)
    
    function new (string name="gp_one_reg");
        super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
        general = uvm_reg_field::type_id::create( "general" );
        general.configure( 
        .parent                 ( this ),
        .size                   ( 8    ),
        
        .lsb_pos                ( 0    ),
        .access                 ( "RW" ),
        .volatile               ( 0    ),
        .reset                  ( 8'h00),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
        
    endfunction

endclass: gp_one_reg

`endif //gp_one_reg_sv






