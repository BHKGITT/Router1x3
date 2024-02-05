
/////////////////////////////////////////// ROUTER_SCOREBOARD  ////////////////////////////////////////////

class router_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(router_scoreboard)
//Declaring env_cfg 
	router_env_config env_cfg;
//Declaring fifo's for getting PKT from source & destination monitors
	uvm_tlm_analysis_fifo#(source_txn) fifo_sdh;
	uvm_tlm_analysis_fifo#(dest_txn)   fifo_ddh[];
	
//Declare handles for Source & Destination to store analysi_fifo data
	source_txn stxn_fdata;
	dest_txn   dtxn_fdata;
	
//Declare handles for Source & Destination coverage 
	source_txn  src_cov;
	dest_txn    dst_cov;

//Covergroup for SOURCE
	covergroup source_cov;
		option.per_instance=1;
		ADDR:coverpoint src_cov.header[1:0]{
							bins low = {2'b00};
							bins mid = {2'b01}; 
							bins max = {2'b10};
					      	      }
		PAYLOAD:coverpoint src_cov.header[7:2]{
						        bins small_pkt = {[1:15]};
						        bins med_pkt   = {[16:30]};
						        bins large_pkt = {[31:63]};
						         }
		ADDR_X_PAYLOAD:cross ADDR,PAYLOAD;
	endgroup

//Covergroup for DESTINATION
	covergroup dest_cov;
		option.per_instance=1;
		ADDR:coverpoint dst_cov.header[1:0]{
						
							bins low = {2'b00};
							bins mid = {2'b01}; 
							bins max = {2'b10};
					       	      }

		PAYLOAD:coverpoint dst_cov.header[7:2]{
						 	bins small_pkt = {[1:15]};
							bins med_pkt   = {[16:30]};
							bins large_pkt = {[31:63]};
							 }
		ADDR_X_PAYLOAD:cross ADDR,PAYLOAD;	
	endgroup


	extern function new(string name="router_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void check_pkt(dest_txn data);   
endclass

///////////////////////////////////////////  NEW()  ////////////////////////////////////////////

function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
//Creating instance for covergroup
	source_cov=new();
	dest_cov=new();
endfunction

///////////////////////////////////////////  BUILD_PHASE()  ////////////////////////////////////////////

function void router_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting env_cfg
	if(!uvm_config_db#(router_env_config)::get(this,"","ENV_CFG",env_cfg))
		`uvm_fatal(get_type_name(),"env_cfg cant get Have U set() it?")

	stxn_fdata=source_txn::type_id::create("stxn_fdata");
	dtxn_fdata=dest_txn::type_id::create("dtxn_fdata");
//Instances for fifo handles

	fifo_sdh=new("fifo_sdh",this);
	fifo_ddh=new[env_cfg.no_of_dagent];
	foreach(fifo_ddh[i])
		begin
			fifo_ddh[i]=new($sformatf("fifo_ddh[%0d]",i),this);
		end
endfunction

///////////////////////////////////////////  RUN_PHASE()  ////////////////////////////////////////////

task router_scoreboard::run_phase(uvm_phase phase);
	fork
		begin
			forever
				begin
					fifo_sdh.get(stxn_fdata);
					`uvm_info(get_type_name(),$sformatf("Data from Source Monitor to SCOREBOARD\n %s",stxn_fdata.sprint()),UVM_LOW)
					src_cov = stxn_fdata;
					source_cov.sample();			
				end
		end

		begin
			forever
				begin
					fork:A
						begin	
							fifo_ddh[0].get(dtxn_fdata);
							`uvm_info(get_type_name(),$sformatf("Data from Destination Monitor to SCOREBOARD0\n %s",dtxn_fdata.sprint()),UVM_LOW)	
							check_pkt(dtxn_fdata);
							dst_cov = dtxn_fdata;	
							dest_cov.sample();
						end

						begin
							fifo_ddh[1].get(dtxn_fdata);
							`uvm_info(get_type_name(),$sformatf("Data from Destination Monitor to SCOREBOARD1\n %s",dtxn_fdata.sprint()),UVM_LOW)	
							check_pkt(dtxn_fdata);
							dst_cov = dtxn_fdata;	
							dest_cov.sample();
						end
						begin
							fifo_ddh[2].get(dtxn_fdata);
							`uvm_info(get_type_name(),$sformatf("Data from Destination Monitor to SCOREBOARD2\n %s",dtxn_fdata.sprint()),UVM_LOW)	
							check_pkt(dtxn_fdata);
							dst_cov = dtxn_fdata;	
							dest_cov.sample();
						end

					join_any
					disable A;	
				
				end
		end 
		
	/*	begin
			forever
				begin
					if(addr==2'b00)
						fifo_ddh[0].get(dtxn_fdata);
					if(addr==2'b01)
						fifo_ddh[1].get(dtxn_fdata);
					if(addr==2'b10)
					`uvm_info(get_type_name(),$sformatf("Data from Source Monitor to SCOREBOARD2\n %s",dtxn_fdata.sprint()),UVM_LOW)	
					check(dtxn_fdata);
					dst_cov = dtxn_fdata;	
					dest_cov.sample();
					fifo_ddh[2].get(dtxn_fdata);


				end

		end*/
	join
endtask

///////////////////////////////////////////  CHECK_PKT()  ////////////////////////////////////////////

function void router_scoreboard::check_pkt(dest_txn data);

	if(stxn_fdata.header == data.header)  //checking source PKT "header" & Destination PKT "header"
		`uvm_info(get_type_name(),"Header Matched",UVM_LOW)
	else
		`uvm_info(get_type_name(),"Header Mis-Matched",UVM_LOW)

	if(stxn_fdata.payload == data.payload)  //checking source PKT "payload" & Destination PKT "payload"
		`uvm_info(get_type_name(),"Payload Matched",UVM_LOW)
	else
		`uvm_info(get_type_name(),"Payload Mis-Matched",UVM_LOW)

	if(stxn_fdata.parity == data.parity)  //checking source PKT "parity" & Destination PKT "parity"
		`uvm_info(get_type_name(),"Parity Matched",UVM_LOW)
	else
		`uvm_info(get_type_name(),"Parity Mis-Matched",UVM_LOW) 

endfunction


