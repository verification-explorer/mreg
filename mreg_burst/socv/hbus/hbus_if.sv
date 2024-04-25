`ifndef hbus_if_sv
`define hbus_if_sv
interface hbus_if (input clk, rstn);
    
    import hbus_types_pkg::*;

    logic hen;
    logic hwr_rd;
    wire logic [IfWidth-1:0] hdata;
    logic [IfWidth-1:0] haddr;

    logic [IfWidth-1:0] hdata_reg;

    assign hdata = (hen & hwr_rd) ? hdata_reg : 8'hZ;
    
    modport receive (
        input hen, hwr_rd, haddr, clk, rstn,
        inout hdata
    );
endinterface
`endif //hbus_if_sv