"friends/ChatURLWarningDialog.res"
{
	"URLWarningDialog"
	{
		"ControlName"		"SimpleDialog"
		"fieldName"		"URLWarningDialog"
		"xpos"		"395"
		"ypos"		"1048"
		"wide"		"516"
		"tall"		"298"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#Friends_ChatURLWarning_Title"
	}
	"ContinueButton"
	{
		"ControlName"		"Button"
		"fieldName"		"ContinueButton"
		"xpos"		"70"
		"ypos"		"186"
		"wide"		"249"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"labelText"		"#Friends_ChatURLWarning_Continue"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"Button2"
	{
		"ControlName"		"Button"
		"fieldName"		"Button2"
		"xpos"		"327"
		"ypos"		"186"
		"wide"		"120"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
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
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"70"
		"ypos"		"36"
		"wide"		"437"
		"tall"		"40"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"appearance"		"ListPanelSectionHeader"
		"labelText"		"#Friends_ChatURLWarning_Info"
		"textAlignment"		"west"
		"wrap"		"1"
		style="warning"
	}
	"DontShowCheckButton"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"DontShowCheckButton"
		"xpos"		"70"
		"ypos"		"245"
		"wide"		"374"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"labelText"		"#Friends_ChatURLWarning_DontAskAgainCheck"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"Label2"
	{
		"ControlName"		"Label"
		"fieldName"		"Label2"
		"xpos"		"107"
		"ypos"		"71"
		"wide"		"373"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"%url%"
		"textAlignment"		"west"
		"font"		"basefont"
		"font-weight" "800"
		"wrap"		"0"
		style="danger"
	}
	"Label3"
	{
		"ControlName"		"Label"
		"fieldName"		"Label3"
		"xpos"		"70"
		"ypos"		"116"
		"wide"		"375"
		"tall"		"60"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_ChatURLWarning_Info2"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"Divider1"
	{
		"ControlName"		"Divider"
		"fieldName"		"Divider1"
		"xpos"		"70"
		"ypos"		"229"
		"wide"		"377"
		"tall"		"2"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"ImagePanel1"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImagePanel1"
		"xpos"		"42"
		"ypos"		"58"
		"wide"		"59"
		"tall"		"59"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"image"		"resource/icon_warning"
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	"ImagePanel2"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImagePanel2"
		"xpos"		"107"
		"ypos"		"69"
		"zpos"		"-1"
		"wide"		"340"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"fillcolor"		"label"
		"gradientVertical"		"0"
		"scaleImage"		"0"
		

	}
	
	styles
	{
		SimpleDialog
		{
			bgcolor=ClientBG
			render_bg
			{
				0="image(x0+62,y0+44,x1,y1, graphics/metro/labels/linkwarning)"
				5="fill( x0, y1-44, x1, y1, FrameBorder )"
				6="fill( x0, y1-43, x1, y1, Header_Dark )"
			}
		}
	
		danger
		{
			inset-left=16
			textcolor="white"
			font-family=basefont
			font-size=16
		}

		warning
		{
			inset-left=16
			textcolor="white"
			font-family=basefont
		}
	}
	layout
	{
		place { control="frame_minimize,frame_maximize,frame_close" align=right width=40 height=40 margin-right=1 }

		//Padding
		region { name=top margin=62 margin-top=0 }
		
		//Image and URL
		place { region=top control=ImagePanel1,Label2 width=max height=40 y=62 margin-top=24 dir=right }
		
		//Info
		place { region=top start=ImagePanel1 control=Label3 y=24 margin-top=-6 width=max dir=down }
		
		//Footer
		region { name=left align=left margin=8 margin-left=14 }
		region { name=right align=right margin=8 width=260 }
		place { region=left control=DontShowCheckButton height=28 align=bottom }
		place { region=right control=ContinueButton,Button2 height=28 spacing=8 align=bottom	 }
		
		//Hidden
		place { control=Label1,Divider1 height=0 }
	}
}
