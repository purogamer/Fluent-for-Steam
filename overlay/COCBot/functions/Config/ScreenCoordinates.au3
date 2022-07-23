; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; 	   $aiSomeVar = [StartX, StartY, EndX, EndY]
;Global $aiClickAwayRegionLeft = [225, 10, 255, 30]
;Global $aiClickAwayRegionRight = [605, 10, 645, 30]
;Let's tighten these up to avoid clicking on shields.
Global $aiClickAwayRegionLeft = [235, 10, 245, 30]
Global $aiClickAwayRegionRight = [625, 10, 635, 30]

Global $aCenterEnemyVillageClickDrag = [65, 525] ; Scroll village using this location in the water
Global $aCenterHomeVillageClickDrag = [800, 350] ; Scroll village using this location : upper from setting button
Global $aIsReloadError[4] = [457, 301 + $g_iMidOffsetY, 0x33B5E5, 10] ; Pixel Search Check point For All Reload Button errors, except break ending
Global $aIsMain[4] = [278, 9, 0x7ABDDF, 25] ; Main Screen, Builder Info Icon
Global $aIsMainGrayed[4] = [278, 9, 0x3C5F70, 15] ; Main Screen, Builder Info Icon grayed
Global $aIsOnBuilderBase[4] = [838, 18, 0xffff46, 10] ; Check the Gold Coin from resources , is a square not round

