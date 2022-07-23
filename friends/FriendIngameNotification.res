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
			
			render_bg
			{
				textcolor=red
		
				0="fill(x0+12,y0+11,x1-12,y1-16,clientbg)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0+5,y1-16,x0,y1, materiales/191919xx8px/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="fill(x0+12,y1-16,x1-12,y1-9, clientbg)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="fill(x0+5,y0+10,x0+12,y1-16, clientbg)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0+5,y0+4,x0,y0, materiales/191919xx8px/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="fill(x0+12,y0+4,x1-12,y0+12, clientbg)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="fill(x1-12,y0+10,x1-5,y1-16, clientbg)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-12,y0+4,x1,y0, materiales/191919xx8px/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-12,y1-16,x1,y1,materiales/191919xx8px/ad)"
			
			
			}

		}
		
		Label
		{
			font-family=basefont
			font-size=18
			
			
			
		}
		LabelGame
		{
			
			font-family=basefont
			font-size=18
			
			
		}
	}
	layout
	{
		place { control="ImageAvatar" x=13 y=13 }
		
		place { region=texto control="LabelSender,LabelInfo,LabelGame" dir=down x=62 margin-top=10 margin-right=8 spacing=1}
		place {region=texto  control="" x=63 y=32 margin-right=10 }
		place { control="LabelHotkey" y=500 width=1 }
		//Hidden
		place { control="" width=1 align=right }
	}
}