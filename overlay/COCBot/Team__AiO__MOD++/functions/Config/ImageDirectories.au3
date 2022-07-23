; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for Image Search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#Region - One Gem Boost - Team AiO MOD++
Global $g_sImgOneGemBoostOCR = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Boost\BoostOcr\"
#EndRegion - One Gem Boost - Team AiO MOD++

#Region BuilderBaseCustomArmy
Global $g_sImgCustomArmyBB = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\Attack\VersusBattle\ChangeTroops\"
Global $aArmyTrainButtonBB = [46, 572, 0xE5A439, 10]
Global Const $g_sImgPathFillArmyCampsWindow = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\FillArmyCamps\Window\"
Global Const $g_sImgPathTroopsTrain = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\FillArmyCamps\TroopsTrain\"
Global Const $g_sImgPathCamps = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\FillArmyCamps\Bundles\Camps\"
#EndRegion BuilderBaseCustomArmy

#Region SuperXP
Global $g_sImgFindSX = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\SuperXP\Find\"
Global $g_sImgLockedSX = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\SuperXP\Locked\"
#EndRegion SuperXP

#Region Humanization
Global $g_sImgHumanizationWarLog = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\WarLog"
Global $g_sImgHumanizationDuration = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\Duration"
Global $g_sImgHumanizationFriend = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\Friend"
Global $g_sImgHumanizationClaimReward = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\ClaimReward"
; Global $g_sImgHumanizationCurrentWar = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\CurrentWar"
Global $g_sImgHumanizationWarDetails = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\WarDetails"
Global $g_sImgHumanizationReplay = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\Replay"
Global $g_sImgHumanizationVisit = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\Visit"
Global $g_sImgChatIUnterstandMultiLang = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Humanization\Chat"
#EndRegion Humanization

#Region DailyDiscounts
Global $g_sImgDirDailyDiscounts = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\DailyDiscounts"
Global $g_sImgDDWallRingx5 = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\DailyDiscounts\WallRingAmount\x5_92.png"
Global $g_sImgDDWallRingx10 = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\DailyDiscounts\WallRingAmount\x10_92.png"
#EndRegion DailyDiscounts

#Region ChatActions
Global $g_sImgChatObstacles = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\ChatActions\FriendlyChallenge"
#EndRegion ChatActions

#Region GTFO
Global $g_sImgKickOut = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\GTFO\KickOut"
Global $g_sImgClanProfilePage = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Pages\Profile"
#EndRegion GTFO

#Region MagicItems
Global $g_sImgPotionsBtn = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\MagicItems\Btn"
Global $g_sImgPotionsBtnArmy = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\MagicItems\BtnArmy"
#EndRegion MagicItems

#Region CustomArmy
Global $g_sImgArmyOverviewTroopQueued = @ScriptDir & "\imgxml\ArmyOverview\TroopQueued\"
#EndRegion CustomArmy

#Region CustomRequest
Global $g_sImgArmyRequestCC = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Request"
#EndRegion CustomRequest

#Region Builder Base
Global $g_sModImageLocation = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Old"

;Machine Upgrade
Global Const $g_sXMLTroopsUpgradeMachine = $g_sModImageLocation & "\BuildersBase\TroopsUpgrade\Machine"

; Builder Base
Global Const $g_sImgPathIsCTBoosted = $g_sModImageLocation & "\BuildersBase\ClockTowerBoosted"
Global Const $g_sImgBBLootAvail = @ScriptDir & "\imgxml\Attack\BuilderBase\LootAvail\"

; Builder Base Attack
Global $g_aOpponentVillageVisible[1][3] = [[0xFED5D4, 0, 1]] ; more ez ; samm0d

Global Const $g_sBundleBuilderHall = $g_sModImageLocation & "\BuildersBase\Bundles\AttackBuildings\BuilderHall"
Global Const $g_sBundleDeployPointsBB = $g_sModImageLocation & "\BuildersBase\Bundles\AttackBuildings\DeployPoints"

Global Const $g_sImgOpponentBuildingsBB = $g_sModImageLocation & "\BuildersBase\Bundles\AttackBuildings\"

Global Const $g_sImgAttackBtnBB = $g_sModImageLocation & "\BuildersBase\Attack\AttackBtn\"
Global Const $g_sImgVersusWindow = $g_sModImageLocation & "\BuildersBase\Attack\VersusBattle\Window\"
; Global Const $g_sImgCloudSearch = $g_sModImageLocation & "\BuildersBase\Attack\VersusBattle\Clouds\"

; Report Window : Victory | Draw | Defeat
Global Const $g_sImgReportWaitBB = $g_sModImageLocation & "\BuildersBase\Attack\VersusBattle\Report\Waiting\"
Global Const $g_sImgReportFinishedBB = $g_sModImageLocation & "\BuildersBase\Attack\VersusBattle\Report\Thr\"
#EndRegion Builder Base

#Region Builder Base Walls Upgrade
Global Const $g_sBundleWallsBB = $g_sModImageLocation & "\BuildersBase\Bundles\Walls"
;Global Const $g_aBundleWallsBBParms[3] = [0, "0,50,860,732", False] ; [0] Quantity2Match [1] Area2Search [2] ForceArea
#EndRegion Builder Base Walls Upgrade

#Region - MagicItems
Global Const $g_sImgTraderMod = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\Traderfix"
#EndRegion - MagicItems

