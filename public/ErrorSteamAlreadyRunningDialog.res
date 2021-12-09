"public/ErrorSteamAlreadyRunningDialog.res"
{
	"DialogSteamAlreadyRunning"
	{
		"ControlName"		"SimpleDialog"
		"fieldName"		"DialogSteamAlreadyRunning"
		"xpos"		"610"
		"ypos"		"481"
		"wide"		"380"
		"tall"		"210"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#Steam_AlreadyRunningError_Title"
	}
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"14"
		"ypos"		"50"
		"wide"		"340"
		"tall"		"80"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_AlreadyRunningError_Info"
		"textAlignment"		"west"
		"wrap"		"1"
	}
	"URLLabel1"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"URLLabel1"
		"xpos"		"14"
		"ypos"		"128"
		"wide"		"346"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_AlreadyRunningError_SupportLink"
		"textAlignment"		"west"
		"wrap"		"0"
		"URLText"		"http://support.steampowered.com/cgi-bin/steampowered.cfg/php/enduser/std_adp.php?p_faqid=547"
	}
	"Button1"
	{
		"ControlName"		"Button"
		"fieldName"		"Button1"
		"xpos"		"266"
		"ypos"		"168"
		"wide"		"96"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#vgui_close"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"close"
		"Default"		"1"
	}
	
	layout
	{
		//Bottom
		region { name="bottom" align=bottom height=42 margin=8 }
		place { control="Button1" region=bottom align=right width=96 height=28 }
	}
}
