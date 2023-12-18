module TopModule(
    input logic clk,
    output logic valid,
    output logic ready,
    output logic miss,
    input logic[31:0] addr,
    output logic [31:0] data_out,
    input logic wr_en,
    input logic [31:0] data_in 
);
    logic  sent,CompressedValid,decompressedvalid;
    logic [31:0] mem_data_out, memaddr, cache_data_out;
    logic [255:0] DatfromMem,DecompressedData;
    logic [31:0] Compressed_data [7:0];
    logic [31:7] Tag;
    
    // Instantiate compression module
    axba_compression compression_unit (
        .clk(clk),
        .reset(0), // Assuming no reset for compression module
        .data_in(DatfromMem),
        .error_margin(32'h00000010),
        .compressed_data(Compressed_data),
        .compressed_valid(CompressedValid)
    );

    // Instantiate decompression module
    axba_decompression decompression_unit (
        .clk(clk),
        .reset(0), // Assuming no reset for decompression module
        .compressed_data(Compressed_data),
        .compressed_valid(CompressedValid),
        .decompressed_data(DecompressedData), // Decompressed data replaces original data
        .decompressed_valid(decompressedvalid) // Use the cache's valid signal for decompressed data
    );
    
    L1D_Cache cache (
        .clk(clk), 
        .addr(addr), 
        .data_out(cache_data_out),
        .miss(miss),
        .valid(valid),
        .ready(ready),
        .DatfromMem(DecompressedData), // Send compressed data to cache
        .Tag(Tag),
        .memaddr(memaddr),
        .sent(sent),
        .wr_en(wr_en),
        .data_in(data_in)
        ,.decompressedvalid(decompressedvalid)
    );
    
    MainMemory memory (
        .clk(clk), 
        .valid(valid),
        .ready(ready),
        .addr(memaddr),
        .data_out(mem_data_out),
        .DatfromMem(DatfromMem),
        .Tag(Tag),
        .sent(sent),
        .wr_en(wr_en),
        .data_in(data_in)
    );
    
    assign data_out = miss ? decompression_unit.decompressed_data : cache_data_out;
endmodule
