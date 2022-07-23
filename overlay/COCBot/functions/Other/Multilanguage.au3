; #FUNCTION# ====================================================================================================================
; Name ..........: Multilanguage
; Description ...: This file contains functions to read and write the Multilanguage .ini files and Translate the texts
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-11), Hervidero (2015-11), Boju (2017-04)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetTranslated($iSection = -1, $iKey = -1, $sText = "", $var1 = Default, $var2 = Default, $var3 = Default)
    Static $aLanguage[1][1] ;undimmed language array

	$sText = StringReplace($sText, @CRLF, "\r\n")

	Local $sDefaultText, $g_sLanguageText

	;If GetTranslated was called without correct parameters return value -2 to show the coder there is a mistake made somewhere (debug)
	If $g_bDebugMultilanguage Then Return ($iSection & "-" & $iKey)
	If $iSection = -1 Or $iKey = -1 Or $sText = "" Then Return "-2"

	Local $bOutBound = False
	If $iSection >= UBound($aLanguage, $UBOUND_ROWS) Or $iKey >= UBound($aLanguage, $UBOUND_COLUMNS) Then $bOutBound = True
	If $bOutBound = True Then ReDim $aLanguage[$iSection + 1][$iKey + 1]

	If $aLanguage[$iSection][$iKey] <> "" Then Return $aLanguage[$iSection][$iKey] ; Return from array if it was already parsed.

	If $g_sLanguage = $g_sDefaultLanguage Then ; default English

		$sDefaultText = IniRead($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, "-3")

		If $sText = "-1" Then  ; check for "-1" if text repeated
			If $sDefaultText <> "-3" Then  ; check if text exists inside file
				$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
				$aLanguage[$iSection][$iKey] = $sDefaultText
				Return $sDefaultText ; will also return "-1" as debug if english.ini does not contain the correct section/key
			Else
				Return "-3"  ; Show -3 error code in GUI to show read error and no text in file
			EndIf
		EndIf

		If $sDefaultText <> $sText Then
			IniWrite($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, $sText) ; Rewrite Default English.ini with new text value
			$sText = GetTranslatedParsedText($sText, $var1, $var2, $var3)
			$aLanguage[$iSection][$iKey] = $sText
			Return $sText
		Else
			$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
			$aLanguage[$iSection][$iKey] = $sDefaultText
			Return $sDefaultText
		EndIf
	Else ; translated language
		$g_sLanguageText = IniRead($g_sDirLanguages & $g_sLanguage & ".ini", $iSection, $iKey, "-3")

		If $sText = "-1" Then
			If $g_sLanguageText = "-3" Then
				$sDefaultText = IniRead($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, $sText)
				$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
				$aLanguage[$iSection][$iKey] = $sDefaultText
				Return $sDefaultText ; will also return "-1" as debug if english.ini does not contain the correct section/key
			Else
				$g_sLanguageText = GetTranslatedParsedText($g_sLanguageText, $var1, $var2, $var3)
				$aLanguage[$iSection][$iKey] = $g_sLanguageText
				Return $g_sLanguageText
			EndIf
		EndIf

		If $g_sLanguageText = "-3" Then
			IniWrite($g_sDirLanguages & $g_sLanguage & ".ini", $iSection, $iKey, $sText) ; Rewrite Language.ini with new untranslated Default text value
			$sText = GetTranslatedParsedText($sText, $var1, $var2, $var3)
			$aLanguage[$iSection][$iKey] = $sText
			Return $sText
		EndIf

		$g_sLanguageText = GetTranslatedParsedText($g_sLanguageText, $var1, $var2, $var3)
		$aLanguage[$iSection][$iKey] = $g_sLanguageText
		Return $g_sLanguageText
	EndIf
EndFunc   ;==>GetTranslated

Func GetTranslatedParsedText($sText, $var1 = Default, $var2 = Default, $var3 = Default)
	Local $s = StringReplace(StringReplace($sText, "\r\n", @CRLF), "\n", @CRLF)
	If $var1 = Default Then Return $s
	If $var2 = Default Then Return StringFormat($sText, $var1)
	If $var3 = Default Then Return StringFormat($sText, $var1, $var2)
	Return StringFormat($sText, $var1, $var2, $var3)
EndFunc   ;==>GetTranslatedParsedText

