`ifndef shadow_reg_sv
`define shadow_reg_sv
class shadow_reg extends uvm_reg;
    
    rand uvm_reg_field shadow;
    
    `uvm_object_utils(shadow_reg)
    
    function new (string name="shadow_reg");
        super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
        shadow = uvm_reg_field::type_id::create( "shadow" );
        shadow.configure( 
        .parent                 ( this ),
        .size                   ( 8    ),
        .lsb_pos                ( 0    ),
        .access                 ( "RO" ),
        .volatile               ( 0    ),
        .reset                  ( 8'h1F),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
        
    endfunction

endclass: shadow_reg

`endif //shadow_reg_sv






