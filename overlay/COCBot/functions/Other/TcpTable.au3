; #FUNCTION# ====================================================================================================================
; Name ..........: Functions to get TCP Port usage
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: http://autoit-script.ru/index.php?topic=4741.5;wap2, https://www.autoitscript.com/forum/topic/157358-getting-tcp-connections-of-a-process/
; Modified ......: Cosote (01/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <Array.au3>

; Uncomment for direct testing
;Local $aArray = _TcpTable(0, "adb.exe")
;Local $aArray = _TcpTable(5, "LISTENING")
;_ArrayDisplay($aArray, "TcpTable", "1:" & UBound($aArray), 0, Default, _ArrayToString($aArray, Default, 0, 0))

Func _TcpTable($idx = Default, $sValue = Default)
	Local $aTcpTable = _CV_GetExtendedTcpTable()
	If $idx = Default Or $sValue = Default Then Return $aTcpTable

	Local $aTcpTableFiltered[0][UBound($aTcpTable, 2)]
	_ArrayAdd($aTcpTableFiltered, _ArrayToString($aTcpTable, Default, 0, 0))
	For $i = 1 To UBound($aTcpTable) -1
		If $aTcpTable[$i][$idx] = $sValue Then _ArrayAdd($aTcpTableFiltered, _ArrayToString($aTcpTable, Default, $i, $i))
	Next

	Return $aTcpTableFiltered
EndFUnc

Func _CV_GetExtendedTcpTable()

	Local $aCall = DllCall("iphlpapi.dll", "dword", "GetExtendedTcpTable", _
			"ptr*", 0, _
			"dword*", 0, _
			"int", 1, _ ; 1, sort in ascending order
			"dword", 2, _ ; AF_INET4
			"dword", 5, _ ; TCP_TABLE_OWNER_PID_ALL
			"dword", 0)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If $aCall[0] <> 122 Then ; ERROR_INSUFFICIENT_BUFFER
		Return SetError(2, 0, 0)
	EndIf

	Local $iSize = $aCall[2]

	Local $tByteStructure = DllStructCreate("byte[" & $iSize & "]")

	$aCall = DllCall("iphlpapi.dll", "dword", "GetExtendedTcpTable", _
			"ptr", DllStructGetPtr($tByteStructure), _
			"dword*", $iSize, _
			"int", 1, _ ; 1, sort in ascending order
			"dword", 2, _ ; AF_INET4
			"dword", 5, _ ; TCP_TABLE_OWNER_PID_ALL
			"dword", 0)

	If @error Or $aCall[0] Then
		Return SetError(3, 0, 0)
	EndIf

	Local $tMIB_TCPTABLE_OWNER_PID_DWORDS = DllStructCreate("dword[" & Ceiling($iSize / 4) & "]", DllStructGetPtr($tByteStructure))

	Local $iTCPentries = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1)

	Local $aTCPTable[$iTCPentries + 1][8] = [["Process Name", "Local IP", "Local Port", "Remote IP", "Remote port", "Connection state", "PID", "User Name"]]

	Local $aState[12] = ["CLOSED", "LISTENING", "SYN_SENT", "SYN_RCVD", "ESTABLISHED", "FIN_WAIT1", "FIN_WAIT2", "CLOSE_WAIT", "CLOSING", "LAST_ACK", "TIME_WAIT", "DELETE_TCB"]

	Local $aProcesses = _CV_ProcessList()

	Local $iOffset
	Local $iIP

	;TCPStartup()

	For $i = 1 To $iTCPentries

		$iOffset = ($i - 1) * 6 + 1 ; going thru array of dwords

		Local $iState = Int(DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 1))
		If $iState > 0 And $iState <= UBound($aState) Then
			$aTCPTable[$i][5] = $aState[$iState - 1]
		Else
			$aTCPTable[$i][5] = "UNKNOWN"
		EndIf

		$iIP = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 2)

		If $iIP = 16777343 Then
			$aTCPTable[$i][1] = "localhost (127.0.0.1)"
		ElseIf $iIP = 0 Then
			$aTCPTable[$i][1] = "Any local address"
		Else
			$aTCPTable[$i][1] = BitOR(BinaryMid($iIP, 1, 1), 0) & "." & BitOR(BinaryMid($iIP, 2, 1), 0) & "." & BitOR(BinaryMid($iIP, 3, 1), 0) & "." & BitOR(BinaryMid($iIP, 4, 1), 0)
		EndIf

		$aTCPTable[$i][2] = Dec(Hex(BinaryMid(DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 3), 1, 2)))

		If DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 1) < 3 Then
			$aTCPTable[$i][4] = "-"
			$aTCPTable[$i][3] = "-"
		Else
			$iIP = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 4)
			$aTCPTable[$i][3] = BitOR(BinaryMid($iIP, 1, 1), 0) & "." & BitOR(BinaryMid($iIP, 2, 1), 0) & "." & BitOR(BinaryMid($iIP, 3, 1), 0) & "." & BitOR(BinaryMid($iIP, 4, 1), 0)
			$aTCPTable[$i][4] = Dec(Hex(BinaryMid(DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 5), 1, 2)))
		EndIf

		$aTCPTable[$i][6] = DllStructGetData($tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 6)
		If Not $aTCPTable[$i][6] Then
			$aTCPTable[$i][6] = "-"
			$aTCPTable[$i][0] = "System Idle Process"
			$aTCPTable[$i][7] = "SYSTEM"
		Else
			For $j = 1 To $aProcesses[0][0]
				If $aProcesses[$j][1] = $aTCPTable[$i][6] Then
					$aTCPTable[$i][0] = $aProcesses[$j][0]
					If Not $aTCPTable[$i][0] Then $aTCPTable[$i][0] = $aProcesses[$j][0]
					$aTCPTable[$i][7] = $aProcesses[$j][2]
					If Not $aTCPTable[$i][7] Then
						If IsAdmin() Then
							$aTCPTable[$i][7] = "SYSTEM"
						Else
							$aTCPTable[$i][7] = "-"
						EndIf
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf

	Next

	;TCPShutdown()

	_ArraySort($aTCPTable, 0, 1, 0, 2) ; sort by Local Port
	Return $aTCPTable

