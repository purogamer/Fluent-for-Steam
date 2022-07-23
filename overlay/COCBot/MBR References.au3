ReferenceFunctions() ; call reference function so stripper is not removing these
ReferenceGlobals() ; call reference globals so stripper is not removing these

Func ReferenceFunctions()
	If True Then Return
	; Reference to functions
	Local $a1, $a2
	BotMoveRequest()
	BotMinimizeRequest()
	FindPreferredAdbPath()
	CloseVboxAndroidSvc()
	SetScreenAndroid()
	WaitForRunningVMS()
	WaitForAndroidBootCompleted()
	RebootAndroidSetScreenDefault()
	AndroidSetFontSizeNormal()
	AndroidCloseSystemBar()
	AndroidOpenSystemBar()
	AndroidPicturePathAutoConfig()
	_ShortcutAppId(0)
	GetFont()
	EnableSearchPanels(0)
	AttackCSVAssignDefaultScriptName()
	GUIControl_WM_SYSCOMMAND(0, 0, 0, 0)
	RedrawBotWindowNow()
	_GUICtrlListView_SetItemHeightByFont(0, 0)
	_GUICtrlListView_GetHeightToFitRows(0, 0)
	SortRedline(0, 0, 0)
	_SortRedline(0)
	FindClosestToAxis(0)
	GetSlotIndexFromXPos(0)
	IsElixirTroop(0)
	GetDeployableNextTo(0)
	GUISetFont_DPI(0)
	SetDPI()
	_SysTrayIconTitles()
	_SysTrayIconPids()
	_SysTrayIconProcesses()
	_SysTrayIconIndex(0)
	_SysTrayIconTooltip(0)
	_SysTrayIconPos(0)
	_SysTrayIconVisible(0)
	_SysTrayIconHide(0, 0)
	_SysTrayIconMove(0, 0)
	DefaultZoomOut()
	ZoomOutCtrlWheelScroll()
;~ 	ZoomOutCtrlClick()
	OpenBS()
	OpenBlueStacks()
	OpenBlueStacks2()
	InitBlueStacksX()
	InitBlueStacks()
	InitBlueStacks2()
	RestartBlueStacksXCoC()
	RestartBlueStacksCoC()
	RestartBlueStacks2CoC()
	CheckScreenBlueStacksX()
	CheckScreenBlueStacks()
	CheckScreenBlueStacks2()
	SetScreenBlueStacks()
	SetScreenBlueStacks2()
	RebootBlueStacksSetScreen()
	ConfigBlueStacks2WindowManager()
	RebootBlueStacks2SetScreen()
	GetBlueStacksRunningInstance()
	GetBlueStacks2RunningInstance()
	GetBlueStacksProgramParameter()
	GetBlueStacks2ProgramParameter()
	BlueStacksBotStartEvent()
	BlueStacksBotStopEvent()
	BlueStacks2BotStartEvent()
	BlueStacks2BotStopEvent()
