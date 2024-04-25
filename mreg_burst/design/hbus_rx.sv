`ifndef hbus_rx_sv
`define hbus_rx_sv
module hbus_rx (hbus_if.receive main, hbus_if.receive secondary);
    
    import hbus_types_pkg::*;
    
    // Main register addresses
    parameter int DEF_CTRL_P0 = 8'h00;
    parameter int DEF_CTRL_P1 = 8'h01;
    parameter int DEF_CTRL_P2 = 8'h02;
    parameter int DEF_CTRL_P3 = 8'h03;
    parameter int DEF_STATUS = 8'h04;
    parameter int DEF_ID = 8'h05;
    parameter int DEF_RO = 8'h06;
    parameter int DEF_BITWISE_AND = 8'h07;
    
    // Main register addresses
    parameter int DEF_GP_ONE = 8'h00;
    parameter int DEF_CTRL_P0_S = 8'h01;
    parameter int DEF_SHADOW = 8'h02;
    
    // Main registers
    logic [IfWidth-1:0] ctrl_p0_reg;
    logic [IfWidth-1:0] ctrl_p1_reg;
    logic [IfWidth-1:0] ctrl_p2_reg;
    logic [IfWidth-1:0] ctrl_p3_reg;
    logic [IfWidth-1:0] status_reg;
    logic [IfWidth-1:0] ro_reg;
    logic [2:0] id_reg_pointer;
    logic [2:0] id_reg_pointer_read;
    logic [2:0] id_reg_pointer_read_temp;
    logic [IfWidth-1:0] id_reg_value[IfWidth];
    logic [IfWidth-1:0] id_reg_value_current;
    logic [IfWidth-1:0] bitwise_and_reg;
    
    // Secondary registers
    logic [IfWidth-1:0] gp_one_reg;
    logic [IfWidth-1:0] shadow_reg;
    
    logic [IfWidth-1:0] data_temp;
    logic [IfWidth-1:0] data_temp_s;
    logic id_flag;
    
    assign id_reg_value_current=id_reg_value[id_reg_pointer_read];
    
    assign main.hdata = (main.hen & !main.hwr_rd) ? data_temp : 8'hZ;
    assign secondary.hdata = (secondary.hen & !secondary.hwr_rd) ? data_temp_s : 8'hZ;

    assign shadow_reg = ctrl_p1_reg;
    
    always_ff @ (posedge main.clk, negedge main.rstn) begin: CTRL_REG
        if (~main.rstn) begin
            ctrl_p0_reg <= {3'b000,hbus_types::T47,hbus_types::HT,hbus_types::EN};
            ctrl_p1_reg <= {3'b000,hbus_types::T47,hbus_types::HT,hbus_types::EN};
            ctrl_p2_reg <= {3'b000,hbus_types::T47,hbus_types::HT,hbus_types::EN};
            ctrl_p3_reg <= {3'b000,hbus_types::T47,hbus_types::HT,hbus_types::EN};
        end else begin
            if (main.hen & main.hwr_rd) begin
                case (main.haddr)
                    DEF_CTRL_P0: ctrl_p0_reg <= main.hdata;
                    DEF_CTRL_P1: ctrl_p1_reg <= main.hdata;
                    DEF_CTRL_P2: ctrl_p2_reg <= main.hdata;
                    DEF_CTRL_P3: ctrl_p3_reg <= main.hdata;
                endcase
            end
            else if (secondary.hen & secondary.hwr_rd) begin
                case (secondary.haddr)
                    DEF_CTRL_P0_S: ctrl_p0_reg <= secondary.hdata;
                endcase
            end
        end
    end: CTRL_REG
    
    always_ff @ (posedge main.clk, negedge main.rstn) begin: ID_REG_WRITE
        if (~main.rstn) begin
            id_reg_pointer <= 0;
            id_reg_value <= '{hbus_types::ST0, hbus_types::ST1, hbus_types::ST2, hbus_types::ST3, hbus_types::ST4, hbus_types::ST5, hbus_types::ST6, hbus_types::ST7};
        end else begin
            if (main.hen & main.hwr_rd) begin
                /*unique*/ case (main.haddr)
                DEF_ID: begin
                    if (main.hdata < 8) id_reg_pointer <= main.hdata[2:0];
                    else id_reg_pointer <= 0;
                end
            endcase
        end
    end
end: ID_REG_WRITE

always_ff @ (negedge main.clk, negedge main.rstn) begin : ID_REG_READ
    if (~main.rstn) begin
        id_reg_pointer_read <= 0;
        id_reg_pointer_read_temp <= 0;
        id_flag <= 0;
    end else if (id_reg_pointer_read_temp != id_reg_pointer) begin
        id_reg_pointer_read_temp <= id_reg_pointer;
        id_reg_pointer_read <= id_reg_pointer;
    end else begin
        if (!id_flag) begin
            if (main.hen & !main.hwr_rd) begin
                DEF_ID: begin
                    if (id_reg_pointer_read == 7) id_reg_pointer_read <= 0;
                    else id_reg_pointer_read <= id_reg_pointer_read + 1;
                    id_flag <= 1;
                end
            end
        end else begin
            id_flag <= 0;
        end
    end
end: ID_REG_READ

always_ff @ (posedge main.clk, negedge main.rstn) begin: STATUS_REG
    if (~main.rstn) begin
        status_reg <= 4'hf;
    end else begin
        if (main.hen & main.hwr_rd) begin
            /*unique*/ case (main.haddr)
            DEF_CTRL_P0: status_reg[0] <= main.hdata[0];
            DEF_CTRL_P1: status_reg[1] <= main.hdata[0];
            DEF_CTRL_P2: status_reg[2] <= main.hdata[0];
            DEF_CTRL_P3: status_reg[3] <= main.hdata[0];
        endcase
    end
end
end: STATUS_REG

always_ff @ (posedge main.clk, negedge main.rstn) begin: RO_REG
    if (~main.rstn) begin
        ro_reg <= 'hAA;
    end
end: RO_REG

always_ff @ (posedge main.clk, negedge main.rstn) begin: BITWISE_AND
    if (~main.rstn) begin
        bitwise_and_reg <= 8'hFF;
    end else begin
        if (main.hen & main.hwr_rd) begin
            case (main.haddr)
                DEF_BITWISE_AND: bitwise_and_reg <= main.hdata & bitwise_and_reg;
            endcase
        end else if (main.hen & !main.hwr_rd) begin
            case (main.haddr)
                DEF_BITWISE_AND: bitwise_and_reg <= 8'hFF;
            endcase
        end
    end
end: BITWISE_AND

always_ff @ (negedge main.clk, negedge main.rstn) begin : READ_REG
    if (~main.rstn) begin
        data_temp <= 0;
    end else begin
        if (main.hen & !main.hwr_rd) begin
            /*unique*/ case (main.haddr)
            DEF_CTRL_P0: data_temp <= ctrl_p0_reg;
            DEF_CTRL_P1: data_temp <= ctrl_p1_reg;
            DEF_CTRL_P2: data_temp <= ctrl_p2_reg;
            DEF_CTRL_P3: data_temp <= ctrl_p3_reg;
            DEF_STATUS: data_temp <= status_reg;
            DEF_ID: data_temp <= id_reg_value[id_reg_pointer_read];
            DEF_RO: data_temp <= ro_reg;
            DEF_BITWISE_AND: data_temp <= bitwise_and_reg;
        endcase
    end
end
end: READ_REG

// Secondary registers
always_ff @ (posedge secondary.clk, negedge secondary.rstn) begin: GP_ONE_REG
    if (~secondary.rstn) begin
        gp_one_reg <= 8'h00;
    end else begin
        if (secondary.hen & secondary.hwr_rd) begin
            case (secondary.haddr)
                DEF_GP_ONE: gp_one_reg <= secondary.hdata;
            endcase
        end
    end
end: GP_ONE_REG

always_ff @ (negedge secondary.clk, negedge secondary.rstn) begin : READ_REG_S
    if (~secondary.rstn) begin
        data_temp_s <= 0;
    end else begin
        if (secondary.hen & !secondary.hwr_rd) begin
            case (secondary.haddr)
                DEF_GP_ONE: data_temp_s <= gp_one_reg;
                DEF_CTRL_P0_S: data_temp_s <= ctrl_p0_reg;
                DEF_SHADOW: data_temp_s <= shadow_reg;
            endcase
        end
    end
end: READ_REG_S

endmodule
`endif //hbus_rx_sv