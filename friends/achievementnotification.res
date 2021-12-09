"friends/AchievementNotification.res"
{
	"AchievementNotification"
	{
		"ControlName"		"CAchievmentNotification"
		"fieldName"		"AchievementNotification"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"240"
		"tall"		"94"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		style="notification"
	}
	"DarkenedRegion"
	{
		"controlname"	"imagepanel"
		"fieldname"		"DarkenedRegion"
		"xpos"		"1"
		"ypos"		"74"
		"wide"		"238"
		"tall"		"23"
		"fillcolor"	"ClientBG"
		"zpos"		"-1"
	}
	"AchievementIcon"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"AchievementIcon"
		"xpos"		"14"
		"ypos"		"14"
		"wide"		"64"
		"tall"		"64"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	"IconBorder"
	{
		"ControlName"		"Panel"
		"fieldName"		"IconBorder"
		"xpos"		"13"
		"ypos"		"13"
		"zpos"		"0"
		"wide"		"66"
		"tall"		"66"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"0"
	}
	"LabelTitle"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelTitle"
		"xpos"		"88"
		"ypos"		"25"
		"wide"		"144"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%title%"
		"textAlignment"		"center"
		"wrap"		"1"
		"font"		FriendsSmall
	}
	"LabelDescription"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelText"
		"xpos"		"88"
		"ypos"		"53"
		"wide"		"144"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%text%"
		"textAlignment"		"north-west"
		"wrap"		"1"
		"font"		FriendsSmall
	}
	colors
	{
	}
	styles
	{
		Notification
		{
			render
			{
				0="image(x0+14,y0+15,x1,y1,graphics/metro/overlay/achievement_border)"
			}
			minimum-width=280
		}
	}
	layout
	{
		place { control="AchievementIcon" x=14 y=15 }
		place { control="LabelTitle,LabelText" x=92 y=14 dir=down margin-right=8 }
		place { control="IconBorder,DarkenedRegion" width=1 align=right }
	}
}