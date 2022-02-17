"friends/ClanEventDialog.res"
{
	"ClanEventDialog"
	{
		"ControlName"		"SimpleDialog"
		"fieldName"		"ClanEventDialog"
		"xpos"		"820"
		"ypos"		"506"
		"wide"		"280"
		"tall"		"140"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#Friends_GroupEvent_Title"
	}
	"ImageAvatar"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImageAvatar"
		"xpos"		"16"
		"ypos"		"34"
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
	"ViewEventButton"
	{
		"ControlName"		"Button"
		"fieldName"		"ViewEventButton"
		"xpos"		"16"
		"ypos"		"98"
		"wide"		"136"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_GroupEvent_View"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"CloseButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CloseButton"
		"xpos"		"161"
		"ypos"		"98"
		"wide"		"92"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#vgui_Close"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"LabelGroup"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelGroup"
		"xpos"		"64"
		"ypos"		"34"
		"wide"		"172"
		"tall"		"14"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%group%"
		"textAlignment"		"north-west"
		"font"		"FriendsSmall"
		"wrap"		"0"
	}
	"LabelInfo"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelInfo"
		"xpos"		"64"
		"ypos"		"48"
		"wide"		"172"
		"tall"		"14"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_GroupEvent_NowStarting"
		"textAlignment"		"north-west"
		"font"		"FriendsSmall"
		"wrap"		"0"
	}
	"LabelEventTitle"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelEventTitle"
		"xpos"		"64"
		"ypos"		"62"
		"wide"		"172"
		"tall"		"30"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%event%"
		"textAlignment"		"north-west"
		"font"		"FriendsSmall"
		"wrap"		"1"
	}
	styles
	{
		ImagePanel
		{
			inset-top=-1
		}
		Button
		{
			bgcolor="none"
			image="graphics\metro\icons\event"
			padding-left=-6
		}
		Button:hover
		{
			image="graphics\metro\icons\event_h"
		}
		Button:active
		{
			image="graphics\metro\icons\event_p"
		}
	}
	layout
	{
		region { name="top" margin-top=44 margin-bottom=16 margin-right=16 }
		place { control="ImageAvatar" region=top x=11 y=20 }
		place { control="LabelGroup,LabelInfo,LabelEventTitle" region=top x=62 y=16 width=172 margin-right=38 dir=down }
		place { control="ViewEventButton" region=top y=25 align=right width=36 height=36  }

		//Hidden
		place { control=CloseButton margin-left=-999 }
	}
}