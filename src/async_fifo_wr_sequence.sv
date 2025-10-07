class wr_sequence extends uvm_sequence#(wr_seq_item);
  `uvm_object_utils(wr_sequence)
   wr_seq_item wr_item;
  
  function new(string name="wr_sequence");
    super.new(name);
  endfunction
 
  virtual task body();
    repeat(`no_of_times)
      begin
       wr_item=wr_seq_item::type_id::create("wr_item");
       wait_for_grant();
       wr_item.randomize();
       send_request(wr_item);
       wait_for_item_done();
      end
  endtask
  
endclass

class wr_sequence1 extends uvm_sequence#(wr_seq_item);
  `uvm_object_utils(wr_sequence1)
   wr_seq_item wr_item;
  
  function new(string name="wr_sequence1");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(wr_item,{winc==1;})
      end
  endtask
endclass

class wr_sequence2 extends uvm_sequence#(wr_seq_item);
  `uvm_object_utils(wr_sequence2)
   wr_seq_item wr_item;
  
  function new(string name="wr_sequence2");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(wr_item,{winc==0;})
      end
  endtask
endclass

class wr_sequence3 extends uvm_sequence#(wr_seq_item);
  `uvm_object_utils(wr_sequence3)
   wr_seq_item wr_item;
  
  function new(string name="wr_sequence3");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(wr_item,{winc==1;})
      end
  endtask
endclass

class wr_sequence4 extends uvm_sequence#(wr_seq_item);
  `uvm_object_utils(wr_sequence4)
   wr_seq_item wr_item;
  
  function new(string name="wr_sequence4");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(wr_item,{winc==0;})
      end
  endtask
endclass
