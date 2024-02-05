///////////////////////////////////////////  DEST_DRIVER()  ////////////////////////////////////////////

class dest_driver extends uvm_driver#(dest_txn);
	`uvm_component_utils(dest_driver)
//Virtual interface declaration
	virtual dest_if.DDRV_MP vif;
//Declaring dest_Config handle
	dest_agent_config d_cfg;

	extern function new(string name="dest_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task dst_to_dut(dest_txn dtxn);
endclass

///////////////////////////////////////////  NEW()  ////////////////////////////////////////////

function dest_driver::new(string name="dest_driver",uvm_component parent);
	super.new(name,parent);
endfunction

///////////////////////////////////////////  BUILD_PHASE()  ////////////////////////////////////////////

function void dest_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting d_cfg
	if(!uvm_config_db#(dest_agent_config)::get(this,"","dst_cfg",d_cfg))
		`uvm_fatal(get_type_name(),"d_cfg cant get,Have U set it?")
endfunction

///////////////////////////////////////////  CONNECT_PHASE()  ////////////////////////////////////////////

function void dest_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
//Pointing virtual_interface 
	vif=d_cfg.vif;
endfunction

///////////////////////////////////////////  RUN_PHASE()  ////////////////////////////////////////////

task dest_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever
		begin
			seq_item_port.get_next_item(req);
			dst_to_dut(req);
			seq_item_port.item_done();
		end
endtask

///////////////////////////////////////////  dst_to_dut()  ////////////////////////////////////////////

task dest_driver::dst_to_dut(dest_txn dtxn);
	begin
		`uvm_info(get_type_name(),$sformatf("Getting SMALL_PKT seqs at Destination \n %s",dtxn.sprint()),UVM_LOW)

		@(vif.dst_drv_cb);  //delay
		wait(vif.dst_drv_cb.vld_out===1) // when vld_out==1
		repeat(dtxn.no_of_cycles)
		@(vif.dst_drv_cb);
		vif.dst_drv_cb.read_enb <= 1; //Drive read_enb=1
		wait(vif.dst_drv_cb.vld_out==0) //when vld_out==0
		vif.dst_drv_cb.read_enb <= 0; //Drive read_enb==0
		@(vif.dst_drv_cb);
	end
endtask