EndFunc   ;==>_CV_GetExtendedTcpTable

Func _CV_SystemModuleInformation()
	Local $aCall = DllCall("ntdll.dll", "long", "NtQuerySystemInformation", _
			"dword", 11, _ ; SystemModuleInformation
			"ptr", 0, _
			"dword", 0, _
			"dword*", 0)
	If @error Then Return SetError(1, 0, "")
	Local $iSize = $aCall[4]
	Local $tBufferRaw = DllStructCreate("byte[" & $iSize & "]")
	Local $pBuffer = DllStructGetPtr($tBufferRaw)
	$aCall = DllCall("ntdll.dll", "long", "NtQuerySystemInformation", _
			"dword", 11, _ ; SystemModuleInformation
			"ptr", $pBuffer, _
			"dword", $iSize, _
			"dword*", 0)
	If @error Then Return SetError(2, 0, "")
	Local $pPointer = $pBuffer
	Local $tSYSTEM_MODULE_Modified = DllStructCreate("dword_ptr ModulesCount;" & _
			"dword_ptr Reserved[2];" & _
			"ptr ImageBaseAddress;" & _
			"dword ImageSize;" & _
			"dword Flags;" & _
			"word Index;" & _
			"word Unknown;" & _
			"word LoadCount;" & _
			"word ModuleNameOffset;" & _
			"char ImageName[256]", _
			$pPointer)
	Local $iNameOffset = DllStructGetData($tSYSTEM_MODULE_Modified, "ModuleNameOffset")
	Local $sImageName = DllStructGetData($tSYSTEM_MODULE_Modified, "ImageName")
	Return StringTrimLeft($sImageName, $iNameOffset)
EndFunc   ;==>_CV_SystemModuleInformation

