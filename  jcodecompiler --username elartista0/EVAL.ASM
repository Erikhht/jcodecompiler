
; example of simplified Win32 programming using complex macro features

include '../Include/win32ax.inc'
include '../Macros/let.inc'


.data

   bytes_count dd 12345678h
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
      
      Info: dd 0
      Header: db "Cabecera",0

.code

Main:
      mov eax,[Info]
      push eax ; MB_OK 
      push Header
    call @f
    db "Mensaje enviado por el JCompiler",0
    @@:
      push eax ; HWND_DESKTOP
      call [MessageBoxA]

      push 0 ; HWND_DESKTOP
      call [ExitProcess]

;        invoke  CreateFile,edx,GENERIC_WRITE,0,0,CREATE_ALWAYS,0,0
;        mov     ebx,eax
;        invoke  WriteFile,ebx,MZ_Stub,201h,bytes_count,0
;        invoke  CloseHandle,ebx
;
;
;
;  invoke  MessageBox,HWND_DESKTOP,"1","2",MB_OK
;  invoke  ExitProcess,0

.end Main
