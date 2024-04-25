`ifndef status_reg_sv
`define status_reg_sv
class status_reg extends uvm_reg;
    
    rand uvm_reg_field en_port[4];
    
    `uvm_object_utils(status_reg)
    
    function new (string name="status_reg");
        super.new(.name(name), .n_bits(4), .has_coverage(UVM_NO_COVERAGE));
    endfunction
    
    virtual function void build();
        foreach (en_port[idx]) begin
            en_port[idx] = uvm_reg_field::type_id::create( $sformatf("en_port_%0d",idx));
            en_port[idx].configure( 
            .parent                 ( this ),
            .size                   ( 1    ),
            .lsb_pos                ( idx    ),
            .access                 ( "RO" ),
            .volatile               ( 0    ),
            .reset                  ( 1    ),
            .has_reset              ( 1    ),
            .is_rand                ( 1    ),
            .individually_accessible( 0    ) );
        end
        
    endfunction

    function string convert2string();
        string s="";
        $sformat(s,"%s values for register %s", s, get_name());
        $sformat(s,"%s en_port[0]=%0b", s, en_port[0]);
        $sformat(s,"%s en_port[1]=%0b", s, en_port[1]);
        $sformat(s,"%s en_port[1]=%0b", s, en_port[2]);
        $sformat(s,"%s en_port[1]=%0b", s, en_port[3]);
        return s;
    endfunction
    
endclass: status_reg

`endif //status_reg_sv






