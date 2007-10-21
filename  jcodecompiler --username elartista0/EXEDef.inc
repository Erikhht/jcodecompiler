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
   ¬define $code_file_start ¬curpos
   ¬define $code_start $RVABase + ¬curpos
¬

¬linedef end section .code
   ¬define $code_end $RVABase + ¬curpos
   align &H200
   ¬define $code_end_aligned $RVABase + ¬curpos
¬

¬linedef begin section .data
   ¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   ¬define $data_file_start ¬curpos
   ¬define $data_start $RVABase + ¬curpos
¬

¬linedef end section .data
   $data_definitions
   ¬define $data_end $RVABase + ¬curpos
   align &H200
   ¬define $data_end_aligned $RVABase + ¬curpos
¬

¬linedef begin section .idata
   ¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   ¬define $idata_file_start ¬curpos
   $idata_start:
¬

¬linedef end section .idata
   $idata_libraries
   ¬dd 0,0,0,0,0  ¬comment bloque vacio
   $idata_definitions
   $idata_end:
      align &H200
   $idata_end_aligned:
¬

¬linedef begin section .rsrc
   ¬define $RVABase $RVABase + ¬curpos - 1 / &H100000 + 1 * &H100000 - ¬curpos
   ¬define $rsrc_file_start ¬curpos
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
     dd ¬timestamp ; Time and date when the file was created
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
     dd $code_start      ;BaseOfCode;
     dd $data_start      ;BaseOfData;
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
     dd 0      ;CheckSum;
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

     db '.code',0,0,0
     dd $code_end - $code_start
     dd $code_start ; VirtualAddress;
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
     dd $data_start ; VirtualAddress;
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

¬linedef push word 0
   ¬db &H66,&H6A,0
¬

¬linedef push dword [*]
   ¬db &HFF,&H35
   ¬dd \01
¬

¬linedef push word [*]
   ¬db &H66,&HFF,&H35
   ¬dd \01
¬

¬linedef push dword *
   ¬db &H68
   ¬dd \01
¬

¬linedef push word *
   ¬db &H66,&H68
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

¬linedef pop dword [*]
   ¬db &H8F,&H05
   ¬dd \01
¬

¬linedef pop word [*]
   ¬db &H66,&H8F,&H05
   ¬dd \01
¬

¬linedef define * *
   ¬define \01 \02
¬

¬linedef call [*]
   ¬comment call [*]
   ¬db &HFF,&H15
   ¬dd \01
¬

¬linedef call *
   ¬db &HE8
   ¬dd \01 - ¬curpos - 4 - $ImageBase - $RVABase
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

¬linedef function *(*)
   \01_ADDR:
   ¬define $loctotal
   ¬db &H55             ¬comment push ebp
   ¬db &H89,&HE5        ¬comment mov ebp,esp
   ¬db &H83,&HEC        ¬comment sub esp,locals &H81EC (DWORD) (byte)
   ¬db $loctotal
   ¬define $parnumber 4
   ¬define $locnumber 0
   params \02
   ¬linedef \01(*)
      pushpar \¬01
      call [\01_ADDR]
   ¬
¬

¬linedef params
¬

¬linedef params *,*
   params \01
   params \02
¬

¬linedef params * as dword
   ¬local $temp
   ¬define $parnumber $parnumber + 4
   ¬define $temp $parnumber
   ¬linedef \01 = *
      = \¬01
      ¬db &H89,&H45,$temp  ¬comment mov dword [ebp-x],eax
      ¬define $temp_last ¬curpos
   ¬
   ¬linedef \01
      ¬if $temp_last <> ¬curpos
         ¬db &H8B,&H45,$temp  ¬comment mov eax,dword [ebp-x]
      ¬
   ¬
¬

¬linedef const * = *
   ¬define \01 \02
¬

¬linedef global * as dword
   ¬local $temp
   ¬linedef $data_definitions
      ¬expand $data_definitions
      \01: dd 0
   ¬
   ¬linedef \01 = *
      = \¬01
      ¬db &HA3,$temp  ¬comment mov dword [x],eax
   ¬
   ¬linedef \01
      ¬db &HA1,$temp  ¬comment mov eax,dword [x]
   ¬
¬

¬linedef local * as dword
   ¬local $temp
   ¬define $temp -$locnumber
   ¬linedef \01 = *
      = \¬01
      ¬db &H89,&H45,$temp  ¬comment mov dword [ebp-x],eax
      ¬define $temp_last ¬curpos
   ¬
   ¬linedef \01
      ¬if $temp_last <> ¬curpos
         ¬db &H8B,&H45,$temp  ¬comment mov eax,dword [ebp-x]
      ¬
   ¬
   ¬define $locnumber $locnumber + 4
¬

¬linedef end function
   ¬define $loctotal $locnumber
   ¬db &HC9         ¬comment leave
   ¬db &HC2         ¬comment retn <val>
   ¬dw $parnumber - 4
