; #FUNCTION# ====================================================================================================================
; Name ..........: Smart Milk
; Description ...: This file Includes several files in the current script.
; Syntax ........: #include
; Parameters ....: None
; Return values .: None
; Author ........: ProMac (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TestSmartMilk($bFast = True)
    ; Getting the Run state
    Local $RuntimeA = $g_bRunState
    $g_bRunState = True

    Local $bDebugSmartFarmTemp = $g_bDebugSmartFarm
    Local $bDebugSmartMilkTemp = $g_bDebugSmartMilk
    $g_bDebugSmartMilk = True
    $g_bDebugSmartFarm = True

    Setlog("Starting the SmartMilk Attack Test()", $COLOR_INFO)
    If $bFast = False Then
        checkMainScreen(False)
        CheckIfArmyIsReady()
        ClickP($aAway, 2, 0, "") ;Click Away
        If _Sleep(100) Then Return FuncReturn()
        If (IsSearchModeActive($DB) And checkCollectors(True, False)) Or IsSearchModeActive($LB) Then
            If _Sleep(100) Then Return FuncReturn()
            PrepareSearch()
            If _Sleep(1000) Then Return FuncReturn()
            VillageSearch()
            If $g_bOutOfGold Then Return ; Check flag for enough gold to search
            If _Sleep(100) Then Return FuncReturn()
        Else
            SetLog("Your Army is not prepared, check the Attack/train options")
        EndIf
    EndIf
    PrepareAttack($g_iMatchMode)

    $g_bAttackActive = True

    ; Variable to return : $Return[3]  [0] = To attack InSide  [1] = Quant. Sides  [2] = Name Sides
    SmartFarmMilk()

    ReturnHome($g_bTakeLootSnapShot, False)

    Setlog("Finish the SmartMilk Attack()", $COLOR_INFO)

    $g_bRunState = $RuntimeA
    $g_bDebugSmartFarm = $bDebugSmartFarmTemp
    $g_bDebugSmartMilk = $bDebugSmartMilkTemp

EndFunc   ;==>TestSmartFarm

Func SmartFarmMilk($bDebug = False)
    If $g_iMatchMode <> $DB And $g_aiAttackAlgorithm[$DB] <> 3 And $bDebug = False Then
        Return
    EndIf

	; Custom Fix - Team AIO Mod++
	$g_bAttackActive = True

	$g_bisccdropped = False
	$g_aideployccposition[0] = -1
	$g_aideployccposition[1] = -1
	$g_bisheroesdropped = False
	$g_aideployheroesposition[0] = -1
	$g_aideployheroesposition[1] = -1
	Local $htimer = TimerInit()
	_captureregion2()
	convertinternalexternarea("ChkSmartMilk")
	suspendandroid()
	If $g_busesmartfarmredline Then
		setdebuglog("Using Green Tiles -> Red Lines -> Edges")
		newredlines()
	Else
		setdebuglog("Classic Redlines, mix with edges.")
		_getredarea()
	EndIf
	resumeandroid()
	SetLog(" ====== Start Smart Milking ====== ", $color_info)
	Local Enum $eswallslot, $egiantslot, $ebarbslot, $eSWizaslot, $eWizaslot, $earchslot, $egoblslot, $ebabydslot, $eminislot, $esminislot, $esgoblslot, $ejspellslot, $esbarbslot, $eminerslot
	Local $igiantslot = -1, $ibarbslot = -1, $iSWizaslot = -1, $iWizaslot = -1, $iarchslot = -1, $igoblslot = -1, $ibabydslot = -1, $imini = -1, $ismini = -1, $isgobs = -1, $iswall = -1, $ijspell = -1, $isbarbslot = -1, $isminerslot = -1
	Local $aslots = [$iswall, $igiantslot, $ibarbslot, $iSWizaslot, $iWizaslot, $iarchslot, $igoblslot, $ibabydslot, $imini, $ismini, $isgobs, $ijspell, $isbarbslot, $isminerslot]
	Local $aslots2deploy[UBound($aslots)][4]
	Local $bUsedZap = False, $sTime = "", $iTime = 0 
	#cs
Global Enum $eBarb, $eSBarb, $eArch, $eSArch, $eGiant, $eSGiant, $eGobl, $eSGobl, $eWall, $eSWall, $eBall, $eRBall, $eWiza, $eSWiza, $eHeal, $eDrag, $eSDrag, $ePekk, $eBabyD, $eInfernoD, $eMine, $eEDrag, $eYeti, $eRDrag, _
		$eMini, $eSMini, $eHogs, $eValk, $eSValk, $eGole, $eWitc, $eSWitc, $eLava, $eIceH, $eBowl, $eSBowl, $eIceG, $eHunt, _
		$eKing, $eQueen, $eWarden, $eChampion, $eCastle, _
		$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $eISpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell, $eBtSpell, _
		$eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eArmyCount
		#ce
	For $i = 0 To UBound($g_avattacktroops) - 1
		If _Sleep(10) Then Return
		If NOT $g_brunstate Then Return
		If $g_avattacktroops[$i][0] = $eSWall Then
			$iswall = $i
			$aslots2deploy[$eswallslot][0] = $i
			$aslots2deploy[$eswallslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$eswallslot][2] = 1
			$aslots2deploy[$eswallslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eGiant Then
			$igiantslot = $i
			$aslots2deploy[$egiantslot][0] = $i
			$aslots2deploy[$egiantslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$egiantslot][2] = "Random(1, 2, 1)"
			$aslots2deploy[$egiantslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eBarb Then
			$ibarbslot = $i
			$aslots2deploy[$ebarbslot][0] = $i
			$aslots2deploy[$ebarbslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$ebarbslot][2] = "Random(3, 6, 1)"
			$aslots2deploy[$ebarbslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eArch Then
			$iarchslot = $i
			$aslots2deploy[$earchslot][0] = $i
			$aslots2deploy[$earchslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$earchslot][2] = "Random(3, 6, 1)"
			$aslots2deploy[$earchslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eSWiza Then
			$iSWizaslot = $i
			$aslots2deploy[$eSWizaslot][0] = $i
			$aslots2deploy[$eSWizaslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$eSWizaslot][2] = "Random(2, 3, 1)"
			$aslots2deploy[$eSWizaslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eWiza Then
			$iWizaslot = $i
			$aslots2deploy[$eWizaslot][0] = $i
			$aslots2deploy[$eWizaslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$eWizaslot][2] = "Random(3, 4, 1)"
			$aslots2deploy[$eWizaslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eGobl Then
			$igoblslot = $i
			$aslots2deploy[$egoblslot][0] = $i
			$aslots2deploy[$egoblslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$egoblslot][2] = "Random(5, 8, 1)"
			$aslots2deploy[$egoblslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eBabyD Then
			$ibabydslot = $i
			$aslots2deploy[$ebabydslot][0] = $i
			$aslots2deploy[$ebabydslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$ebabydslot][2] = 1
			$aslots2deploy[$ebabydslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eMini Then
			$imini = $i
			$aslots2deploy[$eminislot][0] = $i
			$aslots2deploy[$eminislot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$eminislot][2] = "Random(4, 6, 1)"
			$aslots2deploy[$eminislot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eSMini Then
			$ismini = $i
			$aslots2deploy[$esminislot][0] = $i
			$aslots2deploy[$esminislot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$esminislot][2] = "Random(1, 3, 1)"
			$aslots2deploy[$esminislot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eSGobl Then
			$isgobs = $i
			$aslots2deploy[$esgoblslot][0] = $i
			$aslots2deploy[$esgoblslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$esgoblslot][2] = "Random(2, 3, 1)"
			$aslots2deploy[$esgoblslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eJSpell Then
			$ijspell = $i
			$aslots2deploy[$ejspellslot][0] = $i
			$aslots2deploy[$ejspellslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$ejspellslot][2] = 1
			$aslots2deploy[$ejspellslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eSBarb Then
			$isbarbslot = $i
			$aslots2deploy[$esbarbslot][0] = $i
			$aslots2deploy[$esbarbslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$esbarbslot][2] = "Random(2, 3, 1)"
			$aslots2deploy[$esbarbslot][3] = $g_avattacktroops[$i][0]
		EndIf
		If $g_avattacktroops[$i][0] = $eMine Then
			$isminerslot = $i
			$aslots2deploy[$eminerslot][0] = $i
			$aslots2deploy[$eminerslot][1] = $g_avattacktroops[$i][1]
			$aslots2deploy[$eminerslot][2] = "Random(2, 3, 1)"
			$aslots2deploy[$eminerslot][3] = $g_avattacktroops[$i][0]
		EndIf
	Next
	Local Enum $efullbdragons = 0, $efullbarbs, $efullSWiza, $efullWiza, $efullarchs, $efullgibarch, $efullgobs, $efullmin, $efullsmin, $efullsgobs, $efullsbarbs, $efullminers
	Local $iTimebetweenloops = 1500
	If $g_bdebugsmartmilk Then SetLog("Selected slot zero on  attack bar.")
	If isattackpage() Then selectdroptroop(0)
	If _Sleep($delaylaunchtroop23) Then Return
	If isattackpage() Then selectdroptroop(0)
	If $g_bdebugsmartmilk Then SetLog("$g_iMilkStrategyArmy: " & $g_imilkstrategyarmy)
	Switch $g_imilkstrategyarmy
		Case $efullbdragons
			If $aslots[$ebabydslot] <> -1 Then
				If isattackpage() Then selectdroptroop($ibabydslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($ibabydslot)
			EndIf
		Case $efullbarbs
			If $aslots[$ebarbslot] <> -1 Then
				If isattackpage() Then selectdroptroop($ibarbslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($ibarbslot)
			EndIf
		Case $efullSWiza
			If $aslots[$eSWizaslot] <> -1 Then
				If isattackpage() Then selectdroptroop($iSWizaslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($iSWizaslot)
			EndIf
		Case $efullWiza
			If $aslots[$eWizaslot] <> -1 Then
				If isattackpage() Then selectdroptroop($iWizaslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($iWizaslot)
			EndIf
		Case $efullarchs
			If $aslots[$earchslot] <> -1 Then
				If isattackpage() Then selectdroptroop($iarchslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($iarchslot)
			EndIf
		Case $efullgibarch
			If $aslots[$egiantslot] <> -1 Then
				If isattackpage() Then selectdroptroop($igiantslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($igiantslot)
			EndIf
		Case $efullgobs
			If $aslots[$egoblslot] <> -1 Then
				If isattackpage() Then selectdroptroop($igoblslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($igoblslot)
			EndIf
		Case $efullmin
			If $aslots[$eminislot] <> -1 Then
				If isattackpage() Then selectdroptroop($imini)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($imini)
			EndIf
		Case $efullsmin
			If $aslots[$esminislot] <> -1 Then
				If isattackpage() Then selectdroptroop($ismini)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($ismini)
			EndIf
		Case $efullsbarbs
			If $aslots[$esbarbslot] <> -1 Then
				If isattackpage() Then selectdroptroop($isbarbslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($isbarbslot)
			EndIf
		Case $efullminers
			If $aslots[$eminerslot] <> -1 Then
				If isattackpage() Then selectdroptroop($isminerslot)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($isminerslot)
			EndIf
		Case $efullsgobs
			If $aslots[$esgoblslot] <> -1 Then
				If isattackpage() Then selectdroptroop($isgobs)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($isgobs)
			EndIf
			If $aslots[$eswallslot] <> -1 Then
				If isattackpage() Then selectdroptroop($iswall)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($iswall)
			EndIf
		Case Else
			If isattackpage() Then selectdroptroop(0)
			If _Sleep($delaylaunchtroop23) Then Return
			If isattackpage() Then selectdroptroop(0)
	EndSwitch
	If $g_bdebugsmartmilk Then SetLog("$aSlots2deploy: " & _arraytostring($aslots2deploy, "-", -1, -1, "|"))
	If $g_bdebugsmartmilk Then SetLog("$g_iMilkStrategyArmy: " & $g_imilkstrategyarmy)
	Local $allpossibledeploypoints[0][2], $heroesdeployjustincase[2], $sside = ""
	For $iloops = 0 To 2
		$htimer = TimerInit()
		Local $acollectorstl[0][6], $acollectorstr[0][6], $acollectorsbl[0][6], $acollectorsbr[0][6]
		If $g_bdebugsmartmilk Then SetLog("Attack loop: " & $iloops)
		suspendandroid()
		Local $acollectorsall = smartfarmdetection("All")
		resumeandroid()
		If $g_bchkmilkforceth Then
			suspendandroid()
			resetthsearch()
			findtownhall(True, True)
			resumeandroid()
			setdebuglog("$IMGLOCTHNEAR: " & $imglocthnear)
			setdebuglog("$g_sTHLoc: " & $g_sthloc)
			setdebuglog("$IMGLOCTHLOCATION: " & _arraytostring($imglocthlocation))
			setdebuglog("$IMGLOCTHRDISTANCE: " & $imglocthrdistance)
			If StringUpper($g_sthloc) = "OUT" Then
				Local $aallpoints = StringSplit($imglocthnear, "|", $str_nocount)
				If NOT @error Then
					Local $aonepoint = StringSplit($aallpoints[0], ",", $str_nocount)
					If NOT @error Then
						Local $adeploypoint[2] = [$aonepoint[0], $aonepoint[1]]
						setdebuglog("$aDeployPoint: " & _arraytostring($adeploypoint))
						If NOT $bDebug Then
							For $i = 0 To UBound($aslots2deploy) - 1
								If $aslots2deploy[$i][1] > 0 AND $aslots2deploy[$i][0] <> $iswall Then
									If isattackpage() Then selectdroptroop($aslots2deploy[$i][0])
									If _Sleep($delaylaunchtroop23) Then Return
									Local $ideployunits = 1
									Switch $aslots2deploy[$i][0]
										Case $ibarbslot
											$ideployunits = 15
										Case $ibabydslot
											$ideployunits = 1
										Case $iarchslot
											$ideployunits = 15
										Case $igoblslot
											$ideployunits = 15
										Case $isgobs
											$ideployunits = 6
										Case $isbarbslot
											$ideployunits = 7
										Case $imini
											$ideployunits = 15
										Case $ismini
											$ideployunits = 4
										Case $isminerslot
											$ideployunits = 7
									EndSwitch
									If $g_bdebugsmartmilk Then SetLog("AttackClick TH: " & $adeploypoint[0] & "," & $adeploypoint[1] & " - " & $ideployunits & "x")
									Local $iRest = _Min($ideployunits, $aslots2deploy[$i][1])
									AttackClick($adeploypoint[0], $adeploypoint[1], $iRest, 100, 0, "#0098")
									$aslots2deploy[$i][1] -= $iRest
									SetLog("Deployed " & GetTroopName($aslots2deploy[$i][3], Number($ideployunits)) & " " & $ideployunits & "x - Snipping TH")
									If $g_bdebugsmartmilk Then SetLog("Remains - " & GetTroopName($aslots2deploy[$i][3]) & " " & $aslots2deploy[$i][1] & "x")
									If _Sleep($delaylaunchtroop23) Then Return
								EndIf
							Next
						EndIf
					EndIf
				EndIf
				If _Sleep($delaylaunchtroop23) Then Return
			EndIf
		EndIf
		setdebuglog(" TOTAL detection Calculated  (in " & Round(TimerDiff($htimer) / 1000, 2) & " seconds)", $color_info)
		If IsArray($acollectorsall) AND UBound($acollectorsall) > 0 Then
			For $collector = 0 To UBound($acollectorsall) - 1
				If _Sleep(10) Then Return
				If NOT $g_brunstate Then Return
				Switch $acollectorsall[$collector][4]
					Case "TL"
						ReDim $acollectorstl[UBound($acollectorstl) + 1][6]
						For $t = 0 To 5
							$acollectorstl[UBound($acollectorstl) - 1][$t] = $acollectorsall[$collector][$t]
						Next
						If $iloops = 0 Then
							$heroesdeployjustincase[0] = $g_aaitopleftdroppoints[3][0]
							$heroesdeployjustincase[1] = $g_aaitopleftdroppoints[3][1]
							$sside = $acollectorsall[$collector][4]
						EndIf
					Case "TR"
						ReDim $acollectorstr[UBound($acollectorstr) + 1][6]
						For $t = 0 To 5
							$acollectorstr[UBound($acollectorstr) - 1][$t] = $acollectorsall[$collector][$t]
						Next
						If $iloops = 0 Then
							$heroesdeployjustincase[0] = $g_aaitoprightdroppoints[3][0]
							$heroesdeployjustincase[1] = $g_aaitoprightdroppoints[3][1]
							$sside = $acollectorsall[$collector][4]
						EndIf
					Case "BL"
						ReDim $acollectorsbl[UBound($acollectorsbl) + 1][6]
						For $t = 0 To 5
							$acollectorsbl[UBound($acollectorsbl) - 1][$t] = $acollectorsall[$collector][$t]
						Next
						If $iloops = 0 Then
							$heroesdeployjustincase[0] = $g_aaibottomleftdroppoints[3][0]
							$heroesdeployjustincase[1] = $g_aaibottomleftdroppoints[3][1]
							$sside = $acollectorsall[$collector][4]
						EndIf
					Case "BR"
						ReDim $acollectorsbr[UBound($acollectorsbr) + 1][6]
						For $t = 0 To 5
							$acollectorsbr[UBound($acollectorsbr) - 1][$t] = $acollectorsall[$collector][$t]
						Next
						If $iloops = 0 Then
							$heroesdeployjustincase[0] = $g_aaibottomrightdroppoints[3][0]
							$heroesdeployjustincase[1] = $g_aaibottomrightdroppoints[3][1]
							$sside = $acollectorsall[$collector][4]
						EndIf
				EndSwitch
			Next
			If ($g_bdebugsmartmilk OR $bDebug) AND $iloops = 0 Then
				SetLog("$aCollectorsAll: " & _arraytostring($acollectorsall, "-", -1, -1, "|"))
				debugimagesmartmilk($acollectorsall, Round(TimerDiff($htimer) / 1000, 2) & "'s", $heroesdeployjustincase)
			EndIf
			If $bDebug Then Return
			Local $random = Random(0, 3, 1)
			Switch $random
				Case 0
					Local $aallbyside[4] = [$acollectorsbl, $acollectorsbr, $acollectorstr, $acollectorstl]
				Case 1
					Local $aallbyside[4] = [$acollectorsbr, $acollectorstr, $acollectorstl, $acollectorsbl]
				Case 2
					Local $aallbyside[4] = [$acollectorstr, $acollectorstl, $acollectorsbl, $acollectorsbr]
				Case 3
					Local $aallbyside[4] = [$acollectorstl, $acollectorsbl, $acollectorsbr, $acollectorstr]
			EndSwitch
			Local $itroopsdistance = 70
			If $ibabydslot = -1 Then $itroopsdistance = 30
			Local $alastposition[2]
			For $j4534 = 0 To 3
				If $g_bdebugsmartmilk Then SetLog("Attack Side :" & $j4534)
				Local $asidecollectors = $aallbyside[$j4534]
				If $g_bdebugsmartmilk Then SetLog("$aSideCollectors: " & _arraytostring($asidecollectors, "-", -1, -1, "|"))
				_arraysort($asidecollectors, 0, 0, 0, 0)
				If $g_bdebugsmartmilk Then SetLog("$aSideCollectors after sort: " & _arraytostring($asidecollectors, "-", -1, -1, "|"))
				Local $alastposition = [0, 0]
				For $collector = 0 To UBound($asidecollectors) - 1
					If $g_bdebugsmartmilk Then SetLog("Pixel_Distance : " & pixel_distance($asidecollectors[$collector][0], $asidecollectors[$collector][1], $alastposition[0], $alastposition[1]))
					If pixel_distance($asidecollectors[$collector][0], $asidecollectors[$collector][1], $alastposition[0], $alastposition[1]) > $itroopsdistance Then
						$alastposition[0] = $asidecollectors[$collector][0]
						$alastposition[1] = $asidecollectors[$collector][1]
						Local $anear = $asidecollectors[$collector][5]
						If $g_bdebugsmartmilk Then SetLog("$aNear: " & $anear)
						Local $nearpoints[0][2]
						If $g_bdebugsmartmilk Then SetLog("Resource position is '" & $asidecollectors[$collector][3] & "'")
						If $asidecollectors[$collector][3] = "In" AND ($g_imilkstrategyarmy = $efullsgobs OR $g_imilkstrategyarmy = $efullgobs) AND $iloops > 0 Then
							If NOT $g_bisheroesdropped AND NOT $g_bisccdropped Then
								If $g_bdebugsmartmilk Then SetLog("Collector is " & $asidecollectors[$collector][3] & ", go to NEXT!")
								ContinueLoop
							EndIf
						EndIf
						If StringInStr($anear, "|") Then
							Local $tempobbj = StringSplit($anear, "|", $str_nocount)
							For $t = 0 To UBound($tempobbj) - 1
								ReDim $nearpoints[UBound($nearpoints) + 1][2]
								Local $nearpoint = StringSplit($tempobbj[$t], ",", $str_nocount)
								$nearpoints[UBound($nearpoints) - 1][0] = $nearpoint[0]
								$nearpoints[UBound($nearpoints) - 1][1] = $nearpoint[1]
								If _Sleep(10) Then Return
								If NOT $g_brunstate Then Return
							Next
						Else
							Local $tempobbj = StringSplit($anear, ",", $str_nocount)
							ReDim $nearpoints[UBound($nearpoints) + 1][2]
							$nearpoints[UBound($nearpoints) - 1][0] = $tempobbj[0]
							$nearpoints[UBound($nearpoints) - 1][1] = $tempobbj[1]
						EndIf
						If UBound($nearpoints) > 2 Then
							Local $deploypoint = [$nearpoints[2][0], $nearpoints[2][1]]
						Else
							Local $deploypoint = [$nearpoints[0][0], $nearpoints[0][1]]
						EndIf
						If $iloops = 0 Then
							ReDim $allpossibledeploypoints[UBound($allpossibledeploypoints) + 1][2]
							$allpossibledeploypoints[UBound($allpossibledeploypoints) - 1][0] = $deploypoint[0]
							$allpossibledeploypoints[UBound($allpossibledeploypoints) - 1][1] = $deploypoint[1]
						EndIf
						Local $iExecute = 1
						For $i = 0 To UBound($aslots2deploy) - 1
							If NOT $g_brunstate Then Return
							If $aslots2deploy[$i][1] > 0 Then
								If $aslots2deploy[$i][0] = $iswall AND $iloops > 0 Then
									ContinueLoop
								EndIf
								If $asidecollectors[$collector][3] <> "In" AND $aslots2deploy[$i][0] = $iswall Then
									If $g_bdebugsmartmilk Then SetLog("Collector is " & $asidecollectors[$collector][3] & ", and you are using SuperWb, go to NEXT!")
									ContinueLoop
								EndIf
								If isattackpage() Then selectdroptroop($aslots2deploy[$i][0])
								If _Sleep($delaylaunchtroop21 * $g_imilkdelay) Then Return
								If $g_bdebugsmartmilk Then SetLog("AttackClick: " & $deploypoint[0] & "," & $deploypoint[1])
								$iExecute = _Min(Execute($aslots2deploy[$i][2]), $aslots2deploy[$i][1])
								AttackClick($deploypoint[0], $deploypoint[1], $iExecute, 100, 0, "#0098")
								$aslots2deploy[$i][1] -= $iExecute
								SetLog("Deployed " & GetTroopName($aslots2deploy[$i][3], $iExecute) & " " & $iExecute & "x", $COLOR_ACTION)
								If $g_bdebugsmartmilk Then SetLog("Remains - " & GetTroopName($aslots2deploy[$i][3]) & " " & $aslots2deploy[$i][1] & "x")
								If _Sleep($delaylaunchtroop21 * $g_imilkdelay) Then Return
								Local $ikingslot = NOT $g_bdropking ? $g_ikingslot : -1
								Local $iqueenslot = NOT $g_bdropqueen ? $g_iqueenslot : -1
								Local $iwardenslot = NOT $g_bdropwarden ? $g_iwardenslot : -1
								Local $ichampionslot = NOT $g_bdropchampion ? $g_ichampionslot : -1
								If $ikingslot <> -1 OR $iqueenslot <> -1 OR $iwardenslot <> -1 OR $ichampionslot <> -1 Then
									checkheroeshealth()
								EndIf
							EndIf
						Next
						If _Sleep($delaylaunchtroop21 * $g_imilkdelay) Then Return
					Else
						If $g_bdebugsmartmilk Then SetLog("Pixel (" & $asidecollectors[$collector][0] & "," & $asidecollectors[$collector][1] & ") doesn't have the min distance to deploy..")
					EndIf
				Next
			Next
			If _Sleep($iTimebetweenloops * $g_imilkdelay) Then Return
			$g_ipercentagedamage = Number(getocroveralldamage(780, 527 + $g_ibottomoffsety))
			$sTime = Round(Int(AttackRemainingTime() / 1000), 2)
			$iTime = Int(AttackRemainingTime() / 1000)
			SetLog("Overall Damage is " & $g_ipercentagedamage & "%", $color_info)
			SetLog("Battle ends in: " & $sTime & " | remain in seconds is " & $iTime & "s", $color_info)
			If isattackpage() AND (($g_iRemainTimeToZap > $iTime AND $g_iRemainTimeToZap <> 0) OR $iTime < 45) AND NOT $bUsedZap Then
				SetLog("let's ZAP, even with troops on the ground", $color_info)
				smartzap()
				$bUsedZap = True
			EndIf
			If $g_bisheroesdropped Then checkheroeshealth()
		EndIf
		$g_ipercentagedamage = Number(getocroveralldamage(780, 527 + $g_ibottomoffsety))
		If $g_ipercentagedamage > 50 Then
			If $iloops = 0 Then
				SetLog("Reached " & $g_ipercentagedamage & "% lets Check if exist any resource!", $color_success)
				ContinueLoop
			Else
				SetLog("Reached " & $g_ipercentagedamage & "% lets Exit!", $color_success)
				ExitLoop
			EndIf
		EndIf
		If (($g_ipercentagedamage > 30 AND $iloops <> 0) OR ($g_bchkmilkforcedeployheroes AND $iloops <> 0) OR ($g_imilkstrategyarmy = $efullsgobs AND $g_bchkmilkforcedeployheroes)) AND NOT $g_bisheroesdropped Then
			Local $ikingslot = NOT $g_bdropking ? $g_ikingslot : -1
			Local $iqueenslot = NOT $g_bdropqueen ? $g_iqueenslot : -1
			Local $iwardenslot = NOT $g_bdropwarden ? $g_iwardenslot : -1
			Local $ichampionslot = NOT $g_bdropchampion ? $g_ichampionslot : -1
			Local $icc = NOT $g_bisccdropped ? $g_iclancastleslot : -1
			If $ikingslot <> -1 OR $iqueenslot <> -1 OR $iwardenslot <> -1 OR $ichampionslot <> -1 OR $icc <> -1 Then
				SetLog("Dropping Heros & CC at " & $sside & " - " & _arraytostring($heroesdeployjustincase, "|", -1, -1, " "), $color_success)
				dropcc($heroesdeployjustincase[0], $heroesdeployjustincase[1], $icc)
				$g_bisccdropped = True
				If _Sleep(2000) Then Return
				dropheroes($heroesdeployjustincase[0], $heroesdeployjustincase[1], $ikingslot, $iqueenslot, $iwardenslot, $ichampionslot, False, True)
				$g_bisheroesdropped = True
				checkheroeshealth()
			EndIf
		EndIf
		If $g_bisheroesdropped Then checkheroeshealth()
		If $g_imilkstrategyarmy = $efullsgobs AND $iloops = 2 AND $g_bmilksjumpspells Then
			setdebuglog("Check the current available loot?")
			setdebuglog("Check available Mines and Elixir collectors")
			$htimer = TimerInit()
			suspendandroid()
			Local $acollectorsall = smartfarmdetection("Milk")
			setdebuglog(" TOTAL detection Calculated  (in " & Round(TimerDiff($htimer) / 1000, 2) & " seconds)", $color_info)
			resumeandroid()
			If $g_bisheroesdropped Then checkheroeshealth()
			setdebuglog("Check available Mines and Elixir collectors")
			If $aslots[$ejspellslot] <> -1 Then
				If isattackpage() Then selectdroptroop($ijspell)
				If _Sleep($delaylaunchtroop23) Then Return
				If isattackpage() Then selectdroptroop($ijspell)
			EndIf
		EndIf
		If $iloops = 2 AND $g_bchkmilkforcealltroops Then
			SetLog("Let's deploy all remain troops!", $color_info)
			setdebuglog("How many last deploy points: " & UBound($allpossibledeploypoints))
			For $point = 0 To UBound($allpossibledeploypoints) - 1
				If $g_bisheroesdropped Then checkheroeshealth()
				For $iZ = 0 To UBound($aslots2deploy) - 1
					Local $iExecute = Execute($aslots2deploy[$iZ][2])
					If $aslots2deploy[$iZ][1] > 0 Then
						If isattackpage() Then selectdroptroop($aslots2deploy[$iZ][0])
						If _Sleep($delaylaunchtroop23 * 2) Then Return 
						If $g_bdebugsmartmilk Then SetLog("AttackClick: " & $allpossibledeploypoints[$point][0] & "," & $allpossibledeploypoints[$point][1])
						AttackClick($allpossibledeploypoints[$point][0], $allpossibledeploypoints[$point][1], $iExecute, 100, 0, "#0098")
						$aslots2deploy[$iZ][1] -= $iExecute
						SetLog("Deployed " & GetTroopName($aslots2deploy[$iZ][3], Number($iExecute)) & " " & $iExecute & "x")
						If $g_bdebugsmartmilk Then SetLog("Remains - " & GetTroopName($aslots2deploy[$iZ][3]) & " " & $aslots2deploy[$iZ][1] & "x")
						If _Sleep($delaylaunchtroop23) Then Return 
					EndIf
				Next
			Next
			If _Sleep($delayalgorithm_alltroops4) Then Return
			SetLog("Dropping left over troops", $color_info)
			For $x = 0 To 1
				If prepareattack($g_imatchmode, True) = 0 Then
					If $g_bdebugsetlog Then setdebuglog("No Wast time... exit, no troops usable left", $color_debug)
					ExitLoop
				EndIf
				For $i = $eBarb To $eTroopCount -1
					If launchtroop($i, 2, 1, 1, 1) Then
						If $g_bisheroesdropped Then checkheroeshealth()
						If _Sleep($delayalgorithm_alltroops5) Then Return
					EndIf
				Next
			Next
		EndIf
		$iTime = Int(AttackRemainingTime() / 1000)
		If isattackpage() AND (($g_iRemainTimeToZap > $iTime AND $g_iRemainTimeToZap <> 0) OR $iTime < 45) AND NOT $bUsedZap Then
			SetLog("let's ZAP, even with troops on the ground", $color_info)
			smartzap()
			$bUsedZap = True
		EndIf
		If $g_bisheroesdropped Then checkheroeshealth()
	Next
	SetLog("Finished Attacking, waiting for the battle to end")
	Return True
EndFunc

Func debugimagesmartmilk($acollectorsall, $stime, $heroesdeployjustincase)
	_captureregion()
	Local $editedimage = $g_hbitmap
	Local $subdirectory = $g_sProfileTempDebugPath & "\SmartMilk\"
	DirCreate($subdirectory)
	Local $date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = "SmartMilk" & "_" & $date & "_" & $time & ".png"
	Local $filenameuntouched = "SmartMilk" & "_" & $date & "_" & $time & "_1.png"
	Local $hgraphic = _gdiplus_imagegetgraphicscontext($editedimage)
	Local $hpen = _gdiplus_pencreate(0xFFFF0000, 2)
	Local $hpen2 = _gdiplus_pencreate(0xFF000000, 2)
	$hpen2 = _gdiplus_pencreate(0xFFFF, 2)
	_gdiplus_graphicsdrawrect($hgraphic, $diamondmiddlex - 5, $diamondmiddley - 5, 10, 10, $hpen2)
	$hpen2 = _gdiplus_pencreate(0xFFFF, 1)
	_gdiplus_graphicsdrawline($hgraphic, 0, $diamondmiddley, $g_iGAME_WIDTH, $diamondmiddley, $hpen2)
	_gdiplus_graphicsdrawline($hgraphic, $diamondmiddlex, 0, $diamondmiddlex, $g_iGAME_HEIGHT, $hpen2)
	$hpen2 = _gdiplus_pencreate(0xFF000000, 2)
	Local $tempobbj, $tempobbjs
	If $heroesdeployjustincase[0] <> NULL  AND $heroesdeployjustincase[1] > 0 Then
		_gdiplus_graphicsdrawrect($hgraphic, $heroesdeployjustincase[0] - 10, $heroesdeployjustincase[1] - 10, 20, 20, $hpen2)
		_addinfotodebugimage($hgraphic, $hpen2, "HEROES", $heroesdeployjustincase[0] - 20, $heroesdeployjustincase[1] - 40, 16, 2, False)
	EndIf
	If $g_ithx <> 0 AND $g_ithy <> 0 Then
		_gdiplus_graphicsdrawrect($hgraphic, $g_ithx - 10, $g_ithy - 10, 20, 20, $hpen)
		_addinfotodebugimage($hgraphic, $hpen, "TH_" & $g_iimglocthlevel & "(" & $g_sthloc & ")", $g_ithx - 20, $g_ithy - 40, 16, 2, False)
	EndIf
	For $i = 0 To UBound($acollectorsall) - 1
		If $acollectorsall[$i][3] = "In" Then
			$hpen = _gdiplus_pencreate(0xFFFF0000, 2)
		Else
			$hpen = _gdiplus_pencreate(0xFF00FF2B, 2)
		EndIf
		_gdiplus_graphicsdrawellipse($hgraphic, $acollectorsall[$i][0] - 7, $acollectorsall[$i][1] - 7, 14, 14, $hpen)
		If StringInStr($acollectorsall[$i][5], "|") Then
			$tempobbj = StringSplit($acollectorsall[$i][5], "|", $str_nocount)
			For $t = 0 To UBound($tempobbj) - 1
				$tempobbjs = StringSplit($tempobbj[$t], ",", $str_nocount)
				Local $penn = $hpen2
				If $t = 2 Then $penn = $hpen
				If UBound($tempobbjs) > 1 Then _gdiplus_graphicsdrawrect($hgraphic, $tempobbjs[0] - 2, $tempobbjs[1] - 2, 4, 4, $penn)
			Next
		Else
			$tempobbj = StringSplit($acollectorsall[$i][5], ",", $str_nocount)
			If UBound($tempobbj) > 1 Then _gdiplus_graphicsdrawrect($hgraphic, $tempobbj[0] - 2, $tempobbj[1] - 2, 4, 4, $hpen2)
		EndIf
		$tempobbj = NULL
		$tempobbjs = NULL
	Next
	$hpen2 = _gdiplus_pencreate(0xFF336EFF, 2)
	Local $pixel
	For $i = 0 To UBound($g_aipixeltopleft) - 1
		$pixel = $g_aipixeltopleft[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	For $i = 0 To UBound($g_aipixeltopright) - 1
		$pixel = $g_aipixeltopright[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	For $i = 0 To UBound($g_aipixelbottomleft) - 1
		$pixel = $g_aipixelbottomleft[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	For $i = 0 To UBound($g_aipixelbottomright) - 1
		$pixel = $g_aipixelbottomright[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	$hpen2 = _gdiplus_pencreate(0xFF6EFF33, 2)
	For $i = 0 To UBound($g_aipixeltopleftfurther) - 1
		$pixel = $g_aipixeltopleftfurther[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	For $i = 0 To UBound($g_aipixeltoprightfurther) - 1
		$pixel = $g_aipixeltoprightfurther[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	For $i = 0 To UBound($g_aipixelbottomleftfurther) - 1
		$pixel = $g_aipixelbottomleftfurther[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	For $i = 0 To UBound($g_aipixelbottomrightfurther) - 1
		$pixel = $g_aipixelbottomrightfurther[$i]
		_gdiplus_graphicsdrawellipse($hgraphic, $pixel[0], $pixel[1], 2, 2, $hpen2)
	Next
	$hpen = _gdiplus_pencreate(0xFFFF, 1)
	_addinfotodebugimage($hgraphic, $hpen, $stime, 370, 70, 20, 2, False)
	_gdiplus_imagesavetofile($editedimage, $subdirectory & $filename)
	_captureregion()
	_gdiplus_imagesavetofile($g_hbitmap, $subdirectory & $filenameuntouched)
	_gdiplus_pendispose($hpen)
	_gdiplus_pendispose($hpen2)
	_gdiplus_graphicsdispose($hgraphic)
	SetLog(" » Debug Image saved!")
EndFunc

Func _addinfotodebugimage(ByRef $hgraphic, ByRef $hpen, $filename, $x, $y, $ifontsize = 12, $ifontstyle = 2, $square = True)
	If $square Then _gdiplus_graphicsdrawrect($hgraphic, $x - 5, $y - 5, 10, 10, $hpen)
	Local $hbrush = _gdiplus_brushcreatesolid(-1)
	Local $hformat = _gdiplus_stringformatcreate()
	Local $hfamily = _gdiplus_fontfamilycreate("Tahoma")
	Local $hfont = _gdiplus_fontcreate($hfamily, $ifontsize, $ifontstyle)
	Local $tlayout = _gdiplus_rectfcreate($x + 10, $y, 0, 0)
	Local $u7126 = String($filename)
	Local $ainfo = _gdiplus_graphicsmeasurestring($hgraphic, $u7126, $hfont, $tlayout, $hformat)
	_gdiplus_graphicsdrawstringex($hgraphic, $u7126, $hfont, $ainfo[0], $hformat, $hbrush)
	$tlayout = 0
	_gdiplus_fontdispose($hfont)
	_gdiplus_fontfamilydispose($hfamily)
	_gdiplus_stringformatdispose($hformat)
	_gdiplus_brushdispose($hbrush)
EndFunc