Global $aIsConnectLost[4] = [255, 271 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsCheckOOS[4] = [223, 272 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aReloadButton[4] = [190, 408 + $g_imidoffsety, 0x80CAC3, 10] ; Reload Coc Button after Out of Sync, 860x780
Global $aAttackButton[2] = [60, 614 + $g_iBottomOffsetY] ; Attack Button, Main Screen
Global $aFindMatchButton[4] = [470, 20 + $g_iBottomOffsetY, 0xD8A420, 10] ; Find Multiplayer Match Button, Attack Screen 860x780 without shield
Global $aIsAttackShield[4] = [250, 415 + $g_iMidOffsetY, 0xE8E8E0, 10] ; Attack window, white shield verification window
Global $aAway[2] = [175, 10] ; Away click, moved from 1,1 to prevent scroll window from top, moved from 0,10 to 175,32 to prevent structure click or 175,10 to just fix MEmu 2.x opening and closing toolbar
Global $aAway2[2] = [235, 10] ; Second Away Position for Windows like Donate Window where at $aAway is a button
Global $aNoShield[4] = [448, 20, 0x43484B, 15] ; Main Screen, charcoal pixel center of shield when no shield is present
Global $aHaveShield[4] = [455, 19, 0xF0F8FB, 15] ; Main Screen, Silver pixel top center of shield
Global $aHavePerGuard[4] = [455, 19, 0x10100D, 15] ; Main Screen, black pixel in sword outline top center of shield
Global $aShieldInfoButton[4] = [431, 10, 0x75BDE4, 15] ; Main Screen, Blue pixel upper part of "i"
Global $aIsShieldInfo[4] = [645, 195 + $g_iMidOffsetYFixed, 0xED1115, 20] ; Main Screen, Shield Info window, red pixel right of X
Global $aSurrenderButton[4] = [70, 545 + $g_iBottomOffsetY, 0xC00000, 40] ; Surrender Button, Attack Screen
Global $aSurrenderButtonFixed[4] = [70, 446 + $g_iBottomOffsetY, 0xC00000, 40] ; AIO Mod++
Global $aConfirmSurrender[4] = [515, 415 + $g_iMidOffsetY, 0x6DBC1F, 30] ; Confirm Surrender Button, Attack Screen, green color on button?
Global $aCancelFight[4] = [822, 48, 0xD80408, 20] ; Cancel Fight Scene
Global $aCancelFight2[4] = [830, 59, 0xD80408, 20] ; Cancel Fight Scene 2nd pixel
Global $aEndFightSceneBtn[4] = [429, 519 + $g_iMidOffsetY, 0xB8E35F, 20] ; Victory or defeat scene buton = green edge
Global $aEndFightSceneAvl[4] = [241, 196 + $g_iMidOffsetY, 0xFFF090, 20] ; Victory or defeat scene left side ribbon = light gold
Global $aEndFightSceneReportGold = $aEndFightSceneAvl ; Missing... TripleM ???
Global $aReturnHomeButton[4] = [376, 567 + $g_iMidOffsetY, 0x60AC10, 20] ; Return Home Button, End Battle Screen
Global $aChatTab[4] = [331, 325 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aChatTab2[4] = [331, 330 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aChatTab3[4] = [331, 335 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aOpenChat[2] = [19, 349 + $g_iMidOffsetY] ; Open Chat Windows, Main Screen
Global $aClanTab[2] = [189, 24] ; Clan Tab, Chat Window, Main Screen
Global $aClanInfo[2] = [282, 55] ; Clan Info Icon
Global $aArmyCampSize[2] = [110, 136 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Size/Total Size
Global $aSiegeMachineSize[2] = [755, 136 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Number/Total Number
Global $aArmySpellSize[2] = [99, 284 + $g_iMidOffsetY] ; Training Window Overviewscreen, current number/total capacity
Global $g_aArmyCCSpellSize[2] = [473, 469 - 3 + $g_iMidOffsetYFixed] ; Training Window, Overview Screen, Current CC Spell number/total cc spell capacity
Global $aArmyCCRemainTime[2] = [782, 552 + $g_iMidOffsetY] ; Training Window Overviewscreen, Minutes & Seconds remaining till can request again
Global $aIsCampFull[4] = [128, 151 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Training Window, Overview screen White pixel in check mark with camp IS full (can not test for Green, as it has trees under it!)
Global $aBuildersDigits[2] = [322, 20] ; Main Screen, Free/Total Builders
Global $aBuildersDigitsBuilderBase[2] = [414, 21] ; Main Screen on Builders Base Free/Total Builders
Global $aTrophies[2] = [69, 84] ; Main Screen, Trophies
Global $aNoCloudsAttack[4] = [25, 606 + $g_iBottomOffsetYFixed, 0xCD0D0D, 15] ; Attack Screen: No More Clouds
Global $aArmyTrainButton[2] = [40, 525 + $g_iBottomOffsetY] ; Main Screen, Army Train Button
Global $aWonOneStar[4] = [714, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 1st Star for winning attack on enemy
Global $aWonTwoStar[4] = [739, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 2nd Star for winning attack on enemy
Global $aWonThreeStar[4] = [763, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 3rd Star for winning attack on enemy
Global $aCancRequestCCBtn[4] = [333, 355 + $g_iMidOffsetYFixed, 0xD84D1E, 20] ; Orange button Cancel in window request CC
Global $aSendRequestCCBtn[3] = [518, 352 + $g_iMidOffsetYFixed, 0x6EBD1F] ; Green button Send in window request CC
Global $atxtRequestCCBtn[2] = [335, 235 + $g_iMidOffsetYFixed] ; textbox in window request CC
Global $aIsAtkDarkElixirFull[4] = [743, 62 + $g_iMidOffsetY, 0x270D33, 10] ; Attack Screen DE Resource bar is full
Global $aIsDarkElixirFull[4] = [708, 147 + $g_iMidOffsetY, 0x270D33, 10] ; Main Screen DE Resource bar is full
Global $aIsGoldFull[4] = [661, 47 + $g_iMidOffsetY, 0xE7C00D, 10] ; Main Screen Gold Resource bar is Full
Global $aIsElixirFull[4] = [661, 97 + $g_iMidOffsetY, 0xC027C0, 10] ; Main Screen Elixir Resource bar is Full
Global $aPerkBtn[4] = [95, 243 + $g_iMidOffsetY, 0x7cd8e8, 10] ; Clan Info Page, Perk Button (blue); 800x780
Global $aIsGemWindow1[4] = [573, 256 + $g_iMidOffsetY, 0xEB1316, 20] ; Main Screen, pixel left of Red X to close gem window
Global $aIsGemWindow2[4] = [577, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow3[4] = [586, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow4[4] = [595, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsTrainPgChk1[4] = [813, 80 + $g_iMidOffsetY, 0xFF8D95, 10] ; Main Screen, Train page open - left upper corner of x button
Global $aIsTrainPgChk2[4] = [762, 328 + $g_iMidOffsetY, 0xF18439, 10] ; Main Screen, Train page open - Dark Orange in left arrow
Global $aRtnHomeCloud1[4] = [56, 592 + $g_iBottomOffsetY, 0x0A223F, 15] ; Cloud Screen, during search, blue pixel in left eye
Global $aRtnHomeCloud2[4] = [72, 592 + $g_iBottomOffsetY, 0x103F7E, 15] ; Cloud Screen, during search, blue pixel in right eye
Global $aDetectLang[2] = [16, 634 + $g_iBottomOffsetY] ; Detect Language, bottom left Attack button must read "Attack"
Global $aGreenArrowTrainTroops[2] = [310, 127 + $g_iMidOffsetYFixed]
Global $aGreenArrowBrewSpells[2] = [467, 127 + $g_iMidOffsetYFixed]
Global $aGreenArrowTrainSiegeMachines[2] = [623, 127 + $g_iMidOffsetYFixed]
Global $g_aShopWindowOpen[4] = [804, 54 + $g_iMidOffsetYFixed, 0xC00508, 15] ; Red pixel in lower right corner of RED X to close shop window
Global $aTreasuryWindow[4] = [689, 138 + $g_iMidOffsetY, 0xFF8D95, 20] ; Redish pixel above X to close treasury window
Global $aAttackForTreasury[4] = [88, 619 + $g_iMidOffsetY, 0xF0EBE8, 5] ; Red pixel below X to close treasury window
Global $aAtkHasDarkElixir[4]  = [ 31, 144, 0x282020, 10] ; Attack Page, Check for DE icon
Global $aVillageHasDarkElixir[4] = [837, 134, 0x3D2D3D, 10] ; Main Page, Base has dark elixir storage

Global $aCheckTopProfile[4] = [200, 166 + $g_iMidOffsetYFixed, 0x868CAC, 5]
Global $aCheckTopProfile2[4] = [220, 355 + $g_iMidOffsetYFixed, 0x4E4D79, 5]

Global $aIsTabOpen[4] = [0, 145 + $g_iMidOffsetYFixed, 0xEAEAE3, 25];Check if specific Tab is opened, X Coordinate is a dummy

Global $aRecievedTroops[4] = [200, 215 + $g_iMidOffsetYFixed, 0xFFFFFF, 20] ; Y of You have recieved blabla from xx!

; King Health Bar, check at the middle of the bar, index 4 is x-offset added to middle of health bar
Global $aKingHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15, 13]
; Queen Health Bar, check at the middle of the bar, index 4 is x-offset added to middle of health bar
Global $aQueenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15, 8]
; Warden Health Bar, check at the middle of the bar, index 4 is x-offset added to middle of health bar
Global $aWardenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15, 3]
; Champion Health Bar, check at the middle of the bar, index 4 is x-offset added to middle of health bar
Global $aChampionHealth = [-1, 567 + $g_iBottomOffsetY, 0x00D500, 15, 7]

; attack report... stars won
Global $aWonOneStarAtkRprt[4] = [325, 180 + $g_iMidOffsetY, 0xC8CaC4, 30] ; Center of 1st Star reached attacked village
Global $aWonTwoStarAtkRprt[4] = [398, 180 + $g_iMidOffsetY, 0xD0D6D0, 30] ; Center of 2nd Star reached attacked village
Global $aWonThreeStarAtkRprt[4] = [534, 180 + $g_iMidOffsetY, 0xC8CAC7, 30] ; Center of 3rd Star reached attacked village
; pixel color: location information								BS 850MB (Reg GFX), BS 500MB (Med GFX) : location

Global $NextBtn[4] = [780, 606 + $g_iBottomOffsetYFixed, 0xE54E0D, 30] ;  Next Button
Global $NextBtnFixed[4] = [780, 507 + $g_iBottomOffsetYFixed, 0xE54E0D, 30] ; AIO Mod++
Global $a12OrMoreSlots[4] = [16, 648 + $g_iBottomOffsetYFixed, 0x4583B9, 25] ; Attackbar Check if 12+ Slots exist
Global $a12OrMoreSlots2[4] = [16, 648 + $g_iBottomOffsetYFixed, 0x7E2327, 25] ; Attackbar Check if 12+ Slots exist SuperTroops
Global $aDoubRowAttackBar[4] = [68, 486 + $g_iBottomOffsetYFixed, 0xFC5D64, 20]
Global $aTroopIsDeployed[4] = [0, 0, 0x404040, 20] ; Attackbar Remain Check X and Y are Dummies
Global Const $aIsAttackPage[4] = [18, 548 + $g_iBottomOffsetY, 0xcf0d0e, 20] ; red button "end battle" - left portion

; 1 - Dark Gray : Castle filled/No Castle | 2 - Light Green : Available or Already made | 3 - White : Available or Castle filled/No Castle
Global $aRequestTroopsAO[6] = [761, 592 + $g_iBottomOffsetYFixed, 0x565656, 0x71BA2F, 0xFFFFFE, 25] ; Button Request Troops in Army Overview  (x,y, Gray - Full/No Castle, Green - Available or Already, White - Available or Full)

Global Const $aOpenChatTab[4] = [19, 335 + $g_iMidOffsetY, 0xE88D27, 20]
Global Const $aCloseChat[4] = [331, 330 + $g_iMidOffsetY, 0xF0951D, 20] ; duplicate with $aChatTab above, need to rename and fix all code to use one?
Global Const $aChatDonateBtnColors[4][4] = [[0x0d0d0d, 0, -4, 20], [0xdaf582, 10, 0, 20], [0xcdef75, 10, 5, 20], [0xFFFFFF, 24, 9, 10]]

;attackreport
Global Const $aAtkRprtDECheck[4] = [459, 372 + $g_iMidOffsetY, 0x433350, 20]
Global Const $aAtkRprtTrophyCheck[4] = [327, 189 + $g_iMidOffsetY, 0x3B321C, 30]
Global Const $aAtkRprtDECheck2[4] = [678, 418 + $g_iMidOffsetY, 0x030000, 30]

;returnhome
Global Const $aRtnHomeCheck1[4] = [363, 548 + $g_iMidOffsetY, 0x78C11C, 20]
Global Const $aRtnHomeCheck2[4] = [497, 548 + $g_iMidOffsetY, 0x79C326, 20]

Global Const $aProfileReport[4] = [619, 344 + $g_iMidOffsetYFixed, 0x4E4D79, 20] ; Dark Purple of Profile Page when no Attacks were made

Global $aArmyTrainButtonRND[4] = [20, 540 + $g_iMidOffsetY, 55, 570 + $g_iMidOffsetY] ; Main Screen, Army Train Button, RND  Screen 860x732
Global $aAttackButtonRND[4] = [20, 610 + $g_iMidOffsetY, 100, 670 + $g_iMidOffsetY] ; Attack Button, Main Screen, RND  Screen 860x732

;Switch Account
Global $aLoginWithSupercellID[4] = [136, 578, 0xDDF685, 20] ; Upper green button section "Log in with Supercell ID" 0xDDF685
Global $aLoginWithSupercellID2[4] = [409, 603, 0x83CD2B , 20] ; Lower green button section "Log in with Supercell ID" 0x83CD2B
Global $aButtonSetting[4] = [820, 495, 0xFFFFFF, 10] ; Setting button, Main Screen ; Resolution fixed
Global $aIsSettingPage[4] = [753, 81 + $g_iMidOffsetY, 0xFF8F95, 10] ; Main Screen, Setting page open - left upper corner of x button

;Google Play
Global $aListAccount[4] = [635, 230 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Accounts list google, White
Global $aButtonVillageLoad[4] = [515, 411 + $g_iMidOffsetY, 0x6EBD1F, 20] ; Load button, Green
Global $aTextBox[4] = [320, 160 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Text box, White
Global $aButtonVillageOkay[4] = [500, 200, 0x81CA2D, 20] ; Okay button, Green

;SuperCell ID
Global $aButtonConnectedSCID[4] = [640, 160 + $g_iMidOffsetY, 0x2D89FD, 20] ; Setting screen, Supercell ID Connected button (Blue Part)
Global $aCloseTabSCID[4] = [831, 57 + $g_iMidOffsetYFixed] ; Button Close Supercell ID tab

;Train
Global $aButtonEditArmy[4] = [800, 542 + $g_iBottomOffsetYFixed, 0xDDF685, 25]
Global $aButtonRemoveTroopsOK1[4] = [747, 582 + $g_iBottomOffsetYFixed, 0x76BF2F, 20]
Global $aButtonRemoveTroopsOK2[4] = [500, 447 + $g_iBottomOffsetYFixed, 0x6DBC1F, 20]

;Change Language To English
Global $aButtonLanguage[4] = [324, 363, 0xDDF685, 20]  ; Resolution fixed
Global $aListLanguage[4] = [110, 87, 0xFFFFFF, 10]     ; Resolution fixed
Global $aEnglishLanguage[4] = [210, 140, 0xD7D5C7, 20] ; Resolution fixed
Global $aLanguageOkay[4] = [510, 400, 0x6FBD1F, 20]    ; Resolution fixed

;Personal Challenges
Global Const $aPersonalChallengeOpenButton1[4] = [149, 631 + $g_iBottomOffsetY, 0xB5CEE4, 20] ; Personal Challenge Button
Global Const $aPersonalChallengeOpenButton2[4] = [149, 631 + $g_iBottomOffsetY, 0xFDE575, 20] ; Personal Challenge Button with Gold Pass
Global Const $aPersonalChallengeOpenButton3[4] = [166, 606 + $g_iBottomOffsetY, 0xFF1815, 20] ; Personal Challenge Button with red symbol
Global Const $aPersonalChallengeCloseButton[4] = [813, 51 + $g_iMidOffsetY, 0xF51D1E, 20] ; Personal Challenge Window Close Button
Global Const $aPersonalChallengeRewardsAvail[4] = [542, 20 + $g_iMidOffsetY, 0xFF0A08, 20] ; Personal Challenge - Red symbol showing available rewards
Global Const $aPersonalChallengeRewardsTab[4] = [450, 33 + $g_iMidOffsetY, 0x988510, 20] ; Personal Challenge - Rewards tab unchecked with Gold Pass
Global Const $aPersonalChallengePerksTab[4] = [660, 33 + $g_iMidOffsetY, 0xEFE079, 20] ; Personal Challenge - Perks tab Checked
Global Const $aPersonalChallengeLeftEdge[4] = [30, 385 + $g_iMidOffsetY, 0x28221E, 20] ; Personal Challenge Window - Rewards tab - Black left edge
Global Const $aPersonalChallengeCancelBtn[4] = [350, 380 + $g_iMidOffsetY, 0xFDC875, 20] ; Personal Challenge Window - Cancel button at Storage Full msg
Global Const $aPersonalChallengeOkBtn[4] = [515, 380 + $g_iMidOffsetY, 0xDFF887, 20] ; Personal Challenge Window - Okay button at Storage Full msg
