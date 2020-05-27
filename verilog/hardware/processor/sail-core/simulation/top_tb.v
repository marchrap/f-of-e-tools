/*
	Authored 2020, Marcin Chrapek..

	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:

	*	Redistributions of source code must retain the above
		copyright notice, this list of conditions and the following
		disclaimer.

	*	Redistributions in binary form must reproduce the above
		copyright notice, this list of conditions and the following
		disclaimer in the documentation and/or other materials
		provided with the distribution.

	*	Neither the name of the author nor the names of its
		contributors may be used to endorse or promote products
		derived from this software without specific prior written
		permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/



/*
 *	Description:
 *
 *		This testbench implements the top module of the CPU.
 */



module top_tb;
	wire [7:0]	led;		//  The led top output
	reg		clk = 0; 	//  The clk of the top module

	integer		i;
	integer		number_of_cycles = 0;
	integer		last_cycle_seen = 0;
	integer		number_of_instructions = 0;

	top top_module(
		.led(led), 
		.clk(clk)
	);
	
	always begin
		#0.5 clk = ~clk;
		if (number_of_cycles % 1000 == 0) 
			$display("%d", number_of_cycles);	
	end

	always @(posedge clk)
		number_of_cycles += 1;

	always @(top_module.inst_out) begin
		//if (top_module.inst_out == 32'b0 && top_module.inst_in == 32'b0) begin
		//	$display("Number of instructions: %0d", number_of_instructions);
		//	$display("Number of clock cycles: %0d", number_of_cycles);
		//	$finish;
		//end
			
		//$display("%h, %b", top_module.inst_out, top_module.inst_out != 32'b0);
		number_of_instructions += 1;
		last_cycle_seen = number_of_cycles;
	end

	initial begin
		$dumpfile ("top_tb.vcd");
		$dumpvars;
		repeat (50000000) @(posedge clk);
		//for (i = 0; i < 50; i = i + 1) begin
		//	      $display ("Memory location %0d: %3h", i, top_module.data_mem_inst.data_block[i]);
		//end

		$display("Number of instructions: %0d", number_of_instructions);
		$display("Number of clock cycles: %0d", last_cycle_seen);
		$finish;
	end

//	initial begin
//		for (i = 0; i < 10; i = i + 1) begin
//			      $display ("Memory location %0d: %3h", i, top_module.inst_mem.instruction_memory[i], );
//		end
//		$display("Clk cycle");
//		$monitor("Memory location %0d: %3h", 0, top_module.data_mem_inst.data_block[0]);
//	end
endmodule
