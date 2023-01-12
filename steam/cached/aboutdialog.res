"steam/cached/aboutdialog.res"
{
	"AboutDialog"
	{
		"ControlName"		"CAboutDialog"
		"fieldName"		"AboutDialog"
		"xpos"		"911"
		"ypos"		"473"
		"wide"		"351"
		"tall"		"250"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#Steam_About_Title"
	}
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"24"
		"ypos"		"62"
		"wide"		"256"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_About_Build"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	"Button1"
	{
		"ControlName"		"Button"
		"fieldName"		"Button1"
		"xpos"		"248"
		"ypos"		"213"
		"wide"		"92"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"labelText"		"#vgui_close"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"0"
		"selected"		"0"
	}
	"Label2"
	{
		"ControlName"		"Label"
		"fieldName"		"Label2"
		"xpos"		"24"
		"ypos"		"38"
		"wide"		"256"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_About_Info"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	"Label3"
	{
		"ControlName"		"Label"
		"fieldName"		"Label3"
		"xpos"		"24"
		"ypos"		"86"
		"wide"		"320"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_About_InterfaceVer"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	"URLLabel1"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"URLLabel1"
		"xpos"		"25"
		"ypos"		"138"
		"wide"		"296"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_SteamPoweredURL"
		"textAlignment"		"west"
		"wrap"		"0"
		"URLText"		"http://www.steampowered.com"
	}
	"GreyStrip"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"GreyStrip"
		"xpos"		"22"
		"ypos"		"160"
		"zpos"		"-1"
		"wide"		"312"
		"tall"		"1"
		"AutoResize"		"1"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"fillcolor"		"SecBG"
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	
	"Label4"
	{
		"ControlName"		"Label"
		"fieldName"		"Label4"
		"xpos"		"24"
		"ypos"		"110"
		"wide"		"303"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_PackageVersion"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	styles {
		FrameTitle {

			font-size=26
			font-family=cachetazo
			textcolor=white
			inset="18 28 0 0"
			minimum-height=60

		}
		Label {
			
			font-size=18
			textcolor=white

		}
			URLLabel {
			font-size=18
			font-family=basefont
			textcolor=accent
			padding-left=8
			padding-right=8
			font-style=none
			  render_bg {

				0="fill(x0+10,y0+0,x1-9,y1+1,accent_alpha_31 )"
			
             			
				//////////////////////////for esquina "izquierda"  superior///////////////////////////////////////////
				5="image(x0+0,y0-0,x0,y0, graphics/assets/accent/materiales/accent_alpha_31_url/ti)"
      
	  			///////////////////for esquina "izquierda" inferior/////////////////////////////
				////////left, bottom  ,left bottom
				1="image(x0+0,y1-9,x0,y1, graphics/assets/accent/materiales/accent_alpha_31_url/ai)"

         	  
 							
			

					/////////////////////////for esquina derecha superior///////////////////////////////////////////////
				7="image(x1-9,y0,x1,y0, graphics/assets/accent/materiales/accent_alpha_31_url/td)"
				/////////////////////for esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-9,y1-9,x1,y1, graphics/assets/accent/materiales/accent_alpha_31_url/ad)"
			}
		}
		URLLabel:hover {
			textcolor=accent_h
			
		}
	}
	layout
	{
		region { name="top" width=max height=max margin=24 margin-top=80}

		place { control="frame_minimize,frame_maximize,frame_close" align=right width=46 height=32 margin-right=1 }
		
		place { region="top" control="Label2,Label3,Label4,Label1," spacing=4 dir=down  }
		place { control="websiteurl" dir=down start=label1 margin-top=12}
		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="Button1" region=bottom align=right width=0 height=0 spacing=8 }
		
		place { control="GreyStrip" width=10 height=20 }

	}
}
