"friends/SteamInputControllerPlayerNumberNotification.res"
{
	"SteamInputPlayerNumberChangedNotification"
	{
		"ControlName"		"CSteamInputPlayerNumberChangedNotification"
		"fieldName"		"CSteamInputPlayerNumberChangedNotification"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"240"
		"tall"		"74"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		style="Notification"
	}
	
	"ControllerImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ControllerImage"
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
		"scaleImage"		"1"
	}
	
	"LabelInfo"
	{
		"ControlName"		"Label"
		"fieldName"			"LabelTitle"
		"xpos"				"68"
		"ypos"				"16"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"#Friends_SteamInputControllerPlayerNumberTitle"
		"textAlignment"		"north-west"
		"wrap"				"0"
		"font"				FriendsSmall
		"textcolor"			"Friends.OfflineColor"
	}

	"LabelControllerName"
	{
		"ControlName"		"Label"
		"fieldName"			"LabelControllerName"
		"xpos"				"68"
		"ypos"				"30"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"%controller%"
		"textAlignment"		"north-west"
		"wrap"				"0"
		"font"				FriendsSmall	
		"textcolor"			"NotificationBodyText"	
	}
	
	"LabelInfo"
	{
		"ControlName"		"Label"
		"fieldName"			"LabelInfo"
		"xpos"				"68"
		"ypos"				"44"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"#Friends_SteamInputControllerPlayerNumberChanged"
		"textAlignment"		"north-west"
		"wrap"				"0"
		"font"				FriendsSmall
		"textcolor"			"Friends.OfflineColor"
	}
	layout
	{
		place { control="ControllerImage" x=16 y=12 }
		place { control="LabelControllerName, LabelInfo" dir=down x=68 y=12 width=max height=max }
	}
}
