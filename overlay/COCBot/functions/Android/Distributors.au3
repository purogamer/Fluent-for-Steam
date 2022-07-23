; #FUNCTION# ====================================================================================================================
; Name ..........: Distributors
; Description ...: This file contains the detection and get info fucntions for the COC APKs installed
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sNO_COC, $g_sUNKNOWN_COC
Global $_g_asDISTRIBUTORS[22][4] = [ _
	["Google", "com.supercell.clashofclans", "com.supercell.titan.GameApp", "Google"], _
	["Kunlun", "com.supercell.clashofclans.kunlun", "com.supercell.titan.kunlun.GameAppKunlun", "Kunlun"], _
	["Qihoo", "com.supercell.clashofclans.qihoo", "com.supercell.titan.kunlun.GameAppKunlun","Qihoo"], _
	["Baidu", "com.supercell.clashofclans.baidu", "com.supercell.titan.kunlun.GameAppKunlun", "Baidu"], _
	["9game", "com.supercell.clashofclans.uc", "com.supercell.titan.kunlun.uc.GameAppKunlunUC", "9game"], _
	["Wandoujia/Downjoy", "com.supercell.clashofclans.wdj", "com.supercell.titan.kunlun.GameAppKunlun", "Wandoujia/Downjoy"], _
	["Huawei", "com.supercell.clashofclans.huawei", "com.supercell.titan.kunlun.GameAppKunlun", "Huawei"], _
	["OPPO", "com.supercell.clashofclans.nearme.gamecenter", "com.supercell.titan.kunlun.GameAppKunlun", "OPPO"], _
	["VIVO", "com.supercell.clashofclans.vivo", "com.supercell.titan.kunlun.GameAppKunlun", "VIVO"], _
	["Anzhi", "com.supercell.clashofclans.anzhi", "com.supercell.titan.kunlun.GameAppKunlun", "Anzhi"], _
	["Kaopu", "com.supercell.clashofclans.ewan.kaopu", "com.supercell.titan.kunlun.GameAppKunlun", "Kaopu"], _
	["Lenovo", "com.supercell.clashofclans.lenovo", "com.lenovo.lsf.gamesdk.ui.WelcomeActivity", "Lenovo"], _
	["Guopan", "com.supercell.clashofclans.guopan", "com.flamingo.sdk.view.GPSplashActivity", "Guopan"], _
	["Xiaomi", "com.supercell.clashofclans.mi", "com.supercell.titan.kunlun.mi.GameAppKunlunXiaomi","Xiaomi"], _
	["Haimawan", "com.supercell.clashofclans.ewan.hm", "cn.ewan.supersdk.activity.SplashActivity", "Haimawan"], _
	["Leshi", "com.supercell.clashofclans.ewan.leshi", "cn.ewan.supersdk.activity.SplashActivity", "Leshi"], _
	["Microvirt", "com.supercell.clashofclans.ewan.xyaz", "cn.ewan.supersdk.activity.SplashActivity", "Microvirt"], _
	["Yeshen", "com.supercell.clashofclans.ewan.yeshen", "cn.ewan.supersdk.activity.SplashActivity","Yeshen"], _
	["Aiyouxi", "com.supercell.clashofclans.ewan.egame", "cn.ewan.supersdk.activity.SplashActivity","Aiyouxi"], _
	["Tencent", "com.tencent.tmgp.supercell.clashofclans", "com.supercell.titan.tencent.GameAppTencent","Tencent"], _
	["Ewan", "com.supercell.clashofclans.ewan", "com.supercell.titan.kunlun.GameAppKunlun","Ewan"], _
	["Cocserver", "co.cocserver.s3v4", "com.atrasis.main.GameMain","CoCServer S3"]]


Func InitializeCOCDistributors() ;initialized in InitializeMBR() after language is detected
	$g_sNO_COC = "<" & GetTranslatedFileIni("MBR Distributors", "NO_COC", "No COC") & ">"
	$g_sUNKNOWN_COC = "<" & GetTranslatedFileIni("MBR Distributors", "Unknown_COC", "Unknown COC") & ">"
EndFunc   ;==>InitializeCOCDistributors

