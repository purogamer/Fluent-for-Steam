"friends/SteamInputControllerConnectedNotification.res"
{
	"SteamInputControllerConnectedNotification"
	{
		"ControlName"		"CSteamInputControllerConnectedNotification"
		"fieldName"		"CSteamInputControllerConnectedNotification"
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
	
	"NotificationClickPanel"
	{
		"ControlName"		"CNotificationClickPanel"
		"fieldName"		"NotificationClickPanel"
		"xpos"		"0"
		"ypos"		"0"
		"zpos"		"1"
		"wide"		"64"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"0"
	}
	
	"LabelControllerName"
	{
		"ControlName"		"Label"
		"fieldName"			"LabelControllerName"
		"xpos"				"68"
		"ypos"				"24"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"#Friends_SteamInputControllerConfigNotification_Info"
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
		"ypos"				"36"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"#Friends_SteamInputControllerConfigNotification_Info2"
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
