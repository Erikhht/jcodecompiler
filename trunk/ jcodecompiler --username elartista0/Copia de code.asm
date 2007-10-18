¬comment {} = forward reference
¬comment [] = char list, ^ negative
¬comment () = block
¬comment \  = escape char, \01, \02... forward reference

¬linedef *;*
	\01
¬

¬linedef *:*
	¬define \01 ¬curpos + $ImageBase + $RVABase
	\02
¬

¬linedef align *
	¬align \01
¬

¬linedef begin section .code
	¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   filepos $code_file_start
   $code_start:
¬

¬linedef end section .code
   $code_end:
      align &H200
   $code_end_aligned:
¬

¬linedef begin section .data
	¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   filepos $data_file_start
   $data_start:
¬

¬linedef end section .data
   $data_end:
      align &H200
   $data_end_aligned:
¬

¬linedef begin section .idata
	¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   filepos $idata_file_start
   $idata_start:
¬

¬linedef end section .idata
   $idata_end:
      align &H200
   $idata_end_aligned:
¬

¬linedef begin section .rsrc
	¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   filepos $rsrc_file_start
   $rsrc_start:
¬

¬linedef end section .rsrc
   $rsrc_end:
      align &H200
   $rsrc_end_aligned:
¬

¬linedef begin file
   define $ImageBase &H400000
   define $RVABase 0

   $image_start:
     db "MZ"
     dw &H80  ;Stub size
     dw 1     ;no relocations
     dw 0
     dw 4     ; 4-para header
     dw &H10   ; 16 extra para for stack
     dw -1    ; maximum extra paras: LOTS
     dw 0,&H140 ; SS:SP = 0000:0140
     dw 0     ; no checksum
     dw 0,0   ; CS:IP = 0:0, start at beginning
     dw &H40   ; reloc table beyond hdr
     dw 0     ; overlay number
     dw 0,0,0,0 ; reserved
     dw 0,0   ; OEM id and OEM info
     dw 0,0,0,0,0,0,0,0,0,0 ; reserved
     dd &H80   ; offset PE header
     db &H0E,&H1F,&HBA,&HE,0,&HB4,&H09,&HCD,&H21,&HB8,1,&H4C,&HCD,&H21
     ;db 'This program cannot be run in DOS mode.',0Dh,0Ah,24h
     db 'Este programa no funciona desde modo DOS.',&H0D,&H0A,&H24
   
   	 align &H80

   PE_Stub:
     db "PE",0,0
     dw &H014C  ; 386-compatible
     dw 4      ; number of sections
     dd &H11223344 ; Time and date when the file was created
     dd 0      ; PointerToSymbolTable
     dd 0      ; NumberOfSymbols
     dw &HE0   ; SizeOfOptionalHeader
     dw &H10E  ;Characteristics
     ; IMAGE_FILE_RELOCS_STRIPPED           0x0001  // Relocation info stripped from file.
     ; IMAGE_FILE_EXECUTABLE_IMAGE          0x0002  // File is executable  (i.e. no unresolved externel references).
     ; IMAGE_FILE_LINE_NUMS_STRIPPED        0x0004  // Line nunbers stripped from file.
     ; IMAGE_FILE_LOCAL_SYMS_STRIPPED       0x0008  // Local symbols stripped from file.
     ; IMAGE_FILE_32BIT_MACHINE             0x0100  // 32 bit word machine.

     dw &H10B  ;Magic for a normal executable/DLL.
     db 1      ;MajorLinkerVersion;
     db &H43   ;MinorLinkerVersion;
     dd 0      ;SizeOfCode;
     dd 0      ;SizeOfInitializedData;
     dd 0      ;SizeOfUninitializedData;
     dd $EntryPoint - $ImageBase ;RVA AddressOfEntryPoint;
     dd $code_start - $ImageBase      ;BaseOfCode;
     dd $data_start - $ImageBase      ;BaseOfData;
     dd $ImageBase ;ImageBase;
     dd &H100000   ;SectionAlignment;
     dd &H200   ;FileAlignment;
     dw 1      ;MajorOperatingSystemVersion;
     dw 0      ;MinorOperatingSystemVersion;
     dw 0      ;MajorImageVersion;
     dw 0      ;MinorImageVersion;
     dw 4      ;MajorSubsystemVersion;
     dw 0      ;MinorSubsystemVersion;
     dd 0      ;Win32VersionValue;
     dd $image_end - $ImageBase ;SizeOfImage;
     dd $header_end - $image_start ;SizeOfHeaders;
     dd &H12345678      ;CheckSum;
     dw 2      ;Subsystem; IMAGE_SUBSYSTEM_WINDOWS_GUI
     dw 0      ;DllCharacteristics;
     dd &H1000  ;SizeOfStackReserve;
     dd &H1000  ;SizeOfStackCommit;
     dd &H10000 ;SizeOfHeapReserve;
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
     dd &H60000020 ; Characteristics;
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
     dd &HC0000040 ; Characteristics;
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
     dd &HC0000040 ; Characteristics;
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
     dd &H40000040 ; Characteristics;
     ;IMAGE_SCN_MEM_READ                   0x40000000  // Section is readable.
     ;IMAGE_SCN_CNT_INITIALIZED_DATA       0x00000040  // Section contains initialized data.

      align &H200
   $header_end:
