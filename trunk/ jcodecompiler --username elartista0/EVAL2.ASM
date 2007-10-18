
; example of simplified Win32 programming using complex macro features

include '../Include/win32ax.inc'
include '../Macros/let.inc'


.data
    .dim var1 as long
    .dim var2 as long
    .dim var3 as long

.code

.sub Main
  .local var4 as long
  .local cSt as string

  .let var2 = var1 + var2 * var3
  .let var4 = (var3 + var2) * var1
  .let cSt = "prueba"

  invoke  MessageBox,HWND_DESKTOP,cSt,"Win32 Assembly",MB_OK
  invoke  ExitProcess,0

.endsub

.end Main
