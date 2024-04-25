`ifndef bitwise_and_reg_sv
`define bitwise_and_reg_sv
class bitwise_and_reg extends uvm_reg;
    
    rand uvm_reg_field result;
    
    `uvm_object_utils(bitwise_and_reg)
    
    function new (string name="bitwise_and_reg");
        super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
        result = uvm_reg_field::type_id::create( "result" );
        result.configure( 
        .parent                 ( this ),
        .size                   ( 8    ),
        .lsb_pos                ( 0    ),
        .access                 ( "RW" ),
        .volatile               ( 0    ),
        .reset                  ( 8'hFF),
        .has_reset              ( 1    ),
        .is_rand                ( 1    ),
        .individually_accessible( 0    ) );
    endfunction
    
endclass: bitwise_and_reg

`endif //bitwise_and_reg_sv






