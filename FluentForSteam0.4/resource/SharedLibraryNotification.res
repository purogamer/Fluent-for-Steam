"resource/SharedLibraryNotification.res"
{
	"SharedLibraryNotification"
	{
		"ControlName"		"SharedLibraryNotification"
		"fieldName"		"SharedLibraryNotification"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"240"
		"tall"		"75"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		style="notification"
	}
	"ImageAvatar"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImageAvatar"
		"xpos"		"16"
		"ypos"		"16"
		"wide"		"42"
		"tall"		"42"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	"LabelInfo"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelInfo"
		"xpos"		"64"
		"ypos"		"16"
		"wide"		"172"
		"tall"		"42"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_InGameNotification_Info"
		"textAlignment"		"north-west"
		"wrap"		"1"
		"font"		FriendsSmall
	}

	"DarkenedRegion"
	{
		"controlname"	"imagepanel"
		"fieldname"		"DarkenedRegion"
		"xpos"		"0"
		"ypos"		"74"
		"wide"		"240"
		"tall"		"24"
		"fillcolor"	"Black"
		"zpos"		"-1"
	}
	colors
	{
		Black="0 0 0 0"
	}
	layout
	{
		place { control="ImageAvatar" x=13 y=13 }
		place { control="LabelInfo" x=67 dir=down margin=11 margin-left=0 margin-bottom=0 }
		place { control="LabelHotkey" y=76 width=250 }
	}
}