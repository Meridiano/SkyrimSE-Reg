#pragma compile(Console, True)
#NoTrayIcon

If (Not @Compiled) Then
	MsgBox(0, "Error", "This script must be compiled to run correctly.")
	Exit
EndIf

#include <File.au3>
#include <JSON.au3>

Global $ConfigPath = @ScriptDir & "\" & StringTrimRight(@ScriptName, 3) & "ini"

ShowInfo("[ Steam Path ]", ProcessSteam())
ShowInfo("[ GOG Path ]", ProcessGOG())
ShowInfo("[ EGS Path ]", ProcessEGS())
WaitForEnter("Press ENTER to exit...")
Exit

Func ShowInfo($Title, ByRef $Data)
	Local $InfoK = StringFormat('Key   = "%s"', $Data[0]) & @CRLF
	Local $InfoV = StringFormat('Value = "%s"', $Data[1]) & @CRLF
	Local $InfoT = StringFormat('Type  = "%s"', $Data[2]) & @CRLF
	Local $InfoD = StringFormat('Data  = "%s"', $Data[3]) & @CRLF
	ConsoleWrite($Title & @CRLF & $InfoK & $InfoV & $InfoT & $InfoD & @CRLF)
EndFunc

Func ProcessSteam()
	Local $KeyName = IniRead($ConfigPath, "Steam", "sKeyName", "")
	Local $ValueName = IniRead($ConfigPath, "Steam", "sValueName", "")
	Local $Result[4] = [$KeyName, $ValueName, "", ""]
	Local $SkyrimPath = RegRead($KeyName, $ValueName)
	If (@error == 0) Then
		$Result[2] = "REG_SZ"
		$Result[3] = $SkyrimPath
	EndIf
	Return $Result
EndFunc

Func ProcessGOG()
	Local $KeyName = IniRead($ConfigPath, "GOG", "sKeyName", "")
	Local $ValueName = IniRead($ConfigPath, "GOG", "sValueName", "")
	Local $Result[4] = [$KeyName, $ValueName, "", ""]
	Local $SkyrimPath = RegRead($KeyName, $ValueName)
	If (@error == 0) Then
		$Result[2] = "REG_SZ"
		$Result[3] = $SkyrimPath
	EndIf
	Return $Result
EndFunc

Func ProcessEGS()
	Local $KeyName = IniRead($ConfigPath, "EGS", "sKeyName", "")
	Local $ValueName = IniRead($ConfigPath, "EGS", "sValueName", "")
	Local $Result[4] = [$KeyName, $ValueName, "", ""]
	Local $AppDataPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Epic Games\EpicGamesLauncher", "AppDataPath")
	If (@error == 0) Then
		Local $FilesToProcess = _FileListToArray($AppDataPath & "Manifests", "*.item", $FLTA_FILES, True)
		If (@error == 0) Then
			For $Index = 1 To $FilesToProcess[0] Step 1
				Local $Object = Json_Decode(FileRead($FilesToProcess[$Index]))
				If (StringUpper(Json_Get($Object, ".AppName")) == $KeyName) Then
					$Result[2] = "JSON_STRING"
					$Result[3] = Json_Get($Object, "." & $ValueName)
					ExitLoop
				EndIf
			Next
		EndIf
	EndIf
	Return $Result
EndFunc

Func WaitForEnter($Text)
	ConsoleWrite($Text)
	While True
		Sleep(333)
		Local $ConsoleInput = ConsoleRead(False, False)
		If (@extended) Then ExitLoop
	WEnd
EndFunc
