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
		"ypos"				"16"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"%controller_name%"
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
		"ypos"				"30"
		"wide"				"172"
		"tall"				"14"
		"AutoResize"		"0"
		"PinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"paintbackground"	"1"
		"labelText"			"#Friends_SteamInputControllerConnectedNotification_Info"
		"textAlignment"		"north-west"
		"wrap"				"0"
		"font"				FriendsSmall
		"textcolor"			"Friends.OfflineColor"
	}
	
	"LabelAccountName"
	{
		"ControlName"		"Label"
		"fieldName"			"LabelAccountName"
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
		"labelText"			"%account_name%"
		"textAlignment"		"north-west"
		"wrap"				"1"
		"font"				FriendsSmall
		"textcolor"			"Friends.OnlineColor"
	}
	styles {
		Label {
			font-size=18
			font-family=basefont
			textcolor=white
		}
		notification {
			minimum-width=350
			minimum-height=107
			render_bg
			{
				1="image( x0-7, y0-3, x1, y1, graphics/notification/joystick)"
				
				
			}	
		
		}
		
	}
	layout
	{
		place { control="ControllerImage" margin-left=24 margin-top=26}
		place { control="LabelControllerName, LabelInfo, LabelAccountName" dir=down margin-left=105 y=18 width=250 height=max }
	}
}
