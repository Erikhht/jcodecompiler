
define $ImageBase 400000h

define $rsrc_file_start 0
define $rsrc_start 400000h
define $rsrc_end 400000h
define $rsrc_end_aligned 400000h

   $image_start:
     db "MZ"
     dw 80h   ;Stub size
     dw 1     ;no relocations
     dw 0
     dw 4     ; 4-para header
     dw 10h   ; 16 extra para for stack
     dw -1    ; maximum extra paras: LOTS
     dw 0,140h ; SS:SP = 0000:0140
     dw 0     ; no checksum
     dw 0,0   ; CS:IP = 0:0, start at beginning
     dw 40h   ; reloc table beyond hdr
     dw 0     ; overlay number
     dw 0,0,0,0 ; reserved
     dw 0,0   ; OEM id and OEM info
     dw 0,0,0,0,0,0,0,0,0,0 ; reserved
     dd 80h   ; offset PE header
     db 0eh,1fh,0bah,0eh,0,0b4h,09h,0cdh,21h,0b8h,1,4ch,0cdh,21h
     ;db 'This program cannot be run in DOS mode.',0Dh,0Ah,24h
     db 'Este programa no funciona desde modo DOS.',0Dh,0Ah,24h
   
   	 align 80h

   PE_Stub:
     db "PE",0,0
     dw 014Ch  ; 386-compatible
     dw 3      ; number of sections
     dd 11223344h ; Time and date when the file was created
     dd 0      ; PointerToSymbolTable
     dd 0      ; NumberOfSymbols
     dw 0E0h   ; SizeOfOptionalHeader
     dw 010Eh  ;Characteristics
     ; IMAGE_FILE_RELOCS_STRIPPED           0x0001  // Relocation info stripped from file.
     ; IMAGE_FILE_EXECUTABLE_IMAGE          0x0002  // File is executable  (i.e. no unresolved externel references).
     ; IMAGE_FILE_LINE_NUMS_STRIPPED        0x0004  // Line nunbers stripped from file.
     ; IMAGE_FILE_LOCAL_SYMS_STRIPPED       0x0008  // Local symbols stripped from file.
     ; IMAGE_FILE_32BIT_MACHINE             0x0100  // 32 bit word machine.

     dw 010Bh  ;Magic for a normal executable/DLL.
     db 1      ;MajorLinkerVersion;
     db 43h    ;MinorLinkerVersion;
     dd 0      ;SizeOfCode;
     dd 0      ;SizeOfInitializedData;
     dd 0      ;SizeOfUninitializedData;
     dd $EntryPoint - $ImageBase ;RVA AddressOfEntryPoint;
     dd $code_start - $ImageBase      ;BaseOfCode;
     dd $data_start - $ImageBase      ;BaseOfData;
     dd $ImageBase ;ImageBase;
     dd 1000000h   ;SectionAlignment;
     dd 200h   ;FileAlignment;
     dw 1      ;MajorOperatingSystemVersion;
     dw 0      ;MinorOperatingSystemVersion;
     dw 0      ;MajorImageVersion;
     dw 0      ;MinorImageVersion;
     dw 4      ;MajorSubsystemVersion;
     dw 0      ;MinorSubsystemVersion;
     dd 0      ;Win32VersionValue;
     dd $image_end - $ImageBase ;SizeOfImage;
     dd $header_end - $image_start ;SizeOfHeaders;
     dd 12345678h      ;CheckSum;
     dw 2      ;Subsystem; IMAGE_SUBSYSTEM_WINDOWS_GUI
     dw 0      ;DllCharacteristics;
     dd 1000h  ;SizeOfStackReserve;
     dd 1000h  ;SizeOfStackCommit;
     dd 10000h ;SizeOfHeapReserve;
     dd 0      ;SizeOfHeapCommit;
     dd 0      ;LoaderFlags;
     dd 16     ;NumberOfRvaAndSizes;
     dd 0,0         ;Directory1 edata RVa, Size
     dd $idata_start - $ImageBase,$idata_end - $idata_start ;Directory2 idata RVa, Size
     dd $rsrc_start - $ImageBase,$rsrc_end - $rsrc_start ; Directory 3 .rsrc
     dd 0,0    ; Directory 4
     dd 0,0    ; Directory 5
     dd 0,0    ; Directory 6
     dd 0,0    ; Directory 7
     dd 0,0    ; Directory 8
     dd 0,0    ; Directory 9
     dd 0,0    ; Directory 10
     dd 0,0    ; Directory 11
     dd 0,0    ; Directory 12
     dd 0,0    ; Directory 13
     dd 0,0    ; Directory 14
     dd 0,0    ; Directory 15
     dd 0,0    ; Directory 16

     db '.text',0,0,0
     dd $code_end - $code_start
     dd $code_start - $ImageBase ; VirtualAddress;
     dd $code_end_aligned - $code_start ; SizeOfRawData; Size aligned to FileAlign
     dd $code_file_start   ; PointerToRawData;
     dd 0         ; PointerToRelocations;
     dd 0         ; PointerToLinenumbers;
     dw 0         ; NumberOfRelocations;
     dw 0         ; NumberOfLinenumbers;
     dd 060000020h ; Characteristics;
     ;IMAGE_SCN_CNT_CODE                   0x00000020  // Section contains code.
     ;IMAGE_SCN_MEM_EXECUTE                0x20000000  // Section is executable.
     ;IMAGE_SCN_MEM_READ                   0x40000000  // Section is readable.

     ;.data section
     db '.data',0,0,0
     dd $data_end - $data_start ; VirtualSize;
     dd $data_start - $ImageBase ; VirtualAddress;
     dd $data_end_aligned - $data_start ; SizeOfRawData; Size aligned to FileAlign
     dd $data_file_start    ; PointerToRawData;
     dd 0         ; PointerToRelocations;
     dd 0         ; PointerToLinenumbers;
     dw 0         ; NumberOfRelocations;
     dw 0         ; NumberOfLinenumbers;
     dd 0C0000040h ; Characteristics;
     ;IMAGE_SCN_MEM_READ                   0x40000000  // Section is readable.
     ;IMAGE_SCN_MEM_WRITE                  0x80000000  // Section is writeable.
     ;IMAGE_SCN_CNT_INITIALIZED_DATA       0x00000040  // Section contains initialized data.

     db '.idata',0,0
     dd $idata_end - $idata_start
     dd $idata_start - $ImageBase ; VirtualAddress;
     dd $idata_end_aligned - $idata_start ; SizeOfRawData; Size aligned to FileAlign
     dd $idata_file_start  ; PointerToRawData;
     dd 0         ; PointerToRelocations;
     dd 0         ; PointerToLinenumbers;
     dw 0         ; NumberOfRelocations;
     dw 0         ; NumberOfLinenumbers;
     dd 0C0000040h ; Characteristics;
     ;IMAGE_SCN_MEM_READ                   0x40000000  // Section is readable.
     ;IMAGE_SCN_MEM_WRITE                  0x80000000  // Section is writeable.
     ;IMAGE_SCN_CNT_INITIALIZED_DATA       0x00000040  // Section contains initialized data.

     db '.rsrc',0,0,0
     dd $rsrc_end - $rsrc_start
     dd $rsrc_start - $ImageBase ; VirtualAddress;
     dd $rsrc_end_aligned - $rsrc_start ; SizeOfRawData; Size aligned to FileAlign
     dd $rsrc_file_start  ; PointerToRawData;
     dd 0         ; PointerToRelocations;
     dd 0         ; PointerToLinenumbers;
     dw 0         ; NumberOfRelocations;
     dw 0         ; NumberOfLinenumbers;
     dd 040000040h ; Characteristics;
     ;IMAGE_SCN_MEM_READ                   0x40000000  // Section is readable.
     ;IMAGE_SCN_CNT_INITIALIZED_DATA       0x00000040  // Section contains initialized data.

      align 200h
   $header_end:


   filepos $code_file_start
   
   rva
   $code_start:
  
   $EntryPoint:
      mov eax,[$Info]
      push eax ; MB_OK 
      push dword $Header
      push "Mensaje enviado por el JCompiler"
      push eax ; HWND_DESKTOP
      call [$MessageBoxA]

      push dword 0 ; HWND_DESKTOP
      call [$ExitProcess]
    
   $code_end:
      align 200h
   $code_end_aligned:
   
  
   filepos $data_file_start
   
   rva
   $data_start:
      $bytes_count: dd 12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      dd 12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h,12345678h
      
      $Info: dd 0
      $Header: db "Cabecera",0
   $data_end:
      align 200h
   $data_end_aligned:

   
   filepos $idata_file_start
   
   rva
   $idata_start:
      dd $OriginalFirstThunkKERNEL32 - $ImageBase ;OriginalFirstThunk
      dd 0  ;TimeDateStamp
      dd 0  ;ForwarderChain
      dd $DLLNameKERNEL32    - $ImageBase ;Name
      dd $FirstThunkKERNEL32 - $ImageBase ;FirstThunk

      dd $OriginalFirstThunkUSER32 - $ImageBase ;OriginalFirstThunk
      dd 0  ;TimeDateStamp
      dd 0  ;ForwarderChain
      dd $DLLNameUSER32 - $ImageBase    ;Name 
      dd $FirstThunkUSER32 - $ImageBase ;FirstThunk

      dd 0  ;OriginalFirstThunk
      dd 0  ;TimeDateStamp
      dd 0  ;ForwarderChain
      dd 0  ;Name
      dd 0  ;FirstThunk

