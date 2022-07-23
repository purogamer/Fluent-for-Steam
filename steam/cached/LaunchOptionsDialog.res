"Steam/Cached/LaunchOptionsDialog.res"
{
	"LaunchOptionsDialog"
	{
		"ControlName"		"CLaunchOptionsDialog"
		"fieldName"		"LaunchOptionsDialog"
		"xpos"		"209"
		"ypos"		"528"
		"wide"		"373"
		"tall"		"177"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#Steam_GameLaunchOptions_Title"
	}
	"LaunchButton"
	{
		"ControlName"		"Button"
		"fieldName"		"LaunchButton"
		"xpos"		"170"
		"ypos"		"144"
		"wide"		"96"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"labelText"		"#Steam_Launch"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"1"
	}
	"RadioButton0"
	{
		"ControlName"		"RadioButton"
		"fieldName"		"RadioButton0"
		"xpos"		"18"
		"ypos"		"64"
		"wide"		"320"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
		"SubTabPosition"		"1"
	}
	"RadioButton1"
	{
		"ControlName"		"RadioButton"
		"fieldName"		"RadioButton1"
		"xpos"		"18"
		"ypos"		"94"
		"wide"		"320"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
		"SubTabPosition"		"2"
	}
	"ImagePanel1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImagePanel1"
		"xpos"		"8"
		"ypos"		"47"
		"zpos"		"-1"
		"wide"		"357"
		"tall"		"90"
		"AutoResize"		"3"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"fillcolor"		"Blank"
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	"Button1"
	{
		"ControlName"		"Button"
		"fieldName"		"Button1"
		"xpos"		"273"
		"ypos"		"144"
		"wide"		"94"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"3"
		"paintbackground"		"1"
		"labelText"		"#vgui_cancel"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"0"
	}
}
styles {

button {
    minimum-height=32
}

}
layout {

place { control=LaunchButton height=32} 

}