¬

¬linedef end file
	¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   $image_end:
¬

¬linedef db *
	¬db \01
¬

¬linedef dw *
	¬dw \01
¬

¬linedef dd *
	¬dd \01
¬

¬linedef push eax
	¬db &H50
¬

¬linedef push 0
	¬db &H6A,0
¬

¬linedef push dword 0
	¬db &H6A,0
¬


¬linedef push dword [*]
	¬db &HFF,&H35
	¬dd \01
¬

¬linedef push dword *
	¬db &H68
	¬dd \01
¬

¬linedef push *
	¬db &H68
	¬dd \01
¬

¬linedef pushstr *
	¬local $temp
	call $temp
	¬db \01,0
	$temp:
¬

¬linedef pop eax
	¬db &H58
¬

¬linedef define * *
	¬define \01 \02
¬

¬linedef filepos *
	¬define \01 ¬curpos
¬

¬linedef call [*]
	¬comment call [*]
	¬db &HFF,&H15
	¬dd \01
¬

¬linedef call *
	¬local $temp
	¬db &HE8
	$temp:
	¬dd \01 - $temp - 4
¬

¬linedef xor eax,eax
	¬db &H31,&HC0
¬

¬linedef mov eax,[ebp*]
	¬db &H8B,&H45
	¬db \01
¬

¬linedef mov eax,[*]
	¬db &HA1
	¬dd \01
¬

¬linedef mov eax,*
	¬db &HB8
	¬dd \01
¬

¬linedef proc *
	\01:
	¬db &H55			   ¬comment push ebp
	¬db &H89,&HE5     ¬comment mov ebp,esp
¬

¬linedef endproc *
   	¬db &HC9			¬comment leave
   	¬db &HC2			¬comment retn <val>
   	¬dw \01
¬

¬include "EXEDef.inc"
begin file
begin section .code
   $EntryPoint:
      push 0
      call [$GetModuleHandleA]
      push dword 0
      push dword $DialogProc
      push dword 0 ;HWND_DESKTOP
      push dword 37
      push eax
      call [$DialogBoxParamA]

      mov eax,[$Info]
      push eax ; MB_OK 
      push dword $Header
      pushstr ""
      push eax ; HWND_DESKTOP
      call [$MessageBoxA]

      push dword 0 ; HWND_DESKTOP
      call [$ExitProcess]
      
      call Prueba2
      mov eax,0

Prueba2:
      mov eax,&H12345678
      
proc $DialogProc
   
   mov	eax,0     
endproc 16

end section .code    

section .data  
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

end section .data
   
section .idata   
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
    dd $FN_GetModuleHandleA - $ImageBase
    dd $FN_ExitProcess - $ImageBase
    ;dd $FN_WriteFile
    dd 0
$FirstThunkKERNEL32:
    ;$CloseHandle: dd $FN_CloseHandle
    ;$CreateFileA: dd $FN_CreateFileA
   $GetModuleHandleA: dd $FN_GetModuleHandleA - $ImageBase
   $ExitProcess: dd $FN_ExitProcess - $ImageBase
    ;$WriteFile: dd $FN_WriteFile
    dd 0
    
;$FN_CloseHandle: db 0,0,"CloseHandle",0
;$FN_CreateFileA: db 0,0,"CreateFileA",0
$FN_GetModuleHandleA: db 0,0,'GetModuleHandleA',0
$FN_ExitProcess: db 0,0,'ExitProcess',0
;$FN_WriteFile: db 0,0,"WriteFile",0

   
$DLLNameUSER32:
    db "USER32.DLL",0,0

$OriginalFirstThunkUSER32:
   dd $FN_DialogBoxParamA - $ImageBase
   dd $FN_MessageBoxA - $ImageBase
	dd $FN_EndDialog - $ImageBase
   dd 0
