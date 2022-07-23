; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: applyConfig()
; Parameters ....: $bRedrawAtExit = True, redraws bot window after config was applied
; Return values .: NA
; Author ........: Team AiO MOD++ (2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;<><><> Team AiO MOD++ (2019) <><><>
Func ApplyConfig_MOD_CustomArmyBB($TypeReadSave)
	; <><><> CustomArmyBB <><><>
	Switch $TypeReadSave
		Case "Read"
			; BB Upgrade Walls - Team AiO MOD++
			GUICtrlSetState($g_hChkBBUpgradeWalls, $g_bChkBBUpgradeWalls ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBWallLevel, $g_iCmbBBWallLevel)
			GUICtrlSetData($g_hBBWallNumber, $g_iBBWallNumber)
			GUICtrlSetState($g_hChkBBWallRing, $g_bChkBBWallRing = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBUpgWallsGold, $g_bChkBBUpgWallsGold = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBUpgWallsElixir, $g_bChkBBUpgWallsElixir = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			ChkBBWalls()
			cmbBBWall()

			For $i = 0 To UBound($g_hComboTroopBB) - 1
				_GUICtrlComboBox_SetCurSel($g_hComboTroopBB[$i], $g_iCmbCampsBB[$i])
				_GUICtrlSetImage($g_hIcnTroopBB[$i], $g_sLibIconPath, $g_avStarLabTroops[$g_iCmbCampsBB[$i] + 1][4])
			Next

			GUICtrlSetState($g_hChkPlacingNewBuildings, $g_iChkPlacingNewBuildings = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkActivateBBSuggestedUpgrades()
			chkActivateBBSuggestedUpgradesGold()
			chkActivateBBSuggestedUpgradesElixir()
			chkPlacingNewBuildings()
			GUICtrlSetState($g_hChkBuilderAttack, $g_bChkBuilderAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBStopAt3, $g_bChkBBStopAt3 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBTrophiesRange, $g_bChkBBTrophiesRange ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBCustomAttack, $g_bChkBBCustomAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkBuilderAttack()
			PopulateComboScriptsFilesBB()
			For $i = 0 To 2
				Local $tempindex = _GUICtrlComboBox_FindStringExact($g_hCmbBBAttackStyle[$i], $g_sAttackScrScriptNameBB[$i])
				If $tempindex = -1 Then
					$tempindex = 0
					SetLog("Previous saved BB Scripted Attack not found (deleted, renamed?)", $COLOR_ERROR)
					SetLog("Automatically setted a default script, please check your config", $COLOR_ERROR)
				EndIf
				_GUICtrlComboBox_SetCurSel($g_hCmbBBAttackStyle[$i], $tempindex)
			Next
			cmbScriptNameBB()
			GUICtrlSetData($g_hTxtBBDropTrophiesMin, $g_iTxtBBDropTrophiesMin)
			GUICtrlSetData($g_hTxtBBDropTrophiesMax, $g_iTxtBBDropTrophiesMax)
			chkBBtrophiesRange()
			; -- AIO BB
			GUICtrlSetState($g_hChkBBGetFromCSV, $g_bChkBBGetFromCSV ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBGetFromArmy, $g_bChkBBGetFromArmy ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBAttack, $g_iCmbBBAttack) ; switching between smart and csv attack
			GUICtrlSetData($g_hTxtBBMinAttack, $g_iBBMinAttack)
			GUICtrlSetData($g_hTxtBBMaxAttack, $g_iBBMaxAttack)
			GUICtrlSetState($g_hChkDSICGBB, $g_bDSICGBB ? $GUI_CHECKED : $GUI_UNCHECKED)
			cmbBBAttack()
			ChkBBGetFromArmy()
			ChkBBGetFromCSV()
			ChkBBCustomAttack()
			ChkBBAttackLoops()
			GUICtrlSetState($g_hChkUpgradeMachine, $g_bChkUpgradeMachine ? $GUI_CHECKED : $GUI_UNCHECKED)

		Case "Save"
			; BB Upgrade Walls - Team AiO MOD++
			$g_bChkBBUpgradeWalls = (GUICtrlRead($g_hChkBBUpgradeWalls) = $GUI_CHECKED)
			$g_iCmbBBWallLevel = _GUICtrlComboBox_GetCurSel($g_hCmbBBWallLevel)
			$g_iBBWallNumber = Int(GUICtrlRead($g_hBBWallNumber))
			$g_bChkBBWallRing = (GUICtrlRead($g_hChkBBWallRing) = $GUI_CHECKED)
			$g_bChkBBUpgWallsGold = (GUICtrlRead($g_hChkBBUpgWallsGold) = $GUI_CHECKED)
			$g_bChkBBUpgWallsElixir = (GUICtrlRead($g_hChkBBUpgWallsElixir) = $GUI_CHECKED)

			For $i = 0 To UBound($g_hComboTroopBB) - 1
				$g_iCmbCampsBB[$i] = _GUICtrlComboBox_GetCurSel($g_hComboTroopBB[$i])
			Next

			$g_iChkPlacingNewBuildings = (GUICtrlRead($g_hChkPlacingNewBuildings) = $GUI_CHECKED) ? 1 : 0
			$g_bChkBuilderAttack = (GUICtrlRead($g_hChkBuilderAttack) = $GUI_CHECKED) ? 1 : 0
			$g_bChkBBStopAt3 = (GUICtrlRead($g_hChkBBStopAt3) = $GUI_CHECKED) ? 1 : 0
			$g_bChkBBTrophiesRange = (GUICtrlRead($g_hChkBBTrophiesRange) = $GUI_CHECKED) ? 1 : 0
			$g_bChkBBCustomAttack = (GUICtrlRead($g_hChkBBCustomAttack) = $GUI_CHECKED) ? 1 : 0
			For $i = 0 To 2
				Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackStyle[$i])
				Local $scriptname
				_GUICtrlComboBox_GetLBText($g_hCmbBBAttackStyle[$i], $indexofscript, $scriptname)
				$g_sAttackScrScriptNameBB[$i] = $scriptname
				IniWriteS($g_sProfileConfigPath, "BuilderBase", "ScriptBB" & $i, $g_sAttackScrScriptNameBB[$i])
			Next
			$g_iTxtBBDropTrophiesMin = Int(GUICtrlRead($g_hTxtBBDropTrophiesMin))
			$g_iTxtBBDropTrophiesMax = Int(GUICtrlRead($g_hTxtBBDropTrophiesMax))
			; -- AIO BB
			$g_bChkBBGetFromArmy = (GUICtrlRead($g_hChkBBGetFromArmy) = $GUI_CHECKED)
			$g_bChkBBGetFromCSV = (GUICtrlRead($g_hChkBBGetFromCSV) = $GUI_CHECKED)
			$g_iCmbBBAttack = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttack)
			$g_iBBMinAttack = Int(GUICtrlRead($g_hTxtBBMinAttack))
			$g_iBBMaxAttack = Int(GUICtrlRead($g_hTxtBBMaxAttack))
			$g_bChkUpgradeMachine = (GUICtrlRead($g_hChkUpgradeMachine) = $GUI_CHECKED)
			$g_bDSICGBB = (GUICtrlRead($g_hChkDSICGBB) = $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_CustomArmyBB

Func ApplyConfig_MOD_MiscTab($TypeReadSave)
	; <><><> MiscTab <><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkSkipFirstAttack, ($g_bChkSkipFirstAttack = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_hEdgeObstacle, ($g_bEdgeObstacle = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))

			For $i = $DB To $LB
				GUICtrlSetState($g_hDeployCastleFirst[$i], ($g_bDeployCastleFirst[$i] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			Next

			; Setlog limit
			GUICtrlSetState($g_hChkBotLogLineLimit, ($g_bChkBotLogLineLimit = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetData($g_hTxtLogLineLimit, Abs($g_iTxtLogLineLimit))

			; Skip first check
			GUICtrlSetState($g_hChkBuildingsLocate, ($g_bChkAvoidBuildingsLocate = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))

			; DeployDelay
			GUICtrlSetData($g_hDeployDelay[0], $g_iDeployDelay[0])
			GUICtrlSetData($g_hDeployDelay[1], $g_iDeployDelay[1])
			GUICtrlSetData($g_hDeployDelay[2], $g_iDeployDelay[2])

			; DeployWave
			GUICtrlSetData($g_hDeployWave[0], $g_iDeployWave[0])
			GUICtrlSetData($g_hDeployWave[1], $g_iDeployWave[1])
			GUICtrlSetData($g_hDeployWave[2], $g_iDeployWave[2])

			; ChkEnableRandom
			GUICtrlSetState($g_hChkEnableRandom[0], ($g_bChkEnableRandom[0] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_hChkEnableRandom[1], ($g_bChkEnableRandom[1] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_hChkEnableRandom[2], ($g_bChkEnableRandom[2] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))

			; Max sides
			GUICtrlSetState($g_hMaxSidesSF, ($g_bMaxSidesSF = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetData($g_hCmbMaxSidesSF, $g_iCmbMaxSidesSF)

			; Custom SmartFarm
			GUICtrlSetState($g_hChkSmartFarmAndRandomDeploy, ($g_bUseSmartFarmAndRandomDeploy = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))

			; War Preparation
			GUICtrlSetState($g_hChkStopForWar, ($g_bStopForWar = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			_GUICtrlComboBox_SetCurSel($g_hCmbStopTime, Abs($g_iStopTime))
			_GUICtrlComboBox_SetCurSel($g_hCmbStopBeforeBattle, $g_iStopTime < 0 ? 0 : 1)
			_GUICtrlComboBox_SetCurSel($g_hCmbReturnTime, $g_iReturnTime)

			GUICtrlSetState($g_hChkTrainWarTroop, ($g_bTrainWarTroop = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_hChkUseQuickTrainWar, ($g_bUseQuickTrainWar = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_ahChkArmyWar[0], ($g_aChkArmyWar[0] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_ahChkArmyWar[1], ($g_aChkArmyWar[1] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_ahChkArmyWar[2], ($g_aChkArmyWar[2] = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))

			For $i = 0 To $eTroopCount - 1
				GUICtrlSetData($g_ahTxtTrainWarTroopCount[$i], $g_aiWarCompTroops[$i])
			Next

			For $j = 0 To $eSpellCount - 1
				GUICtrlSetData($g_ahTxtTrainWarSpellCount[$j], $g_aiWarCompSpells[$j])
			Next
			GUICtrlSetState($g_hChkRequestCCForWar, ($g_bRequestCCForWar = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetData($g_hTxtRequestCCForWar, $g_sTxtRequestCCForWar)

			#Region - Return Home by Time - Team AIO Mod++
			GUICtrlSetState($g_hChkResetByCloudTimeEnable, ($g_bResetByCloudTimeEnable = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetData($g_hTxtReturnTimer, $g_iTxtReturnTimer)
			chkReturnTimer()
			#EndRegion - Return Home by Time - Team AIO Mod++

			#Region - No Upgrade In War - Team AIO Mod++
			GUICtrlSetState($g_hChkNoUpgradeInWar, ($g_bNoUpgradeInWar = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			#EndRegion - No Upgrade In War - Team AIO Mod++

			#Region - Legend trophy protection - Team AIO Mod++
			GUICtrlSetState($g_hChkProtectInLL, ($g_bProtectInLL = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			GUICtrlSetState($g_hChkForceProtectLL, ($g_bForceProtectLL = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED))
			ChkProtectInLL()
			#EndRegion - Legend trophy protection - Team AIO Mod++

			#Region - Buy Guard - Team AIO Mod++
			GUICtrlSetState($g_hChkBuyGuard, $g_bChkBuyGuard ? $GUI_CHECKED : $GUI_UNCHECKED)
			#EndRegion - Buy Guard - Team AIO Mod++

			#Region - Colorful attack log - Team AIO Mod++
			GUICtrlSetState($g_hChkColorfulAttackLog, $g_bChkColorfulAttackLog ? $GUI_CHECKED : $GUI_UNCHECKED)
			#EndRegion - Colorful attack log - Team AIO Mod++

			#Region - Firewall - Team AIO Mod++
			GUICtrlSetState($g_hChkEnableFirewall, $g_bChkEnableFirewall ? $GUI_CHECKED : $GUI_UNCHECKED)
			#EndRegion - Firewall - Team AIO Mod++

			chkMaxSidesSF()
			ReadConfig_600_52_2()
			ChkStopForWar()
			chkMiscModOptions()
			chkEdgeObstacle()
		Case "Save"
			$g_bChkSkipFirstAttack = (GUICtrlRead($g_hChkSkipFirstAttack) = $GUI_CHECKED)

			For $i = $DB To $LB
				$g_bDeployCastleFirst[$i] = (GUICtrlRead($g_hDeployCastleFirst[$i]) = $GUI_CHECKED)
			Next

			; Setlog limit
			$g_bChkBotLogLineLimit = (GUICtrlRead($g_hChkBotLogLineLimit) = $GUI_CHECKED)
			$g_iTxtLogLineLimit = Int(GUICtrlRead($g_hTxtLogLineLimit))

			; Skip first check
			$g_bChkAvoidBuildingsLocate = (GUICtrlRead($g_hChkBuildingsLocate) = $GUI_CHECKED)

			; Remove edge obstacles
			$g_bEdgeObstacle = GUICtrlRead($g_hEdgeObstacle) = $GUI_CHECKED

			; DeployDelay
			$g_iDeployDelay[0] = Int(GUICtrlRead($g_hDeployDelay[0]))
			$g_iDeployDelay[1] = Int(GUICtrlRead($g_hDeployDelay[1]))
			$g_iDeployDelay[2] = Int(GUICtrlRead($g_hDeployDelay[2]))

			; DeployWave
			$g_iDeployWave[0] = Int(GUICtrlRead($g_hDeployWave[0]))
			$g_iDeployWave[1] = Int(GUICtrlRead($g_hDeployWave[1]))
			$g_iDeployWave[2] = Int(GUICtrlRead($g_hDeployWave[2]))

			; ChkEnableRandom
			$g_bChkEnableRandom[0] = (GUICtrlRead($g_hChkEnableRandom[0]) = $GUI_CHECKED)
			$g_bChkEnableRandom[1] = (GUICtrlRead($g_hChkEnableRandom[1]) = $GUI_CHECKED)
			$g_bChkEnableRandom[2] = (GUICtrlRead($g_hChkEnableRandom[2]) = $GUI_CHECKED)

			; Max sides
			$g_bMaxSidesSF = (GUICtrlRead($g_hMaxSidesSF) = $GUI_CHECKED) ? 1 : 0
			$g_iCmbMaxSidesSF = Int(GUICtrlRead($g_hCmbMaxSidesSF))

			; Custom SmartFarm
			$g_bUseSmartFarmAndRandomDeploy = (GUICtrlRead($g_hChkSmartFarmAndRandomDeploy) = $GUI_CHECKED)

			; War Preparation
			$g_bStopForWar = GUICtrlRead($g_hChkStopForWar) = $GUI_CHECKED

			$g_iStopTime = _GUICtrlComboBox_GetCurSel($g_hCmbStopTime)
			If _GUICtrlComboBox_GetCurSel($g_hCmbStopBeforeBattle) = 0 Then $g_iStopTime = $g_iStopTime * -1
			$g_iReturnTime = _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime)

			$g_bTrainWarTroop = GUICtrlRead($g_hChkTrainWarTroop) = $GUI_CHECKED
			$g_bUseQuickTrainWar = GUICtrlRead($g_hChkUseQuickTrainWar) = $GUI_CHECKED
			$g_aChkArmyWar[0] = GUICtrlRead($g_ahChkArmyWar[0]) = $GUI_CHECKED
			$g_aChkArmyWar[1] = GUICtrlRead($g_ahChkArmyWar[1]) = $GUI_CHECKED
			$g_aChkArmyWar[2] = GUICtrlRead($g_ahChkArmyWar[2]) = $GUI_CHECKED
			For $i = 0 To $eTroopCount - 1
				$g_aiWarCompTroops[$i] = GUICtrlRead($g_ahTxtTrainWarTroopCount[$i])
			Next
			For $j = 0 To $eSpellCount - 1
				$g_aiWarCompSpells[$j] = GUICtrlRead($g_ahTxtTrainWarSpellCount[$j])
			Next

			$g_bRequestCCForWar = GUICtrlRead($g_hChkRequestCCForWar) = $GUI_CHECKED
			$g_sTxtRequestCCForWar = GUICtrlRead($g_hTxtRequestCCForWar)

			#Region - Return Home by Time - Team AIO Mod++
			$g_bResetByCloudTimeEnable = (GUICtrlRead($g_hChkResetByCloudTimeEnable) = $GUI_CHECKED)
			$g_iTxtReturnTimer = GUICtrlRead($g_hTxtReturnTimer)
			#EndRegion - Return Home by Time - Team AIO Mod++

			#Region - Legend trophy protection - Team AIO Mod++
			$g_bProtectInLL = (GUICtrlRead($g_hChkProtectInLL) = $GUI_CHECKED)
			$g_bForceProtectLL = (GUICtrlRead($g_hChkForceProtectLL) = $GUI_CHECKED)
			#EndRegion - Legend trophy protection - Team AIO Mod++

			#Region - No Upgrade In War - Team AIO Mod++
			$g_bNoUpgradeInWar = (GUICtrlRead($g_hChkNoUpgradeInWar) = $GUI_CHECKED)
			#EndRegion - No Upgrade In War - Team AIO Mod++

			#Region - Buy Guard - Team AIO Mod++
			$g_bChkBuyGuard = (GUICtrlRead($g_hChkBuyGuard) = $GUI_CHECKED)
			#EndRegion - Buy Guard - Team AIO Mod++

			#Region - Colorful attack log - Team AIO Mod++
			$g_bChkColorfulAttackLog = (GUICtrlRead($g_hChkColorfulAttackLog) = $GUI_CHECKED)
			#EndRegion - Colorful attack log - Team AIO Mod++

			#Region - Firewall - Team AIO Mod++
			$g_bChkEnableFirewall = (GUICtrlRead($g_hChkEnableFirewall) = $GUI_CHECKED)
			#EndRegion - Firewall - Team AIO Mod++	EndSwitch
    EndSwitch
EndFunc   ;==>ApplyConfig_MOD_MiscTab

Func ApplyConfig_MOD_SuperXP($TypeReadSave)
	; <><><> SuperXP / GoblinXP <><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkEnableSuperXP, $g_bEnableSuperXP ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkEnableSuperXP()
			GUICtrlSetState($g_hChkSkipZoomOutSX, $g_bSkipZoomOutSX ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkFastSuperXP, $g_bFastSuperXP ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSkipDragToEndSX, $g_bSkipDragToEndSX ? $GUI_CHECKED : $GUI_UNCHECKED)
			radActivateOptionSX()
			radGoblinMapOptSX()
			radLblGoblinMapOpt()

			GUICtrlSetData($g_hTxtMaxXPToGain, $g_iMaxXPtoGain)
			GUICtrlSetState($g_hChkBKingSX, $g_bBKingSX = $eHeroKing ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkAQueenSX, $g_bAQueenSX = $eHeroQueen ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkGWardenSX, $g_bGWardenSX = $eHeroWarden ? $GUI_CHECKED : $GUI_UNCHECKED)
		Case "Save"
			$g_bEnableSuperXP = (GUICtrlRead($g_hChkEnableSuperXP) = $GUI_CHECKED)
			$g_bSkipZoomOutSX = (GUICtrlRead($g_hChkSkipZoomOutSX) = $GUI_CHECKED)
			$g_bFastSuperXP = (GUICtrlRead($g_hChkFastSuperXP) = $GUI_CHECKED)
			$g_bSkipDragToEndSX = (GUICtrlRead($g_hChkSkipDragToEndSX) = $GUI_CHECKED)
			If GUICtrlRead($g_hRdoTrainingSX) = $GUI_CHECKED Then
				$g_iActivateOptionSX = 1
			ElseIf GUICtrlRead($g_hRdoAttackingSX) = $GUI_CHECKED Then
				$g_iActivateOptionSX = 2
			EndIf
			If GUICtrlRead($g_hRdoGoblinPicnic) = $GUI_CHECKED Then
				$g_iGoblinMapOptSX = 1
			ElseIf GUICtrlRead($g_hRdoTheArena) = $GUI_CHECKED Then
				$g_iGoblinMapOptSX = 2
			EndIf

			$g_iMaxXPtoGain = GUICtrlRead($g_hTxtMaxXPToGain)
			$g_bBKingSX = (GUICtrlRead($g_hChkBKingSX) = $GUI_CHECKED) ? $eHeroKing : $eHeroNone
			$g_bAQueenSX = (GUICtrlRead($g_hChkAQueenSX) = $GUI_CHECKED) ? $eHeroQueen : $eHeroNone
			$g_bGWardenSX = (GUICtrlRead($g_hChkGWardenSX) = $GUI_CHECKED) ? $eHeroWarden : $eHeroNone
	EndSwitch

EndFunc   ;==>ApplyConfig_MOD_SuperXP

Func ApplyConfig_MOD_MagicItems($TypeReadSave)
	; <><><> MagicItems <><><>

	Switch $TypeReadSave
		Case "Read"
			; Magic Items - Team AIO Mod++
			GUICtrlSetData($g_hInputGoldItems, $g_iInputGoldItems)
			GUICtrlSetData($g_hInputElixirItems, $g_iInputElixirItems)
			GUICtrlSetData($g_hInputDarkElixirItems, $g_iInputDarkElixirItems)
			
			If $g_iInputBuilderPotion < 0 Then $g_iInputBuilderPotion = 4
			GUICtrlSetState($g_hChkBuilderPotion, $g_bChkBuilderPotion = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbInputBuilderPotion, $g_iInputBuilderPotion)
			ChkBuilderPotion()
			
			GUICtrlSetData($g_hInputLabPotion, $g_iInputLabPotion)

			_GUICtrlComboBox_SetCurSel($g_hComboHeroPotion, $g_iComboHeroPotion)
			_GUICtrlComboBox_SetCurSel($g_hComboPowerPotion, $g_iComboPowerPotion)

			GUICtrlSetState($g_hChkCollectMagicItems, $g_bChkCollectMagicItems = True ? $GUI_CHECKED : $GUI_UNCHECKED)

			GUICtrlSetState($g_hChkHeroPotion, $g_bChkHeroPotion = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkLabPotion, $g_bChkLabPotion = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkPowerPotion, $g_bChkPowerPotion = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkResourcePotion, $g_bChkResourcePotion = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			
			; ChkResourcePotion()
			
			; New building MV - Team AIO Mod++
			GUICtrlSetState($g_hChkAutoBuildNew, $g_bNewUpdateMainVillage = True ? $GUI_CHECKED : $GUI_UNCHECKED)
		Case "Save"
			; Magic Items - Team AIO Mod++
			$g_iInputGoldItems = GUICtrlRead($g_hInputGoldItems)
			$g_iInputElixirItems = GUICtrlRead($g_hInputElixirItems)
			$g_iInputDarkElixirItems = GUICtrlRead($g_hInputDarkElixirItems)

			$g_iInputBuilderPotion = _GUICtrlComboBox_GetCurSel($g_hCmbInputBuilderPotion)
			$g_iInputLabPotion = GUICtrlRead($g_hInputLabPotion)

			$g_iComboPowerPotion = _GUICtrlComboBox_GetCurSel($g_hComboPowerPotion)
			$g_iComboHeroPotion = _GUICtrlComboBox_GetCurSel($g_hComboHeroPotion)

			$g_bChkCollectMagicItems = (GUICtrlRead($g_hChkCollectMagicItems) = $GUI_CHECKED)

			$g_bChkBuilderPotion = (GUICtrlRead($g_hChkBuilderPotion) = $GUI_CHECKED)
			$g_bChkHeroPotion = (GUICtrlRead($g_hChkHeroPotion) = $GUI_CHECKED)
			$g_bChkLabPotion = (GUICtrlRead($g_hChkLabPotion) = $GUI_CHECKED)
			$g_bChkPowerPotion = (GUICtrlRead($g_hChkPowerPotion) = $GUI_CHECKED)
			$g_bChkResourcePotion = (GUICtrlRead($g_hChkResourcePotion) = $GUI_CHECKED)

			; New building MV - Team AIO Mod++
			$g_bNewUpdateMainVillage = (GUICtrlRead($g_hChkAutoBuildNew) = $GUI_CHECKED)
	EndSwitch

EndFunc   ;==>ApplyConfig_MOD_MagicItems

Func ApplyConfig_MOD_ChatActions($TypeReadSave)
	; <><><> ChatActions <><><>
	Switch $TypeReadSave
		Case "Read"
			If $g_iCmbPriorityCHAT < 0 Then $g_iCmbPriorityCHAT = 0
			_GUICtrlComboBox_SetCurSel($g_hCmbPriorityCHAT, $g_iCmbPriorityCHAT)
			If $g_iCmbPriorityFC < 0 Then $g_iCmbPriorityFC = 0
			_GUICtrlComboBox_SetCurSel($g_hCmbPriorityFC, $g_iCmbPriorityFC)
			
			GUICtrlSetState($g_hChkHarangueCG, $g_bChkHarangueCG = True ? $GUI_CHECKED : $GUI_UNCHECKED)

			; GUICtrlSetState($g_hChkClanChat, $g_bChatClan = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDelayTimeClan, $g_sDelayTimeClan)
			GUICtrlSetState($g_hChkUseResponses, $g_bClanUseResponses = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkUseGeneric, $g_bClanUseGeneric = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			; GUICtrlSetState($g_hChkCleverbot, $g_bCleverbot = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkChatNotify, $g_bUseNotify = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkPbSendNewChats, $g_bPbSendNew = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			cmbChatActionsChat()

			; GUICtrlSetState($g_hChkEnableFriendlyChallenge, $g_bEnableFriendlyChallenge = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDelayTimeFC, $g_sDelayTimeFC)
			GUICtrlSetState($g_hChkOnlyOnRequest, $g_bOnlyOnRequest = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			For $i = 0 To 5
				GUICtrlSetState($g_hChkFriendlyChallengeBase[$i], $g_bFriendlyChallengeBase[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To 23
				GUICtrlSetState($g_ahChkFriendlyChallengeHours[$i], $g_abFriendlyChallengeHours[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			cmbChatActionsFC()
			ChatGuiEditUpdate()
		Case "Save"
			$g_iCmbPriorityCHAT = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityCHAT)
			$g_iCmbPriorityFC = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityFC)

			$g_bChkHarangueCG = (GUICtrlRead($g_hChkHarangueCG) = $GUI_CHECKED)

			$g_sDelayTimeClan = GUICtrlRead($g_hTxtDelayTimeClan)
			$g_bClanUseResponses = (GUICtrlRead($g_hChkUseResponses) = $GUI_CHECKED)
			$g_bClanUseGeneric = (GUICtrlRead($g_hChkUseGeneric) = $GUI_CHECKED)
			; $g_bCleverbot = (GUICtrlRead($g_hChkCleverbot) = $GUI_CHECKED)
			$g_bUseNotify = (GUICtrlRead($g_hChkChatNotify) = $GUI_CHECKED)
			$g_bPbSendNew = (GUICtrlRead($g_hChkPbSendNewChats) = $GUI_CHECKED)

			$g_bChkHarangueCG = (GUICtrlRead($g_hChkHarangueCG) = $GUI_CHECKED)
			$g_sDelayTimeFC = GUICtrlRead($g_hTxtDelayTimeFC)
			$g_bOnlyOnRequest = (GUICtrlRead($g_hChkOnlyOnRequest) = $GUI_CHECKED)
			For $i = 0 To 5
				$g_bFriendlyChallengeBase[$i] = (GUICtrlRead($g_hChkFriendlyChallengeBase[$i]) = $GUI_CHECKED)
			Next
			For $i = 0 To 23
				$g_abFriendlyChallengeHours[$i] = (GUICtrlRead($g_ahChkFriendlyChallengeHours[$i]) = $GUI_CHECKED)
			Next
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_ChatActions

Func ApplyConfig_MOD_600_6($TypeReadSave)
	; <><><> Daily Discounts + Builder Base Attack + Builder Base Drop Order <><><>
	Switch $TypeReadSave
		Case "Read"
			For $i = 0 To $g_iDDCount - 1
				GUICtrlSetState($g_ahChkDD_Deals[$i], $g_abChkDD_Deals[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			;GUICtrlSetBkColor($g_hBtnMagicItemsConfig, $g_bChkCollectMagicItems = True ? $COLOR_GREEN : $COLOR_RED)
			btnDDApply()
		Case "Save"
			For $i = 0 To $g_iDDCount - 1
				$g_abChkDD_Deals[$i] = (GUICtrlRead($g_ahChkDD_Deals[$i]) = $GUI_CHECKED)
			Next

			$g_bChkEnableBBAttack = (GUICtrlRead($g_hChkEnableBBAttack) = $GUI_CHECKED)
			$g_bChkBBTrophyRange = (GUICtrlRead($g_hChkBBTrophyRange) = $GUI_CHECKED)
			$g_iTxtBBTrophyLowerLimit = GUICtrlRead($g_hTxtBBTrophyLowerLimit)
			$g_iTxtBBTrophyUpperLimit = GUICtrlRead($g_hTxtBBTrophyUpperLimit)
			$g_bChkBBAttIfLootAvail = (GUICtrlRead($g_hChkBBAttIfLootAvail) = $GUI_CHECKED)
			; $g_bChkBBWaitForMachine = (GUICtrlRead($g_hChkBBWaitForMachine) = $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_6

Func ApplyConfig_MOD_600_12($TypeReadSave)
	; <><><> GTFO <><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkGTFOClanHop, $g_bChkGTFOClanHop = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkGTFOReturnClan, $g_bChkGTFOReturnClan = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkUseGTFO, $g_bChkUseGTFO = True ? $GUI_CHECKED : $GUI_UNCHECKED)

			If $g_iTxtCyclesGTFO < 1 Then $g_iTxtCyclesGTFO = 100
			GUICtrlSetData($g_hTxtCyclesGTFO, $g_iTxtCyclesGTFO)
			
			If $g_iTxtCyclesGTFO < 1 Then $g_iTxtCyclesGTFO = 100
			GUICtrlSetData($g_hTxtMinSaveGTFO_Elixir, $g_iTxtMinSaveGTFO_Elixir)

			If $g_iTxtCyclesGTFO < 1 Then $g_iTxtCyclesGTFO = 100
			GUICtrlSetData($g_hTxtMinSaveGTFO_DE, $g_iTxtMinSaveGTFO_DE)

			If StringLeft($g_sTxtClanID, 1) <> "#" Then $g_sTxtClanID = "#XXXXXX"
			GUICtrlSetData($g_hTxtClanID, $g_sTxtClanID)
			ApplyGTFO()

			GUICtrlSetState($g_hChkUseKickOut, $g_bChkUseKickOut = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDonatedCap, $g_iTxtDonatedCap)
			GUICtrlSetData($g_hTxtReceivedCap, $g_iTxtReceivedCap)
			GUICtrlSetState($g_hChkKickOutSpammers, $g_bChkKickOutSpammers = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtKickLimit, $g_iTxtKickLimit)
			ApplyKickOut()

		Case "Save"
			$g_bChkGTFOClanHop = (GUICtrlRead($g_hChkGTFOClanHop) = $GUI_CHECKED)
			$g_bChkGTFOReturnClan = (GUICtrlRead($g_hChkGTFOReturnClan) = $GUI_CHECKED)
			$g_iTxtCyclesGTFO = Number(GUICtrlRead($g_hTxtCyclesGTFO))
			$g_sTxtClanID = GUICtrlRead($g_hTxtClanID)

			$g_bChkUseGTFO = (GUICtrlRead($g_hChkUseGTFO) = $GUI_CHECKED)
			$g_bExitAfterCyclesGTFO = (GUICtrlRead($g_hExitAfterCyclesGTFO) = $GUI_CHECKED)
			$g_iTxtMinSaveGTFO_Elixir = Number(GUICtrlRead($g_hTxtMinSaveGTFO_Elixir))
			$g_iTxtMinSaveGTFO_DE = Number(GUICtrlRead($g_hTxtMinSaveGTFO_DE))
			$g_bChkUseKickOut = (GUICtrlRead($g_hChkUseKickOut) = $GUI_CHECKED)
			$g_iTxtDonatedCap = Number(GUICtrlRead($g_hTxtDonatedCap))
			$g_iTxtReceivedCap = Number(GUICtrlRead($g_hTxtReceivedCap))
			$g_bChkKickOutSpammers = (GUICtrlRead($g_hChkKickOutSpammers) = $GUI_CHECKED)
			$g_iTxtKickLimit = Number(GUICtrlRead($g_hTxtKickLimit))
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_12

Func ApplyConfig_MOD_600_28($TypeReadSave)
	; <><><> Max logout time <><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkTrainLogoutMaxTime, $g_bTrainLogoutMaxTime = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtTrainLogoutMaxTime, $g_iTrainLogoutMaxTime)
			chkTrainLogoutMaxTime()

			; Check No League for Dead Base
			GUICtrlSetState($g_hChkDBNoLeague, $g_bChkNoLeague[$DB] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			
			; Stick to Army page when time left
			GUICtrlSetData($g_hTxtStickToTrainWindow, $g_iStickToTrainWindow)
			txtStickToTrainWindow()
		Case "Save"
			$g_bTrainLogoutMaxTime = (GUICtrlRead($g_hChkTrainLogoutMaxTime) = $GUI_CHECKED)
			$g_iTrainLogoutMaxTime = GUICtrlRead($g_hTxtTrainLogoutMaxTime)

			; Check No League for Dead Base
			$g_bChkNoLeague[$DB] = (GUICtrlRead($g_hChkDBNoLeague) = $GUI_CHECKED)
			
			; Stick to Army page when time left
			$g_iStickToTrainWindow = Int(GUICtrlRead($g_hTxtStickToTrainWindow))
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_28

Func ApplyConfig_MOD_600_29($TypeReadSave)
	; <><><> Classic Four Finger + CSV Deploy Speed <><><>
	Switch $TypeReadSave
		Case "Read"
			cmbDBMultiFinger()

			_GUICtrlComboBox_SetCurSel($cmbCSVSpeed[$LB], $icmbCSVSpeed[$LB])
			_GUICtrlComboBox_SetCurSel($cmbCSVSpeed[$DB], $icmbCSVSpeed[$DB])
		Case "Save"
			$icmbCSVSpeed[$LB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$LB])
			$icmbCSVSpeed[$DB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$DB])
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_29

Func ApplyConfig_MOD_600_31($TypeReadSave)
	; <><><> Check Collectors Outside <><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkDBMeetCollectorOutside, $g_bDBMeetCollectorOutside = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDBCollectorNone, $g_bDBCollectorNone = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDBMinCollectorOutsidePercent, $g_iDBMinCollectorOutsidePercent)

			GUICtrlSetState($g_hChkDBCollectorNearRedline, $g_bDBCollectorNearRedline = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbRedlineTiles, $g_iCmbRedlineTiles)

			GUICtrlSetState($g_hChkSkipCollectorCheck, $g_bSkipCollectorCheck = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtSkipCollectorGold, $g_iTxtSkipCollectorGold)
			GUICtrlSetData($g_hTxtSkipCollectorElixir, $g_iTxtSkipCollectorElixir)
			GUICtrlSetData($g_hTxtSkipCollectorDark, $g_iTxtSkipCollectorDark)

			GUICtrlSetState($g_hChkSkipCollectorCheckTH, $g_bSkipCollectorCheckTH = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbSkipCollectorCheckTH, $g_iCmbSkipCollectorCheckTH)
			aplCollectorsAndRedLines()
		Case "Save"
			$g_bDBMeetCollectorOutside = (GUICtrlRead($g_hChkDBMeetCollectorOutside) = $GUI_CHECKED)
			$g_bDBCollectorNone = (GUICtrlRead($g_hChkDBCollectorNone) = $GUI_CHECKED)
			$g_iDBMinCollectorOutsidePercent = GUICtrlRead($g_hTxtDBMinCollectorOutsidePercent)

			$g_bDBCollectorNearRedline = (GUICtrlRead($g_hChkDBCollectorNearRedline) = $GUI_CHECKED)
			$g_iCmbRedlineTiles = _GUICtrlComboBox_GetCurSel($g_hCmbRedlineTiles)

			$g_bSkipCollectorCheck = (GUICtrlRead($g_hChkSkipCollectorCheck) = $GUI_CHECKED)
			$g_iTxtSkipCollectorGold = GUICtrlRead($g_hTxtSkipCollectorGold)
			$g_iTxtSkipCollectorElixir = GUICtrlRead($g_hTxtSkipCollectorElixir)
			$g_iTxtSkipCollectorDark = GUICtrlRead($g_hTxtSkipCollectorDark)

			$g_bSkipCollectorCheckTH = (GUICtrlRead($g_hChkSkipCollectorCheckTH) = $GUI_CHECKED)
			$g_iCmbSkipCollectorCheckTH = _GUICtrlComboBox_GetCurSel($g_hCmbSkipCollectorCheckTH)
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_31

Func ApplyConfig_MOD_600_35_1($TypeReadSave)
	; <><><> Auto Dock, Hide Emulator & Bot <><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkEnableAuto, $g_bEnableAuto = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkEnableAuto()
			GUICtrlSetState($g_hChkAutoDock, $g_bChkAutoDock = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkAutoHideEmulator, $g_bChkAutoHideEmulator = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			btnEnableAuto()
			GUICtrlSetState($g_hChkAutoMinimizeBot, $g_bChkAutoMinimizeBot = True ? $GUI_CHECKED : $GUI_UNCHECKED)

			; <><><> Only Farm <><><>
			If $g_iComboStatusMode < 0 Then $g_iComboStatusMode = 0
			_GUICtrlComboBox_SetCurSel($g_hCmbStatusMode, $g_iComboStatusMode)
			ComboStatusMode()
			
			; <><><> AIO Updater <><><>
			GUICtrlSetState($g_hChkForAIOUpdates, $g_bCheckVersionAIO ?  $GUI_UNCHECKED : $GUI_CHECKED )
		Case "Save"
			$g_bEnableAuto = (GUICtrlRead($g_hChkEnableAuto) = $GUI_CHECKED)
			$g_bChkAutoDock = (GUICtrlRead($g_hChkAutoDock) = $GUI_CHECKED)
			$g_bChkAutoHideEmulator = (GUICtrlRead($g_hChkAutoHideEmulator) = $GUI_CHECKED)
			$g_bChkAutoMinimizeBot = (GUICtrlRead($g_hChkAutoMinimizeBot) = $GUI_CHECKED)

			; <><><> Only Farm <><><>
			$g_iComboStatusMode = Int(_GUICtrlComboBox_GetCurSel($g_hCmbStatusMode))

			; <><><> AIO Updater <><><>
			$g_bCheckVersionAIO = (GUICtrlRead($g_hChkForAIOUpdates) = $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_35_1

Func ApplyConfig_MOD_600_35_2($TypeReadSave)
	; <><><><> Switch Profiles <><><><>
	Switch $TypeReadSave
		Case "Read"
			For $i = 0 To 3
				GUICtrlSetState($g_ahChk_SwitchMax[$i], $g_abChkSwitchMax[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_ahChk_SwitchMin[$i], $g_abChkSwitchMin[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmb_SwitchMax[$i], $g_aiCmbSwitchMax[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmb_SwitchMin[$i], $g_aiCmbSwitchMin[$i])

				GUICtrlSetState($g_ahChk_BotTypeMax[$i], $g_abChkBotTypeMax[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_ahChk_BotTypeMin[$i], $g_abChkBotTypeMin[$i] = True ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmb_BotTypeMax[$i], $g_aiCmbBotTypeMax[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmb_BotTypeMin[$i], $g_aiCmbBotTypeMin[$i])

				GUICtrlSetData($g_ahTxt_ConditionMax[$i], $g_aiConditionMax[$i])
				GUICtrlSetData($g_ahTxt_ConditionMin[$i], $g_aiConditionMin[$i])
			Next
			chkSwitchProfile()
			chkSwitchBotType()
		Case "Save"
			For $i = 0 To 3
				$g_abChkSwitchMax[$i] = (GUICtrlRead($g_ahChk_SwitchMax[$i]) = $GUI_CHECKED)
				$g_abChkSwitchMin[$i] = (GUICtrlRead($g_ahChk_SwitchMin[$i]) = $GUI_CHECKED)
				$g_aiCmbSwitchMax[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_SwitchMax[$i])
				$g_aiCmbSwitchMin[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_SwitchMin[$i])

				$g_abChkBotTypeMax[$i] = (GUICtrlRead($g_ahChk_BotTypeMax[$i]) = $GUI_CHECKED)
				$g_abChkBotTypeMin[$i] = (GUICtrlRead($g_ahChk_BotTypeMin[$i]) = $GUI_CHECKED)
				$g_aiCmbBotTypeMax[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_BotTypeMax[$i])
				$g_aiCmbBotTypeMin[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_BotTypeMin[$i])

				$g_aiConditionMax[$i] = GUICtrlRead($g_ahTxt_ConditionMax[$i])
				$g_aiConditionMin[$i] = GUICtrlRead($g_ahTxt_ConditionMin[$i])
			Next
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_600_35_2

Func ApplyConfig_MOD_Humanization($TypeReadSave)
	; <><><><> Humanization <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkUseBotHumanization, $g_bUseBotHumanization ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkUseAltRClick, $g_bUseAltRClick ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkLookAtRedNotifications, $g_bLookAtRedNotifications ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseBotHumanization()
			For $i = 0 To UBound($g_iaCmbPriority) -1
				_GUICtrlComboBox_SetCurSel($g_acmbPriority[$i], $g_iacmbPriority[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbMaxSpeed[$i], $g_iacmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbPause[$i], $g_iacmbPause[$i])
			Next
			; For $i = 0 To 1
				; GUICtrlSetData($g_ahumanMessage[$i], $g_iahumanMessage[$i])
			; Next
			_GUICtrlComboBox_SetCurSel($g_hCmbMaxActionsNumber, $g_iCmbMaxActionsNumber)
			; GUICtrlSetData($g_hChallengeMessage, $g_iTxtChallengeMessage)
			cmbStandardReplay()
			cmbWarReplay()
		Case "Save"
			$g_bUseBotHumanization = (GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED)
			$g_bUseAltRClick = (GUICtrlRead($g_hChkUseAltRClick) = $GUI_CHECKED)
			$g_bLookAtRedNotifications = (GUICtrlRead($g_hChkLookAtRedNotifications) = $GUI_CHECKED)
			For $i = 0 To UBound($g_iaCmbPriority) -1
				$g_iacmbPriority[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i])
			Next
			For $i = 0 To 1
				$g_iacmbMaxSpeed[$i] = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				$g_iacmbPause[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPause[$i])
			Next
			; For $i = 0 To 1
				; $g_iahumanMessage[$i] = GUICtrlRead($g_ahumanMessage[$i])
			; Next
			$g_iCmbMaxActionsNumber = _GUICtrlComboBox_GetCurSel($g_iCmbMaxActionsNumber)
			; $g_iTxtChallengeMessage = GUICtrlRead($g_hChallengeMessage)
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_Humanization

#Region - One Gem Boost - Team AiO MOD++
Func ApplyConfig_MOD_OneGem($TypeReadSave)
	; <><><> Attack Plan / Train Army / Boost <><><>

	Switch $TypeReadSave
		Case "Read"
			; One Gem Boost - Team AiO MOD++
			GUICtrlSetState($g_hChkOneGemBoostBarracks, $g_bChkOneGemBoostBarracks ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkOneGemBoostSpells, $g_bChkOneGemBoostSpells ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkOneGemBoostHeroes, $g_bChkOneGemBoostHeroes ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkOneGemBoostWorkshop, $g_bChkOneGemBoostWorkshop ? $GUI_CHECKED : $GUI_UNCHECKED)
			
			; Schedule boost - Team AIO Mod++ 
			GUICtrlSetData($g_hTxtminBoostGold, $g_iMinBoostGold)
			GUICtrlSetData($g_hTxtminBoostElixir, $g_iMinBoostElixir)
			GUICtrlSetData($g_hTxtminBoostDark, $g_iMinBoostDark)

			For $i = 0 To 2
				 _GUICtrlComboBox_SetCurSel($g_hCmbSwitchBoostSchedule[$i], $g_iSwitchBoostSchedule[$i])
			Next
			
			; Set on GUI 
			CmbSwitchBoostSchedule()
		Case "Save"
			; One Gem Boost - Team AiO MOD++
			$g_bChkOneGemBoostBarracks = (GUICtrlRead($g_hChkOneGemBoostBarracks) = $GUI_CHECKED)
			$g_bChkOneGemBoostSpells = (GUICtrlRead($g_hChkOneGemBoostSpells) = $GUI_CHECKED)
			$g_bChkOneGemBoostHeroes = (GUICtrlRead($g_hChkOneGemBoostHeroes) = $GUI_CHECKED)
			$g_bChkOneGemBoostWorkshop = (GUICtrlRead($g_hChkOneGemBoostWorkshop) = $GUI_CHECKED)
			
			; Schedule boost - Team AIO Mod++ 
			$g_iMinBoostGold = GUICtrlRead($g_hTxtminBoostGold)
			$g_iMinBoostElixir = GUICtrlRead($g_hTxtminBoostElixir)
			$g_iMinBoostDark = GUICtrlRead($g_hTxtminBoostDark)
			
			For $i = 0 To 2
				$g_iSwitchBoostSchedule[$i] = _GUICtrlComboBox_GetCurSel($g_hCmbSwitchBoostSchedule[$i])
			Next
	EndSwitch
EndFunc   ;==>ApplyConfig_MOD_OneGem
#EndRegion - One Gem Boost - Team AiO MOD++

; Custom Wall - Team AIO Mod++
Func ApplyConfig_MOD_Walls($TypeReadSave)
	; <><><><> Village / Upgrade - Walls <><><><>
	If $TypeReadSave = "Read" Then
		GUICtrlSetState($g_hchkwallspriorities, $g_bchkwallspriorities ? $gui_checked : $gui_unchecked)
		chkwallspriorities()
	Else
		$g_bchkwallspriorities = (GUICtrlRead($g_hchkwallspriorities) = $gui_checked)
	EndIf
EndFunc   ;==>ApplyConfig_MOD_Walls

#Region - Smart milk - Team AIO Mod++
Func ApplyConfig_600_29_DB_SmartMilk($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"
			If $g_imilkstrategyarmy < 0 Then $g_imilkstrategyarmy = 0
			If $g_imilkdelay < 0 Then $g_imilkdelay = 0
			_guictrlcombobox_setcursel($g_hcmbmilkstrategyarmy, $g_imilkstrategyarmy)
			cmbmilkstrategyarmytips()
			GUICtrlSetState($g_hchkmilkforcedeployheroes, $g_bchkmilkforcedeployheroes ? $gui_checked : $gui_unchecked)
			GUICtrlSetState($g_hchkmilkforcealltroops, $g_bchkmilkforcealltroops ? $gui_checked : $gui_unchecked)
			GUICtrlSetState($g_hchkdebugsmartmilk, $g_bdebugsmartmilk ? $gui_checked : $gui_unchecked)
			GUICtrlSetState($g_hchkmilkforceth, $g_bchkmilkforceth ? $gui_checked : $gui_unchecked)
			_guictrlsetimage($g_ahpicmilk, $g_slibiconpath, $g_hicnmilk[$g_imilkstrategyarmy])
			_guictrlcombobox_setcursel($g_hcmbmilkdelays, $g_imilkdelay)
		Case "Save"
			$g_imilkstrategyarmy = _guictrlcombobox_getcursel($g_hcmbmilkstrategyarmy)
			If $g_imilkstrategyarmy < 0 Then $g_imilkstrategyarmy = 0
			$g_bchkmilkforcedeployheroes = (GUICtrlRead($g_hchkmilkforcedeployheroes) = $gui_checked)
			$g_bchkmilkforcealltroops = (GUICtrlRead($g_hchkmilkforcealltroops) = $gui_checked)
			$g_bdebugsmartmilk = (GUICtrlRead($g_hchkdebugsmartmilk) = $gui_checked)
			$g_bchkmilkforceth = (GUICtrlRead($g_hchkmilkforceth) = $gui_checked)
			$g_imilkdelay = _guictrlcombobox_getcursel($g_hcmbmilkdelays)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_29_DB_SmartMilk
#EndRegion - Smart milk - Team AIO Mod++
