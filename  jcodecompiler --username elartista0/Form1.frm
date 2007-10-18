VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5250
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   8175
   LinkTopic       =   "Form1"
   ScaleHeight     =   5250
   ScaleWidth      =   8175
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim lNumUsoLabels As Long
Dim cUsoLabels() As String
Dim lDirUsoLabels() As Long
Dim iSizeUsoLabels() As Integer
'Dim cVersionLarga() As String

Dim lNumLabels As Long
Dim cLabelNames() As String
Dim cLabelDirs As New Collection

Dim lNumLineDefs As Long
Dim cLineDefs() As String
Dim cLineDefsSubst() As String
Dim cLineDefsHistory() As String

Const lImageBase = &H400000

Dim lRVAOffset As Long

Private Sub ProcesarDB(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim lVal As Long
   Dim cTemp As String
   Do
      cTemp = cGetSep(cVals, ",")
      If Left$(cTemp, 1) = """" And Right$(cTemp, 1) = """" Then
         cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬db '" & Mid$(cTemp, 2, Len(cTemp) - 2) & "'" & vbCrLf
         cRes = cRes & Mid$(cTemp, 2, Len(cTemp) - 2)
      ElseIf Left$(cTemp, 1) = "'" And Right$(cTemp, 1) = "'" Then
         cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬db '" & Mid$(cTemp, 2, Len(cTemp) - 2) & "'" & vbCrLf
         cRes = cRes & Mid$(cTemp, 2, Len(cTemp) - 2)
      Else
         lVal = Val(cTemp)
         If lVal = 0 And cTemp <> "0" Then
            cTemp = cEval(cRes, cTemp)
            If IsNumeric(cTemp) Then
               lVal = Val(cTemp)
            Else
               lNumUsoLabels = lNumUsoLabels + 1
               ReDim Preserve cUsoLabels(lNumUsoLabels)
               ReDim Preserve lDirUsoLabels(lNumUsoLabels)
               ReDim Preserve iSizeUsoLabels(lNumUsoLabels)
               cUsoLabels(lNumUsoLabels) = cTemp
               If cTemp = "dword 0" Then Stop
               lDirUsoLabels(lNumUsoLabels) = Len(cRes)
               iSizeUsoLabels(lNumUsoLabels) = 1
               cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬comment recall " & Len(cRes) & " " & cTemp & vbCrLf
            End If
         End If
         cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬db " & cTemp & vbCrLf
         cRes = cRes & Chr$(lVal And &HFF)
      End If
   Loop Until cVals = ""
End Sub

Private Sub ProcesarDW(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim lVal As Long
   Dim cTemp As String
   Do
      cTemp = cGetSep(cVals, ",")
      If Left$(cTemp, 1) = """" And Right$(cTemp, 1) = """" Then
         cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬dw '" & Mid$(cTemp, 2, Len(cTemp) - 2) & "'" & vbCrLf
         cRes = cRes & StrConv(Mid$(cTemp, 2, Len(cTemp) - 2), vbUnicode)
      ElseIf Left$(cTemp, 1) = "'" And Right$(cTemp, 1) = "'" Then
         cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬dw '" & Mid$(cTemp, 2, Len(cTemp) - 2) & "'" & vbCrLf
         cRes = cRes & StrConv(Mid$(cTemp, 2, Len(cTemp) - 2), vbUnicode)
      Else
         lVal = Val(cTemp)
         If lVal = 0 And cTemp <> "0" Then
            cTemp = cEval(cRes, cTemp)
            If IsNumeric(cTemp) Then
               lVal = Val(cTemp)
            Else
               lNumUsoLabels = lNumUsoLabels + 1
               ReDim Preserve cUsoLabels(lNumUsoLabels)
               ReDim Preserve lDirUsoLabels(lNumUsoLabels)
               ReDim Preserve iSizeUsoLabels(lNumUsoLabels)
               cUsoLabels(lNumUsoLabels) = cTemp
               lDirUsoLabels(lNumUsoLabels) = Len(cRes)
               iSizeUsoLabels(lNumUsoLabels) = 2
               cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬comment recall " & Len(cRes) & " " & cTemp & vbCrLf
            End If
         End If
         cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬dw " & cTemp & vbCrLf
         cRes = cRes & Chr$(lVal And &HFF&)
         cRes = cRes & Chr$((lVal And &HFF00&) / 256)
      End If
   Loop Until cVals = ""
End Sub

Private Sub ProcesarALIGN(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim lVal As Long
   Dim lAlig As Long
   cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬align " & cVals & vbCrLf
   lAlig = Val(cVals)
   lVal = Len(cRes) Mod lAlig
   If lVal > 0 Then
      cRes = cRes & String$(lAlig - lVal, 0)
   End If
End Sub

Private Function MKL(ByVal lVal As Double) As String
   Dim cRes As String
   cRes = Chr$(lVal And &HFF&)
   cRes = cRes & Chr$((lVal And &HFF00&) / &H100&)
   cRes = cRes & Chr$((lVal And &HFF0000) / &H10000)
   lVal = lVal And &HFF000000
   If lVal < 0 Then
      lVal = 4294967296# + lVal
   End If
   MKL = cRes & Chr$(lVal / &H1000000)
End Function

Private Sub ProcesarDD(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim lVal As Double
   Dim cTemp As String
   Do
      cTemp = cGetSep(cVals, ",")
      lVal = Val(cTemp)
      If lVal = 0 And cTemp <> "0" Then
         cTemp = cEval(cRes, cTemp)
         If IsNumeric(cTemp) Then
            lVal = Val(cTemp)
         Else
            lNumUsoLabels = lNumUsoLabels + 1
            ReDim Preserve cUsoLabels(lNumUsoLabels)
            ReDim Preserve lDirUsoLabels(lNumUsoLabels)
            ReDim Preserve iSizeUsoLabels(lNumUsoLabels)
            cUsoLabels(lNumUsoLabels) = cTemp
            If cTemp = "dword 0" Then Stop
            lDirUsoLabels(lNumUsoLabels) = Len(cRes)
            iSizeUsoLabels(lNumUsoLabels) = 4
            cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬comment recall " & Len(cRes) & " " & cTemp & vbCrLf
         End If
      End If
      cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬dd " & cTemp & vbCrLf
      cRes = cRes & MKL(lVal)
   Loop Until cVals = ""
End Sub

Private Sub ProcesarLABEL(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   lNumLabels = lNumLabels + 1
   ReDim Preserve cLabelNames(lNumLabels)
   cLabelNames(lNumLabels) = cVals
   cLabelDirs.Add Len(cRes) + lRVAOffset + lImageBase, cVals
End Sub

Private Sub ProcesarMOV(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim cTemp As String
   Dim cResto As String
   cTemp = cGetSep(cVals, ",")
   If bComiezaPor(cTemp, "[ebp", cResto) Then
      Select Case cVals
      Case "eax"
         cRes = cRes & Chr$(&H89) & Chr$(&H45)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "ebx"
         cRes = cRes & Chr$(&H89) & Chr$(&H5D)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "ecx"
         cRes = cRes & Chr$(&H89) & Chr$(&H4D)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "esi"
         cRes = cRes & Chr$(&H89) & Chr$(&H75)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "edi"
         cRes = cRes & Chr$(&H89) & Chr$(&H7D)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case Else
         Error 1
      End Select
   ElseIf bComiezaPor(cVals, "[ebp", cResto) Then
      Select Case cTemp
      Case "eax"
         cRes = cRes & Chr$(&H8B) & Chr$(&H45)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "ebx"
         cRes = cRes & Chr$(&H8B) & Chr$(&H5D)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "ecx"
         cRes = cRes & Chr$(&H8B) & Chr$(&H4D)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "esi"
         cRes = cRes & Chr$(&H8B) & Chr$(&H75)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case "edi"
         cRes = cRes & Chr$(&H8B) & Chr$(&H7D)
         Call ProcesarDB(cLog, cRes, cGetSep(cResto, "]"))
      Case Else
         Error 1
      End Select
   ElseIf bComiezaPor(cTemp, "[", cResto) Then
      Select Case cVals
      Case "eax"
         cRes = cRes & Chr$(&HA3)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ebx"
         cRes = cRes & Chr$(&H89) & Chr$(&H1D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ecx"
         cRes = cRes & Chr$(&H89) & Chr$(&HD)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "esi"
         cRes = cRes & Chr$(&H89) & Chr$(&H35)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "edi"
         cRes = cRes & Chr$(&H89) & Chr$(&H3D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case Else
         Error 1
      End Select
   ElseIf bComiezaPor(cVals, "[", cResto) Then
      Select Case cTemp
      Case "eax"
         cRes = cRes & Chr$(&HA1)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ebx"
         cRes = cRes & Chr$(&H8B) & Chr$(&H1D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ecx"
         cRes = cRes & Chr$(&H8B) & Chr$(&HD)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "esi"
         cRes = cRes & Chr$(&H89) & Chr$(&H35)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "edi"
         cRes = cRes & Chr$(&H89) & Chr$(&H3D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case Else
         Error 1
      End Select
   Else
      Select Case cTemp
      Case "eax"
         cRes = cRes & Chr$(&HB8)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "ebx"
         cRes = cRes & Chr$(&HBB)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "ecx"
         cRes = cRes & Chr$(&HB9)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "esi"
         cRes = cRes & Chr$(&HBE)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "edi"
         cRes = cRes & Chr$(&HBF)
         Call ProcesarDD(cLog, cRes, cVals)
      Case Else
         Error 1
      End Select
   End If
End Sub

Private Sub ProcesarCMP(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim cTemp As String
   Dim cResto As String
   cTemp = cGetSep(cVals, ",")
   If bComiezaPor(cTemp, "[", cResto) Then
      Select Case cVals
      Case "eax"
         cRes = cRes & Chr$(&HA3)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ebx"
         cRes = cRes & Chr$(&H89) & Chr$(&H1D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ecx"
         cRes = cRes & Chr$(&H89) & Chr$(&HD)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "esi"
         cRes = cRes & Chr$(&H89) & Chr$(&H35)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "edi"
         cRes = cRes & Chr$(&H89) & Chr$(&H3D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case Else
         Error 1
      End Select
   ElseIf bComiezaPor(cVals, "[", cResto) Then
      Select Case cTemp
      Case "eax"
         cRes = cRes & Chr$(&HA1)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ebx"
         cRes = cRes & Chr$(&H8B) & Chr$(&H1D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "ecx"
         cRes = cRes & Chr$(&H8B) & Chr$(&HD)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "esi"
         cRes = cRes & Chr$(&H89) & Chr$(&H35)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case "edi"
         cRes = cRes & Chr$(&H89) & Chr$(&H3D)
         Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
      Case Else
         Error 1
      End Select
   Else
      Select Case cTemp
      Case "eax"
         cRes = cRes & Chr$(&HB8)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "ebx"
         cRes = cRes & Chr$(&HBB)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "ecx"
         cRes = cRes & Chr$(&HB9)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "esi"
         cRes = cRes & Chr$(&HBE)
         Call ProcesarDD(cLog, cRes, cVals)
      Case "edi"
         cRes = cRes & Chr$(&HBF)
         Call ProcesarDD(cLog, cRes, cVals)
      Case Else
         Error 1
      End Select
   End If
End Sub

'Private Sub ProcesarCALL(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cResto As String
'   Dim cLabel As String
'   If bComiezaPor(cVals, "[", cResto) Then
'      cRes = cRes & Chr$(&HFF) & Chr$(&H15)
'      Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
'   Else
'      cRes = cRes & Chr$(&HE8)
'      cLabel = cNewLabel()
'      Call ProcesarDD(cLog, cRes, cVals & "-" & cLabel)
'      Call ProcesarLABEL(cLog, cRes, cLabel)
'   End If
'End Sub
'
'Private Sub ProcesarJMP(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   cRes = cRes & Chr$(&HE9)
'   cLabel = cNewLabel()
'   Call ProcesarDD(cLog, cRes, cVals & "-" & cLabel)
'   Call ProcesarLABEL(cLog, cRes, cLabel)
'End Sub
'
'Private Sub ProcesarJZ(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   cRes = cRes & Chr$(&HF) & Chr$(&H84) 'Chr$(&H74)
'   cLabel = cNewLabel()
'   Call ProcesarDD(cLog, cRes, cVals & "-" & cLabel)
'   Call ProcesarLABEL(cLog, cRes, cLabel)
'End Sub
'
'Private Sub ProcesarJNZ(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   cRes = cRes & Chr$(&HF) & Chr$(&H85) 'Chr$(&H75)
'   cLabel = cNewLabel()
'   Call ProcesarDD(cLog, cRes, cVals & "-" & cLabel)
'   Call ProcesarLABEL(cLog, cRes, cLabel)
'End Sub
'
'Private Sub ProcesarJC(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   cRes = cRes & Chr$(&HF) & Chr$(&H82) 'Chr$(&H72)
'   cLabel = cNewLabel()
'   Call ProcesarDD(cLog, cRes, cVals & "-" & cLabel)
'   Call ProcesarLABEL(cLog, cRes, cLabel)
'End Sub
'
'Private Sub ProcesarJNC(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   cRes = cRes & Chr$(&HF) & Chr$(&H83) 'Chr$(&H73)
'   cLabel = cNewLabel()
'   Call ProcesarDD(cLog, cRes, cVals & "-" & cLabel)
'   Call ProcesarLABEL(cLog, cRes, cLabel)
'End Sub

'Private Sub ProcesarPUSH(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   Dim cResto As String
'   If Left$(cVals, 1) = """" Or Left$(cVals, 1) = "'" Then
'      cLabel = cNewLabel()
'      Call ProcesarCALL(cLog, cRes, cLabel)
'      Call ProcesarDB(cLog, cRes, cVals & ",0")
'      Call ProcesarLABEL(cLog, cRes, cLabel)
'   ElseIf bComiezaPor(cVals, "dword [", cResto) Then
'      cRes = cRes & Chr$(&HFF) & Chr$(&H35)
'      Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
'   ElseIf bComiezaPor(cVals, "dword ", cResto) Then
'      If IsNumeric(cResto) Then
'         If (Val(cVals) And 255) = Val(cResto) Then
'            cRes = cRes & Chr$(&H6A)
'            Call ProcesarDB(cLog, cRes, cResto)
'         Else
'            cRes = cRes & Chr$(&H68)
'            Call ProcesarDD(cLog, cRes, cResto)
'         End If
'      Else
'         cRes = cRes & Chr$(&H68)
'         Call ProcesarDD(cLog, cRes, cResto)
'      End If
'   ElseIf bComiezaPor(cVals, "word ", cResto) Then
'      cRes = cRes & Chr$(&H66) & Chr$(&H68)
'      Call ProcesarDW(cLog, cRes, cResto)
'   ElseIf cVals = "eax" Then
'      cRes = cRes & Chr$(&H50)
'   Else
'      cRes = cRes & Chr$(&H68)
'      Call ProcesarDD(cLog, cRes, cResto)
'   End If
'End Sub
'
'Private Sub ProcesarPOP(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cResto As String
'   If bComiezaPor(cVals, "dword [", cResto) Then
'      cRes = cRes & Chr$(&H8F) & Chr$(&H5)
'      Call ProcesarDD(cLog, cRes, cGetSep(cResto, "]"))
'   ElseIf bComiezaPor(cVals, "word [", cResto) Then
'      cRes = cRes & Chr$(&H66) & Chr$(&H8F) & Chr$(&H5)
'      Call ProcesarDW(cLog, cRes, cGetSep(cResto, "]"))
'   ElseIf cVals = "eax" Then
'      cRes = cRes & Chr$(&H58)
'   Else
'      Error 1
'   End If
'End Sub

'Private Function cEval(ByVal cFormula As String) As String
'   Dim iNumPar As Integer
'   Dim lPos As Long
'   Dim cResul As String
'
'   If Left$(cFormula, 1) = "(" Then
'      iNumPar = 1
'      For lPos = 2 To Len(cFormula)
'         If Mid$(cFormula, lPos, 1) = ")" Then
'            iNumPar = iNumPar - 1
'            If iNumPar = 0 Then
'               cFormula = cEval(Mid$(cFormula, 2, lPos - 3)) + Mid$(cFormula, lPos + 1)
'               Exit For
'            End If
'         ElseIf Mid$(cFormula, lPos, 1) = "(" Then
'            iNumPar = iNumPar + 1
'         End If
'      Next
'   End If
'   cResul = cGetSep(cFormula, "+")
'   If Len(cFormula) > 0 Then
'      If IsNumeric(cResul) And IsNumeric(cFormula) Then
'      cEval=cEval(cResul ) +
'   Else
'      cResul = cGetSep(cFormula, "+")
'      If Len(cFormula) > 0 Then
'
'End Function

Private Sub ProcesarDEFINE(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim cTemp As String
   Dim cValTemp As String
   Dim lIndice As Long
   
   cTemp = cGetSep(cVals, " ")
   For lIndice = lNumLabels To 0 Step -1
      If cLabelNames(lIndice) = cTemp Then
         Exit For
      End If
   Next
   If lIndice = -1 Then
      lNumLabels = lNumLabels + 1
      ReDim Preserve cLabelNames(lNumLabels)
      cLabelNames(lNumLabels) = cTemp
   End If
   
   'If cTemp = "$RVABase" Then Stop
   cValTemp = cEval(cRes, cVals)
   If lIndice > -1 Then
      cLabelDirs.Remove cTemp
   End If
   cLabelDirs.Add cValTemp, cTemp
   If IsNumeric(cValTemp) Then
      cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬define " & cTemp & " " & cValTemp & "    ¬comment &H" & Right$("00000000" & Hex$(Val(cValTemp)), 8) & " = " & cVals & vbCrLf
   Else
      cLog = cLog & Right$("00000000" & Hex$(Len(cRes)), 8) & ": ¬define " & cTemp & " " & cValTemp & vbCrLf
   End If
End Sub

Private Function cEval(ByVal cRes As String, ByVal cFormula As String) As String
   Dim lVal As Double
   Dim cOp As String
   Dim cVariable As String
   Dim bConst As Boolean
   Dim cValTemp As String
   Dim lIndice As Long
   Dim iNumPar As Integer
   
   cVariable = ""
   lVal = 0
   bConst = (cFormula > "")
   cOp = "+"
   lIndice = 1
   While lIndice <= Len(cFormula) + 1
      Select Case Mid$(cFormula, lIndice, 1)
      Case "("
         cVariable = ""
         iNumPar = 1
         Do While lIndice <= Len(cFormula) + 1
            lIndice = lIndice + 1
            Select Case Mid$(cFormula, lIndice, 1)
            Case "("
               iNumPar = iNumPar + 1
            Case ")"
               iNumPar = iNumPar - 1
               If iNumPar = 0 Then
                  cVariable = cEval(cRes, cVariable)
                  If Not IsNumeric(cVariable) Then
                     If InStr(cVariable, "+") > 0 _
                     Or InStr(cVariable, "-") > 0 _
                     Or InStr(cVariable, "*") > 0 _
                     Or InStr(cVariable, "/") > 0 _
                     Or InStr(cVariable, "%") > 0 Or Not bConst Then
                        cVariable = "(" & cVariable & ")"
                     End If
                  End If
                  Exit Do
               End If
            Case ""
               Error 1
            End Select
            cVariable = cVariable & Mid$(cFormula, lIndice, 1)
         Loop
      Case "+", "-", "*", "/", "%", "[", "]", " ", ""
         If Len(cVariable) > 0 Then
            If cVariable = "¬curpos" Then
               cVariable = Len(cRes)
            ElseIf cVariable = "¬checksum" Then
               cVariable = cCalcularCheckSum(cRes)
            Else
               On Error Resume Next
               If cLabelDirs(cVariable) = "" Then
               Else
                  cVariable = cLabelDirs(cVariable)
               End If
               If Not IsNumeric(cVariable) Then
                  If InStr(cVariable, "+") > 0 _
                  Or InStr(cVariable, "-") > 0 _
                  Or InStr(cVariable, "*") > 0 _
                  Or InStr(cVariable, "/") > 0 _
                  Or InStr(cVariable, "%") > 0 Then
                     cVariable = "(" & cVariable & ")"
                  End If
               End If
               On Error GoTo 0
            End If
            If IsNumeric(cVariable) And bConst Then
               Select Case cOp
               Case "+", " "
                  lVal = lVal + Val(cVariable)
               Case "-"
                  lVal = lVal - Val(cVariable)
               Case "*"
                  lVal = lVal * Val(cVariable)
               Case "/"
                  lVal = Int(lVal / Val(cVariable))
               Case "%"
                  lVal = lVal - Int(lVal / Val(cVariable)) * Val(cVariable)
               Case Else
                  Error 1
               End Select
               If lVal < &H80000000 Then
                  lVal = lVal + 4294967296#
               ElseIf lVal > &H7FFFFFFF Then
                  lVal = lVal - 4294967296#
               End If
            Else
               bConst = False
            End If
            cValTemp = cValTemp & cVariable
         End If
         cValTemp = cValTemp & Mid$(cFormula, lIndice, 1)
         cVariable = ""
         Select Case Mid$(cFormula, lIndice, 1)
         Case "+", "-", "*", "/", "%"
            cOp = Mid$(cFormula, lIndice, 1)
         End Select
      Case Else
         cVariable = cVariable & Mid$(cFormula, lIndice, 1)
      End Select
      lIndice = lIndice + 1
   Wend
   If bConst Then
      cValTemp = lVal
   End If
   cEval = cValTemp
End Function
'
'Private Sub ProcesarRVA(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   lRVAOffset = lRVAOffset + Len(cRes) - 1
'   lRVAOffset = Int(lRVAOffset / &H100000) + 1
'   lRVAOffset = lRVAOffset * &H100000 - Len(cRes)
'End Sub
'
'Private Sub ProcesarFILEPOS(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   lNumLabels = lNumLabels + 1
'   ReDim Preserve cLabelNames(lNumLabels)
'   cLabelNames(lNumLabels) = cVals
'   cLabelDirs.Add Len(cRes), cVals
'End Sub

Private Sub ProcesarPROC(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Call ProcesarLABEL(cLog, cRes, cVals)
   cRes = cRes & Chr$(&H55) & Chr$(&H89) & Chr$(&HE5) 'push ebp; mov ebp,esp
End Sub

Private Sub ProcesarENDPROC(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   cRes = cRes & Chr$(&HC9) & Chr$(&HC2) 'leave; retn <val>
   Call ProcesarDW(cLog, cRes, cVals)
End Sub

Private Function bRegExp(ByVal cLinea As String, ByVal cPatron As String, cParams() As String) As Boolean
   Dim lPosLinea As Long
   Dim lPosPatron As Long
   Dim cBloquePatron As Long
   Dim iNumParam As Integer
   Dim cBloque As String
   Dim bResultado As Boolean
   
   bResultado = True
   lPosPatron = InStr(cPatron, "*")
   If lPosPatron = 0 Then
      bRegExp = (cLinea = cPatron)
      Exit Function
   ElseIf lPosPatron > 1 Then
      cBloque = Left$(cPatron, lPosPatron - 1)
      cPatron = Mid$(cPatron, lPosPatron + 1)
      If Not bComiezaPor(cLinea, cBloque, cLinea) Then
         bRegExp = False
         Exit Function
      End If
   Else
      cPatron = Mid$(cPatron, 2)
   End If
   iNumParam = 0
   lPosPatron = InStr(cPatron, "*")
   While bResultado And lPosPatron > 0
      cBloque = Left$(cPatron, lPosPatron - 1)
      lPosLinea = InStr(cLinea, cBloque)
      If lPosLinea > 0 Then
         iNumParam = iNumParam + 1
         ReDim Preserve cParams(iNumParam)
         cParams(iNumParam) = Left$(cLinea, lPosLinea - 1)
         cLinea = Mid$(cLinea, lPosLinea + Len(cBloque))
      Else
         bRegExp = False
         Exit Function
      End If
      cPatron = Mid$(cPatron, lPosPatron + 1)
      lPosPatron = InStr(cPatron, "*")
   Wend
   If Len(cPatron) > 0 And Right$(cLinea, Len(cPatron)) <> cPatron Then
      bRegExp = False
   Else
      iNumParam = iNumParam + 1
      ReDim Preserve cParams(iNumParam)
      cParams(iNumParam) = Left$(cLinea, Len(cLinea) - Len(cPatron))
      bRegExp = True
   End If
End Function

Private Sub ProcesarPUSHDEF(ByRef cCodigo As String, ByRef cRes As String, ByVal cVals As String)
   Dim lNumLineDefAct As Long
   Dim iIndice As Integer
   For lNumLineDefAct = lNumLineDefs To 0 Step -1
      If cLineDefs(lNumLineDefAct) = cVals Then
         For iIndice = 20 To 1 Step -1
            cLineDefsHistory(iIndice, lNumLineDefAct) = cLineDefsHistory(iIndice - 1, lNumLineDefAct)
         Next
         cLineDefsHistory(iIndice, lNumLineDefAct) = cLineDefsSubst(lNumLineDefAct)
         Exit For
      End If
   Next
   cCodigo = "¬linedef " & cVals & vbCrLf & cCodigo
End Sub

Private Sub ProcesarPOPDEF(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
   Dim lNumLineDefAct As Long
   Dim iIndice As Integer
   For lNumLineDefAct = lNumLineDefs To 0 Step -1
      If cLineDefs(lNumLineDefAct) = cVals Then
         cLineDefsSubst(lNumLineDefAct) = cLineDefsHistory(0, lNumLineDefAct)
         For iIndice = 0 To 19
            cLineDefsHistory(iIndice, lNumLineDefAct) = cLineDefsHistory(iIndice + 1, lNumLineDefAct)
         Next
         cLineDefsHistory(20, lNumLineDefAct) = ""
         Exit For
      End If
   Next
End Sub

Private Sub ProcesarIF(ByRef cCodigo As String, ByRef cRes As String, ByVal cVals As String)
   Dim cTemp As String
   Dim iNumIf As Integer
   Dim cLinea As String
   Dim cResultado As String
   Dim bCondicion As Boolean
   Dim cResto As String
   If InStr(cVals, "=") Then
      cTemp = cGetSep(cVals, "=")
      bCondicion = (cEval(cRes, cTemp) = cEval(cRes, cVals))
   ElseIf InStr(cVals, "<>") Then
      cTemp = cGetSep(cVals, "<>")
      bCondicion = (cEval(cRes, cTemp) <> cEval(cRes, cVals))
   ElseIf InStr(cVals, ">") Then
      cTemp = cGetSep(cVals, ">")
      bCondicion = (cEval(cRes, cTemp) > cEval(cRes, cVals))
   ElseIf InStr(cVals, "<") Then
      cTemp = cGetSep(cVals, "<")
      bCondicion = (cEval(cRes, cTemp) < cEval(cRes, cVals))
   Else
      Error 1
   End If
   iNumIf = 1
   Do While cCodigo > ""
      cLinea = cGetSep(cCodigo, vbCrLf)
      If bComiezaPor(cLinea, "¬if ", cResto) Then
         iNumIf = iNumIf + 1
      ElseIf iNumIf = 1 And bComiezaPor(cLinea, "¬else", cResto) Then
         If Not bCondicion And bComiezaPor(cResto, "if ", cResto) Then
            cResultado = cResultado & vbCrLf & "¬if " & cResto
            Exit Do
         End If
         bCondicion = Not bCondicion
      ElseIf cLinea = "¬" Then
         iNumIf = iNumIf - 1
         If iNumIf = 0 Then
            Exit Do
         End If
      End If
      If bCondicion Then
         cResultado = cResultado & cLinea & vbCrLf
      End If
   Loop
   cCodigo = cResultado & cCodigo
   
End Sub

Private Function cCalcularCheckSum(ByRef cRes As String) As String
   Dim lPos As Long
   Dim lSum As Long
   For lPos = 1 To Len(cRes)
      lSum = lSum + Asc(Mid$(cRes, lPos, 1)) + 256& * Asc(Mid$(cRes, lPos, 1))
      lSum = lSum And &HFFFF&
   Next
   Stop
End Function

Private Sub ProcesarLINEDEF(ByRef cCodigo As String, ByRef cRes As String, ByVal cVals As String)
   Dim cLineDef As String
   Dim lNumLineDefAct As Long
   Dim iNumLindef As Integer
   Dim cLinea As String
   Dim lIndice As Long
   Dim lUnico As Long
   Dim cTemp As String
   
   For lNumLineDefAct = lNumLineDefs To 0 Step -1
      If cLineDefs(lNumLineDefAct) = cVals Then
         Exit For
      End If
   Next
   If lNumLineDefAct = -1 Then
      lNumLineDefs = lNumLineDefs + 1
      lNumLineDefAct = lNumLineDefs
      ReDim Preserve cLineDefs(lNumLineDefAct)
      ReDim Preserve cLineDefsSubst(lNumLineDefAct)
      ReDim Preserve cLineDefsHistory(20, lNumLineDefAct)
      cLineDefs(lNumLineDefAct) = cVals
   End If
   cLinea = cGetSep(cCodigo, vbCrLf)
   cLineDef = ""
   iNumLindef = 1
   Do
      If Left$(cLinea, 9) = "¬linedef " Then
         iNumLindef = iNumLindef + 1
      ElseIf Left$(cLinea, 9) = "¬pushdef " Then
         iNumLindef = iNumLindef + 1
      ElseIf Left$(cLinea, 4) = "¬if " Then
         iNumLindef = iNumLindef + 1
      ElseIf cLinea = "¬" Then
         iNumLindef = iNumLindef - 1
         If iNumLindef = 0 Then
            Exit Do
         End If
      End If
      If iNumLindef = 1 And Left$(cLinea, 8) = "¬expand " Then
         cLinea = Mid$(cLinea, 9)
         For lIndice = 0 To lNumLineDefs
            If cLinea = cLineDefs(lIndice) Then
               cLinea = cLineDefsSubst(lIndice)
               If bComiezaPor(cLinea, "¬local ", cLinea) Then
                  cVals = cGetSep(cLinea, vbCrLf)
                  While Len(cVals) > 0
                     lUnico = lUnico + 1
                     cTemp = cGetSep(cVals, ",")
                     cLinea = Replace(cLinea, cTemp, cTemp & lUnico)
                  Wend
               End If
               cLineDef = cLineDef & cLinea
               Exit For
            End If
         Next
      ElseIf Not bComiezaPor(cLinea, "¬comment ", cVals) Then
         cLineDef = cLineDef & cLinea & vbCrLf
       End If
      cLinea = cGetSep(cCodigo, vbCrLf)
      If cCodigo = "" Then Stop
   Loop
   cLineDefsSubst(lNumLineDefAct) = cLineDef
End Sub

'Private Sub ProcesarRSRCDIR(ByRef cLog As String, ByRef cRes As String, ByVal cVals As String)
'   Dim cLabel As String
'   Call ProcesarDD(clog,cRes, "0,0,0")
'   Call ProcesarDW(cRes, "0,0,1")
'   cLabel = cNewLabel
'   Call ProcesarDW(cRes, "5,0," & cLabel & "-$rsrc_start,8000h")
'End Sub

Private Sub Form_Load()
   Dim cResultado As String
   Dim cCodigo As String
   Dim cLinea As String
   Dim cResto As String
   Dim cTemp As String
   Dim lIndice As Long
   Dim lVal As Double
   Dim lOffset As Long
   Dim lUnico As Long
   Dim cOp As String
   Dim cOpAnt As String
   Dim cParams() As String
   Dim lParam As Long
   Dim bEncontrado As Boolean
   Dim cLog As String
   Dim lNumLinea As Integer
   
   lNumUsoLabels = -1
   lNumLabels = -1
   lNumLineDefs = -1
   cResultado = ""
   'ChDir "U:\Mis proyectos\fasm\VBAssembler"
   ChDir "E:\Otros\Masm32\fasmw16723\VBAssembler"
   Open "code.asm" For Binary As 1
   cCodigo = Replace(Replace(Replace(Input$(10000000, 1), vbTab, " "), "   ", " "), "  ", " ")
   Close 1
   
   Do
      cLinea = cGetSep(cCodigo, vbCrLf)
      lIndice = InStr(cLinea, "¬comment")
      If lIndice > 0 Then
         cLog = cLog & Mid$(cLinea, lIndice) & vbCrLf
         cLinea = Trim$(Left$(cLinea, lIndice - 1))
      End If
      If cLinea = "" Then
      ElseIf bComiezaPor(cLinea, "¬db ", cResto) Then
         Call ProcesarDB(cLog, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬dw ", cResto) Then
         Call ProcesarDW(cLog, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬dd ", cResto) Then
         Call ProcesarDD(cLog, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬define ", cResto) Then
         Call ProcesarDEFINE(cLog, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬align ", cResto) Then
         Call ProcesarALIGN(cLog, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬include ", cResto) Then
         If Left$(cResto, 1) = """" Then
            cResto = cGetSep(Mid$(cResto, 2), """")
         ElseIf Left$(cResto, 1) = "'" Then
            cResto = cGetSep(Mid$(cResto, 2), "'")
         End If
         Open cResto For Binary As 1
         cResto = Replace(Replace(Replace(Input$(10000000, 1), vbTab, " "), "   ", " "), "  ", " ")
         Close 1
         cCodigo = cResto & vbCrLf & cCodigo
      ElseIf bComiezaPor(cLinea, "¬if ", cResto) Then
         Call ProcesarIF(cCodigo, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬linedef ", cResto) Then
         Call ProcesarLINEDEF(cCodigo, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬pushdef ", cResto) Then
         Call ProcesarPUSHDEF(cCodigo, cResultado, cResto)
      ElseIf bComiezaPor(cLinea, "¬popdef ", cResto) Then
         Call ProcesarPOPDEF(cLog, cResultado, cResto)
      Else
         bEncontrado = False
         'If cLinea = "local var1 as dword" Then Stop
         ReDim cParams(0)
         'cLinea = cEval(cResultado, cLinea)
         cLog = cLog & "¬comment " & cLinea & vbCrLf
         For lIndice = 0 To lNumLineDefs
            If bRegExp(cLinea, cLineDefs(lIndice), cParams) Then
               cLinea = cLineDefsSubst(lIndice)
               If bComiezaPor(cLinea, "¬local ", cLinea) Then
                  cResto = cGetSep(cLinea, vbCrLf)
                  While Len(cResto) > 0
                     lUnico = lUnico + 1
                     cTemp = cGetSep(cResto, ",")
                     cLinea = Replace(cLinea, cTemp, cTemp & lUnico)
                  Wend
               End If
               For lParam = 1 To UBound(cParams)
                  cTemp = cParams(lParam)
                  'On Error Resume Next
                  'cTemp = cLabelDirs(cTemp)
                  'On Error GoTo 0
                  cLinea = Replace(cLinea, "\" & Format$(lParam, "00"), cTemp)
               Next
               cCodigo = Replace(cLinea, "\¬", "\") & cCodigo
               bEncontrado = True
               Exit For
            End If
         Next
         If Not bEncontrado Then
            MsgBox "Error en la línea " & lNumLinea & ": No se reconoce '" & cLinea & "'.", vbCritical
         End If
      End If
   Loop Until cCodigo = ""
   
   Do
      lOffset = 0
      For lIndice = 0 To lNumUsoLabels
         cResto = cEval("", cUsoLabels(lIndice))
         If IsNumeric(cResto) Then
            lVal = cResto
         Else
            lVal = 0
            MsgBox "No se ha definido el símbolo " & cResto, vbCritical
         End If
         Mid$(cResultado, lDirUsoLabels(lIndice) + 1, iSizeUsoLabels(lIndice)) = Left$(MKL(lVal), iSizeUsoLabels(lIndice))
      Next
   Loop Until lOffset = 0
   
   cLog = cLog & vbCrLf
   
   For lIndice = 0 To lNumLabels
      cLog = cLog & "¬define " & cLabelNames(lIndice) & " " & cLabelDirs(cLabelNames(lIndice)) & vbCrLf
   Next
   cLog = cLog & vbCrLf
   
   For lIndice = 0 To lNumLineDefs
      cLog = cLog & "¬linedef " & cLineDefs(lIndice) & vbCrLf
      cLog = cLog & cLineDefsSubst(lIndice) & vbCrLf & vbCrLf
   Next
   
   Open "code.exe" For Output As 1
   Print #1, cResultado;
   Close 1
   Open "code.log" For Output As 1
   Print #1, cLog
   Close 1
   End
End Sub

Private Function cGetSep(cCode As String, cSep As String) As String
   Dim lPos As Long
   lPos = InStr(cCode, cSep)
   If lPos > 0 Then
      cGetSep = Trim$(Left$(cCode, lPos - 1))
      cCode = LTrim$(Mid$(cCode, lPos + Len(cSep)))
   Else
      cGetSep = Trim$(cCode)
      cCode = ""
   End If
End Function

Private Function bComiezaPor(cLine As String, cLineType As String, cResto As String) As Boolean
   If Left$(cLine, Len(cLineType)) = cLineType Then
      bComiezaPor = True
      cResto = Trim$(Mid$(cLine, Len(cLineType) + 1))
   Else
      bComiezaPor = False
   End If
End Function