;~ 	BlueStacksAdjustClickCoordinates($a1, $a2)
;~ 	BlueStacks2AdjustClickCoordinates($a1, $a2)
	GetBlueStacksAdbPath()
	GetBlueStacks2AdbPath()
	DisableBS(0, 0)
	EnableBS(0, 0)
	GetBlueStacksSvcPid()
	CloseBlueStacks()
	CloseBlueStacks2()
	KillBSProcess()
	ServiceStop(0)
	CloseUnsupportedBlueStacks2()
	OpenMEmu()
	GetMEmuProgramParameter()
	GetMEmuPath()
	GetMEmuAdbPath()
	InitMEmu()
	SetScreenMEmu()
	RebootMEmuSetScreen()
	CloseMEmu()
	CheckScreenMEmu()
	UpdateMEmuConfig()
	UpdateMEmuWindowState()
	OpenNox()
	IsNoxCommandLine(0)
	GetNoxProgramParameter()
	GetNoxRtPath()
	GetNoxPath()
	GetNoxAdbPath()
	InitNox()
	SetScreenNox()
	RebootNoxSetScreen()
	CloseNox()
	CheckScreenNox()
	GetNoxRunningInstance()
	RedrawNoxWindow()
	HideNoxWindow()
	EmbedNox()
	AndroidEmbedded()
	_ProcessSuspendResume2(0)
	__EnumDefaultProc(0, 0)
	__EnumPageFilesProc(0, 0, 0)
	GemClickP(0, 0)
	SetGuiLog(0)
	Tab(0, 0)
	WinGetPos2(0)
	ControlGetPos2(0, 0, 0)
	WindowSystemMenu(0, 0)
	IsMainChatOpenPage()
	IsClanInfoPage()
	getOcrOverAllDamage(0, 0)
	returnAllMatches(0)
	returnLowestLevelSingleMatch(0)
	updateGlobalVillageOffset(0, 0)
	; GemClickR(0, 0, 0)
	GetBlueStacksBackgroundMode()
	GetBlueStacks2BackgroundMode()
	GetMEmuBackgroundMode()
	GetNoxBackgroundMode()
	ConfigureSharedFolderBlueStacks()
	ConfigureSharedFolderBlueStacks2()
	; DonateCC.au3
	getChatString(0, 0, 0)
	getChatStringChinese(0, 0)
	getChatStringKorean(0, 0)
	getChatStringPersian(0, 0)
EndFunc   ;==>ReferenceFunctions