$FirstThunkUSER32:
   $DialogBoxParamA: dd $FN_DialogBoxParamA - $ImageBase
   $MessageBoxA: dd $FN_MessageBoxA - $ImageBase
   $EndDialog: dd $FN_EndDialog - $ImageBase
   dd 0

$FN_DialogBoxParamA: db 0,0,'DialogBoxParamA',0
$FN_MessageBoxA: db 0,0,'MessageBoxA',0
$FN_EndDialog: db 0,0,'EndDialog',0

end section .idata

section .rsrc
      dd 0 ;Characteristics;
      dd 0 ;TimeDateStamp;
      dw 0 ;MajorVersion;
      dw 0 ;MinorVersion;
      dw 0 ;NumberOfNamedEntries;
      dw 1 ;NumberOfIdEntries;      
      
      dd 5 ;Type
      dd  $direntry1 - $rsrc_start + &H80000000 ;Type
      
   $direntry1:
      dd 0 ;Characteristics;
      dd 0 ;TimeDateStamp;
      dw 0 ;MajorVersion;
      dw 0 ;MinorVersion;
      dw 0 ;NumberOfNamedEntries;
      dw 1 ;NumberOfIdEntries;      
      
      dd 37 ;Type
      dd $direntry2 - $rsrc_start + &H80000000 ;Type

   $direntry2:
      dd 0 ;Characteristics;
      dd 0 ;TimeDateStamp;
      dw 0 ;MajorVersion;
      dw 0 ;MinorVersion;
      dw 0 ;NumberOfNamedEntries;
      dw 1 ;NumberOfIdEntries;      
      
      dd 0409h ;Language
      dd $dialogs - $rsrc_start 

   $dialogs:
      dd $dialog1 - $ImageBase ;DataPtr
      dd $dialog1_end - $dialog1 ;Size
      dd 0,0

   $dialog1:
      dd 80C800C0h ;WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME+DS_SETFONT 
;WS_CAPTION          0x00C00000L     /* WS_BORDER | WS_DLGFRAME  */
;WS_POPUP            0x80000000L
;WS_SYSMENU          0x00080000L
;DS_MODALFRAME       0x80L   /* Can be combined with WS_CAPTION  */
;DS_SETFONT          0x40L   /* User specified font for Dlg controls */
      dd 0  ;ExsStyle
      dw 2  ;items,
      dw 70,70,190,175 ; x,y,cx,cy
      dw 0,0,"Primer dialogo",0
      dw 8,'MS Sans Serif',0      ;Fontsize, FontName
      align 4
      
   $static1:
      dd 50000000h ;WS_CHILD+WS_VISIBLE          
      dd 0  ;ExsStyle
      dw 10,10,70,8 ; x,y,cx,cy
      dw -1 ;ID
      dw -1, 82h ;STATIC
      dw "&Caption",0
      dw 0
      align 4

   $static2:
      dd 50000000h ;WS_CHILD+WS_VISIBLE          
      dd 0  ;ExsStyle
      dw 10,20,70,8 ; x,y,cx,cy
      dw -1 ;ID
      dw -1, 82h ;STATIC
      dw "Mas Informacion",0
      dw 0
      align 4

    $dialog1_end:

;WS_CHILD            0x40000000L
;WS_VISIBLE          0x10000000L

;Window Styles
; WS_OVERLAPPED       0x00000000L
; WS_CHILD            0x40000000L
; WS_MINIMIZE         0x20000000L
; WS_VISIBLE          0x10000000L
; WS_DISABLED         0x08000000L
; WS_CLIPSIBLINGS     0x04000000L
; WS_CLIPCHILDREN     0x02000000L
; WS_MAXIMIZE         0x01000000L
; WS_BORDER           0x00800000L
; WS_DLGFRAME         0x00400000L
; WS_VSCROLL          0x00200000L
; WS_HSCROLL          0x00100000L
; WS_THICKFRAME       0x00040000L
; WS_GROUP            0x00020000L
; WS_TABSTOP          0x00010000L

; WS_MINIMIZEBOX      0x00020000L
; WS_MAXIMIZEBOX      0x00010000L

;Dialog Styles
; DS_ABSALIGN         0x01L
; DS_SYSMODAL         0x02L
; DS_LOCALEDIT        0x20L   /* Edit items get Local storage. */
; DS_SETFONT          0x40L   /* User specified font for Dlg controls */
; DS_MODALFRAME       0x80L   /* Can be combined with WS_CAPTION  */
; DS_NOIDLEMSG        0x100L  /* WM_ENTERIDLE message will not be sent */
; DS_SETFOREGROUND    0x200L  /* not in win3.1 */

end section .rsrc

end file
