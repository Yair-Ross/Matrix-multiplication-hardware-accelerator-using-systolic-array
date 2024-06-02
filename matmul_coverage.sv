`resetall
`timescale 1ns/10ps
module matmul_coverage #(parameter DATA_WIDTH = 16, parameter BUS_WIDTH = 64,
	parameter ADDR_WIDTH = 16, localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH,
	parameter SP_NTARGETS = 4)
(
  // port declaration
	matmul_intf.functional_coverage coverage_bus
);

typedef bit [BUS_WIDTH-1:0] data_bus;
typedef bit [MAX_DIM-1:0] strobe;

covergroup apb_regular_test (data_bus max_data = (2**BUS_WIDTH-1), strobe max_strobe = (2**MAX_DIM-1)) @(posedge coverage_bus.clk);								
	   RESET : coverpoint coverage_bus.rst {
	   bins low = {0};
	   bins high = {1};
	   }	
	
	
	   SLAVE_SEL : coverpoint coverage_bus.psel {															
	   bins low = {0};
	   bins high = {1};
	   }	
	
	
	   SLAVE_ENABLE : coverpoint coverage_bus.penable {															
	   bins low = {0};
	   bins high = {1};
	   }	
	
	   ADDRESSES : coverpoint coverage_bus.paddr {
	   bins control = {0};
	   bins operandA = {4};
	   bins operandB = {8};
	   bins flags = {12};
	   bins scratchpad ={[16 : 16 + SP_NTARGETS * 4]};
	   }	
	
		
	   WRITE_TO_SLAVE : coverpoint coverage_bus.pwrite {
    	bins read = {0};
    	bins write = {1};
    	bins not_valid = default;
    	}	
    	
    	SLAVE_STROBE : coverpoint coverage_bus.pstrb {
    	bins valid_data = {[0 : max_strobe]};		
    	bins not_valid = default;
    	}	
    	
    	
    	APB_WRITE_DATA : coverpoint coverage_bus.pwdata {				
    	bins valid_data = {[0 : max_data]};		
    	bins not_valid = default;
    	}
    	
    	READY_SLAVE : coverpoint coverage_bus.pready {				
    	bins low = {0};
    	bins high = {1};
    	}
    	
    	SLAVE_ERROR : coverpoint coverage_bus.pslverr {				
    	bins low = {0};
    	bins high = {1};
    	}
    	
    	SLAVE_BUSY : coverpoint coverage_bus.busy {				
    	bins low = {0};
    	bins high = {1};
    	}
    	
    	APB_READ_DATA : coverpoint coverage_bus.prdata {				
    	bins valid_data = {[0 : max_data]};		
    	bins not_valid = default;
    	}
    	
    endgroup 

//instance of covergroup apb_regular_test
apb_regular_test tst = new();

endmodule