¬

¬linedef return *
   \01
   ¬db &HC9         ¬comment leave
   ¬db &HC2         ¬comment retn <val>
   ¬dw $parnumber - 4
¬

¬linedef dword *
   ¬db &HB8        ¬comment mov eax,x
   ¬dd \01
¬

¬linedef 0
   xor eax,eax
   ¬comment ¬db &HB8        ¬comment mov eax,x
   ¬comment ¬dd 0\01
¬
¬linedef 1*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 1\01
¬
¬linedef 2*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 2\01
¬
¬linedef 3*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 3\01
¬
¬linedef 4*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 4\01
¬
¬linedef 5*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 5\01
¬
¬linedef 6*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 6\01
¬
¬linedef 7*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 7\01
¬
¬linedef 8*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 8\01
¬
¬linedef 9*
   ¬db &HB8        ¬comment mov eax,x
   ¬dd 9\01
¬
¬linedef "*
   ¬local $temp
   ¬linedef $data_definitions
      ¬expand $data_definitions
      $temp: db "\01,0
   ¬
   ¬db &HB8        ¬comment mov eax,x
   ¬dd $temp
¬

¬comment ¬linedef cmp dword [ebp*],*
¬comment    ¬db &H81,&H7D        ¬comment cmp [ebp+x],y
¬comment    ¬db \01
¬comment    ¬dd \02
¬comment ¬

¬linedef = * + *
   = \02
   ¬db &H89,&HC3        ¬comment mov ebx,eax
   = \01
   ¬db &H01,&HD8
¬

¬linedef = * - *
   = \02
   ¬db &H89,&HC3        ¬comment mov ebx,eax
   = \01
   ¬db &H29,&HD8
¬

¬linedef = * % *
   = \01
   ¬db &H89,&HC3        ¬comment mov ebx,eax
   = \02
   ¬db &HF7,&HEB        ¬comment imul ebx
¬

¬linedef = * / *
   = \02
   ¬db &H89,&HC3        ¬comment mov ebx,eax
   = \01
   ¬db &HF7,&HFB        ¬comment idiv ebx
¬
¬linedef = *
   \01
¬

¬linedef jmpexpr * = 0
   \01
   ¬db &H83,&HF8,0        ¬comment cmp eax,0
   ¬db &HF,&H85         ¬comment jne
¬
¬linedef jmpexpr * = *
   \02
   ¬db &H89,&HC3        ¬comment mov ebx,eax
   \01
   ¬db &H39,&HD8        ¬comment cmp eax,ebx
   ¬db &HF,&H85         ¬comment jne
¬
¬linedef if * then
   ¬local $elselbl, $endiflbl
   jmpexpr \01
   ¬dd $elselbl - ¬curpos - 4 - $ImageBase - $RVABase
   ¬pushdef else
      ¬db Chr$(&HE9)    ¬comment jmp
      ¬dd $endiflbl - ¬curpos - 4 - $ImageBase - $RVABase
      ¬define $elselbl ¬curpos + $ImageBase + $RVABase
      ¬linedef end if
         ¬popdef else
         ¬popdef end if
         ¬define $endiflbl ¬curpos + $ImageBase + $RVABase
      ¬
   ¬
   ¬pushdef end if
      ¬popdef else
      ¬popdef end if
      ¬define $elselbl ¬curpos + $ImageBase + $RVABase
   ¬
¬

¬linedef library *.DLL
   ¬local $OriginalFirstThunk, $DLLName, $FirstThunk, $LibraryOriginalImports, $LibraryThunkImports, $LibraryFunctionsImports
   ¬linedef $idata_libraries
      ¬expand $idata_libraries
      ¬dd $OriginalFirstThunk - $ImageBase
      ¬dd 0
      ¬dd 0
      ¬dd $DLLName - $ImageBase
      ¬dd $FirstThunk - $ImageBase
   ¬
   ¬linedef $idata_definitions
      ¬expand $idata_definitions
      ¬define $DLLName ¬curpos + $ImageBase + $RVABase
      ¬db "\01.DLL",0,0
      ¬define $OriginalFirstThunk ¬curpos + $ImageBase + $RVABase
      $LibraryOriginalImports
      ¬dd 0
      ¬define $FirstThunk ¬curpos + $ImageBase + $RVABase
      $LibraryThunkImports
      ¬dd 0
      $LibraryFunctionsImports
   ¬
   ¬linedef import * as *
      ¬local $FNLib
      ¬linedef \¬02(*)
         pushpar \¬¬01
         call [\¬02_ADDR]
      ¬
      ¬linedef $LibraryOriginalImports
         ¬expand $LibraryOriginalImports
         ¬dd $FNLib - $ImageBase
      ¬
      ¬linedef $LibraryThunkImports
         ¬expand $LibraryThunkImports
         ¬define \¬02_ADDR ¬curpos + $ImageBase + $RVABase
         ¬dd $FNLib - $ImageBase
      ¬
      ¬linedef $LibraryFunctionsImports
         ¬expand $LibraryFunctionsImports
         ¬define $FNLib ¬curpos + $ImageBase + $RVABase
         ¬db 0,0,'\¬01',0
      ¬
   ¬
   ¬linedef import *
      import \¬01 as \¬01
   ¬
