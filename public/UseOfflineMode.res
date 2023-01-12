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
		CUseOfflineModeDialog {
			minimum-width=515
			render_bg {

				0="fill(x0,y0+228,x1,y1, black25)"
				1="image(x0+24,y0+24,x1,y1, graphics/offline)"

			}
		}
		FrameTitle {

			font-size=26
			font-family=cachetazo
			textcolor=white
			inset="18 56 0 0"
			minimum-height=100

		}
		"Label"
		{
			font-size=18
			textcolor=white
			font-family=basefont
		}
		"URLLabel"
		{
			textcolor=accent
			font-size=18
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
		region { name="top" width=max height=229 margin=24 margin-top=102}
		place { control="Label1,Label3," region=top dir=down spacing=6  width=max }
		place { region="top" start=label3 control=LabelAppearOffline, margin-top=6 dir=down  }
		place { region="top" align=bottom control=URLLabel1 }
		region { name=bottom align=bottom height=80}
		place { control="RetryButton,OfflineModeButton,QuitButton" region=bottom margin=24 height=32 width=150 spacing=8 }
	
		//Hidden
		place { control="frame_close," width=1 align=right }
	}
}
