module clock_counter(
    input wire clk,
    input wire rstb,
    input wire [15:0] dip_switch,
    input wire [4:0] push_switch,
    output wire [7:0] seg_data,
    output wire [7:0] digit,
    output reg [15:0] led
);
    // Ŭ�� ���� (1Hz)
    wire clk_1hz;

    // Ŭ�� ���ֱ� �ν��Ͻ�
    clock_divider clk_div_inst (
        .clk_in(clk),
        .rst(rstb),
        .clk_out(clk_1hz)
    );

    // ���� �ð� ��������
    reg [7:0] current_time_reg [7:0];

    // �ð� ���� �� ���� ����
    always @(posedge clk_1hz or negedge rstb) begin
        if (!rstb) begin
            current_time_reg[0] <= 8'd0; // ��
            current_time_reg[1] <= 8'd0; // ��
            current_time_reg[2] <= 8'd0; // ��
            current_time_reg[3] <= 8'd0; // ��
            current_time_reg[4] <= 8'd0; // ��
            current_time_reg[5] <= 8'd0;
            current_time_reg[6] <= 8'd0;
            current_time_reg[7] <= 8'd0;
        end else if (push_switch[2]) begin
            // �ð� ���� ����
            if (current_time_reg[0] < 8'd59)
                current_time_reg[0] <= current_time_reg[0] + 1;
            else begin
                current_time_reg[0] <= 8'd0;
                if (current_time_reg[1] < 8'd59)
                    current_time_reg[1] <= current_time_reg[1] + 1;
                else begin
                    current_time_reg[1] <= 8'd0;
                    if (current_time_reg[2] < 8'd23)
                        current_time_reg[2] <= current_time_reg[2] + 1;
                    else begin
                        current_time_reg[2] <= 8'd0;
                        if (current_time_reg[3] < 8'd31)
                            current_time_reg[3] <= current_time_reg[3] + 1;
                        else begin
                            current_time_reg[3] <= 8'd0;
                            if (current_time_reg[4] < 8'd12)
                                current_time_reg[4] <= current_time_reg[4] + 1;
                            else
                                current_time_reg[4] <= 8'd0;
                        end
                    end
                end
            end
        end else if (dip_switch[0]) begin
            if (push_switch[0] && current_time_reg[4] < 8'd9)
                current_time_reg[4] <= current_time_reg[4] + 1;
            if (push_switch[4] && current_time_reg[4] > 8'd0)
                current_time_reg[4] <= current_time_reg[4] - 1;
        end
        // �ٸ� DIP ����ġ�� Ǫ�� ��ư�� ���� ó�� �߰�
    end

    // 7-���׸�Ʈ ���÷��� ��� �ν��Ͻ�ȭ
    seg7 seg7_inst (
        .rstb(rstb),
        .clk(clk),
        .digit(digit),
        .seg_data(seg_data)
    );

    // DIP ����ġ�� ���� LED ���
    always @(posedge clk) begin
        led <= dip_switch;
    end

endmodule
