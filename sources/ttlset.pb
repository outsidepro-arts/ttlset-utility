; TTLSet Utility
; Copyright (c) 2021 Outsidepro
; License: MIT License

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
XIncludeFile "..\modules\Registry Module.pb"
CompilerElse
MessageRequester("Operating system is not supported", "This operating system is currently not supported. If you have the full utility distributive, you may have the source codes also. If you've runnen this source code in your system and see this message, it means you're known with PureBasic programming. So, if you're known with your system's TTL interracting, you're welcome to add this to the utility. I'll asking you one: please, send me this changes via E-Mail denis.outsidepro@gmail.com.", #PB_MessageRequester_Error)
End
CompilerEndIf

Structure TTLPreset
Name.s
IP4.s
IP6.s
EndStructure

#CUSTOM_EVENT_ReadValues = #PB_Event_FirstCustomValue

Dim TTLPresets.TTLPreset(0)
Macro CreatePreset(pName, pIP4, pIP6)
ReDim TTLPresets(ArraySize(TTLPresets())+1)
TTLPresets(ArraySize(TTLPresets())-1)\Name = pName
TTLPresets(ArraySize(TTLPresets())-1)\IP4 = pIP4
TTLPresets(ArraySize(TTLPresets())-1)\IP6 = pIP6
EndMacro

CreatePreset("Default TTL for Windows", "128", "128")
CreatePreset("Default TTL for Linux/Mac/Android/iOS", "64", "64") 
CreatePreset("Hide shared internet for cellular operators", "65", "65")
CreatePreset("Nullify all TTLs (default protocol values will be used)", "", "")

Procedure.s GetTTLFromPing(CMDLine.s)
Protected PingProc = RunProgram("ping.exe", "-n 1 "+CMDLine, "", #PB_Program_Open|#PB_Program_Read)
WaitProgram(PingProc)
Protected TTLValue.s = #Null$
While AvailableProgramOutput(PingProc) > 0
Protected CurLine$ = ReadProgramString(PingProc)
Protected ttlPos.i = FindString(CurLine$, "TTL")
If ttlPos
TTLValue = Mid(CurLine$, ttlPos+4)
EndIf
Wend
CloseProgram(PingProc)
ProcedureReturn TTLValue
EndProcedure

Procedure.s GetCurrentIP4TTL()
Protected Result.s = Registry::ReadValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "DefaultTTL", #REG_DWORD)
If Result
ProcedureReturn Result
EndIf
EndProcedure

Procedure.s GetCurrentIP6TTL()
Protected Result.s = Registry::ReadValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters", "DefaultTTL", #REG_DWORD)
If Result
ProcedureReturn Result
EndIf
EndProcedure

Procedure.a SetCurrentIP4TTL(Value.s)
If Value
ProcedureReturn Registry::WriteValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "DefaultTTL", Value, #REG_DWORD)
EndIf
ProcedureReturn Registry::DeleteValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "DefaultTTL")
EndProcedure

Procedure.a SetCurrentIP6TTL(Value.s)
If Value
ProcedureReturn Registry::WriteValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters", "DefaultTTL", Value, #REG_DWORD)
EndIf
ProcedureReturn Registry::DeleteValue(#HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters", "DefaultTTL")
EndProcedure

Global WindowForm = OpenWindow(#PB_Any, 0, 0, 640, 480, "TTL set utility V1."+#PB_Editor_BuildCount, #PB_Window_TitleBar|#PB_Window_Normal|#PB_Window_ScreenCentered)
TextGadget(#PB_Any, 20, 20, 110, 10, "TTL presets:")
Global ttlPresets_Combo = ComboBoxGadget(#PB_Any, 121, 20, 300, 20)
For i.i = 0 To ArraySize(TTLPresets())-1
AddGadgetItem(ttlPresets_Combo, -1, TTLPresets(i)\Name)
Next
TextGadget(#PB_Any, 20, 31, 140, 10, "TCP IP V4 TTL:")
Global IP4TTL_Edit = SpinGadget(#PB_Any, 20, 42, 50, 50, 1, 256, #PB_Spin_Numeric)
Global IP4TTL_Checkbox = CheckBoxGadget(#PB_Any, 80, 42, 200, 20, "Specify IP V4 value")
Global IP4TTLPing_Button = ButtonGadget(#PB_Any, 80, 63, 200, 19, "Ping IP V4 TTL")
TextGadget(#PB_Any, 220, 31, 140, 10, "TCP IP V6 TTL:")
Global IP6TTL_Edit = SpinGadget(#PB_Any, 220, 42, 50, 50, 1, 256, #PB_Spin_Numeric)
Global IP6TTL_Checkbox = CheckBoxGadget(#PB_Any, 280, 42, 200, 20, "Specify IP V6 value")
Global IP6TTLPing_Button = ButtonGadget(#PB_Any, 280, 63, 200, 19, "Ping IP V6 TTL")
Global Set_Button = ButtonGadget(#PB_Any, 50, 100, 100, 100, "Set TTL")
Global RereadFromSystem_Button = ButtonGadget(#PB_Any, 200, 100, 250, 100, "Re-read TTL from system")
PostEvent(#CUSTOM_EVENT_ReadValues)
Repeat
Event = WaitWindowEvent()
Select Event
Case #PB_Event_Gadget
Select EventGadget()
Case ttlPresets_Combo
If EventType() = #PB_EventType_Change
SelectedPreset.l = GetGadgetState(ttlPresets_Combo)
If TTLPresets(SelectedPreset)\IP4
SetGadgetState(IP4TTL_Checkbox, #True)
DisableGadget(IP4TTL_Edit, #False)
SetGadgetText(IP4TTL_Edit, TTLPresets(SelectedPreset)\IP4)
Else
SetGadgetState(IP4TTL_Checkbox, #False)
DisableGadget(IP4TTL_Edit, #True)
SetGadgetText(IP4TTL_Edit, #Null$)
EndIf
If TTLPresets(SelectedPreset)\IP6
SetGadgetState(IP6TTL_Checkbox, #True)
DisableGadget(IP6TTL_Edit, #False)
SetGadgetText(IP6TTL_Edit, TTLPresets(SelectedPreset)\IP6)
Else
SetGadgetState(IP6TTL_Checkbox, #False)
DisableGadget(IP6TTL_Edit, #True)
SetGadgetText(IP6TTL_Edit, #Null$)
EndIf
EndIf
Case IP4TTL_Edit, IP6TTL_Edit
Select EventType()
Case #PB_EventType_Change
; Надо найти событие, которое этот долбанный SpinGadget отправляет кроме события изменения, чтобы выделять содержимое. Пока пусть это событие останется закомментированным. Переписывать его на StringGadget не охота - потеряется весь шарм.
; SendMessage_(GadgetID(GetActiveGadget()), #EM_SETSEL, 0, -1)
EndSelect
Case IP4TTL_Checkbox
DisableGadget(IP4TTL_Edit, GetGadgetState(IP4TTL_Checkbox)!1)
If GetGadgetState(IP4TTL_Checkbox) = #True
SetGadgetText(IP4TTL_Edit, "1")
SetActiveGadget(IP4TTL_Edit)
EndIf
Case IP6TTL_Checkbox
DisableGadget(IP6TTL_Edit, GetGadgetState(IP6TTL_Checkbox)!1)
If GetGadgetState(IP6TTL_Edit) = #True
SetGadgetText(IP6TTL_Edit, "1")
SetActiveGadget(IP6TTL_Edit)
EndIf
Case IP4TTLPing_Button
Result.s = GetTTLFromPing("127.0.0.1")
If Result
SetGadgetText(IP4TTL_Edit, Result)
If GetGadgetState(IP4TTL_Checkbox) = #False
SetGadgetState(IP4TTL_Checkbox, #True)
DisableGadget(IP4TTL_Edit, #False)
EndIf
SetActiveGadget(IP4TTL_Edit)
Else
MessageRequester("Ping error", "Couldn't retrieve the TTL value from ping results.", #PB_MessageRequester_Error)
EndIf
Case IP6TTLPing_Button
Result.s = GetTTLFromPing("::1")
If Result
SetGadgetText(IP6TTL_Edit, Result)
If GetGadgetState(IP6TTL_Checkbox) = #False
SetGadgetState(IP6TTL_CheckboxTL_Checkbox, #True)
DisableGadget(IP6TTL_Edit, #False)
EndIf
SetActiveGadget(IP6TTL_Edit)
Else
MessageRequester("Ping error", "Couldn't retrieve the TTL value from ping results.", #PB_MessageRequester_Error)
EndIf
Case Set_Button
If GetGadgetState(IP4TTL_Checkbox) = #True
If Not SetCurrentIP4TTL(GetGadgetText(IP4TTL_Edit))
MessageRequester("Set IP TTL error", "Couldn't set new TTL value for IP V4.", #PB_MessageRequester_Error)
EndIf
Else
If Not SetCurrentIP4TTL(#Null$)
MessageRequester("Set IP TTL error", "Couldn't nullify the TTL value for IP V4.", #PB_MessageRequester_Error)
EndIf
EndIf
If GetGadgetState(IP6TTL_Checkbox) = #True
If  Not SetCurrentIP6TTL(GetGadgetText(IP6TTL_Edit))
MessageRequester("Set IP TTL error", "Couldn't set new TTL value for IP V6.", #PB_MessageRequester_Error)
EndIf
Else
If Not SetCurrentIP6TTL(#Null$)
MessageRequester("Set IP TTL error", "Couldn't nullify the TTL value for IP V6.", #PB_MessageRequester_Error)
EndIf
EndIf
PostEvent(#CUSTOM_EVENT_ReadValues)
Case RereadFromSystem_Button
PostEvent(#CUSTOM_EVENT_ReadValues)
EndSelect
Case #CUSTOM_EVENT_ReadValues
IPValue.s = GetCurrentIP4TTL()
If IPValue
SetGadgetText(IP4TTL_Edit, IPValue)
; Хотя бы тут выделить весь текст...
SendMessage_(GadgetID(IP4TTL_Edit), #EM_SETSEL, 0, -1)
DisableGadget(IP4TTL_Edit, #False)
SetGadgetState(IP4TTL_Checkbox, #True)
Else
DisableGadget(IP4TTL_Edit, #True)
SetGadgetState(IP4TTL_Checkbox, #False)
EndIf
IPValue = GetCurrentIP6TTL()
If IPValue
SetGadgetText(IP6TTL_Edit, IPValue)
; Хотя бы тут выделить весь текст...
SendMessage_(GadgetID(IP6TTL_Edit), #EM_SETSEL, 0, -1)
DisableGadget(IP6TTL_Edit, #False)
SetGadgetState(IP6TTL_Checkbox, #True)
Else
DisableGadget(IP6TTL_Edit, #True)
SetGadgetState(IP6TTL_Checkbox, #False)
EndIf
SetGadgetState(ttlPresets_Combo, -1)
For i.i = 0 To ArraySize(TTLPresets())-1
If GetGadgetText(IP4TTL_Edit) = TTLPresets(i)\IP4 And GetGadgetText(IP6TTL_Edit) = TTLPresets(i)\IP6
SetGadgetState(ttlPresets_Combo, i)
EndIf
Next
SetActiveGadget(ttlPresets_Combo)
EndSelect
Until Event = #PB_Event_CloseWindow
End