Func _CV_ProcessList()
	Const $sSystemModule = _CV_SystemModuleInformation()
	Local $aCall = DllCall("wtsapi32.dll", "bool", "WTSEnumerateProcessesW", _
			"handle", 0, _
			"dword", 0, _
			"dword", 1, _
			"ptr*", 0, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then
		Local $aProcesses = ProcessList()
		ReDim $aProcesses[$aProcesses[0][0]][3]
		For $i = 1 To UBound($aProcesses) - 1
			$aProcesses[$i][2] = "-"
		Next
		Return SetError(1, 0, $aProcesses)
	EndIf
	Local $tWTS_PROCESS_INFO
	Local $pString, $iStringLen
	Local $aOut[$aCall[5] + 1][3]
	$aOut[0][0] = $aCall[5]
	For $i = 1 To $aCall[5]
		$tWTS_PROCESS_INFO = DllStructCreate("dword SessionId;" & _
				"dword ProcessId;" & _
				"ptr ProcessName;" & _
				"ptr UserSid", _
				$aCall[4] + ($i - 1) * DllStructGetSize($tWTS_PROCESS_INFO)) ; looping thru structures
		$pString = DllStructGetData($tWTS_PROCESS_INFO, "ProcessName")
		$iStringLen = _CV_PtrStringLenW($pString)
		$aOut[$i][0] = DllStructGetData(DllStructCreate("wchar[" & $iStringLen + 1 & "]", $pString), 1)
		If $aOut[$i][0] = "System" Then $aOut[$i][0] = $sSystemModule ; & " (System)"
		$aOut[$i][1] = DllStructGetData($tWTS_PROCESS_INFO, "ProcessId")
		$aOut[$i][2] = _CV_AccountName(DllStructGetData($tWTS_PROCESS_INFO, "UserSid"))
	Next
	DllCall("wtsapi32.dll", "none", "WTSFreeMemory", "ptr", $aCall[4])
	Return $aOut
EndFunc   ;==>_CV_ProcessList

Func _CV_IpToName($iIP)
	Local $aCall = DllCall("ws2_32.dll", "ptr", "gethostbyaddr", _
			"dword*", $iIP, _
			"int", 4, _
			"int", 2) ; AF_INET
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Local $pHostent = $aCall[0]
	Local $tHostent = DllStructCreate("align 2; ptr Name;" & _
			"ptr Aliases;" & _
			"ushort Addrtype;" & _
			"ushort Length;" & _
			"ptr AddrList", _
			$pHostent)
	Return DllStructGetData(DllStructCreate("char[" & _CV_PtrStringLen(DllStructGetData($tHostent, "Name")) + 1 & "]", DllStructGetData($tHostent, "Name")), 1)
EndFunc   ;==>_CV_IpToName

Func _CV_GetPortHint($iPort)
	Local Static $sPorts = _CV_Ports()
	Local $aArray = StringRegExp($sPorts, ";" & $iPort & "\|(.*?);", 3)
	If @error Then Return ""
	Return " (" & $aArray[0] & ")"
EndFunc   ;==>_CV_GetPortHint

Func _CV_GetPIDFileName($iPID)
	Local $aCall = DllCall("kernel32.dll", "ptr", "OpenProcess", _
			"dword", 1040, _ ; PROCESS_QUERY_INFORMATION|PROCESS_VM_READ
			"int", 0, _
			"dword", $iPID)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Local $hProcess = $aCall[0]
	$aCall = DllCall("psapi.dll", "dword", "GetModuleFileNameExW", _
			"handle", $hProcess, _
			"ptr", 0, _
			"wstr", "", _
			"dword", 32767)
	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
		Return SetError(2, 0, "")
	EndIf
	Local $sFilename = $aCall[3]
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	Return $sFilename
EndFunc   ;==>_CV_GetPIDFileName

Func _CV_PtrStringLenW($pString)
	Local $aCall = DllCall("kernel32.dll", "dword", "lstrlenW", "ptr", $pString)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_CV_PtrStringLenW

Func _CV_AccountName($pSID)
	Local $aCall = DllCall("advapi32.dll", "bool", "LookupAccountSidW", _
			"ptr", 0, _
			"ptr", $pSID, _
			"wstr", "", _
			"dword*", 1024, _
			"wstr", "", _
			"dword*", 1024, _
			"ptr*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return $aCall[3]
EndFunc   ;==>_CV_AccountName

Func _CV_PtrStringLen($pString)
	Local $aCall = DllCall("kernel32.dll", "dword", "lstrlen", "ptr", $pString)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_CV_PtrStringLen

Func _CV_Ports()
	Local $sString = ";1|TCPPortServiceMultiplexer;2|ManagementUtility;3|CompressionPr" & _
			"ocess;5|RemoteJobEntry;7|Echo;8|Unassigned;9|Discard;11|Active U" & _
			"sers;13|DAYTIME;17|QD;18|MSP;19|CG;20|FTP;21|FTP;22|SSH;23|Telne" & _
			"t;25|SMTP;34|RF;35|PPS;35|QMS;37|TIME;39|RLP;41|Graphics;42|ARPA" & _
			";42|WINS;43|WHOIS;47|GRE;49|TACACS;52|XNS;53|DNS;54|XNS;55|ISI-G" & _
			"L;56|XNS;56|RAP;57|MTP;58|XNS;67|BOOTP (DHCP);68|BOOTP (DHCP);69" & _
			"|TFTP;70|Gopher;79|Finger;80|HTTP;81|Torpark—Onion;82|Torpark—Co" & _
			"ntrol;83|MIT ML Device;88|Kerberos—authentication;90|dnsix;90|Po" & _
			"intcast;99|WIP;101|NIC;102|ISO-TSAP;104|ACR/NEMA;105|CCSO;107|Re" & _
			"moteTELNET;109|POP2;110|POP3;111|Sun;113|IRC;113|auth;115|SFTP;1" & _
			"17|UUCP;118|SQL;119|NNTP;123|NTP;135|DCE;135|MicrosoftEPMAP;137|" & _
			"NetBIOSName;138|NetBIOSDatagram;139|NetBIOSSession;143|IMAP;152|" & _
			"BFTP;153|SGMP;156|SQL;158|DMSP;161|SNMP;162|SNMPTRAP;170|Print-s" & _
			"rv;177|XDMCP;179|BGP;194|IRC;199|SMUX;201|AppleTalk;209|QMTP;210" & _
			"|ANSI Z39.50;213|IPX;218|MPP;220|IMAP v3;256|2DEV 2SP;259|ESRO;2" & _
			"64|BGMP;311|MacOSXServerAdmin;308|Novastor;318|PKIX TSP;323|IMMP" & _
			";350|MATIP-Type A;351|MATIP-Type B;366|ODMR;369|Rpc2portmap;370|" & _
			"codaauth2;370|OutgoingNAI;371|ClearCase albd;383|HP;384|RNSS;387" & _
			"|AURP;389|LDAP;401|UPS;402|Altiris;411|DCH;412|DCCC;427|SLP;443|" & _
			"HTTPS;444|SNPP;445|Microsoft-DS AD;445|Microsoft-DS SMB;464|Kerb" & _
			"eros;465|Cisco;465|SMTPS;475|tcpnethaspsrv;497|DantzRetrospect;5" & _
			"00|ISAKMP;501|STMF;502|Modbus;504|Citadel;510|FCP;512|Rexec, com" & _
			"sat;513|Login;513|Who;514|Shell—used;514|Syslog—used;515|Line Pr" & _
			"inter Daemon;517|Talk;518|NTalk;520|efs;520|Routing—RIP;524|NCP;" & _
			"525|Timeserver;530|RPC;531|AOL, IRC;532|netnews;533|netwall;540|" & _
			"UUCP;542|commerce;543|klogin;544|kshell;545|VMS;546|DHCPv6;547|D" & _
			"HCPv6;548|AFP;550|new-rwho, new-who;554|RTSP;556|RFS;560|rmonito" & _
			"r;561|monitor;563|NNTPS;587|SMTP;591|HTTP Alternate;593|HTTP RPC" & _
			";604|TUNNEL;623|ASF-RMCP;631|IPP;636|LLDAPS;639|MSDP;641|Support" & _
			"Soft;646|LDP;647|DHCP;648|RRP;652|DTCP;653|SupportSoft;654|AODV;" & _
			"655|IEEE MMS;657|IBM RMC;660|MacOSXServerAdmin;665|sun-dr;666|Do"
	$sString &= "om;674|ACAP;691|MSExchangeRouting;692|Hyperwave-ISP;694|Linux-HA" & _
			";695|IEEE-MMS-SSL;698|OLSR;699|AccessNetwork;700|EPP;701|LMP;702" & _
			"|IRIS over BEEP;706|SILC;711|CiscoTDP;712|TBRPF;712|PromiseRAIDC" & _
			"ontroller, SMQP;749|Kerberos;750|rfile;750|loadav;750|kerberos-4" & _
			";751|pump;751|kerberos_master;752|qrh, userreg_server;753|rrh, p" & _
			"asswd_server;754|tell send, krb5_prop;760|ns, krbupdate;782|Cons" & _
			"erver;783|SpamAssassin;829|CMP;843|AdobeFlash;860|iSCSI;873|rsyn" & _
			"c;888|cddbp;901|SWAT;901|VMware;902|VMware;903|VMware;904|VMware" & _
			";911|NCA;953|DNS;981|SofaWare;989|FTPS;990|FTPS;991|NAS;992|TELN" & _
			"ET;993|IMAPS;995|POP3S;999|ScimoreDB;1001|JtoMB;1025|NFS-or-IIS;" & _
			"1026|MicrosoftDCOM;1029|MicrosoftDCOM;1058|NIM;1059|NIMreg;1080|" & _
			"SOCKS;1085|WebObjects;1098|RMIactivation;1099|RMIregistry;1109|K" & _
			"POP;1111|EasyBits;1140|AutoNOC;1167|phone;1169|Tripwire;1176|PAI" & _
			"Home;1182|AITP;1194|OpenVPN;1198|cajo;1200|scol, SFA;1214|Kazaa;" & _
			"1220|QSS;1223|TGP;1234|VLC;1236|SymantecBVC;1241|NSScanner;1248|" & _
			"NSClient/NSClient++/NC_Net;1270|SCOM;1293|IPSec;1311|DellHTTPS;1" & _
			"313|Xbiim;1337|MandM DNS, PowerFolderP2P, WASTE;1352|IBM RPC;138" & _
			"7|cadsi-lm;1414|IBMWebSphereMQ;1417|Timbuktu;1418|Timbuktu;1419|" & _
			"Timbuktu;1420|Timbuktu;1431|RGTP;1433|MSSQL;1434|MSSQL;1494|ICA;" & _
			"1500|NetGuard;1501|NetGuard;1503|WLMessenger;1512|WINS;1521|nCub" & _
			"e, Oracle;1524|ingreslock, ingres;1526|Oracle;1533|IBM Microsoft" & _
			"SQL;1547|Laplink;1550|Gadu-Gadu;1581|MIL STD 2045-47001 VMF;1589" & _
			"|Cisco VQP/ VMPS;1645|radius/radacct;1627|iSketch;1677|NovellGro" & _
			"upWise;1701|L2F L2TP;1716|MMO;1719|H.323;1720|H.323;1723|PPTP;17" & _
			"25|VSC;1755|MMS;1761|cft-0;1761|NovellZRC;1762|cft-1;1763|cft-2;" & _
			"1764|cft-3;1765|cft-4;1766|cft-5;1767|cft-6;1768|cft-7;1812|radi" & _
			"us;1813|radacct;1863|MSNP;1900|MicrosoftSSDP;1920|IBM Tivoli;193" & _
			"5|AdobeRTMP;1947|hasplm;1970|DNORC;1971|DNOS;1972|InterSystems;1" & _
			"975|CiscoTCO;1975|CiscoTCO;1977|CiscoTCO;1984|BB;1985|CiscoHSRP;" & _
			"1994|CiscoSTUN-SDLC;1998|CiscoX.25;2000|CiscoSCCP;2001|CAPTAN;20" & _
			"02|ACS;2030|OracleMTS;2041|Mail.Ru;2049|NFS;2049|shilp;2053|lot1" & _
			"05;2053|knetd;2056|Civilization4;2073|DataReel;2074|VertelVMF SA"
	$sString &= ";2082|IMServer, CPanel;2083|radsec;2083|CPanel;2086|GNUnet;2086|" & _
			"WebHostManager;2087|WebHostManage;2095|CPanel;2096|CPanel;2102|z" & _
			"ephyr-srv;2103|zephyr-clt;2104|zephyr-hm;2105|IBM MiniPay;2105|r" & _
			"login;2105|zephyr-hm-srv;2144|IronMountainLiveVault;2145|IronMou" & _
			"ntainLiveVault;2161|APC;2181|EForward;2190|TiVoConnectBeacon;220" & _
			"0|Tuxanci;2210|NOAAPORT, MikroTik;2211|EMWIN, MikroTik;2212|LeeC" & _
			"O, Port-A-Pour;2219|NetIQ NCAP;2220|NetIQ End2End;2222|DirectAdm" & _
			"in;2223|MSOffice;2301|HP System Management;2302|ArmA, CombatEvol" & _
			"ved;2303|ArmA;2305|ArmA;2369|BMC;2370|BMC;2381|HP;2401|CVS;2404|" & _
			"IEC 60870-5-104;2420|WestellRemoteAccess;2427|CiscoMGCP, ovwdb;2" & _
			"483|Oracle;2500|THENSMESSENGER;2546|EVault;2593|RunUO;2598|new I" & _
			"CA;2610|DarkAges;2612|QPasa;2638|Sybase;2700|KnowShowGo;2710|XBT" & _
			";2710|Knuddels;2713|Raven;2714|Raven;2735|NetIQ;2800|KnowShowGo;" & _
			"2809|corbaloc, IBMWebSphere;2868|NPEP;2944|MegacoTextH.248;2945|" & _
			"MegacoBinaryH.248;2948|WAP-push MMS;2949|WAP-pushsecure MMS;2967" & _
			"|Symantec;3000|Miralix, DIS;3001|Miralix;3002|Miralix;3003|Miral" & _
			"ix;3004|Miralix;3005|Miralix;3006|Miralix;3007|Miralix;3025|netp" & _
			"d.org;3030|NetPanzer;3050|gds_db;3051|Galaxy;3074|Xbox;3100|HTTP" & _
			";3101|Blackberry;3128|HTTP;3225|FCIP;3233|WhiskerControl;3235|Ga" & _
			"laxy;3260|iSCSI;3268|msft-gc;3269|msft-gc-ssl;3283|Apple;3299|SA" & _
			"P-Router;3300|TripleA, DebateGopher;3305|odette-ftp;3306|MySQL;3" & _
			"333|NetworkCallerID;3386|GTP' 3GPP GSM/UMTS;3389|RDP WBT;3396|No" & _
			"vell;3423|Xware;3424|Xware;3455|RSVP;3478|STUN;3483|Slim;3483|Sl" & _
			"im;3516|Smartcard;3532|Raven;3533|Raven;3537|ni-visa-remote;3544" & _
			"|Teredo;3632|distributed compiler;3689|DAAP;3690|Subversion;3702" & _
			"|WS-Discovery;3723|Battle.net;3724|WOW MMORPG, ClubPenguinDisney" & _
			";3784|VentriloVoIP;3785|VentriloVoIP;3868|DBP;3872|Oracle;3899|R" & _
			"emoteAdmin;3900|udt_os;3945|EMCADS;3978|OpenTTD;3979|OpenTTD;399" & _
			"9|Norman;4000|DiabloII;4001|MicrosoftAnts;4007|PrintBuzzer;4018|" & _
			"protocol information;4069|MEAV;4089|OpenCORE;4093|PxPlus;4096|AS" & _
			"COM;4100|WatchGuard;4111|Xgrid;4116|Smartcard-TLS;4125|MSRemoteW" & _
			"ebWorkplace;4201|TinyMUD;4226|Aleph;4224|Cisco;4321|RWhois;4323|"
	$sString &= "Lincoln;4500|IPSec;4534|Armagetron;4569|Inter-Asterisk;4610|Qual" & _
			"iSystems TestShell Suite Services;4662|OrbitNet, eMule;4664|Goog" & _
			"le;4672|eMule;4747|Apprentice;4750|BladeLogic Agent;4840|OPC;484" & _
			"3|OPC;4847|WebFreshComm;4993|HomeFTP;4894|LysKOM;4899|Radmin;500" & _
			"0|commplex-main, UPnP, VTun;5001|commplex, Iperf, Sling;5003|Fil" & _
			"eMaker;5004|RTP;5005|RTP;5031|AVM CAPI;5050|Yahoo!;5051|ita;5060" & _
			"|SIP;5061|SIP;5093|SPSS;5104|IBM Tivoli;5106|A-Talk;5107|A-Talk;" & _
			"5110|ProRat;5121|Neverwinter;5151|ESRI;5154|BZFlag;5176|ConsoleW" & _
			"orks default UI interface;5190|ICQ and AOL;5222|XMPP;5223|XMPP;5" & _
			"269|XMPP;5298|XMPP;5310|Ginever.net;5311|Ginever.net;5312|Gineve" & _
			"r.net;5313|Ginever.net;5314|Ginever.net;5315|Ginever.net;5351|NA" & _
			"T PMP;5353|mDNS;5355|LLMNR;5402|mftp;5405|NetSupport;5421|NetSup" & _
			"port2;5432|PostgreSQL;5433|Bouwsoft;5445|Cisco;5450|OSIsoft;5495" & _
			"|Applix;5498|Hotline;5499|Hotline;5500|VNC;5501|Hotline;5517|Set" & _
			"iqueue;5550|Hewlett-Packard;5555|Freeciv;5556|Freeciv;5631|pcANY" & _
			"WHEREdata;5632|pcANYWHEREstat;5666|NRPE;5667|NSCA;5723|Operation" & _
			"sManager;5800|VNC;5814|Hewlett-Packard;5850|COMIT SE(PCR);5852|A" & _
			"deona;5900|VNC;5938|TeamViewer;5984|CouchDB;5999|CVSup;6000|X11;" & _
			"6001|X11;6005|BMC;6005|Camfrog;6050|Brightstor, Nortel;6051|Brig" & _
			"htsto;6072|iOperator;6086|PDTP—FTP;6100|Vizrt;6101|BackupExecAge" & _
			"ntBrowser;6110|softcm;6111|spc;6112|dtspcd—a, Blizzard, Disney;6" & _
			"113|Disney;6129|DameWare;6257|WinMX;6262|SybaseADS;6346|gnutella" & _
			"-svc;6347|gnutella-rtr;6389|EMC;6432|PgBouncer;6444|SunGridEngin" & _
			"e;6445|SunGridEngine;6502|Danware;6522|Gobby;6523|Gobby0.5;6543|" & _
			"Paradigm;6566|SANE;6571|WindowsLiveFolderShare;6600|MPD;6619|ode" & _
			"tte-ftps;6646|McAfee;6660|Internet Relay Chat;6665|Internet Rela" & _
			"y Chat;6679|IRC SSL;6697|IRC SSL;6699|WinMX;6771|Polycom;6789|Da" & _
			"talogger;6881–6887|BitTorrent;6888|MUSE;6888|BitTorrent;6889–689" & _
			"0|BitTorrent;6891–6900|WindowsLiveMessenger, BitTorrent;6901|Win" & _
			"dowsLiveMessenger;6901|BitTorrent;6902–6968|BitTorrent;6969|acms" & _
			"oda, BitTorrent;6970–6999|BitTorrent;7000|Bittorrent;7001|WebLog" & _
			"ic;7002|WebLogic;7005|BMC;7006|BMC;7010|Cisco;7025|ZimbraLMTP;70"
	$sString &= "47|Zimbra;7133|EnemyTerritory;7171|Tibia;7306|Zimbra;7307|Zimbra" & _
			";7312|Sibelius;7400|RTPS;7401|RTPS;7402|RTPS;7670|BrettspielWelt" & _
			";7676|AquminAlphaVision;7777|iChat, Oracle, tini.exe, Unreal;777" & _
			"8|Unreal;7831|Smartlaunch;7915|YSFlight;8000|iRDMI, SHOUTcast;80" & _
			"01|SHOUTcast;8002|Cisco;8008|HTTP, IBM HTTP;8009|ajp13;8010|XMPP" & _
			";8074|Gadu-Gadu;8080|HTTP;8080|ApacheTomcat, FilePhile;8081|HTTP" & _
			";8086|HELM;8086|Kaspersky;8087|HostingAccelerator, ParallelsPles" & _
			"k, Kaspersky;8090|HTTP;8116|CPCC;8118|Privoxy;8123|Polipo;8192|S" & _
			"ophos;8193|Sophos;8194|Sophos;8200|GoToMyPC;8222|VMware;8243|HTT" & _
			"PS;8280|HTTP;8291|Winbox;8333|VMware;8400|cvp;8443|SW;8484|Maple" & _
			"Story;8500|ColdFusion;8501|DukesterX;8691|UltraFractal;8701|Soft" & _
			"Perfect;8702|SoftPerfect;8767|TeamSpeak;8768|TeamSpeak;8880|cddb" & _
			"p-alt, WebSpher;8881|Atlasz;8882|Atlasz;8888|NewsEDGE, Sun, GNUm" & _
			"p3d, LoLo, D2GS (Diablo 2), Earthland;8889|Earthland;9000|Buffal" & _
			"o, DBGp, SqueezeCenter, UDPCast;9001|MicrosoftSharepoint, cisco;" & _
			"9001|Tor, DBGp;9009|Pichat;9030|Tor;9043|WebSphere;9050|Tor;9051" & _
			"|Tor;9060|WebSphere;9080|glrpc;9080|WebSphere;9090|Openfire, Squ" & _
			"eezeCenter;9091|Openfire;9100|PDL;9101|Bacula;9102|Bacula;9103|B" & _
			"acula;9105|Xadmin;9110|SSMP;9119|MXit;9300|IBMCognos;9418|git;94" & _
			"20|MooseFS;9421|MooseFS;9422|MooseFS;9535|mngsuite;9535|mngsuite" & _
			";9800|WebDAV, WebCT;9875|Disney;9898|MonkeyCom;9898|Tripwire;999" & _
			"6|PalaceChat;9999|Hydranode, Lantronix, Urchin;10000|Webmin, Bac" & _
			"kupExec, Ericsson;10001|Lantronix;10008|Octopus;10010|ooRexx;100" & _
			"17|AIX;10024|Zimbra;10025|Ximbra;10050|Zabbix;10051|Zabbix;10113" & _
			"|NetIQ;10114|NetIQ;10115|NetIQ;10116|NetIQ;10200|FRISK;10201|FRI" & _
			"SK;10202|FRISK;10203|FRISK;10204|FRISK;10308|Lock-on;10480|SWAT4" & _
			";11211|memcached;11235|Savage;11294|BloodQuest;11371|OpenPGP;115" & _
			"76|IPStor;12012|Audition;12013|Audition;12035|Linden;12345|NetBu" & _
			"s;12975|LogMeIn;12998|Takenaka;12999|Takenaka;13000|Linden;13076" & _
			"|BMC;13720|Symantec;13721|Symantec;13724|Symantec;13782|Symantec" & _
			";13783|Symantec;13785|Symantec;13786|Symantec;14439|APRS;14567|B" & _
			"attlefield;15000|psyBNC, Wesnoth, Kaspersky, hydap;15567|Battlef"
	$sString &= "ield;15345|XPilot;16000|shroudBNC;16080|HTTP;16384|IronMountainD" & _
			"igital;16567|Battlefield;18010|SDO-X;18180|DART;18200|AsiaSoft;1" & _
			"8201|AsiaSoft;18206|AsiaSoft;18300|AsiaSoft;18301|AsiaSoft;18306" & _
			"|AsiaSoft;18400|KAIZEN;18401|KAIZEN;18505|Nexon;18506|Nexon;1860" & _
			"5|X-BEAT;18606|X-BEAT;19000|G10/alaplaya;19001|G10/alaplaya;1922" & _
			"6|Panda;19283|K2;19315|KeyShadow;19638|Ensim;19771|Softros;19813" & _
			"|4D;19880|Softros;20000|DNP, Usermin;20014|DART;20720|Symantec;2" & _
			"2347|WibuKey;22350|CodeMeter;23073|SoldatDedicated;23399|Skype;2" & _
			"3513|DukeNukem;24444|NetBeans;24465|Tonido;24554|BINKP;24800|Syn" & _
			"ergy;24842|StepMania;25888|Xfire;25999|Xfire;26000|idSoftware, E" & _
			"VE MMORPG;26901|EVE MMORPG;27000|QuakeWorld;27000|FlexNet;27001|" & _
			"FlexNet;27002|FlexNet;27003|FlexNet;27004|FlexNet;27005|FlexNet;" & _
			"27006|FlexNet;27007|FlexNet;27008|FlexNet;27009|FlexNet;27010|So" & _
			"urceEngineDedicated;27015|GoldSrc;27374|Sub7;27500|QuakeWorld;27" & _
			"888|Kaillera;27900|Nintendo;27901|QuakeII;27902|QuakeII;27903|Qu" & _
			"akeII;27904|QuakeII;27905|QuakeII;27906|QuakeII;27907|QuakeII;27" & _
			"908|QuakeII;27909|QuakeII;27910|QuakeII;27960|QuakeIII;28000|Bit" & _
			"fighter;28001|Starsiege;28395|SmartSale5.0;28910|Nintendo;28960|" & _
			"CallOfDuty;29900|Nintendo;29901|Nintendo;29920|Nintendo;30000|Po" & _
			"kemon;30301|BitTorrent;30564|Multiplicity;31337|BackOrifice;3141" & _
			"5|ThoughtSignal;31456|TetriNET IRC;31457|TetriNET;31458|TetriNET" & _
			";32245|MMTSG;32976|LogMeInHamachi;33434|traceroute;34443|Linksys" & _
			" PSUS4;36963|CounterStrike;37777|DigitalVideoRecorder;40000|Safe" & _
			"tyNET;43047|TheosMessenger;43594|RuneScape;43595|RuneScape;47808" & _
			"|BACnet;"
	Return $sString
EndFunc   ;==>_CV_Ports
