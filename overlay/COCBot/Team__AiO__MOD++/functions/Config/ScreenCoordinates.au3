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

;Clan Hop
Global $aJoinClanBtn[4] = [157, 510 + $g_iBottomOffsetYFixed, 0x6CBB1F, 20] ; Green Join Button on Chat Tab when you are not in a Clan
Global $aClanPage[4] = [725, 410 + $g_iBottomOffsetYFixed, 0xEF5D5F, 20] ; Red Leave Clan Button on Clan Page
Global $aClanPageJoin[4] = [720, 407 + $g_iBottomOffsetYFixed, 0xBCE764, 20] ; Green Join Clan Button on Clan Page
Global $aJoinClanPage[4] = [755, 319 + $g_iBottomOffsetYFixed, 0xE8C672, 20] ; Trophy Amount of Clan Background of first Clan
Global $aClanChat[4] = [83, 650 + $g_iBottomOffsetYFixed, 0x8BD004, 30] ; *Your Name* joined the Clan Message Check to verify loaded Clan Chat
Global $aClanBadgeNoClan[4] = [150, 315, 0xEB4C30, 20] ; Orange Tile of Clan Logo on Chat Tab if you are not in a Clan
Global $aClanChatRules[4] = [158, 493 + $g_iBottomOffsetYFixed, 0x6CB531, 20]
Global $aClanNameBtn[2] = [89, 63 + $g_iMidOffsetYFixed] ; Button to open Clan Page from Chat Tab

;Chat Actions
Global $aGlobalChatTab[4] = [20, 24, 0x706C50, 20] ; Global Chat Tab on Top, check if right one is selected
Global $aClanChatTab[4] = [170, 24, 0x706C50, 20] ; Clan Chat Tab on Top, check if right one is selected
Global $aChatRules[4] = [75, 495 + $g_iBottomOffsetYFixed, 0xB4E35C, 20]
Global $aChatSelectTextBox[4] = [277, 700 + $g_iBottomOffsetYFixed, 0xFFFFFF, 10] ; color white Select Chat Textbox
Global $aOpenedChatSelectTextBox[4] = [100, 700 + $g_iBottomOffsetYFixed, 0xFFFFFF, 10] ; color white Select Chat Textbox Opened
Global $aChatSendBtn[4] = [840, 700 + $g_iBottomOffsetYFixed, 0xFFFFFF, 10] ; color white Send Chat Textbox
Global $aSelectLangBtn[2] = [260, 415 + $g_iBottomOffsetYFixed] ; On Setting screen select language button
Global $aOpenedSelectLang[4] = [90, 113 + $g_iMidOffsetYFixed, 0xD7F37F, 20] ; On Setting screen language screen back button
Global $aLangSelected[4] = [118, 185 + $g_iMidOffsetYFixed, 0xCAFF40, 20] ; V color green to the left of the language
Global $aLangSettingOK[4] = [506, 446 + $g_iBottomOffsetYFixed, 0x6DBC1F, 20] ; Language Selection Dialog Ok button

Global $aButtonFriendlyChallenge[4] = [200, 695 + $g_iBottomOffsetYFixed, 0xDDF685, 20]
Global $aButtonFCChangeLayout[4] = [240, 286 + $g_iMidOffsetYFixed, 0XDDF685, 20]
Global $aButtonFCBack[4] = [160, 106 + $g_iMidOffsetYFixed, 0xD5F27D, 20]
Global $aButtonFCStart[4] = [638, 285 + $g_iMidOffsetYFixed, 0xDDF685, 20]

; Super XP
Global $aLootInfo[5] = [300, 590 + $g_iBottomOffsetYFixed, 0xFFFFFF, 0xFFFFFF, 10] ; Color in the frame of Loot Available info
Global $aEndMapPosition[4] = [337, 664 + $g_iBottomOffsetYFixed, 0x403828, 10] ; Safe Coordinates To Avoid Conflict With Stars Color - June Update 2019
Global $aFirstMapPosition[4] = [752, 139 + $g_iMidOffsetYFixed, 0x403828, 15] ; Safe Coordinates To Avoid Conflict With Stars Color - June Update 2019
Global $aCloseSingleTab[4] = [808, 70 + $g_iMidOffsetYFixed, 0xFF8D95, 20] ; X color red on the 'Close' button
Global $aIsInAttack[4] = [60, 576 + $g_iBottomOffsetYFixed, 0x0A0A0A, 10] ; color black on the 'End Battle' button
Global Const $EndBattleText1[4] = [30, 565 + $g_iMidOffsetY, 0xFFFFFF, 10] ; color white 'E' on the 'End Battle' button
Global Const $EndBattleText2[4] = [377, 244 + $g_iMidOffsetY, 0xFFFFFF, 10] ; color white 'n' on the 'End Battle' popup
Global Const $ReturnHomeText[4] = [373, 545 + $g_iMidOffsetY, 0xFFFFFF, 10] ; color white 'R' on the 'Return Home' button
Global $aEarnedStar[4] = [455, 405 + $g_iBottomOffsetYFixed, 0xD0D8D0, 20] ; color gray in the star in the middle of the screen
Global $aOneStar[4] = [714, 594 + $g_iBottomOffsetYFixed, 0xD2D4CE, 20] ; color gray in the 'one star' in the bottom right of the screen
Global $aTwoStar[4] = [739, 594 + $g_iBottomOffsetYFixed, 0xD2D4CE, 20] ; color gray in the 'tow star' in the bottom right of the screen
Global $aThreeStar[4] = [764, 594 + $g_iBottomOffsetYFixed, 0xD2D4CE, 20] ; color gray in the 'three star' in the bottom right of the screen
Global $aIsLaunchSinglePage[4] = [830, 48, 0x98918F, 15] ; color brown in the 'Single Player' popup

