; #FUNCTION# ====================================================================================================================
; Name ..........: BattleMachineUpgrade
; Description ...:
; Syntax ........: BattleMachineUpgrade()
; Parameters ....:
; Return values .: None
; Author ........: Boludoz (redo), ProMac (03-2018), Fahid.Mahmood
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as Multibot and ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_sMachineTime = '1000/01/01 00:00:00'

Func TestBattleMachineUpgrade()
	Local $bWasRunState = $g_bRunState
	Local $sWasMachineTime = $g_sMachineTime
	Local $bWasChkUpgradeMachine = $g_bChkUpgradeMachine
	$g_bRunState = True
	$g_bChkUpgradeMachine = True
	$g_sMachineTime = '1000/01/01 00:00:00'
	Local $Result = BattleMachineUpgrade()
	$g_bRunState = $bWasRunState
	$g_sMachineTime = $sWasMachineTime
	$g_bChkUpgradeMachine = $bWasChkUpgradeMachine
	Return $Result
EndFunc

Func BattleMachineUpgrade($bTestRun = False)

	; If is to run
	If Not $g_bChkUpgradeMachine Then Return

	;Just to debug
	FuncEnter(BattleMachineUpgrade)

	ClickAway() ; ClickP($aAway, 1, 0, "#0900") ;Click Away

	; [0] = Remain Upgrade time for next level  [1] = Machine next Level , [2] = Machine Next level cost
	Local $aMachineStatus[3] = [0,0,0]

	Local $bDoNotProceedWithMachine = False

	Local $iDateS = Number(_DateDiff('s', $g_sMachineTime, _NowCalc()))
	Local $iDateH = Number(_DateDiff('h', $g_sMachineTime, _NowCalc()))

	If _Sleep(500) Then Return
	
	If Not (($iDateS <= 0) Or ($iDateH > 72) Or $bTestRun) Then ; > 72 prevent infinite
		ClickAway() ; ClickP($aAway, 2, 100, "#0900") ;Click Away
		Setlog("Battle machine skipped : upgrade in progress.", $COLOR_INFO)
		Return
	EndIf
	
	; Remain Times and if we are waiting or Not
	$g_sMachineTime = '1000/01/01 00:00:00'

	BuilderBaseUpgradeMachine($bTestRun)
	If _Sleep(1000) Then Return

	FuncReturn()
EndFunc   ;==>BattleMachineUpgrade

; Machine
Func BuilderBaseUpgradeMachine($bTestRun = False)
		Local $iXMoved = 0, $iYMoved = 0, $sSelectedUpgrade = "Battle Machine"
		ZoomOut()
		If IsMainPageBuilderBase() Then

			; Machine Detection
			Local $aMachinePosition = _ImageSearchXML($g_sXMLTroopsUpgradeMachine, 0, "FV", True, $bTestRun)
			
			If UBound($aMachinePosition) > 0 And not @error Then 
				Local $aResult, $sEvaluateUpgrade
				For $i = 0 To UBound($aMachinePosition) -1
					Click($aMachinePosition[$i][1], $aMachinePosition[$i][2], 1, 0, "#9010")
					$aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY)
					$sEvaluateUpgrade = String($aResult[1])
					If StringIsSpace($sEvaluateUpgrade) = 0 Then ExitLoop
					If RandomSleep(1000) Then Return
					ClickAway()
				Next
				
				If StringIsSpace($sEvaluateUpgrade) = 0 Then
				
					SetDebugLog("Machine Found: " & _ArrayToString($aMachinePosition))
				
					Setlog("Machine level : " &  $aResult[2], $COLOR_INFO)
					
					If GetUpgradeButton("Elixir", $bTestRun) Then
					
						Local $iMachineLevel = ($aResult[2] = "Broken") ? ("Broken") : (Number($aResult[2]))
						If $bTestRun = True Then 
							Setlog("Machine Level: " & $iMachineLevel)
						EndIf
						
						If RandomSleep(1500) Then Return
						
						Local $iMachineFinishTime
						Switch $iMachineLevel
							Case "Broken"
								$iMachineFinishTime = Int(12 * 60)
							Case Else
								$iMachineFinishTime = $g_aBBUpgradeResourceCostDuration[2]
						EndSwitch
			
						If BattleMachineUpgradeUpgrade($iMachineFinishTime, $bTestRun) = True Then 
							Local $sStartTime = _NowCalc() ; what is date:time now
							Local $sResult = ($iMachineFinishTime / 60)
							
							SetLog($sSelectedUpgrade & " Upgrade Finishes @ " & $sResult & " (" & $sSelectedUpgrade & ")", $COLOR_SUCCESS)
						
							SetLog("Upgrade " & $sSelectedUpgrade & " started with success...", $COLOR_SUCCESS)
							; PushMsg("BattleMachineUpgradeSuccess")
							$g_sMachineTime = _DateAdd('n', Ceiling($iMachineFinishTime), $sStartTime)
							If _Sleep($DELAYLABUPGRADE2) Then Return
								
							Return True
						Else
							SetLog("Machine upgrade not possible.", $COLOR_INFO)
							SaveDebugImage("UpgradeMachine")
						EndIf
					Else
						Setlog("Upgrade machine: Not resources or skipped.", $COLOR_INFO)
						; SaveDebugImage("UpgradeMachine")
					EndIf
				Else
					Setlog("Error geting the Machine Info", $COLOR_ERROR)
					SaveDebugImage("UpgradeMachine")
				EndIf
			Else
				Setlog("Machine upgrade bad (Not aMachinePosition)", $COLOR_ERROR)
				SaveDebugImage("UpgradeMachine")
			EndIf
		Else
			SetLog("Machine upgrade bad (Not IsMainPageBuilderBase).", $COLOR_INFO)
			SaveDebugImage("UpgradeMachine")
		EndIf
		
		ClickAway()
		If _Sleep(500) Then Return
		
		CheckMainScreen(Default, isOnBuilderBase(True))
		Return False

EndFunc   ;==>BuilderBaseUpgradeMachine

Func BattleMachineUpgradeUpgrade(ByRef $iMachineFinishTime, $bTestRun = False)
	; get upgrade time from window part 
	$iMachineFinishTime = ConvertOCRTime("Machine Time", getLabUpgradeTime(581, 495 + $g_iBottomOffsetYFixed), False)
	If ($iMachineFinishTime > 0) Then
		Return True
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf
	Return False
EndFunc   ;==>BattleMachineUpgrade