Func ReferenceGlobals()
	If True Then Return
	; Reference to variables
	Local $a1

	$a1 = $g_aArmyCCSpellSize

	$a1 = $g_aaiTroopsToBeUsed
	$a1 = $aArmyCCRemainTime
	$a1 = $aIsReloadError
	$a1 = $g_iAndroidControlClickWindow

	$a1 = $g_sTownHallVectors ; Custom DROP - Team AIO Mod++
	$a1 = $ATTACKVECTOR_A
	$a1 = $ATTACKVECTOR_B
	$a1 = $ATTACKVECTOR_C
	$a1 = $ATTACKVECTOR_D
	$a1 = $ATTACKVECTOR_E
	$a1 = $ATTACKVECTOR_F
	$a1 = $ATTACKVECTOR_G
	$a1 = $ATTACKVECTOR_H
	$a1 = $ATTACKVECTOR_I
	$a1 = $ATTACKVECTOR_J
	$a1 = $ATTACKVECTOR_K
	$a1 = $ATTACKVECTOR_L
	$a1 = $ATTACKVECTOR_M
	$a1 = $ATTACKVECTOR_N
	$a1 = $ATTACKVECTOR_O
	$a1 = $ATTACKVECTOR_P
	$a1 = $ATTACKVECTOR_Q
	$a1 = $ATTACKVECTOR_R
	$a1 = $ATTACKVECTOR_S
	$a1 = $ATTACKVECTOR_T
	$a1 = $ATTACKVECTOR_U
	$a1 = $ATTACKVECTOR_V
	$a1 = $ATTACKVECTOR_W
	$a1 = $ATTACKVECTOR_X
	$a1 = $ATTACKVECTOR_Y
	$a1 = $ATTACKVECTOR_Z

	; enums
	$a1 = $eIcnArcher
	$a1 = $eIcnDonArcher
	$a1 = $eIcnBalloon
	$a1 = $eIcnDonBalloon
	$a1 = $eIcnBarbarian
	$a1 = $eIcnDonBarbarian
	$a1 = $eBtnTest
	$a1 = $eIcnBuilder
	$a1 = $eIcnCC
	$a1 = $eIcnGUI
	$a1 = $eIcnDark
	$a1 = $eIcnDragon
	$a1 = $eIcnDonDragon
	$a1 = $eIcnDrill
	$a1 = $eIcnElixir
	$a1 = $eIcnCollector
	$a1 = $eIcnFreezeSpell
	$a1 = $eIcnInvisibilitySpell
	$a1 = $eIcnGem
	$a1 = $eIcnGiant
	$a1 = $eIcnDonGiant
	$a1 = $eIcnTrap
	$a1 = $eIcnGoblin
	$a1 = $eIcnDonGoblin
	$a1 = $eIcnGold
	$a1 = $eIcnGolem
	$a1 = $eIcnDonGolem
	$a1 = $eIcnHealer
	$a1 = $eIcnDonHealer
	$a1 = $eIcnHogRider
	$a1 = $eIcnDonHogRider
	$a1 = $eIcnHealSpell
	$a1 = $eIcnInferno
	$a1 = $eIcnJumpSpell
	$a1 = $eIcnLavaHound
	$a1 = $eIcnDonLavaHound
	$a1 = $eIcnLightSpell
	$a1 = $eIcnMinion
	$a1 = $eIcnDonMinion
	$a1 = $eIcnPekka
	$a1 = $eIcnDonPekka
	$a1 = $eIcnTreasury
	$a1 = $eIcnRageSpell
	$a1 = $eIcnTroops
	$a1 = $eIcnHourGlass
	$a1 = $eIcnTH1
	$a1 = $eIcnTH10
	$a1 = $eIcnTrophy
	$a1 = $eIcnValkyrie
	$a1 = $eIcnDonValkyrie
	$a1 = $eIcnWall
	$a1 = $eIcnWallBreaker
	$a1 = $eIcnDonWallBreaker
	$a1 = $eIcnWitch
	$a1 = $eIcnDonWitch
	$a1 = $eIcnWizard
	$a1 = $eIcnDonWizard
	$a1 = $eIcnXbow
	$a1 = $eIcnBarrackBoost
	$a1 = $eIcnMine
	$a1 = $eIcnCamp
	$a1 = $eIcnBarrack
	$a1 = $eIcnSpellFactory
	$a1 = $eIcnDonBlacklist
	$a1 = $eIcnSpellFactoryBoost
	$a1 = $eIcnMortar
	$a1 = $eIcnWizTower
	$a1 = $eIcnPayPal
	$a1 = $eIcnNotify
	$a1 = $eIcnGreenLight
	$a1 = $eIcnLaboratory
	$a1 = $eIcnRedLight
	$a1 = $eIcnBlank
	$a1 = $eIcnYellowLight
	$a1 = $eIcnDonCustom
	$a1 = $eIcnTombstone
	$a1 = $eIcnSilverStar
	$a1 = $eIcnGoldStar
	$a1 = $eIcnDarkBarrack
	$a1 = $eIcnCollectorLocate
	$a1 = $eIcnDrillLocate
	$a1 = $eIcnMineLocate
	$a1 = $eIcnBarrackLocate
	$a1 = $eIcnDarkBarrackLocate
	$a1 = $eIcnDarkSpellFactoryLocate
	$a1 = $eIcnDarkSpellFactory
	$a1 = $eIcnEarthQuakeSpell
	$a1 = $eIcnHasteSpell
	$a1 = $eIcnPoisonSpell
	$a1 = $eIcnBldgTarget
	$a1 = $eIcnBldgX
	$a1 = $eIcnRecycle
	$a1 = $eIcnHeroes
	$a1 = $eIcnBldgElixir
	$a1 = $eIcnBldgGold
	$a1 = $eIcnMagnifier
	$a1 = $eIcnWallElixir
	$a1 = $eIcnWallGold
	$a1 = $eIcnKing
	$a1 = $eIcnQueen
	$a1 = $eIcnDarkSpellBoost
	$a1 = $eIcnQueenBoostLocate
	$a1 = $eIcnKingBoostLocate
	$a1 = $eIcnKingUpgr
	$a1 = $eIcnQueenUpgr
	$a1 = $eIcnWardenUpgr
	$a1 = $eIcnWarden
	$a1 = $eIcnWardenBoostLocate
	$a1 = $eIcnKingBoost
	$a1 = $eIcnQueenBoost
	$a1 = $eIcnWardenBoost
	$a1 = $eEmpty3
	$a1 = $eIcnReload
	$a1 = $eIcnCopy
	$a1 = $eIcnAddcvs
	$a1 = $eIcnEdit
	$a1 = $eIcnTreeSnow
	$a1 = $eIcnSleepingQueen
	$a1 = $eIcnSleepingKing
	$a1 = $eIcnGoldElixir
	$a1 = $eIcnBowler
	$a1 = $eIcnDonBowler
	$a1 = $eIcnSuperBowler
	$a1 = $eIcnCCDonate
	$a1 = $eIcnEagleArt
	$a1 = $eIcnGembox
	$a1 = $eIcnInferno4
	$a1 = $eIcnInfo
	$a1 = $eIcnMain
	$a1 = $eIcnTree
	$a1 = $eIcnProfile
	$a1 = $eIcnCCRequest
	$a1 = $eIcnTelegram
	$a1 = $eIcnTiles
	$a1 = $eIcnXbow3
	$a1 = $eIcnBark
	$a1 = $eIcnDailyProgram
	$a1 = $eIcnLootCart
	$a1 = $eIcnSleepMode
	$a1 = $eIcnTH11
	$a1 = $eIcnTH12
	$a1 = $eIcnTrainMode
	$a1 = $eIcnSleepingWarden
	$a1 = $eIcnCloneSpell
	$a1 = $eIcnSkeletonSpell
	$a1 = $eIcnBabyDragon
	$a1 = $eIcnDonBabyDragon
	$a1 = $eIcnElectroDragon
	$a1 = $eIcnYeti
	$a1 = $eIcnDragonRider
	$a1 = $eIcnMiner
	$a1 = $eIcnDonMiner
	$a1 = $eIcnNoShield
	$a1 = $eIcnDonCustomB
	$a1 = $eIcnAirdefense
	$a1 = $eIcnScattershot
	$a1 = $eIcnDarkBarrackBoost
	$a1 = $eIcnDarkElixirStorage
	$a1 = $eIcnSpellsCost
	$a1 = $eIcnTroopsCost
	$a1 = $eIcnResetButton
	$a1 = $eIcnNewSmartZap
	$a1 = $eIcnTrain
	$a1 = $eIcnAttack
	$a1 = $eIcnDelay
	$a1 = $eIcnReOrder
	$a1 = $eIcn2Arrow
	$a1 = $eIcnArrowLeft
	$a1 = $eIcnArrowRight
	$a1 = $eIcnAndroid
	$a1 = $eHdV04
	$a1 = $eHdV05
	$a1 = $eHdV06
	$a1 = $eHdV07
	$a1 = $eHdV08
	$a1 = $eHdV09
	$a1 = $eHdV10
	$a1 = $eHdV11
	$a1 = $eHdV12
	$a1 = $eHdV13
	$a1 = $eHdV14
	$a1 = $eUnranked
	$a1 = $eBronze
	$a1 = $eSilver
	$a1 = $eGold
	$a1 = $eCrystal
	$a1 = $eMaster
	$a1 = $eLChampion
	$a1 = $eTitan
	$a1 = $eLegend
	$a1 = $eWall04
	$a1 = $eWall05
	$a1 = $eWall06
	$a1 = $eWall07
	$a1 = $eWall08
	$a1 = $eWall09
	$a1 = $eWall10
	$a1 = $eWall11
	$a1 = $eIcnPBNotify
	$a1 = $eIcnCCTroops
	$a1 = $eIcnCCSpells
	$a1 = $eIcnSpellsGroup
	$a1 = $eBahasaIND
	$a1 = $eChinese_S
	$a1 = $eChinese_T
	$a1 = $eEnglish
	$a1 = $eFrench
	$a1 = $eGerman
	$a1 = $eItalian
	$a1 = $ePersian
	$a1 = $eRussian
	$a1 = $eSpanish
	$a1 = $eTurkish
	$a1 = $eMissingLangIcon
	$a1 = $eWall12
	$a1 = $ePortuguese
	$a1 = $eIcnDonPoisonSpell
	$a1 = $eIcnDonEarthQuakeSpell
	$a1 = $eIcnDonHasteSpell
	$a1 = $eIcnDonSkeletonSpell
	$a1 = $eVietnamese
	$a1 = $eKorean

	$a1 = $eTroopBarbarian
	$a1 = $eTroopArcher
	$a1 = $eTroopGiant
	$a1 = $eTroopGoblin
	$a1 = $eTroopWallBreaker
	$a1 = $eTroopBalloon

	$a1 = $eTroopWizard
	$a1 = $eTroopHealer
	$a1 = $eTroopDragon
	$a1 = $eTroopPekka
	$a1 = $eTroopBabyDragon
	$a1 = $eTroopMiner
	$a1 = $eTroopElectroDragon
	$a1 = $eTroopYeti
	$a1 = $eTroopDragonRider

	$a1 = $eTroopMinion
	$a1 = $eTroopHogRider
	$a1 = $eTroopValkyrie
	$a1 = $eTroopGolem
	$a1 = $eTroopWitch

	$a1 = $eTroopLavaHound
	$a1 = $eTroopBowler
	$a1 = $eTroopIceGolem
	$a1 = $eTroopHeadhunter
	$a1 = $eTroopCount
	$a1 = $eSpellLightning
	$a1 = $eSpellHeal
	$a1 = $eSpellRage
	$a1 = $eSpellJump
	$a1 = $eSpellFreeze
	$a1 = $eSpellClone
	$a1 = $eSpellInvisibility

	$a1 = $eSpellPoison
	$a1 = $eSpellEarthquake
	$a1 = $eSpellHaste
	$a1 = $eSpellSkeleton
	$a1 = $eSpellBat
	$a1 = $eSpellCount
	$a1 = $eBarb
	$a1 = $eArch
	$a1 = $eGiant
	$a1 = $eGobl
	$a1 = $eWall
	$a1 = $eBall
	$a1 = $eWiza
	$a1 = $eHeal
	$a1 = $eDrag
	$a1 = $eSDrag
	$a1 = $ePekk
	$a1 = $eBabyD
	$a1 = $eEDrag
	$a1 = $eYeti
	$a1 = $eRDrag
	$a1 = $eMine

	$a1 = $eMini
	$a1 = $eHogs
	$a1 = $eValk
	$a1 = $eGole
	$a1 = $eWitc
	$a1 = $eLava
	$a1 = $eBowl
	$a1 = $eSBowl
	$a1 = $eIceG
	$a1 = $eHunt
	$a1 = $eKing
	$a1 = $eQueen
	$a1 = $eWarden
	$a1 = $eCastle

	$a1 = $eLSpell
	$a1 = $eHSpell
	$a1 = $eRSpell
	$a1 = $eJSpell
	$a1 = $eFSpell
	$a1 = $eCSpell
	$a1 = $eISpell
	$a1 = $ePSpell
	$a1 = $eESpell
	$a1 = $eHaSpell
	$a1 = $eSkSpell
	$a1 = $eBtSpell

	$a1 = $eIcnChampion
	$a1 = $eIcnChampionBoostLocate
	$a1 = $eIcnChampionUpgr
	$a1 = $eIcnChampionBoost
	$a1 = $eIcnSleepingChampion
	$a1 = $eChampion

	$a1 = $aLoginWithSupercellID

	$a1 = $TELEGRAM_URL
	$a1 = $HTTP_STATUS_OK

#cs
	; Team AIO Mod++
	; Queen
	$a1 = $g_bUpgradeQueenEnable
	$a1 = $g_sDateAndTimeQueen
	$a1 = $s_QueenMin[$a1]
	$a1 = $g_aiQueenAltarPos

	; Warden
	$a1 = $g_bUpgradeWardenEnable
	$a1 = $g_sDateAndTimeWarden
	$a1 = $s_WardenMin[$a1]
	$a1 = $g_aiWardenAltarPos

	; King
	$a1 = $g_bUpgradeKingEnable
	$a1 = $g_sDateAndTimeKing
	$a1 = $s_KingMin[$a1]
	$a1 = $g_aiKingAltarPos

	; Champion
	$a1 = $g_bUpgradeChampionEnable
	$a1 = $g_sDateAndTimeChampion
	$a1 = $s_ChampionMin[$a1]
	$a1 = $g_aiChampionAltarPos
#ce

EndFunc   ;==>ReferenceGlobals
