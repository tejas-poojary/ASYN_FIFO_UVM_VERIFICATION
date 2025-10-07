class rd_sequence extends uvm_sequence#(rd_seq_item);
  `uvm_object_utils(rd_sequence)
  rd_seq_item rd_item;
  
  function new(string name="rd_sequence");
    super.new(name);
  endfunction
 
  virtual task body();
    repeat(`no_of_times)
      begin
       rd_item=rd_seq_item::type_id::create("rd_item");
       wait_for_grant();
       rd_item.randomize();
       send_request(rd_item);
       wait_for_item_done();
      end
  endtask
  
endclass

class rd_sequence1 extends uvm_sequence#(rd_seq_item);
  `uvm_object_utils(rd_sequence1)
   rd_seq_item rd_item;
  
  function new(string name="rd_sequence1");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(rd_item,{rinc==1;})
      end
  endtask
endclass

class rd_sequence2 extends uvm_sequence#(rd_seq_item);
  `uvm_object_utils(rd_sequence2)
   rd_seq_item rd_item;
  
  function new(string name="rd_sequence2");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(rd_item,{rinc==0;})
      end
  endtask
endclass

class rd_sequence3 extends uvm_sequence#(rd_seq_item);
  `uvm_object_utils(rd_sequence3)
   rd_seq_item rd_item;
  
  function new(string name="rd_sequence3");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(rd_item,{rinc==0;})
      end
  endtask
endclass

class rd_sequence4 extends uvm_sequence#(rd_seq_item);
  `uvm_object_utils(rd_sequence4)
   rd_seq_item rd_item;
  
  function new(string name="rd_sequence4");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(`no_of_times)
      begin
        `uvm_do_with(rd_item,{rinc==1;})
      end
  endtask
endclass
