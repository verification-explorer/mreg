`ifndef ro_reg_sv
`define ro_reg_sv
class ro_reg extends uvm_reg;
    
    rand uvm_reg_field general;
    
    `uvm_object_utils(ro_reg)
    
    function new (string name="ro_reg");
        super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
        general = uvm_reg_field::type_id::create( "general" );
        general.configure( 
        .parent                 ( this ),
        .size                   ( 8    ),
        .lsb_pos                ( 0    ),
        .access                 ( "RO" ),
        .volatile               ( 0    ),
        .reset                  ( 'hAA ),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
    endfunction
    
endclass: ro_reg

`endif //ro_reg_sv