#Region - Auto Locate
Global Const $g_sImgLocationLabs = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\AutoLocate\Lab\"
Global Const $g_sImgLocationKing =	@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\AutoLocate\King\"
Global Const $g_sImgLocationQueen =	@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\AutoLocate\Queen\"
Global Const $g_sImgLocationChamp =	@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\AutoLocate\Champion\"
Global Const $g_sImgLocationWarden = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\AutoLocate\Warden\"
Global Const $g_sImgLocationCastle = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\AutoLocate\Castle\"
Global Const $g_sImgLocationPetHouse =  @ScriptDir & "\imgxml\Buildings\PetHouse\"
#EndRegion - Auto Locate

#Region - Chk no league
Global Const $g_sImgNoLeague = @ScriptDir & "\COCBot\Team__AiO__MOD++\Images\NoLeague\"
#EndRegion - Chk no league

#Region - Pets
Global Const $g_sImgpetsHouseSelection = @ScriptDir & "\imgxml\Pets\SelectedHeroes\"
Global Const $g_sImgpetsHouseHeroes = @ScriptDir & "\imgxml\Pets\Heroes\"
#EndRegion - Pets

#Region - DMatchingBundles.au3
; #FUNCTION# ====================================================================================================================
; Name ..........: DMatchingBundles.au3
; Description ...: Dissociable.Matching.dll Bundles
; Author ........: Dissociable (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_sBaseDMatchingPathB = @ScriptDir & "\COCBot\Team__AiO__MOD++\Bundles\Image Matching"

; Deadbase, Elixir Collectors.
Global $g_sECollectorDMatB = $g_sBaseDMatchingPathB & "\deadbase\Elixir\"

; DPBB !
Global Const $g_sBundleDeployPointsBBD = $g_sBaseDMatchingPathB & "\DPBB\"

; Cross 
Global Const $g_sCrossX = $g_sBaseDMatchingPathB & "\Cross\"

; New DB.
Global Const $g_sBundleDefensesEagle = $g_sBaseDMatchingPathB & "\deadbase\Defenses\Eagle\"

; Forge 
Global Const $g_sForgeCollect = $g_sBaseDMatchingPathB & "\Forge\Collect\"

;Clan Capital
; 105, 93, 754, 673
; DMClassicArray(DFind("C:\Users\Admin\Documents\AIO-Mod\COCBot\Team__AiO__MOD++\Bundles\Image Matching\ClanCapital\Locked\", 105, 93, 754, 673, 0, 0, 1000, True), 10, $g_bDebugImageSave)
Global Const $g_sClanCapitalLocked = $g_sBaseDMatchingPathB & "\ClanCapital\Locked\"
;298, 1, 415, 37
; DMClassicArray(DFind($g_sBaseDMatchingPathB & "\ClanCapital\Info\", 298, 1, 415, 37, 0, 0, 1000, True), 10, $g_bDebugImageSave)
Global Const $g_sClanCapitalInfo = $g_sBaseDMatchingPathB & "\ClanCapital\Info\"
; 427, 73, 573, 370
; DMClassicArray(DFind($g_sBaseDMatchingPathB & "\ClanCapital\AutoUpgrade\GoldIconAutoInProgress\", 427, 73, 573, 370, 0, 0, 1000, True), 10, $g_bDebugImageSave)
Global Const $g_sClanCapitalInProgress = $g_sBaseDMatchingPathB & "\ClanCapital\AutoUpgrade\GoldIconAutoInProgress\"

; RedLine
Global Const $g_sBundleRedLineNV = $g_sBaseDMatchingPathB & "\RedLine\"
; DMClassicArray(DFind($g_sBundleRedLineNV, 0, 0, 0, 0, 0, 0, 1000, True), 10, $g_bDebugImageSave)

#EndRegion - DMatchingBundles.au3

; #FUNCTION# ====================================================================================================================
; Name ..........: DOCRBundles.au3
; Description ...: OCR Bundles Paths
; Author ........: Dissociable (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sBaseDOCRPathB = @ScriptDir & "\COCBot\Team__AiO__MOD++\Bundles\OCR"

; MainScreen.
Global $g_sMainResourcesDOCRB = $g_sBaseDOCRPathB & "\MainScreen\Resources.docr"
Global $g_sMainBuildersDOCRB = $g_sBaseDOCRPathB & "\MainScreen\Builders.docr"

; Search for villages.
Global $g_sAttackRGold = $g_sBaseDOCRPathB & "\AttackResources\Gold.docr"
Global $g_sAttackRPink = $g_sBaseDOCRPathB & "\AttackResources\Elixir.docr"
Global $g_sAttackRBlack = $g_sBaseDOCRPathB & "\AttackResources\DarkE.docr"

Global $g_sAOverviewTotals = $g_sBaseDOCRPathB & "\ArmyOverview\ArmyPage-Totals.docr"

; AttackBar.
Global $g_sAttackBarDOCRB = $g_sBaseDOCRPathB & "\AttackBar.docr"

; AttackScreen Buttons
Global $g_sASButtonsDOCRPath = $g_sBaseDOCRPathB & "\AttackScreen\Buttons"

; Upgrade resources.
Global $g_sASUpgradeResourcesDOCRPath = $g_sBaseDOCRPathB & "\UpgradeResources\OK.docr"
Global $g_sASUpgradeResourcesRedDOCRPath = $g_sBaseDOCRPathB & "\UpgradeResources\Red.docr"

; Gems
Global $g_sASGemsSDOCRPath = $g_sBaseDOCRPathB & "\GemsS\"

; getOcrAndCaptureDOCR($g_sASForgeValueDOCRPath, 585, 475, 855, 565, True, True)