;DetectLanguage()
Func DetectLanguage()
    Local $decimalCode = "", $countryCode = "", $langName = ""
	$g_sLanguage = IniRead($g_sProfileConfigPath, "other", "language", "")
	If Not FileExists(@ScriptDir & "\Languages\" & $g_sLanguage & ".ini") Then $g_sLanguage = ""
	If $g_sLanguage = "" Then
		Local $OSLang = @OSLang
		SetDebugLog("Detected language code: " & $OSLang)
		Switch $OSLang;get language

			Case Hex(0x0004, 4)
				$decimalCode = '4'
				$countryCode = 'zh-CHS'
				$langName = 'Chinese_S'
			Case Hex(0x0401, 4)
				$decimalCode = '1025'
				$countryCode = 'ar-SA'
				$langName = 'Arabic'
			Case Hex(0x0402, 4)
				$decimalCode = '1026'
				$countryCode = 'bg-BG'
				$langName = 'Bulgarian'
			Case Hex(0x0403, 4)
				$decimalCode = '1027'
				$countryCode = 'ca-ES'
				$langName = 'Catalan'
			Case Hex(0x0404, 4)
				$decimalCode = '1028'
				$countryCode = 'zh-TW'
				$langName = 'Chinese_T'
			Case Hex(0x0405, 4)
				$decimalCode = '1029'
				$countryCode = 'cs-CZ'
				$langName = 'Czech'
			Case Hex(0x0406, 4)
				$decimalCode = '1030'
				$countryCode = 'da-DK'
				$langName = 'Danish'
			Case Hex(0x0407, 4)
				$decimalCode = '1031'
				$countryCode = 'de-DE'
				$langName = 'German'
			Case Hex(0x0408, 4)
				$decimalCode = '1032'
				$countryCode = 'el-GR'
				$langName = 'Greek'
			Case Hex(0x0409, 4)
				$decimalCode = '1033'
				$countryCode = 'en-US'
				$langName = 'English'
			Case Hex(0x040A, 4)
				$decimalCode = '1034'
				$countryCode = 'es-ES_tradnl'
				$langName = 'Spanish'
			Case Hex(0x040B, 4)
				$decimalCode = '1035'
				$countryCode = 'fi-FI'
				$langName = 'Finnish'
			Case Hex(0x040C, 4)
				$decimalCode = '1036'
				$countryCode = 'fr-FR'
				$langName = 'French'
			Case Hex(0x040D, 4)
				$decimalCode = '1037'
				$countryCode = 'he-IL'
				$langName = 'Hebrew'
			Case Hex(0x040E, 4)
				$decimalCode = '1038'
				$countryCode = 'hu-HU'
				$langName = 'Hungarian'
			Case Hex(0x040F, 4)
				$decimalCode = '1039'
				$countryCode = 'is-IS'
				$langName = 'Icelandic'
			Case Hex(0x0410, 4)
				$decimalCode = '1040'
				$countryCode = 'it-IT'
				$langName = 'Italian'
			Case Hex(0x0411, 4)
				$decimalCode = '1041'
				$countryCode = 'ja-JP'
				$langName = 'Japanese'
			Case Hex(0x0412, 4)
				$decimalCode = '1042'
				$countryCode = 'ko-KR'
				$langName = 'Korean'
			Case Hex(0x0413, 4)
				$decimalCode = '1043'
				$countryCode = 'nl-NL'
				$langName = 'Dutch'
			Case Hex(0x0414, 4)
				$decimalCode = '1044'
				$countryCode = 'nb-NO'
				$langName = 'Norwegian'
			Case Hex(0x0415, 4)
				$decimalCode = '1045'
				$countryCode = 'pl-PL'
				$langName = 'Polish'
			Case Hex(0x0416, 4)
				$decimalCode = '1046'
				$countryCode = 'pt-BR'
				$langName = 'Portuguese'
			Case Hex(0x0417, 4)
				$decimalCode = '1047'
				$countryCode = 'rm-CH'
				$langName = 'Romansh'
			Case Hex(0x0418, 4)
				$decimalCode = '1048'
				$countryCode = 'ro-RO'
				$langName = 'Romanian'
			Case Hex(0x0419, 4)
				$decimalCode = '1049'
				$countryCode = 'ru-RU'
				$langName = 'Russian'
			Case Hex(0x041A, 4)
				$decimalCode = '1050'
				$countryCode = 'hr-HR'
				$langName = 'Croatian'
			Case Hex(0x041B, 4)
				$decimalCode = '1051'
				$countryCode = 'sk-SK'
				$langName = 'Slovak'
			Case Hex(0x041C, 4)
				$decimalCode = '1052'
				$countryCode = 'sq-AL'
				$langName = 'Albanian'
			Case Hex(0x041D, 4)
				$decimalCode = '1053'
				$countryCode = 'sv-SE'
				$langName = 'Swedish'
			Case Hex(0x041E, 4)
				$decimalCode = '1054'
				$countryCode = 'th-TH'
				$langName = 'Thai'
			Case Hex(0x041F, 4)
				$decimalCode = '1055'
				$countryCode = 'tr-TR'
				$langName = 'Turkish'
			Case Hex(0x0420, 4)
				$decimalCode = '1056'
				$countryCode = 'ur-PK'
				$langName = 'Urdu'
			Case Hex(0x0421, 4)
				$decimalCode = '1057'
				$countryCode = 'id-ID'
				$langName = 'Indonesian'
			Case Hex(0x0422, 4)
				$decimalCode = '1058'
				$countryCode = 'uk-UA'
				$langName = 'Ukrainian'
			Case Hex(0x0423, 4)
				$decimalCode = '1059'
				$countryCode = 'be-BY'
				$langName = 'Belarusian'
			Case Hex(0x0424, 4)
				$decimalCode = '1060'
				$countryCode = 'sl-SI'
				$langName = 'Slovenian'
			Case Hex(0x0425, 4)
				$decimalCode = '1061'
				$countryCode = 'et-EE'
				$langName = 'Estonian'
			Case Hex(0x0426, 4)
				$decimalCode = '1062'
				$countryCode = 'lv-LV'
				$langName = 'Latvian'
			Case Hex(0x0427, 4)
				$decimalCode = '1063'
				$countryCode = 'lt-LT'
				$langName = 'Lithuanian'
			Case Hex(0x0428, 4)
				$decimalCode = '1064'
				$countryCode = 'tg-Cyrl-TJ'
				$langName = 'Tajik'
			Case Hex(0x0429, 4)
				$decimalCode = '1065'
				$countryCode = 'fa-IR'
				$langName = 'Persian'
			Case Hex(0x042A, 4)
				$decimalCode = '1066'
				$countryCode = 'vi-VN'
				$langName = 'Vietnamese'
			Case Hex(0x042B, 4)
				$decimalCode = '1067'
				$countryCode = 'hy-AM'
				$langName = 'Armenian'
			Case Hex(0x042C, 4)
				$decimalCode = '1068'
				$countryCode = 'az-Latn-AZ'
				$langName = 'Azeri'
			Case Hex(0x042D, 4)
				$decimalCode = '1069'
				$countryCode = 'eu-ES'
				$langName = 'Basque'
			Case Hex(0x042E, 4)
				$decimalCode = '1070'
				$countryCode = 'hsb-DE'
				$langName = 'Upper'
			Case Hex(0x042F, 4)
				$decimalCode = '1071'
				$countryCode = 'mk-MK'
				$langName = 'Macedonian'
			Case Hex(0x0432, 4)
				$decimalCode = '1074'
				$countryCode = 'tn-ZA'
				$langName = 'Setswana'
			Case Hex(0x0434, 4)
				$decimalCode = '1076'
				$countryCode = 'xh-ZA'
				$langName = 'isiXhosa'
			Case Hex(0x0435, 4)
				$decimalCode = '1077'
				$countryCode = 'zu-ZA'
				$langName = 'isiZulu'
			Case Hex(0x0436, 4)
				$decimalCode = '1078'
				$countryCode = 'af-ZA'
				$langName = 'Afrikaans'
			Case Hex(0x0437, 4)
				$decimalCode = '1079'
				$countryCode = 'ka-GE'
				$langName = 'Georgian'
			Case Hex(0x0438, 4)
				$decimalCode = '1080'
				$countryCode = 'fo-FO'
				$langName = 'Faroese'
			Case Hex(0x0439, 4)
				$decimalCode = '1081'
				$countryCode = 'hi-IN'
				$langName = 'Hindi'
			Case Hex(0x043A, 4)
				$decimalCode = '1082'
				$countryCode = 'mt-MT'
				$langName = 'Maltese'
			Case Hex(0x043B, 4)
				$decimalCode = '1083'
				$countryCode = 'se-NO'
				$langName = 'Sami'
			Case Hex(0x043e, 4)
				$decimalCode = '1086'
				$countryCode = 'ms-MY'
				$langName = 'Malay'
			Case Hex(0x043F, 4)
				$decimalCode = '1087'
				$countryCode = 'kk-KZ'
				$langName = 'Kazakh'
			Case Hex(0x0440, 4)
				$decimalCode = '1088'
				$countryCode = 'ky-KG'
				$langName = 'Kyrgyz'
			Case Hex(0x0441, 4)
				$decimalCode = '1089'
				$countryCode = 'sw-KE'
				$langName = 'Swahili'
			Case Hex(0x0442, 4)
				$decimalCode = '1090'
				$countryCode = 'tk-TM'
				$langName = 'Turkmen'
			Case Hex(0x0443, 4)
				$decimalCode = '1091'
				$countryCode = 'uz-Latn-UZ'
				$langName = 'Uzbek'
			Case Hex(0x0444, 4)
				$decimalCode = '1092'
				$countryCode = 'tt-RU'
				$langName = 'Tatar'
			Case Hex(0x0445, 4)
				$decimalCode = '1093'
				$countryCode = 'bn-IN'
				$langName = 'Bangla'
			Case Hex(0x0446, 4)
				$decimalCode = '1094'
				$countryCode = 'pa-IN'
				$langName = 'Punjabi'
			Case Hex(0x0447, 4)
				$decimalCode = '1095'
				$countryCode = 'gu-IN'
				$langName = 'Gujarati'
			Case Hex(0x0448, 4)
				$decimalCode = '1096'
				$countryCode = 'or-IN'
				$langName = 'Oriya'
			Case Hex(0x0449, 4)
				$decimalCode = '1097'
				$countryCode = 'ta-IN'
				$langName = 'Tamil'
			Case Hex(0x044A, 4)
				$decimalCode = '1098'
				$countryCode = 'te-IN'
				$langName = 'Telugu'
			Case Hex(0x044B, 4)
				$decimalCode = '1099'
				$countryCode = 'kn-IN'
				$langName = 'Kannada'
			Case Hex(0x044C, 4)
				$decimalCode = '1100'
				$countryCode = 'ml-IN'
				$langName = 'Malayalam'
			Case Hex(0x044D, 4)
				$decimalCode = '1101'
				$countryCode = 'as-IN'
				$langName = 'Assamese'
			Case Hex(0x044E, 4)
				$decimalCode = '1102'
				$countryCode = 'mr-IN'
				$langName = 'Marathi'
			Case Hex(0x044F, 4)
				$decimalCode = '1103'
				$countryCode = 'sa-IN'
				$langName = 'Sanskrit'
			Case Hex(0x0450, 4)
				$decimalCode = '1104'
				$countryCode = 'mn-MN'
				$langName = 'Mongolian'
			Case Hex(0x0451, 4)
				$decimalCode = '1105'
				$countryCode = 'bo-CN'
				$langName = 'Tibetan'
			Case Hex(0x0452, 4)
				$decimalCode = '1106'
				$countryCode = 'cy-GB'
				$langName = 'Welsh'
			Case Hex(0x0453, 4)
				$decimalCode = '1107'
				$countryCode = 'km-KH'
				$langName = 'Khmer'
			Case Hex(0x0454, 4)
				$decimalCode = '1108'
				$countryCode = 'lo-LA'
				$langName = 'Lao'
			Case Hex(0x0456, 4)
				$decimalCode = '1110'
				$countryCode = 'gl-ES'
				$langName = 'Galician'
			Case Hex(0x0457, 4)
				$decimalCode = '1111'
				$countryCode = 'kok-IN'
				$langName = 'Konkani'
			Case Hex(0x0459, 4)
				$decimalCode = '1113'
				$countryCode = 'sd-Deva-IN'
				$langName = '(reserved)'
			Case Hex(0x045A, 4)
				$decimalCode = '1114'
				$countryCode = 'syr-SY'
				$langName = 'Syriac'
			Case Hex(0x045B, 4)
				$decimalCode = '1115'
				$countryCode = 'si-LK'
				$langName = 'Sinhala'
			Case Hex(0x045C, 4)
				$decimalCode = '1116'
				$countryCode = 'chr-Cher-US'
				$langName = 'Cherokee'
			Case Hex(0x045D, 4)
				$decimalCode = '1117'
				$countryCode = 'iu-Cans-CA'
				$langName = 'Inuktitut'
			Case Hex(0x045E, 4)
				$decimalCode = '1118'
				$countryCode = 'am-ET'
				$langName = 'Amharic'
			Case Hex(0x0461, 4)
				$decimalCode = '1121'
				$countryCode = 'ne-NP'
				$langName = 'Nepali'
			Case Hex(0x0462, 4)
				$decimalCode = '1122'
				$countryCode = 'fy-NL'
				$langName = 'Frisian'
			Case Hex(0x0463, 4)
				$decimalCode = '1123'
				$countryCode = 'ps-AF'
				$langName = 'Pashto'
			Case Hex(0x0464, 4)
				$decimalCode = '1124'
				$countryCode = 'fil-PH'
				$langName = 'Filipino'
			Case Hex(0x0465, 4)
				$decimalCode = '1125'
				$countryCode = 'dv-MV'
				$langName = 'Divehi'
			Case Hex(0x0468, 4)
				$decimalCode = '1128'
				$countryCode = 'ha-Latn-NG'
				$langName = 'Hausa'
			Case Hex(0x046A, 4)
				$decimalCode = '1130'
				$countryCode = 'yo-NG'
				$langName = 'Yoruba'
			Case Hex(0x046B, 4)
				$decimalCode = '1131'
				$countryCode = 'quz-BO'
				$langName = 'Quechua'
			Case Hex(0x046C, 4)
				$decimalCode = '1132'
				$countryCode = 'nso-ZA'
				$langName = 'Sesotho'
			Case Hex(0x046D, 4)
				$decimalCode = '1133'
				$countryCode = 'ba-RU'
				$langName = 'Bashkir'
			Case Hex(0x046E, 4)
				$decimalCode = '1134'
				$countryCode = 'lb-LU'
				$langName = 'Luxembourgish'
			Case Hex(0x046F, 4)
				$decimalCode = '1135'
				$countryCode = 'kl-GL'
				$langName = 'Greenlandic'
			Case Hex(0x0470, 4)
				$decimalCode = '1136'
				$countryCode = 'ig-NG'
				$langName = 'Igbo'
			Case Hex(0x0473, 4)
				$decimalCode = '1139'
				$countryCode = 'ti-ET'
				$langName = 'Tigrinya'
			Case Hex(0x0475, 4)
				$decimalCode = '1141'
				$countryCode = 'haw-US'
				$langName = 'Hawiian'
			Case Hex(0x0478, 4)
				$decimalCode = '1144'
				$countryCode = 'ii-CN'
				$langName = 'Yi'
			Case Hex(0x047A, 4)
				$decimalCode = '1146'
				$countryCode = 'arn-CL'
				$langName = 'Mapudungun'
			Case Hex(0x047C, 4)
				$decimalCode = '1148'
				$countryCode = 'moh-CA'
				$langName = 'Mohawk'
			Case Hex(0x047E, 4)
				$decimalCode = '1150'
				$countryCode = 'br-FR'
				$langName = 'Breton'
			Case Hex(0x0480, 4)
				$decimalCode = '1152'
				$countryCode = 'ug-CN'
				$langName = 'Uyghur'
			Case Hex(0x0481, 4)
				$decimalCode = '1153'
				$countryCode = 'mi-NZ'
				$langName = 'Maori'
			Case Hex(0x0482, 4)
				$decimalCode = '1154'
				$countryCode = 'oc-FR'
				$langName = 'Occitan'
			Case Hex(0x0483, 4)
				$decimalCode = '1155'
				$countryCode = 'co-FR'
				$langName = 'Corsican'
			Case Hex(0x0484, 4)
				$decimalCode = '1156'
				$countryCode = 'gsw-FR'
				$langName = 'Alsatian'
			Case Hex(0x0485, 4)
				$decimalCode = '1157'
				$countryCode = 'sah-RU'
				$langName = 'Sakha'
			Case Hex(0x0486, 4)
				$decimalCode = '1158'
				$countryCode = 'quc-Latn-GT'
				$langName = "K'iche"
			Case Hex(0x0487, 4)
				$decimalCode = '1159'
				$countryCode = 'rw-RW'
				$langName = 'Kinyarwanda'
			Case Hex(0x0488, 4)
				$decimalCode = '1160'
				$countryCode = 'wo-SN'
				$langName = 'Wolof'
			Case Hex(0x048C, 4)
				$decimalCode = '1164'
				$countryCode = 'prs-AF'
				$langName = 'Dari'
			Case Hex(0x0491, 4)
				$decimalCode = '1169'
				$countryCode = 'gd-GB'
				$langName = 'Scottish'
			Case Hex(0x0492, 4)
				$decimalCode = '1170'
				$countryCode = 'ku-Arab-IQ'
				$langName = 'Central'
			Case Hex(0x0801, 4)
				$decimalCode = '2049'
				$countryCode = 'ar-IQ'
				$langName = 'Arabic'
			Case Hex(0x0803, 4)
				$decimalCode = '2051'
				$countryCode = 'ca-ES-valencia'
				$langName = 'Valencian'
			Case Hex(0x0804, 4)
				$decimalCode = '2052'
				$countryCode = 'zh-CN'
				$langName = 'Chinese_S'
			Case Hex(0x0807, 4)
				$decimalCode = '2055'
				$countryCode = 'de-CH'
				$langName = 'German'
			Case Hex(0x0809, 4)
				$decimalCode = '2057'
				$countryCode = 'en-GB'
				$langName = 'English'
			Case Hex(0x080A, 4)
				$decimalCode = '2058'
				$countryCode = 'es-MX'
				$langName = 'Spanish'
			Case Hex(0x080C, 4)
				$decimalCode = '2060'
				$countryCode = 'fr-BE'
				$langName = 'French'
			Case Hex(0x0810, 4)
				$decimalCode = '2064'
				$countryCode = 'it-CH'
				$langName = 'Italian'
			Case Hex(0x0813, 4)
				$decimalCode = '2067'
				$countryCode = 'nl-BE'
				$langName = 'Dutch'
			Case Hex(0x0814, 4)
				$decimalCode = '2068'
				$countryCode = 'nn-NO'
				$langName = 'Norwegian'
			Case Hex(0x0816, 4)
				$decimalCode = '2070'
				$countryCode = 'pt-PT'
				$langName = 'Portuguese'
			Case Hex(0x081A, 4)
				$decimalCode = '2074'
				$countryCode = 'sr-Latn-CS'
				$langName = 'Serbian'
			Case Hex(0x081D, 4)
				$decimalCode = '2077'
				$countryCode = 'sv-FI'
				$langName = 'Swedish'
			Case Hex(0x0820, 4)
				$decimalCode = '2080'
				$countryCode = 'ur-IN'
				$langName = 'Urdu'
			Case Hex(0x082C, 4)
				$decimalCode = '2092'
				$countryCode = 'az-Cyrl-AZ'
				$langName = 'Azeri'
			Case Hex(0x082E, 4)
				$decimalCode = '2094'
				$countryCode = 'dsb-DE'
				$langName = 'Lower'
			Case Hex(0x0832, 4)
				$decimalCode = '2098'
				$countryCode = 'tn-BW'
				$langName = 'Setswana'
			Case Hex(0x083B, 4)
				$decimalCode = '2107'
				$countryCode = 'se-SE'
				$langName = 'Sami'
			Case Hex(0x083C, 4)
				$decimalCode = '2108'
				$countryCode = 'ga-IE'
				$langName = 'Irish'
			Case Hex(0x083E, 4)
				$decimalCode = '2110'
				$countryCode = 'ms-BN'
				$langName = 'Malay'
			Case Hex(0x0843, 4)
				$decimalCode = '2115'
				$countryCode = 'uz-Cyrl-UZ'
				$langName = 'Uzbek'
			Case Hex(0x0845, 4)
				$decimalCode = '2117'
				$countryCode = 'bn-BD'
				$langName = 'Bangla'
			Case Hex(0x0846, 4)
				$decimalCode = '2118'
				$countryCode = 'pa-Arab-PK'
				$langName = 'Punjabi'
			Case Hex(0x0849, 4)
				$decimalCode = '2121'
				$countryCode = 'ta-LK'
				$langName = 'Tamil'
			Case Hex(0x0850, 4)
				$decimalCode = '2128'
				$countryCode = 'mn-Mong-CN'
				$langName = 'Mongolian'
			Case Hex(0x0859, 4)
				$decimalCode = '2137'
				$countryCode = 'sd-Arab-PK'
				$langName = 'Sindhi'
			Case Hex(0x085D, 4)
				$decimalCode = '2141'
				$countryCode = 'iu-Latn-CA'
				$langName = 'Inuktitut'
			Case Hex(0x085F, 4)
				$decimalCode = '2143'
				$countryCode = 'tzm-Latn-DZ'
				$langName = 'Tamazight'
			Case Hex(0x0867, 4)
				$decimalCode = '2151'
				$countryCode = 'ff-Latn-SN'
				$langName = 'Pular'
			Case Hex(0x086B, 4)
				$decimalCode = '2155'
				$countryCode = 'quz-EC'
				$langName = 'Quechua'
			Case Hex(0x0873, 4)
				$decimalCode = '2163'
				$countryCode = 'ti-ER'
				$langName = '(reserved)'
			Case Hex(0x0873, 4)
				$decimalCode = '2163'
				$countryCode = 'ti-ER'
				$langName = 'Tigrinya'
			Case Hex(0x0C01, 4)
				$decimalCode = '3073'
				$countryCode = 'ar-EG'
				$langName = 'Arabic'
			Case Hex(0x0C04, 4)
				$decimalCode = '3076'
				$countryCode = 'zh-HK'
				$langName = 'Chinese_T'
			Case Hex(0x0C07, 4)
				$decimalCode = '3079'
				$countryCode = 'de-AT'
				$langName = 'German'
			Case Hex(0x0C09, 4)
				$decimalCode = '3081'
				$countryCode = 'en-AU'
				$langName = 'English'
			Case Hex(0x0C0A, 4)
				$decimalCode = '3082'
				$countryCode = 'es-ES'
				$langName = 'Spanish'
			Case Hex(0x0C0C, 4)
				$decimalCode = '3084'
				$countryCode = 'fr-CA'
				$langName = 'French'
			Case Hex(0x0C1A, 4)
				$decimalCode = '3098'
				$countryCode = 'sr-Cyrl-CS'
				$langName = 'Serbian'
			Case Hex(0x0C3B, 4)
				$decimalCode = '3131'
				$countryCode = 'se-FI'
				$langName = 'Sami'
			Case Hex(0x0C6B, 4)
				$decimalCode = '3179'
				$countryCode = 'quz-PE'
				$langName = 'Quechua'
			Case Hex(0x1001, 4)
				$decimalCode = '4097'
				$countryCode = 'ar-LY'
				$langName = 'Arabic'
			Case Hex(0x1004, 4)
				$decimalCode = '4100'
				$countryCode = 'zh-SG'
				$langName = 'Chinese_S'
			Case Hex(0x1007, 4)
				$decimalCode = '4103'
				$countryCode = 'de-LU'
				$langName = 'German'
			Case Hex(0x1009, 4)
				$decimalCode = '4105'
				$countryCode = 'en-CA'
				$langName = 'English'
			Case Hex(0x100A, 4)
				$decimalCode = '4106'
				$countryCode = 'es-GT'
				$langName = 'Spanish'
			Case Hex(0x100C, 4)
				$decimalCode = '4108'
				$countryCode = 'fr-CH'
				$langName = 'French'
			Case Hex(0x101A, 4)
				$decimalCode = '4122'
				$countryCode = 'hr-BA'
				$langName = 'Croatian'
			Case Hex(0x103B, 4)
				$decimalCode = '4155'
				$countryCode = 'smj-NO'
				$langName = 'Sami'
			Case Hex(0x105F, 4)
				$decimalCode = '4191'
				$countryCode = 'tzm-Tfng-MA'
				$langName = 'Central'
			Case Hex(0x1401, 4)
				$decimalCode = '5121'
				$countryCode = 'ar-DZ'
				$langName = 'Arabic'
			Case Hex(0x1404, 4)
				$decimalCode = '5124'
				$countryCode = 'zh-MO'
				$langName = 'Chinese_T'
			Case Hex(0x1407, 4)
				$decimalCode = '5127'
				$countryCode = 'de-LI'
				$langName = 'German'
			Case Hex(0x1409, 4)
				$decimalCode = '5129'
				$countryCode = 'en-NZ'
				$langName = 'English'
			Case Hex(0x140A, 4)
				$decimalCode = '5130'
				$countryCode = 'es-CR'
				$langName = 'Spanish'
			Case Hex(0x140C, 4)
				$decimalCode = '5132'
				$countryCode = 'fr-LU'
				$langName = 'French'
			Case Hex(0x141A, 4)
				$decimalCode = '5146'
				$countryCode = 'bs-Latn-BA'
				$langName = 'Bosnian'
			Case Hex(0x143B, 4)
				$decimalCode = '5179'
				$countryCode = 'smj-SE'
				$langName = 'Sami'
			Case Hex(0x1801, 4)
				$decimalCode = '6145'
				$countryCode = 'ar-MA'
				$langName = 'Arabic'
			Case Hex(0x1809, 4)
				$decimalCode = '6153'
				$countryCode = 'en-IE'
				$langName = 'English'
			Case Hex(0x180A, 4)
				$decimalCode = '6154'
				$countryCode = 'es-PA'
				$langName = 'Spanish'
			Case Hex(0x180C, 4)
				$decimalCode = '6156'
				$countryCode = 'fr-MC'
				$langName = 'French'
			Case Hex(0x181A, 4)
				$decimalCode = '6170'
				$countryCode = 'sr-Latn-BA'
				$langName = 'Serbian'
			Case Hex(0x183B, 4)
				$decimalCode = '6203'
				$countryCode = 'sma-NO'
				$langName = 'Sami'
			Case Hex(0x1C01, 4)
				$decimalCode = '7169'
				$countryCode = 'ar-TN'
				$langName = 'Arabic'
			Case Hex(0x1c09, 4)
				$decimalCode = '7177'
				$countryCode = 'en-ZA'
				$langName = 'English'
			Case Hex(0x1C0A, 4)
				$decimalCode = '7178'
				$countryCode = 'es-DO'
				$langName = 'Spanish'
			Case Hex(0x1C1A, 4)
				$decimalCode = '7194'
				$countryCode = 'sr-Cyrl-BA'
				$langName = 'Serbian'
			Case Hex(0x1C3B, 4)
				$decimalCode = '7227'
				$countryCode = 'sma-SE'
				$langName = 'Sami'
			Case Hex(0x2001, 4)
				$decimalCode = '8193'
				$countryCode = 'ar-OM'
				$langName = 'Arabic'
			Case Hex(0x2009, 4)
				$decimalCode = '8201'
				$countryCode = 'en-JM'
				$langName = 'English'
			Case Hex(0x200A, 4)
				$decimalCode = '8202'
				$countryCode = 'es-VE'
				$langName = 'Spanish'
			Case Hex(0x201A, 4)
				$decimalCode = '8218'
				$countryCode = 'bs-Cyrl-BA'
				$langName = 'Bosnian'
			Case Hex(0x203B, 4)
				$decimalCode = '8251'
				$countryCode = 'sms-FI'
				$langName = 'Sami'
			Case Hex(0x2401, 4)
				$decimalCode = '9217'
				$countryCode = 'ar-YE'
				$langName = 'Arabic'
			Case Hex(0x2409, 4)
				$decimalCode = '9225'
				$countryCode = 'en-029'
				$langName = 'English'
			Case Hex(0x240A, 4)
				$decimalCode = '9226'
				$countryCode = 'es-CO'
				$langName = 'Spanish'
			Case Hex(0x241A, 4)
				$decimalCode = '9242'
				$countryCode = 'sr-Latn-RS'
				$langName = 'Serbian'
			Case Hex(0x243B, 4)
				$decimalCode = '9275'
				$countryCode = 'smn-FI'
				$langName = 'Sami'
			Case Hex(0x2801, 4)
				$decimalCode = '10241'
				$countryCode = 'ar-SY'
				$langName = 'Arabic'
			Case Hex(0x2809, 4)
				$decimalCode = '10249'
				$countryCode = 'en-BZ'
				$langName = 'English'
			Case Hex(0x280A, 4)
				$decimalCode = '10250'
				$countryCode = 'es-PE'
				$langName = 'Spanish'
			Case Hex(0x281A, 4)
				$decimalCode = '10266'
				$countryCode = 'sr-Cyrl-RS'
				$langName = 'Serbian'
			Case Hex(0x2C01, 4)
				$decimalCode = '11265'
				$countryCode = 'ar-JO'
				$langName = 'Arabic'
			Case Hex(0x2C09, 4)
				$decimalCode = '11273'
				$countryCode = 'en-TT'
				$langName = 'English'
			Case Hex(0x2C0A, 4)
				$decimalCode = '11274'
				$countryCode = 'es-AR'
				$langName = 'Spanish'
			Case Hex(0x2C1A, 4)
				$decimalCode = '11290'
				$countryCode = 'sr-Latn-ME'
				$langName = 'Serbian'
			Case Hex(0x3001, 4)
				$decimalCode = '12289'
				$countryCode = 'ar-LB'
				$langName = 'Arabic'
			Case Hex(0x3009, 4)
				$decimalCode = '12297'
				$countryCode = 'en-ZW'
				$langName = 'English'
			Case Hex(0x300A, 4)
				$decimalCode = '12298'
				$countryCode = 'es-EC'
				$langName = 'Spanish'
			Case Hex(0x301A, 4)
				$decimalCode = '12314'
				$countryCode = 'sr-Cyrl-ME'
				$langName = 'Serbian'
			Case Hex(0x3401, 4)
				$decimalCode = '13313'
				$countryCode = 'ar-KW'
				$langName = 'Arabic'
			Case Hex(0x3409, 4)
				$decimalCode = '13321'
				$countryCode = 'en-PH'
				$langName = 'English'
			Case Hex(0x340A, 4)
				$decimalCode = '13322'
				$countryCode = 'es-CL'
				$langName = 'Spanish'
			Case Hex(0x3801, 4)
				$decimalCode = '14337'
				$countryCode = 'ar-AE'
				$langName = 'Arabic'
			Case Hex(0x380A, 4)
				$decimalCode = '14346'
				$countryCode = 'es-UY'
				$langName = 'Spanish'
			Case Hex(0x3C01, 4)
				$decimalCode = '15361'
				$countryCode = 'ar-BH'
				$langName = 'Arabic'
			Case Hex(0x3C0A, 4)
				$decimalCode = '15370'
				$countryCode = 'es-PY'
				$langName = 'Spanish'
			Case Hex(0x4001, 4)
				$decimalCode = '16385'
				$countryCode = 'ar-QA'
				$langName = 'Arabic'
			Case Hex(0x4009, 4)
				$decimalCode = '16393'
				$countryCode = 'en-IN'
				$langName = 'English'
			Case Hex(0x400A, 4)
				$decimalCode = '16394'
				$countryCode = 'es-BO'
				$langName = 'Spanish'
			Case Hex(0x4409, 4)
				$decimalCode = '17417'
				$countryCode = 'en-MY'
				$langName = 'English'
			Case Hex(0x440A, 4)
				$decimalCode = '17418'
				$countryCode = 'es-SV'
				$langName = 'Spanish'
			Case Hex(0x4809, 4)
				$decimalCode = '18441'
				$countryCode = 'en-SG'
				$langName = 'English'
			Case Hex(0x480A, 4)
				$decimalCode = '18442'
				$countryCode = 'es-HN'
				$langName = 'Spanish'
			Case Hex(0x4C0A, 4)
				$decimalCode = '19466'
				$countryCode = 'es-NI'
				$langName = 'Spanish'
			Case Hex(0x500A, 4)
				$decimalCode = '20490'
				$countryCode = 'es-PR'
				$langName = 'Spanish'
			Case Hex(0x540A, 4)
				$decimalCode = '21514'
				$countryCode = 'es-US'
				$langName = 'Spanish'
			Case Hex(0x7C04, 4)
				$decimalCode = '31748'
				$countryCode = 'zh-CHT'
				$langName = 'Chinese_T'
			Case Else
				SetLog("Your computer's language was not recognized.")
				$langName = "NONE"
		EndSwitch
		SetLog("Detected System Locale: " & $langName, $COLOR_INFO)
		If FileExists($g_sDirLanguages & "/" & $langName & ".ini") Then;if language file found
			SetLog("Language file " & $langName & ".ini found in " & $g_sDirLanguages)
			$g_sLanguage = $langName
			If FileExists($g_sProfileConfigPath) Then IniWrite($g_sProfileConfigPath, "other", "language", $g_sLanguage)
		Else;otherwise, use english if the language isn't available yet
			SetLog("Language file for " & $langName & " not found! Defaulting to English", $COLOR_ERROR)
			$g_sLanguage = $g_sDefaultLanguage
		EndIf
	Else
		;read the selected language from profile ini
		$g_sLanguage = IniRead($g_sProfileConfigPath, "other", "language", $g_sDefaultLanguage)
	EndIf


EndFunc   ;==>DetectLanguage

Func GetTranslatedFileIni($iSection = -1, $iKey = -1, $sText = "", $var1 = Default, $var2 = Default, $var3 = Default)
	Static $aNewLanguage[1][2] ;undimmed language array
	$sText = StringReplace($sText, @CRLF, "\r\n")

	Local $sDefaultText, $g_sLanguageText
	Local $SearchInLanguage = $iSection & "§" & $iKey
	Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
	If $result <> -1 Then
		Return GetTranslatedParsedText($aNewLanguage[$result][1], $var1, $var2, $var3)
	EndIf

	If $g_sLanguage = $g_sDefaultLanguage Then ; default English

		$sDefaultText = IniRead($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, "-3")

		If $sText = "-1" Then  ; check for "-1" if text repeated
			If $sDefaultText <> "-3" Then  ; check if text exists inside file
				$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
				Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
				If $result <> -1 Then
					$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
					$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sDefaultText
					ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
				EndIf
				Return $sDefaultText ; will also return "-1" as debug if english.ini does not contain the correct section/key
			Else
				Return "-3"  ; Show -3 error code in GUI to show read error and no text in file
			EndIf
		EndIf

		If $sDefaultText <> $sText Then
			Local $ini_file = $g_sDirLanguages & $g_sDefaultLanguage & ".ini"
			Local $aSection[1][2] = [[$iKey, $sText]]
			Local $Count = 1
			Local $aKey = IniReadSection($ini_file, $iSection)
			 If IsArray($aKey) Then
				For $i = 1 To $aKey[0][0]
					If _ArraySearch($aSection, $aKey[$i][0], 0, 0, 0, 0, 1, 0) = -1 Then
						; add only unique keys
						$Count += 1
						ReDim $aSection[$Count][2]
						$aSection[$Count - 1][0] = $aKey[$i][0]
						$aSection[$Count - 1][1] = $aKey[$i][1]
					EndIf
				Next
			EndIf
			_ArraySort($aSection, 0, 0, 0, 0)
			IniWriteSection($ini_file, $iSection, $aSection, 0)
			$sText = GetTranslatedParsedText($sText, $var1, $var2, $var3)
			Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
			If $result <> -1 Then
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sText
				ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
			Else
				; $aNewLanguage[$result][1] = $sText
			EndIf
			Return $sText
		Else
			$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
			Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
			If $result <> -1 Then
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sDefaultText
				ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
			Else
				; $aNewLanguage[$result][1] = $sDefaultText
			EndIf
			Return $sDefaultText
		EndIf
	Else ; translated language
		$g_sLanguageText = IniRead($g_sDirLanguages & $g_sLanguage & ".ini", $iSection, $iKey, "-3")

		If $sText = "-1" Then
			If $g_sLanguageText = "-3" Then
				$sDefaultText = IniRead($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, $sText)
				$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
				Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
				If $result <> -1 Then
					$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
					$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sDefaultText
					ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
				Else
					; $aNewLanguage[$result][1] = $sDefaultText
				EndIf
				Return $sDefaultText ; will also return "-1" as debug if english.ini does not contain the correct section/key
			Else
				$g_sLanguageText = GetTranslatedParsedText($g_sLanguageText, $var1, $var2, $var3)
				Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
				If $result <> -1 Then
					$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
					$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $g_sLanguageText
					ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
				Else
					; $aNewLanguage[$result][1] = $g_sLanguageText
				EndIf
				Return $g_sLanguageText
			EndIf
		EndIf

		If $g_sLanguageText = "-3" Then
			Local $ini_file = $g_sDirLanguages & $g_sLanguage & ".ini"
			Local $aSection[1][2] = [[$iKey, $sText]]
			Local $Count = 1
			Local $aKey = IniReadSection($ini_file, $iSection)
			 If IsArray($aKey) Then
				For $i = 1 To $aKey[0][0]
					If _ArraySearch($aSection, $aKey[$i][0], 0, 0, 0, 0, 1, 0) = -1 Then
						; add only unique keys
						$Count += 1
						ReDim $aSection[$Count][2]
						$aSection[$Count - 1][0] = $aKey[$i][0]
						$aSection[$Count - 1][1] = $aKey[$i][1]
					EndIf
				Next
			EndIf
			_ArraySort($aSection, 0, 0, 0, 0)
			IniWriteSection($ini_file, $iSection, $aSection, 0)
			$sText = GetTranslatedParsedText($sText, $var1, $var2, $var3)
			Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
			If $result <> -1 Then
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sText
				ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
			Else
				; $aNewLanguage[$result][1] = $sText
			EndIf
			Return $sText
		EndIf
		$g_sLanguageText = GetTranslatedParsedText($g_sLanguageText, $var1, $var2, $var3)
			Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
			If $result <> -1 Then
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
				$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $g_sLanguageText
				ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
			Else
				; $aNewLanguage[$result][1] = $g_sLanguageText
			EndIf
		Return $g_sLanguageText
	EndIf
EndFunc   ;==>GetTranslatedFileIni

Func _ReadFullIni()
	Local $ini_file = $g_sDirLanguages & $g_sDefaultLanguage & ".ini"
	Static $aNewLanguage[1][2] ;undimmed language array
	Local $Count = 1 ; Initialisation compteur
	Local $aSection = IniReadSectionNames($ini_file) ; Lecture des sections
	For $i = 1 To UBound($aSection) - 1 ; Boucle de lecture
		Local $aKey = IniReadSection($ini_file, $aSection[$i]) ; Lecture des clés de la section en cours
		If IsArray($aKey) Then ; Si la section n'est pas vide
			ReDim $aNewLanguage[$Count + UBound($aKey) - 1][2] ; On redimentionne le tableau en ajoutant le nombre d'éléments de la section en cours
			For $j = 1 To Ubound($aKey) - 1 ; Boucle de lecture
				If _ArraySearch($aNewLanguage, $aSection[$i] & "§" & $aKey[$j][0], 0, 0, 0, 0, 1, 0) = -1 Then
					; add only unique keys
					$aNewLanguage[$Count][0] = $aSection[$i] & "§" & $aKey[$j][0]; On stocke le nom de la section
					$aNewLanguage[$Count][1] = $aKey[$j][1]; On stocke le nom de la clé
					$Count += 1 ; On incrémente le compteur
				EndIf
			Next
		Else ; Si la section est vide
			ReDim $aNewLanguage[$Count + 1][2] ; On redimentionne le tableau de une ligne
			$aNewLanguage[$Count][0] = $aSection[$i] ; On stocke le nom de la section
			$Count += 1 ; On incrémente le compteur
		EndIf
	Next
EndFunc   ;==>_ReadFullIni
