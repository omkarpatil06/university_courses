`timescale 1ns/1ps

module snake_gamne (

);

    parameter snakeWidth = 4'd5;
    parameter snakeLength = 5'd15;

    reg [7:0] snakeStateX [0 : snakeLength - 1];
    reg [6:0] snakeStateY [0 : snakeLength - 1];
    reg trigg25MHerz;
    reg speed_Trigger;

    UGeneric_Counter #(.COUNTER_WIDTH(2),
            .COUNTER_MAX(3))
            Counter25MHerz (
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(1'b1),
            .TRIG_OUT(trigg25MHerz)
            );

        // A counter to keep track of time. Can be set 1, 0.1, 0.01 or any such number of seconds.           
        UGeneric_Counter #(.COUNTER_WIDTH(24),
            .COUNTER_MAX(9999999))
            TriggTimer (
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(1'b1),
            .TRIG_OUT(speed_Trigger)
            );

    genvar pixelNo
    generate 
        for (pixelNo = 0; pixelNo < snakeLength - 1; pixelNo +1)
        begin: pixShifts
            always@(posedge CLK) begin
                if(RESET) begin
                    snakeStateX[pixelNo + 1] <= 80;
                    snakeStateY[pixelNo + 1] <= 100;
                end
                else if(~speed_Trigger == 0) begin
                    snakeStateX[pixelNo + 1] <= snakeStateX[pixelNo];
                    snakeStateY[pixelNo + 1] <= snakeStateY[pixelNo];
                end
            end
        end
    endgenerate

    always@(posedge CLK) begin
        if(RESET) begin
            snakeStateX[0] <= 80;
            snakeStateY[0] <= 100;
        end
        else if(speed_Trigger == 0) begin
            case(DIRECTION_OUT)
                2'd0 : begin
                    if(snakeStateY[0] == 0)
                        snakeStateY[0] <= 640;     // if snake reaches top of the monitor
                    else begin
                        snakeStateY[0] <= snakeStateY[0] - 1;
                    end
                end
                2'd1 : begin
                    if(snakeStateX[0] == 480)
                        snakeStateX[0] <= 0;
                    else begin
                        snakeStateX[0] <= snakeStateX[0] + 1;
                    end
                end
                2'd2 : begin
                    if(snakeStateY[0] == 640)
                        snakeStateY[0] <= 0;
                    else begin
                        snakeStateY[0] <= snakeStateY[0] + 1;
                    end
                end
                2'd3 : begin
                    if(snakeStateX[0] = 0)
                        snakeStateX <= 480;
                    else begin
                        snakeStateX[0] <= snakeStateX[0] - 1;
                    end
                end
            endcase
        end
    end

    always@(posedge CLK) begin
        if(snakeStateX == TARGET_X && snakeStateY == TARGET_Y)
            TARGET_REACHED <= 1;
        else
            TARGET_REACHED <= 0;
    end

    always(@posedge trigg25MHerz) begin
        case(DIRECTION_OUT)
            2'd0 : begin
                if((snakeStateX[0] <= ADDRESS_H & ADDRESS_H <= snakeStateX[0] + snakeWidth) & ((snakeStateY[0] <= ADDRESS_V & ADDRESS_V <= snakeStateY[0] + snakeWidth) & (snakeStateY[0] <= ADDRESS_V & ADDRESS_V <= snakeStateY[snakeLength - 1])))
                    COLOUR_OUT <= COLOUR_IN;
                else
                    COLOUR_OUT <= 0;
            
            end
            2'd1 : begin
                if(((snakeStateX[snakeLength - 1] <= ADDRESS_H & ADDRESS_H <= snakeStateX[snakeLength - 1] + snakeWidth) & (snakeStateX[snakeLength - 1] <= ADDRESS_H & ADDRESS_H <= snakeStateX[0])) & (snakeStateY[0] <= ADDRESS_V & ADDRESS_V <= snakeStateY[0] + snakeWidth))
                    COLOUR_OUT <= COLOUR_IN;
                else
                    COLOUR_OUT <= 0;
            end
            2'd2 : begin
                if((snakeStateX[0] <= ADDRESS_H & ADDRESS_H <= snakeStateX[0] + snakeWidth) & ((snakeStateY[snakeLength - 1] <= ADDRESS_V & ADDRESS_V <= snakeStateY[snakeLength - 1] + snakeWidth) & (snakeStateY[snakeLength - 1] <= ADDRESS_V & ADDRESS_V <= snakeStateY[0])))
                    COLOUR_OUT <= COLOUR_IN;
                else
                    COLOUR_OUT <= 0;
            
            end
            2'd3 : begin
                if(((snakeStateX[snakeLength - 1] <= ADDRESS_H & ADDRESS_H <= snakeStateX[snakeLength - 1] - snakeWidth) & (snakeStateX[0] <= ADDRESS_H & ADDRESS_H <= snakeStateX[snakeLength - 1])) & (snakeStateY[0] <= ADDRESS_V & ADDRESS_V <= snakeStateY[0] + snakeWidth))
                    COLOUR_OUT <= COLOUR_IN;
                else
                    COLOUR_OUT <= 0;
            end
        endcase
    end
endmodule