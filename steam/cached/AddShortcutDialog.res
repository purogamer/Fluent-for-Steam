"steam/cached/AddShortcutDialog.res"
{
	"AddShortcutDialog"
	{
		"ControlName"		"CAddShortcutDialog"
		"fieldName"		"AddShortcutDialog"
		"xpos"		"794"
		"ypos"		"447"
		"wide"		"700"
		"tall"		"420"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#SteamUI_PickShortcutTitle"
	}
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"10"
		"ypos"		"36"
		"wide"		"645"
		"tall"		"30"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_AddGameLabel"
		"textAlignment"		"north-west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"1"
	}
	"AppList"
	{
		"ControlName"		"ListPanel"
		"fieldName"		"AppList"
		"xpos"		"10"
		"ypos"		"64"
		"wide"		"681"
		"tall"		"288"
		"AutoResize"		"3"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"BrowseButton"
	{
		"ControlName"		"Button"
		"fieldName"		"BrowseButton"
		"xpos"		"291"
		"ypos"		"362"
		"wide"		"92"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"AddSelectedButton"
	{
		"ControlName"		"Button"
		"fieldName"		"AddSelectedButton"
		"xpos"		"393"
		"ypos"		"362"
		"wide"		"195"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"CloseButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CloseButton"
		"xpos"		"599"
		"ypos"		"362"
		"wide"		"92"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#vgui_cancel"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"0"
	}
	styles
	{
		FrameCloseButton 
		{
			bgcolor=none
			render
			{
				
			}
		}
		FrameCloseButton:hover:active
		{
			bgcolor=none
			
		}
		FrameTitle {

			font-size=26
			font-family=cachetazo
			textcolor=white
			inset="8 54 0 0"
			minimum-height=60

		}
		
		checkbutton {
			image="graphics/checkboxcircle_d"
			font-size=16
		}
		checkbutton:hover {
			image="graphics/checkboxcircle_d"
			textcolor=white75
			font-size=16
		}
		checkbutton:selected {
			image="graphics/checkboxcircle_s"
			font-size=16
		}
		 
		label {
		textcolor=white
		font-family=basefont
		font-size=18
		}
		
		ListPanel
		{
			selectedbgcolor=accent_selectedbgcolor
			font-size=18
			font-family=basefont
			render_bg
			{
		
				0="fill(x0+2,y0+7,x1-2,y1-7,panele)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0,y1-7,x0,y1, materiales/panel/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="fill(x0+7,y1-7,x1-7,y1, panele)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+7,x0+2,y1-7, materiales/panel/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0,y0,x0,y0, materiales/panel/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="fill(x0+7,y0,x1-7,y0+7, panele)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+7,x1+3,y1-7, materiales/panel/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-7,y0,x1,y0, materiales/panel/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-7,y1-7,x1,y1,materiales/panel/ad)"
			
			
			}
		}
		
		"ListPanelColumnHeader ListPanelCheckBox"
		{
			padding-top=4
			padding-left=6
			
			
		}
		ListPanelDragger {
			
			render_bg {
					1="image(x1-3,y1-10,x0,y0, graphics/divider)"
			}
			
		}
		ListPanelColumnHeader {
			font-size=18
			bgcolor=none
			font-style=lowercase
			font-family="semibold2"
			font-weight=600
			textcolor=white
			
			
		}
				
		ListPanelCheckBox
		{
			padding-top=1
			padding-left=8
			
			
		}
	}

	layout
	{	
		region {name=applist align=bottom margin-bottom=81}
		place { region=applist align=bottom  control="AppList" height=270 width=max margin=12 margin-bottom=12}
		region { name="top" width=max height=229 margin=24 margin-top=58}
		place { control="Label1" region=top dir=down spacing=6  width=max }

		region { name="bottom" align=bottom height=81 width=max }
		place { control="BrowseButton,AddSelectedButton,CloseButton" region=bottom height=32 width=212 spacing=8 margin=24 }	
	}
}
