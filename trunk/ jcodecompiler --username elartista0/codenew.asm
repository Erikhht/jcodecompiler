¬include "EXEDef.inc"
begin file
begin section .code
   $EntryPoint:
      push 0
      call [GetModuleHandleA]
      push dword 0
      push dword $DialogProc
      push dword 0 ;HWND_DESKTOP
      push dword 37
      push eax
      call [DialogBoxParamA]

      mov eax,[$Info]
      push eax ; MB_OK 
      push dword $Header
      pushstr ""
      push eax ; HWND_DESKTOP
      call [MessageBoxA]

      push dword 0 ; HWND_DESKTOP
      call [ExitProcess]
      
      call Prueba2
      mov eax,0

Prueba2:
      mov eax,&H12345678
      
proc $DialogProc
   
   mov	eax,0     
endproc 16

end section .code    

begin section .data  
      $bytes_count: dd &H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      dd &H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678,&H12345678
      
      $Info: dd 0
      $Header: db "Cabecera",0

end section .data
   
begin section .idata   

library KERNEL32.DLL
import GetModuleHandleA
import ExitProcess

library USER32.DLL
import DialogBoxParamA
import MessageBoxA
import EndDialog

end section .idata

begin section .rsrc
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
      
      dd 37 ;ID_DIALOG1
      dd $direntry2 - $rsrc_start + &H80000000 ;Type

   $direntry2:
      dd 0 ;Characteristics;
      dd 0 ;TimeDateStamp;
      dw 0 ;MajorVersion;
      dw 0 ;MinorVersion;
      dw 0 ;NumberOfNamedEntries;
      dw 1 ;NumberOfIdEntries;      
      
      dd &H0409 ;Language
      dd $dialogs - $rsrc_start 

   $dialogs:
      dd $dialog1 - $ImageBase ;DataPtr
      dd $dialog1_end - $dialog1 ;Size
      dd 0,0

   $dialog1:
      dd &H80C800C0 ;WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME+DS_SETFONT 
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
      dd &H50000000 ;WS_CHILD+WS_VISIBLE          
      dd 0  ;ExsStyle
      dw 10,10,70,8 ; x,y,cx,cy
      dw -1 ;ID
      dw -1, &H82 ;STATIC
      dw "&Caption",0
      dw 0
      align 4

   $static2:
      dd &H50000000 ;WS_CHILD+WS_VISIBLE          
      dd 0  ;ExsStyle
      dw 10,20,70,8 ; x,y,cx,cy
      dw -1 ;ID
      dw -1, &H82 ;STATIC
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
