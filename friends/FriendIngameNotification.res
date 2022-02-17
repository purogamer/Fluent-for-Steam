"friends/FriendInGameNotification.res"
{
	"FriendIngameNotification"
	{
		"ControlName"		"CFriendInGameNotification"
		"fieldName"		"FriendIngameNotification"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"240"
		"tall"		"98"
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
	"LabelSender"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelSender"
		"xpos"		"64"
		"ypos"		"16"
		"wide"		"172"
		"tall"		"14"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%name%"
		"textAlignment"		"north-west"
		"wrap"		"0"
		"font"		FriendsSmall
	}
	"LabelInfo"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelInfo"
		"xpos"		"64"
		"ypos"		"30"
		"wide"		"172"
		"tall"		"14"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_InGameNotification_Info"
		"textAlignment"		"north-west"
		"wrap"		"0"
		"font"		FriendsSmall
	}
	"LabelGame"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelGame"
		"xpos"		"64"
		"ypos"		"44"
		"wide"		"172"
		"tall"		"14"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%game%"
		"textAlignment"		"north-west"
		"wrap"		"0"
		"font"		FriendsSmall
		style="LabelGame"
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
	"LabelHotkey"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelHotkey"
		"xpos"		"0"
		"ypos"		"74"
		"wide"		"240"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_OnlineNotification_Hotkey"
		"textAlignment"		"center"
		"wrap"		"0"
		"font"		FriendsSmall
	}
	colors
	{
		Black="0 0 0 0"
		ingamenickbg = "29 34 28 255"
	}
	styles
	{
		
		notification {

			render_bg {

				0="image(x0,y0,y0,x0, notifications/ingame)"
			}

		}
		
		Label
		{
			textcolor=Friends.InGameColor
			padding-top=1
			padding-bottom=2
			padding-left=4
			padding-right=4
			font-family=Button
			font-size=16
			
			render_bg
			{
		
				0="fill(x0+2,y0+2,x1-2,y1-2,ingamenickbg)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, bordescurvos/notifications/ingamenick/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, bordescurvos/notifications/ingamenick/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, bordescurvos/notifications/ingamenick/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, bordescurvos/notifications/ingamenick/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, bordescurvos/notifications/ingamenick/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, bordescurvos/notifications/ingamenick/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, bordescurvos/notifications/ingamenick/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,bordescurvos/notifications/ingamenick/ad)"
			
			
			}
		}
	}
	layout
	{
		place { control="ImageAvatar" x=13 y=13 }
		
		place { region=texto control="LabelSender,LabelGame" dir=down x=62 margin-top=14 margin-right=8 spacing=3}
		place {region=texto  control="" x=63 y=32 margin-right=10 }
		place { control="LabelHotkey" y=76 width=250 }
		//Hidden
		place { control="LabelInfo" width=1 align=right }
	}
}