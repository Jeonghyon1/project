module music(
        input clk, rstb,
        input is_ringing,
        output buzz
    );
    
    parameter 
    /*C3 = 3822,  C4 = 1910,  C5 = 954, 
    C3S = 3607, C4S = 1803, C5S = 901,
    D3 = 3404,  D4 = 1702,  D5 = 850,
    D3S = 3213, D4S = 1606, D5S = 803,
    E3 = 3033,  E4 = 1516,  E5 = 758,
    F3 = 2862,  F4 = 1431,  F5 = 715,
    F3S = 2702, F4S = 1350, F5S = 675,
    G3 = 2550,  G4 = 1275,  G5 = 637,
    G3S = 2407, G4S = 1203, G5S = 602,
    A3 = 2271,  A4 = 1135,  A5 = 567,
    A3S = 2144, A4S = 1072, A5S = 536,
    B3 = 2024,  B4 = 1011,  B5 = 505;*/
    
    // pitches used in melody
    N0 = 0, N1 = 1910, N2 = 1516, N3 = 1431, N4 = 1275, N5 = 1203, N6 = 1135, 
    N7 = 1011, N8 = 954, N9 = 850, N10 = 803, N11 = 758, N12 = 715;
    
    // phrase consisting the melody
    // each 4 bits indicates the pitches; N0, N1, ..., N12
    parameter
    P0 = 16'b0000000000000000,
    P1 = 16'b1011101010111010,
    P2 = 16'b1011011110011000,
    P3 = 16'b0110011001100001, 
    P4 = 16'b0010011001110111, 
    P5 = 16'b0111001001010111, 
    P6 = 16'b1000100010000010,
    P7 = 16'b0111001010000111,
    P8 = 16'b0110011001100111,
    P9 = 16'b1000100110111011,
    P10= 16'b1011010011001011,
    P11= 16'b1001100110010011,
    P12= 16'b1011100110001000,
    P13= 16'b1000001010011000,
    P14= 16'b0111011101110010,
    P15= 16'b0110011001100010; 
    
    // current pitch
    reg [11:0] PITCH;
	
	// actual sound module instantiation
	// this role as instrument
    sound S (.clk(clk), .rstb(rstb), .is_ringing(is_ringing), .pitch(PITCH), .buzz(buzz));
    
	// This two rel_cnt is used to adjust clock to real tempo
    reg [15:0] rel_cnt1, rel_cnt2;
    // note_cnt denotes which order of note is played in phfase, 
    // from 0 to 3
    reg [1:0] note_cnt;
    // note is the actual note number being played
    reg [3:0] note;
    // the current phrase being played
    reg [15:0] phrase;
    // there are total 25 states(one is just initial stsate)
    reg [4:0] curr_state;
    // triggers for note and phrase change
    reg is_note_changed;
    reg is_phrase_changed;
    
    always@(posedge clk or negedge rstb)
    begin   
    	// reset    
        if (!rstb)
        begin
            rel_cnt1 <= 0;
            rel_cnt2 <= 0;
            note <= 1;
            note_cnt <= 0;
            PITCH <= N11;
            phrase <= P1;
            is_note_changed <= 0;
            is_phrase_changed <= 0;
            curr_state <= 1;
        end
        // if phrase changed is required
        else if (is_phrase_changed)
        begin
            is_phrase_changed <= 0;
            // switch to next phrase
            case (curr_state)
                5'd1: begin phrase <= P2; end
                5'd2: begin phrase <= P3; end
                5'd3: begin phrase <= P4; end
                5'd4: begin phrase <= P5; end
                5'd5: begin phrase <= P6; end
                5'd6: begin phrase <= P1; end
                5'd7: begin phrase <= P2; end
                5'd8: begin phrase <= P3; end
                5'd9: begin phrase <= P4; end
                5'd10: begin phrase <= P7; end
                5'd11: begin phrase <= P8; end
                5'd12: begin phrase <= P9; end
                5'd13: begin phrase <= P10; end
                5'd14: begin phrase <= P11; end
                5'd15: begin phrase <= P12; end
                5'd16: begin phrase <= P13; end
                5'd17: begin phrase <= P14; end
                5'd18: begin phrase <= P1; end
                5'd19: begin phrase <= P2; end
                5'd20: begin phrase <= P3; end
                5'd21: begin phrase <= P4; end
                5'd22: begin phrase <= P7; end
                5'd23: begin phrase <= P15; end
                5'd24: begin phrase <= P1; end
                default: begin phrase <= P1; end
            endcase
        end
        // if there is a note change
        else if (is_note_changed)
        begin
            is_note_changed <= 0;
            // assign a pitch by the note
            case (note)
                4'd1: begin PITCH <= N1; end
                4'd2: begin PITCH <= N2; end
                4'd3: begin PITCH <= N3; end
                4'd4: begin PITCH <= N4; end
                4'd5: begin PITCH <= N5; end
                4'd6: begin PITCH <= N6; end
                4'd7: begin PITCH <= N7; end
                4'd8: begin PITCH <= N8; end
                4'd9: begin PITCH <= N9; end
                4'd10: begin PITCH <= N10; end
                4'd11: begin PITCH <= N11; end
                4'd12: begin PITCH <= N12; end
                default: begin PITCH <= 0; end
            endcase
        end
        else
        begin
        	// each note is 8th note and the tempo is 120 bpm.
        	// therefore two cnt variables are used to count 250ms
            if (rel_cnt1 == 16'd9999) begin
                rel_cnt1 <= 0;
                if (rel_cnt2 == 16'd2499) begin
                    rel_cnt2 <= 0;
                    // assign note in current phrase according to note_cnt
                    case (note_cnt)
                        2'b00: begin
                            note <= phrase[15:12];
                        end
                        2'b01: begin
                            note <= phrase[11:8];
                        end
                        2'b10: begin
                            note <= phrase[7:4];
                        end
                        2'b11: begin
                            note <= phrase[3:0];
                        end
                        default: begin
                            note <= 0;
                        end
                    endcase                    
                    // if note_cnt is 3, then it returns to 0
                    // and phrase change should be triggered
                    if (note_cnt == 2'b11) begin
                        note_cnt <= 0;
                        is_phrase_changed <= 1;
                        // if current state is the last state(24)
                        // then return to first state
                        if (curr_state == 5'd24) begin
                            curr_state <= 5'd1;
                        end
                        // otherwise, move to next state
                        else begin
                            curr_state <= curr_state + 1;
                        end
                    end
                    // move to next note
                    else begin
                        note_cnt <= note_cnt + 1;
                    end
                    // after move to next note, trigger that the note has just been changed
                    is_note_changed <= 1;
                end
                else begin
                    rel_cnt2 <= rel_cnt2 + 1;
                end
            end
            else begin
                rel_cnt1 <= rel_cnt1 + 1;
            end
    
            end 
        end
    
endmodule