; GTFO
Global Const $g_aClanBadgeNoClan[4] = [151, 307 + $g_iMidOffsetYFixed, 0xF05538, 20] ; OK - Orange Tile of Clan Logo on Chat Tab if you are not in a Clan
Global Const $g_aShare[4] = [438, 190 + $g_iMidOffsetYFixed, 0xFFFFFF, 20] ; OK - Share clan
Global Const $g_aCopy[4] = [512, 182 + $g_iMidOffsetYFixed, 0xDDF685, 20] ; OK - Copy button
Global Const $g_aClanPage[4] = [821, 400 + $g_iBottomOffsetYFixed, 0xFB5D63, 20] ; OK - Red Leave Clan Button on Clan Page
Global Const $g_aClanLabel[4] = [522, 70 + $g_iMidOffsetYFixed, 0xEDEDE8, 20] ; OK - Select white label
Global Const $g_aJoinClanBtn[4] = [821, 400 + $g_iBottomOffsetYFixed, 0xDBF583, 25] ; OK - Join Button on Tab
Global Const $g_aIsClanChat[4] = [86, 12, 0xC1BB91, 20] ; OK - Verify is in clan.
Global Const $g_aNoClanBtn[4] = [163, 515 + $g_iBottomOffsetYFixed, 0x6DBB1F, 20] ; OK - Green Join Button on Chat Tab when you are not in a Clan
Global Const $g_aOKBtn[5] = [494, 409 + $g_iMidOffsetYFixed, 0xE0F989, 20, 500] ; OK - Fast OK button.
Global Const $g_aJoinInvBtn[5] = [524, 215 + $g_iMidOffsetYFixed, 0xDFF886, 20, 500] ; OK - Join invitation button.

; RequestFromChat
Global Const $g_aReqGem[4] = [98, 695 + $g_iBottomOffsetYFixed, 0xD7F57F, 20]
Global Const $g_aReqOk[4] = [56, 695 + $g_iBottomOffsetYFixed, 0xD7F57F, 20]
Global Const $g_aReqGrayedOut[4] = [56, 695 + $g_iBottomOffsetYFixed, 0xE0E0E0, 20]

; Humanization
Global Const $g_aHumanizationReplayArea[4] = [780, 210 + $g_iMidOffsetY, 840, 610 + $g_iBottomOffsetY]

; Builder Base
Global Const $g_aBBBlackArts[4] = [700, 575, 0x000000, 5]

; Buy Shield
Global Const $g_aShopOpen[4] = [808, 50, 0xE41115, 15]
Global Const $g_aGuardAvailable[4] = [398, 218 + $g_iMidOffsetYFixed, 0x327AB2, 20]

; Star Bonus
Global Const $g_aSbonusWindowChk1[4] = [640, 184 + $g_iMidOffsetY, 0xCD1A1F, 15] ; Red X to close Window
Global Const $g_aSbonusWindowChk2[4] = [650, 462 + $g_iBottomOffsetY, 0xE8E8E0, 10] ; White pixel on top trees where it does not belong

; Pet House
Global Const $g_iPetUnlockedxCoord[4] = [190, 345, 500, 655]
Global Const $g_iPetLevelxCoord[4] = [134, 288, 443, 598]

; Clan Games
Global Const $g_aEventFailed[4] = [300, 255 + $g_iMidOffsetYFixed, 0xEA2B24, 20]
Global Const $g_aEventPurged[4] = [300, 266 + $g_iMidOffsetYFixed, 0x57c68f, 20]
Global Const $g_aGameTime[4] = [384, 388 + $g_iMidOffsetYFixed, 0xFFFFFF, 10]

; Sugested upgrades
Global Const $g_aMasterBuilder[4] = [360, 11, 0x7cbdde, 10] ; Master Builder Check pixel [i] icon

; Builder base
Global Const $g_aOkayBtnBB = [664, 465 + $g_iMidOffsetYFixed, 0xD9F481, 30] ; Resolution changed
Global Const $g_aOnVersusBattleWindowBB = [375, 245 + $g_iMidOffsetYFixed, 0xE8E8E0, 20] ; Resolution changed
Global Const $g_aFindBattleBB = [592, 301 + $g_iMidOffsetYFixed, 0xFFC949, 30] ; Resolution changed
Global Const $g_aIsAttackBB = [550, 345 + $g_iMidOffsetYFixed, 0xFEFFFF, 20] ; Resolution changed