¬
¬linedef pushpar *,*
   pushpar \02
   pushpar \01
¬
¬linedef pushpar 0
   ¬db &H6A,0
¬
¬linedef pushpar 1*
   ¬db &H68
   ¬dd 1\01
¬
¬linedef pushpar 2*
   ¬db &H68
   ¬dd 2\01
¬
¬linedef pushpar 3*
   ¬db &H68
   ¬dd 3\01
¬
¬linedef pushpar 4*
   ¬db &H68
   ¬dd 4\01
¬
¬linedef pushpar 5*
   ¬db &H68
   ¬dd 5\01
¬
¬linedef pushpar 6*
   ¬db &H68
   ¬dd 6\01
¬
¬linedef pushpar 7*
   ¬db &H68
   ¬dd 7\01
¬
¬linedef pushpar 8*
   ¬db &H68
   ¬dd 8\01
¬
¬linedef pushpar 9*
   ¬db &H68
   ¬dd 9\01
¬
¬linedef pushpar "*
   ¬local $temp
   ¬linedef $data_definitions
      ¬expand $data_definitions
      $temp: db "\01,0
   ¬
   ¬db &H68
   ¬dd $temp
¬
¬linedef pushpar *
   \01
   ¬db &H50
¬
¬linedef library '*.DLL'
   library \01.DLL
¬

¬linedef library "*.DLL"
   library \01.DLL
¬

¬linedef Begin VB.Form *
   ¬local $ClientLeft,$ClientTop,$ClientWidth,$ClientHeight,$FormCaption
   ¬define \01 ¬curpos + $RVABase
   ¬linedef Caption = *
      ¬linedef $FormCaption
         ¬dw \¬01,0
      ¬
   ¬
   ¬linedef ClientLeft = *
      ¬define $ClientLeft \¬01/15
   ¬
   ¬linedef ClientTop = *
      ¬define $ClientTop \¬01/15
   ¬
   ¬linedef ClientWidth = *
      ¬define $ClientWidth \¬01/15
   ¬
   ¬linedef ClientHeight = *
      ¬define $ClientHeight \¬01/15
   ¬
   ¬define $DialogItems
   ¬linedef EndDialog
      ¬dd &H80C800C0
         ¬comment WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME+DS_SETFONT 
         ¬comment WS_CAPTION          0x00C00000L     /* WS_BORDER | WS_DLGFRAME  */
         ¬comment WS_POPUP            0x80000000L
         ¬comment WS_SYSMENU          0x00080000L
         ¬comment DS_MODALFRAME       0x80L   /* Can be combined with WS_CAPTION  */
         ¬comment DS_SETFONT          0x40L   /* User specified font for Dlg controls */
      ¬dd 0                   ¬comment ExStyle
      ¬dw $DialogItems        ¬comment items,
      ¬dw $ClientLeft,$ClientTop,$ClientWidth,$ClientHeight       ¬comment x,y,cx,cy~
      ¬dd 0
      $FormCaption
      ¬dw 8,'MS Sans Serif',0      ¬comment ;Fontsize, FontName
      align 4
      $EndControls
      ¬define \01_Size ¬curpos + $RVABase - \01
   ¬
   ¬define $DialogItems 0
   ¬linedef $EndControls
   ¬
¬

¬linedef Begin VB.Label *
   ¬local $Left,$Top,$Width,$Height,$Caption
   ¬define $Style &H50000000           ¬comment WS_CHILD+WS_VISIBLE
   ¬linedef Caption = *
      ¬linedef $Caption
         ¬dw \¬01,0
      ¬
   ¬
   ¬linedef Left = *
      ¬define $Left \¬01/15
   ¬
   ¬linedef Top = *
      ¬define $Top \¬01/15
   ¬
   ¬linedef Width = *
      ¬define $Width \¬01/15
   ¬
   ¬linedef Height = *
      ¬define $Height \¬01/15
   ¬
   ¬linedef End
      ¬linedef $EndControls
         ¬expand $EndControls
         ¬dd $Style
         ¬dd 0                               ¬comment ExStyle
         ¬dw $Left,$Top,$Width,$Height       ¬comment x,y,cx,cy
         ¬dw -1 ;ID
         ¬dw -1, &H82                        ¬comment STATIC
         $Caption
         ¬dw 0
         align 4
      ¬
      ¬define $DialogItems $DialogItems + 1
   ¬
¬
