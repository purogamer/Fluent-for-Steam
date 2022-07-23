"steam/cached/OverlaySplash.res"
{
	"OverlaySplashScreen"
	{
		"ControlName"		"COverlaySplash"
		"fieldName"		"OverlaySplashScreen"
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
		style="Notification"
	}
	"ImageAvatar"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImageAvatar"
		"xpos"		"10"
		"ypos"		"20"
		"wide"		"52"
		"tall"		"32"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"gradientVertical"		"0"
		"scaleImage"		"1"
		"image"		"resource/steam_logo"
	}
	"LabelMessage"
	{
		"ControlName"		"Label"
		"fieldName"		"LabelMessage"
		"xpos"		"70"
		"ypos"		"24"
		"wide"		"166"
		"tall"		"32"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Overlay_Splash_Message"
		"textAlignment"		"north-west"
		"wrap"		"1"
		"textcolor"		"Text"
		font-family=basefont
	}
	"DarkenedRegion"
	{
		"controlname"	"imagepanel"
		"fieldname"		"DarkenedRegion"
		"xpos"		"1"
		"ypos"		"74"
		"wide"		"238"
		"tall"		"23"
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
		"labelText"		"#Overlay_Splash_Hotkey"
		"textAlignment"		"center"
		"wrap"		"0"
		style="label"

	}
	styles {
	

		notification {
			minimum-width=350
			minimum-height=150
			render_bg
			{
				1="image( x0-7, y0-3, x1, y1, graphics/notification/overlaysplash)"
				
				
			}	
		
		}
		


	}
	layout
	{
		place { control="ImageAvatar" margin-top=15 margin-left=18  width=24 height=24 }
		place { control=",LabelMessage" margin-top=12 margin-left=55  width=220 }
		//Footer
		place { control="LabelHotkey" align=bottom margin-left=9999 margin-bottom=20 }
		//Hidden
		place { control="DarkenedRegion," width=0 y=9999 align=right }
	}
}