$DLLNameKERNEL32:
    db "KERNEL32.DLL",0,0

$OriginalFirstThunkKERNEL32:
    ;dd $FN_CloseHandle
    ;dd $FN_CreateFileA
    dd $FN_ExitProcess - $ImageBase
    ;dd $FN_WriteFile
    dd 0
$FirstThunkKERNEL32:
    ;$CloseHandle: dd $FN_CloseHandle
    ;$CreateFileA: dd $FN_CreateFileA
    $ExitProcess: dd $FN_ExitProcess - $ImageBase
    ;$WriteFile: dd $FN_WriteFile
    dd 0
    
;$FN_CloseHandle: db 0,0,"CloseHandle",0
;$FN_CreateFileA: db 0,0,"CreateFileA",0
$FN_ExitProcess: db 0,0,"ExitProcess",0
;$FN_WriteFile: db 0,0,"WriteFile",0

   
$DLLNameUSER32:
    db "USER32.DLL",0,0

$OriginalFirstThunkUSER32:
    dd $FN_MessageBoxA - $ImageBase
    dd 0
$FirstThunkUSER32:
    $MessageBoxA: dd $FN_MessageBoxA - $ImageBase
    dd 0

$FN_MessageBoxA:
	db 0,0,"MessageBoxA",0

   $idata_end:
      align 200h
   $idata_end_aligned:

   rva
$image_end: