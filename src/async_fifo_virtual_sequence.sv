class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(virtual_sequence)
  virtual_sequencer v_seqr;  //virtual sequencer handle
  wr_sequencer wr_seqr;      //user defined sequencer handles
  rd_sequencer rd_seqr;
  
  wr_sequence wr_seq;       //user defined sequence handles
  rd_sequence rd_seq;
  wr_sequence1 wr_seq1;
  rd_sequence1 rd_seq1;
  wr_sequence2 wr_seq2;
  rd_sequence2 rd_seq2;
  wr_sequence3 wr_seq3;
  rd_sequence3 rd_seq3;
  wr_sequence4 wr_seq4;
  rd_sequence4 rd_seq4;
  
  function new(string name="virtual_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    if(!$cast(v_seqr,m_sequencer))
      begin
        `uvm_error(get_full_name(),"Cast failed")
      end
    else
      begin
        wr_seq=wr_sequence::type_id::create("wr_seq");
        rd_seq=rd_sequence::type_id::create("rd_seq");   //create individual sequences 
        
        wr_seq1=wr_sequence1::type_id::create("wr_seq1");
        rd_seq1=rd_sequence1::type_id::create("rd_seq1");
        
        wr_seq2=wr_sequence2::type_id::create("wr_seq2");
        rd_seq2=rd_sequence2::type_id::create("rd_seq2");
        
        wr_seq3=wr_sequence3::type_id::create("wr_seq3");
        rd_seq3=rd_sequence3::type_id::create("rd_seq3");
        
        wr_seq4=wr_sequence4::type_id::create("wr_seq4");
        rd_seq4=rd_sequence4::type_id::create("rd_seq4");
        
      fork   //no constraint case
      begin
        wr_seq.start(v_seqr.wr_seqr);
      end
      begin
        rd_seq.start(v_seqr.rd_seqr);
      end
    join  
        
   fork   //11 case
      begin
        wr_seq1.start(v_seqr.wr_seqr);
      end
      begin
        rd_seq1.start(v_seqr.rd_seqr);
      end
    join  
        
    fork   //00 case
      begin
        wr_seq2.start(v_seqr.wr_seqr);
      end
      begin
        rd_seq2.start(v_seqr.rd_seqr);
      end
    join   */
        
    fork    //10 case
      begin
        wr_seq3.start(v_seqr.wr_seqr);
      end
      begin
        rd_seq3.start(v_seqr.rd_seqr);  //write continously
      end
    join    
        
    fork    //01 case
      begin
        wr_seq4.start(v_seqr.wr_seqr);    //read continously
      end
      begin
        rd_seq4.start(v_seqr.rd_seqr);
      end
    join  
        
   end
 endtask
  
endclass
