"Public/UseOfflineMode.res"
{
	"OfflineModDialog"
	{
		"ControlName"		"CUseOfflineModeDialog"
		"fieldName"		"OfflineModDialog"
		"xpos"		"620"
		"ypos"		"432"
		"wide"		"360"
		"tall"		"308"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#SteamUI_OfflineMode_ErrorTitle"
	}
	"RetryButton"
	{
		"ControlName"		"Button"
		"fieldName"		"RetryButton"
		"xpos"		"24"
		"ypos"		"224"
		"wide"		"150"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_OfflineMode_Retry"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Retry"
		"Default"		"0"
	}
	"OfflineModeButton"
	{
		"ControlName"		"Button"
		"fieldName"		"OfflineModeButton"
		"xpos"		"180"
		"ypos"		"224"
		"wide"		"150"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_OfflineMode_StartInOffline"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Offline"
		"Default"		"0"
	}
	"QuitButton"
	{
		"ControlName"		"Button"
		"fieldName"		"QuitButton"
		"xpos"		"266"
		"ypos"		"260"
		"wide"		"64"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_OfflineMode_Quit"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Quit"
		"Default"		"1"
	}
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"24"
		"ypos"		"42"
		"wide"		"320"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"appearance"		"LabelBright"
		"labelText"		"#SteamUI_OfflineMode_CouldNotConnect"
		"textAlignment"		"west"
		"font"		"uiHeadline"
		"wrap"		"1"
	}
	"Label2"
	{
		"ControlName"		"Label"
		"fieldName"		"Label2"
		"xpos"		"24"
		"ypos"		"76"
		"wide"		"320"
		"tall"		"54"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"appearance"		"LabelDull"
		"labelText"		"#SteamUI_OfflineMode_AppearOffline"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"Label3"
	{
		"ControlName"		"Label"
		"fieldName"		"Label3"
		"xpos"		"24"
		"ypos"		"140"
		"wide"		"320"
		"tall"		"48"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"appearance"		"LabelDull"
		"labelText"		"#SteamUI_OfflineMode_Choose"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"URLLabel1"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"URLLabel1"
		"xpos"		"24"
		"ypos"		"188"
		"wide"		"306"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_NetworkTroubleshootingTips"
		"textAlignment"		"west"
		"wrap"		"0"
		"URLtext"		"http://support.steampowered.com/cgi-bin/steampowered.cfg/php/enduser/std_adp.php?p_faqid=11"
	}
	styles
	{
		"Label"
		{
			textcolor=white
			font-family=light
			font-weight=300
		}
		"Label" [$WIN32||$WINDOWS]
		{
			font-size=36
		}
		"Label" [$OSX||$LINUX]
		{
			font-size=26
		}
		"URLLabel"
		{
			font-style=underline
		}
		//Hidden - steam process still runnning
		FrameCloseButton
		{
			bgcolor="none"
			render_bg{}
			image=""
		}
	}
	layout
	{
		place { control="Label1,URLLabel1" dir=down spacing=9 x=40 y=40 margin-top=-9 }
		region { name=bottom align=bottom height=44 margin=8 }
		place { control="RetryButton,OfflineModeButton" region=bottom align=left height=28 spacing=8 }
		place { control="QuitButton" region=bottom align=right height=28 }

		//Hidden
		place { control="frame_close,LabelAppearOffline,Label3" width=1 align=right }
	}
}