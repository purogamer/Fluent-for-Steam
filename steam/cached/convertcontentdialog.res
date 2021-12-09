"steam/cached/convertcontentdialog.res"
{
	"ConvertContentDialog"
	{
		"ControlName"		"CConvertContentDialog"
		"fieldName"		"ConvertContentDialog"
		"wide"		"400"
		"tall"		"200"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"settitlebarvisible"		"1"
		"title"		"#Steam_Convert_Content_Dialog_Title"
	}
	
	"TextLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"TextLabel"
		"xpos"		"12"
		"ypos"		"36"
		"wide"		"380"
		"tall"		"64"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"#Steam_Convert_Content_Text"
		"textAlignment"		"north-west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"1"
	}
	
	"StateLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"StateLabel"
		"xpos"		"50"
		"ypos"		"95"
		"wide"		"300"
		"tall"		"24"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"#Steam_Convert_Content_State"
		"textAlignment"		"north-west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"1"
	}
	
	
	"Throbber"
	{
		"ControlName"		"ThrobberImagePanel"
		"fieldName"		"Throbber"
		"xpos"		"20"
		"ypos"		"90"
		"wide"		"20"
		"tall"		"20"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	
	"CancelButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CancelButton"
		"xpos"		"180"
		"ypos"		"165"
		"wide"		"98"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"labelText"		"#Steam_Convert_Content_Cancel"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Cancel"
		"Default"		"0"
	}
	
	"OkButton"
	{
		"ControlName"		"Button"
		"fieldName"		"OkButton"
		"xpos"		"290"
		"ypos"		"165"
		"wide"		"98"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"labelText"		"#Steam_Convert_Content_Start"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Convert"
		"Default"		"0"
	}
	styles
	{
		CConvertContentDialog
		{
			render_bg
			{
				//Title
				2="image(x0+16,y0+16,x1,y1, graphics/metro/labels/SteamPipe/SteamPipe)"
			}
		}
	}
	layout
	{
		place { control="TextLabel" x=16 y=48 }
		place { control="StateLabel" start=TextLabel dir=down width=max y=16 }
		place { control="Throbber" start=TextLabel dir=down align=right y=16 margin-right=16 }
		//Bottom
		region { name=bottom align=bottom height=44 margin=8 }
		place {	control="OKButton,CancelButton" region=bottom align=right spacing=8 height=28 width=84 }
	}
}
 