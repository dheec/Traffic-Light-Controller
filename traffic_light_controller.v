module traffic_light_contrl(t_lights,clk,rst);
parameter RED_LIGHT = 2'b00;
parameter YELLOW_LIGHT = 2'b01;
parameter GREEN_LIGHT = 2'b10;

input clk,rst;
output reg [1:0] t_lights;
reg [1:0] state, next_state;
reg [31:0] count;
reg red_delay, yellow_delay,green_delay,redl_en,yl_en,gl_en;

always@(posedge clk) begin
	if(rst)begin
		t_lights <= 3'b000;
		state <= 2'b00;
	end
	else
		state <= next_state;
end

always @(*) begin
case(state)
	RED_LIGHT:begin
		redl_en = 1;
		t_lights = 3'b100;
		if(redl_en == 0) next_state = YELLOW_LIGHT;
	end

	YELLOW_LIGHT:begin
		yl_en = 1;
		t_lights = 3'b010;
		if(yl_en == 0) next_state = GREEN_LIGHT;

	end

	GREEN_LIGHT:begin
		gl_en = 1;
		t_lights = 3'b001;
		if(gl_en == 0) next_state = RED_LIGHT;
	end
	
	default: begin
		redl_en = 0;
		yl_en = 0;
		gl_en = 0;
		t_lights = 3'b100;

	end
end

always@(posedge clk)begin
	if(redl_en || yl_en || gl_en)begin
		count <= count + 1;
		if(count == 10 && redl_en)begin
		       count = 0;redl_en = 0;
		end
		if(count == 2 && yl_en) begin
			count = 0; yl_en = 0;
		end
		if(count == 5 && gl_en) begin
			count = 0; gl_en = 0;
		end
	end
end

endmodule

