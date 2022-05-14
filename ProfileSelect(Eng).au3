#RequireAdmin
#NoTrayIcon
#include <Constants.au3>
#include <GUIConstantsEx.au3>
Opt("WinWaitDelay", 4)
; Created by TheDoctor (05.03.2022)
_MenuSelector()
Func _MenuSelector()
	Local $idBalance, $idMining, $idGaming, $idTweaks, $idExit, $iMsg
	GUICreate("Profile Selector v1.5 Eng", 300, 80)
	GUICtrlCreateLabel("'Profile Selector' created by TheDoctor. Run as admin first!", 10, 8)
	GUICtrlCreateLabel("Please select the desired profile to use: ", 10, 28)
	$idBalance = GUICtrlCreateButton("Balance", 8, 50, 50, 20)
	$idMining = GUICtrlCreateButton("Mining", 62, 50, 50, 20)
	$idGaming = GUICtrlCreateButton("Gaming", 116, 50, 50, 20)
	$idTweaks = GUICtrlCreateButton("Tweaks", 188, 50, 50, 20)
	$idExit = GUICtrlCreateButton("Exit", 242, 50, 50, 20)
	GUISetState()
	Do
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $idBalance
				RunWait(@ScriptDir & '\dispwin.exe -Sl -d1 -c -I Profiles\Monitor.icm')
				_OptimizedProcesses()
				Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\OptimalPerformance.nip')
				_ClickOK()
				_BalancePwr()
				_BalancePwr()
				Run(@ScriptDir & '\MSIAfterburner\MSIAfterburner.exe -profile1')
				MsgBox($MB_SYSTEMMODAL, "Done!", "Balance profile activated!")
				Exit
			Case $iMsg = $idMining
				RunWait(@ScriptDir & '\dispwin.exe -Sl -d1 -c -I Profiles\Monitor.icm')
				_OptimizedProcesses()
				Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\MiningProfile.nip')
				_ClickOK()
				_MiningPwr()
				_MiningPwr()
				Run(@ScriptDir & '\MSIAfterburner\MSIAfterburner.exe -profile2')
				MsgBox($MB_SYSTEMMODAL, "Done!", "Mining profile activated!")
				Exit
			Case $iMsg = $idGaming
				RunWait(@ScriptDir & '\dispwin.exe -Sl -d1 -c -I Profiles\Monitor.icm')
				_OptimizedProcesses()
				Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\MaxQuality.nip')
				_ClickOK()
				_QualityPwr()
				_QualityPwr()
				Run(@ScriptDir & '\MSIAfterburner\MSIAfterburner.exe -profile3')
				MsgBox($MB_SYSTEMMODAL, "Done!", "Gaming profile activated!")
				Exit
			Case $iMsg = $idTweaks
				MsgBox($MB_SYSTEMMODAL, "Info", "Please wait, tweaks will be applied in hidden mode.")
				ShellExecuteWait(@ScriptDir & "\Tweaks.cmd","","","", @SW_HIDE)
				RunWait(@ScriptDir & "\SetTimerResolutionService.exe -install", "", @SW_HIDE)
				MsgBox($MB_SYSTEMMODAL, "Info", "Install a patch to remove Nvidia driver restrictions on refresh rate and screen resolution.")
				RunWait(@ScriptDir & "\nvlddmkm-patcher.exe", "", @SW_MAXIMIZE)
				MsgBox($MB_SYSTEMMODAL, "Info", "Set up an Nvidia clip to convert colors before sending them to a wide gamut monitor.")
				RunWait(@ScriptDir & "\novideo_srgb.exe", "", @SW_MAXIMIZE)
				MsgBox($MB_SYSTEMMODAL, "Info", "Select devices with support MSI mode and set priority.")
				RunWait(@ScriptDir & "\MSI_util_v3.exe", "", @SW_MAXIMIZE)
				MsgBox($MB_SYSTEMMODAL, "Info", "Select devices to set a specific CPU cores.")
				RunWait(@ScriptDir & "\intPolicy_x64.exe", "", @SW_SHOW)
				MsgBox($MB_SYSTEMMODAL, "Info", "Configure to bypass CPU throttling.")
				RunWait(@ScriptDir & "\ThrottleStop.exe", "", @SW_SHOW)
				MsgBox($MB_SYSTEMMODAL, "Done!", "Tweaks has been applied! Please reboot the computer.")
				Exit
		EndSelect
	Until $iMsg = $GUI_EVENT_CLOSE Or $iMsg = $idExit
EndFunc
Func _OptimizedProcesses()
	ProcessClose("MSIAfterburner.exe")
	Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\DesktopWindowsManager.nip') ; dwm.exe
	_ClickOK()
	Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\WindowsExplorer.nip') ; explorer.exe
	_ClickOK()
	Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\DisplayContainer.nip') ; NVDisplay.Container.exe
	_ClickOK()
	Run(@ScriptDir & '\nvidiaProfileInspector.exe Profiles\ShellExperienceHost.nip') ; ShellExperienceHost.exe
	_ClickOK()
EndFunc
Func _ClickOK()
	Sleep(500)
	WinWaitActive("[CLASS:#32770]", "")
	If WinActivate("[CLASS:#32770]", "") Then
		ControlClick("[CLASS:#32770]", "", "[CLASS:Button; INSTANCE:1]")
	EndIf
EndFunc
Func _BalancePwr()
	RunWait(@ComSpec & ' /c powercfg -import "' & @ScriptDir & '\Profiles\BalancedPower.pow" 381b4222-f694-41f0-9685-ff5bb260df2e', '', @SW_HIDE) ; Balanced Performance
	RunWait(@ComSpec & ' /c powercfg -changename 381b4222-f694-41f0-9685-ff5bb260df2e "Сбалансированная" "Автоматическое соблюдение баланса между производительностью и энергопотреблением"', "", @SW_HIDE)
	RunWait(@ComSpec & " /c powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e", "", @SW_HIDE)
EndFunc
Func _MiningPwr()
	RunWait(@ComSpec & ' /c powercfg -import "' & @ScriptDir & '\Profiles\HighPower.pow" 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c', '', @SW_HIDE) ; High Performance
	RunWait(@ComSpec & ' /c powercfg -changename 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c "Высокая производительность" "Высокая производительность (может потребоваться больше энергии)"', "", @SW_HIDE)
	RunWait(@ComSpec & " /c powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c", "", @SW_HIDE)
EndFunc
Func _QualityPwr()
	RunWait(@ComSpec & ' /c powercfg -import "' & @ScriptDir & '\Profiles\UltraPower.pow" eb3d06d8-1b61-4a20-8b4f-d53cd0091cd3', '', @SW_HIDE) ; Ultra Performance
	RunWait(@ComSpec & ' /c powercfg -changename eb3d06d8-1b61-4a20-8b4f-d53cd0091cd3 "Ультра производительность" "Оптимизация компьютера для наивысшей возможной производительности (большой расход энергии)"', "", @SW_HIDE)
	RunWait(@ComSpec & " /c powercfg -setactive eb3d06d8-1b61-4a20-8b4f-d53cd0091cd3", "", @SW_HIDE)
EndFunc