Func GetCOCDistributors()
	FuncEnter(GetCOCDistributors)
	Static $s_asDistributorsLoaded = -1
	If $s_asDistributorsLoaded <> -1 And Not IsBotLaunched() Then Return FuncReturn($s_asDistributorsLoaded) ; retutn cached list only during bot launch to prevent rare freeze due to CTRITICAL_SECTION deack lock
	SetDebugLog("Retrieving CoC distributors")
	Local $sPkgList = StringReplace(AndroidAdbSendShellCommand("pm list packages clashofclans;pm list packages cocserver"), "package:", "")
	If @error <> 0 Or $sPkgList = "" Then Return FuncReturn(SetError(1, 0, "")) ; ADB error or No COC installed error

	Local $aPkgList = StringSplit($sPkgList, @LF, $STR_ENTIRESPLIT)
	Local $aDList[0]
	Local $bFirstTimeWDJ = True
	Local $iIndex, $wasSilentSetLog

	For $i = 1 To $aPkgList[0]
		$iIndex = _ArraySearch($_g_asDISTRIBUTORS, $aPkgList[$i], 0, 0, 0, 0, 1, 1)
		If @error = 6 Then ; not found
			$wasSilentSetLog = $g_bSilentSetLog
			$g_bSilentSetLog = True
			SetLog("Unrecognized COC Package: " & $aPkgList[$i])
			$g_bSilentSetLog = $wasSilentSetLog
			If $aPkgList[$i] = $g_sUserGamePackage Then _ArrayAdd($aDList, $g_sUserGameDistributor, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING) ;add unknown installed apk info here when matched users ini
		Else
			If $iIndex <> 5 Then
				_ArrayAdd($aDList, $_g_asDISTRIBUTORS[$iIndex][3], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
			Else
				If $bFirstTimeWDJ Then ; Speciall treatment for wdj same name package
					_ArrayAdd($aDList, $_g_asDISTRIBUTORS[5][3], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
					_ArrayAdd($aDList, $_g_asDISTRIBUTORS[12][3], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
					$bFirstTimeWDJ = False
				EndIf
			EndIf
		EndIf
	Next
	If Not IsBotLaunched() Then $s_asDistributorsLoaded = $aDList
	If UBound($aDList) = 0 Then Return FuncReturn(SetError(2, 0, "")) ; All are unrecognized COC packages error
	Return FuncReturn(SetError(0, 0, $aDList))
EndFunc   ;==>GetCOCDistributors

Func GetCOCPackage($sDistributor)
	Local $iIndex = _ArraySearch($_g_asDISTRIBUTORS, $sDistributor, 0, 0, 0, 0, 1, 3)
	If @error = 6 Then ; not found
		Return SetError(1, 0, "")
	Else
		Return SetError(0, 0, $_g_asDISTRIBUTORS[$iIndex][1])
	EndIf
EndFunc   ;==>GetCOCPackage

Func GetCOCClass($sDistributor)
	Local $iIndex = _ArraySearch($_g_asDISTRIBUTORS, $sDistributor, 0, 0, 0, 0, 1, 3)
	If @error = 6 Then ; not found
		Return SetError(1, 0, "")
	Else
		Return SetError(0, 0, $_g_asDISTRIBUTORS[$iIndex][2])
	EndIf
EndFunc   ;==>GetCOCClass

Func GetCOCUnTranslated($sDistributor)
	Local $iIndex = _ArraySearch($_g_asDISTRIBUTORS, $sDistributor, 0, 0, 0, 0, 1, 3)
	If @error = 6 Then ; not found
		Return SetError(1, 0, $sDistributor)
	Else
		Return SetError(0, 0, $_g_asDISTRIBUTORS[$iIndex][0])
	EndIf
EndFunc   ;==>GetCOCUnTranslated

Func GetCOCTranslated($sDistributor)
	Local $iIndex = _ArraySearch($_g_asDISTRIBUTORS, $sDistributor, 0, 0, 0, 0, 1, 0)
	If @error = 6 Then ; not found
		Return SetError(1, 0, $sDistributor)
	Else
		Return SetError(0, 0, $_g_asDISTRIBUTORS[$iIndex][3])
	EndIf
EndFunc   ;==>GetCOCTranslated
