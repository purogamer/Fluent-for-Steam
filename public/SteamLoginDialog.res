"Public/SteamLoginDialog.res"
{
	"SteamLoginDialog"
	{
		"ControlName"		"CSteamLoginDialog"
		"fieldName"		"SteamLoginDialog"
		"xpos"		"590"
		"ypos"		"435"
		"wide"		"420"
		"tall"		"352"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#Steam_Login_Title"
	}
	"ImagePanelLogo"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"ImagePanelLogo"
		"xpos"		"16"
		"ypos"		"40"
		"wide"		"136"
		"tall"		"35"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"image"		"graphics/logo6"
		"fillcolor"		""
		"gradientStart"		""
		"gradientEnd"		""
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
		
	"PasswordEdit"
	{
		"ControlName"		"TextEntry"
		"fieldName"		"PasswordEdit"
		"xpos"		"116"
		"ypos"		"122"
		"wide"		"281"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"textHidden"		"1"
		"editable"		"1"
		"maxchars"		"128"
		"NumericInputOnly"		"0"
		"unicode"		"0"
		style="TextEntryLarge"
	}
	"UserNameEdit"
	{
		"ControlName"		"TextEntry"
		"fieldName"		"UserNameEdit"
		"xpos"		"116"
		"ypos"		"88"
		"wide"		"281"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"textHidden"		"0"
		"editable"		"1"
		"maxchars"		"128"
		"NumericInputOnly"		"0"
		"unicode"		"0"
	}
	"LoginButton"
	{
		"ControlName"		"Button"
		"fieldName"		"LoginButton"
		"xpos"		"115"
		"ypos"		"184"
		"wide"		"136"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"4"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_Btn"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Login"
		"Default"		"1"
		"selected"		"0"
	}
	"SavePasswordCheck"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"SavePasswordCheck"
		"xpos"		"113"
		"ypos"		"152"
		"wide"		"285"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"3"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_RememberPassword"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"RememberPassword"
		"Default"		"0"
		"selected"		"0"
	}
	"SysMenu"
	{
		"ControlName"		"Menu"
		"fieldName"		"SysMenu"
		"xpos"		"0"
		"ypos"		"0"
		"zpos"		"1"
		"wide"		"64"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"UserNameLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"UserNameLabel"
		"xpos"		"6"
		"ypos"		"88"
		"wide"		"100"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_AccountName"
		"textAlignment"		"east"
		"associate"		"UserNameEdit"
		"wrap"		"0"
	}
	"Unnamed dialog1"
	{
		"ControlName"		"Label"
		"fieldName"		"Unnamed dialog1"
		"xpos"		"6"
		"ypos"		"122"
		"wide"		"100"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_Password"
		"textAlignment"		"east"
		"associate"		"PasswordEdit"
		"wrap"		"0"
	}
	"CancelButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CancelButton"
		"xpos"		"261"
		"ypos"		"184"
		"wide"		"136"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"5"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_Cancel"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"0"
		"selected"		"0"
	}
	"CreateNewAccountButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CreateNewAccountButton"
		"xpos"		"210"
		"ypos"		"240"
		"wide"		"187"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"6"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_CreateNewAccount"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"CreateNewAccount"
		"Default"		"0"
		"selected"		"0"
	}
	"PSNAccountSetupButton"
	{
		"ControlName"		"Button"
		"fieldName"		"PSNAccountSetupButton"		
		"xpos"		"210"
		"ypos"		"272"
		"wide"		"187"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"7"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_PSNAccountSetup"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"PSNAccountSetup"
		"Default"		"0"
		"selected"		"0"
	}
	"LostPasswordButton"
	{
		"ControlName"		"Button"
		"fieldName"		"LostPasswordButton"
		"xpos"		"210"
		"ypos"		"304"
		"wide"		"187"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"7"
		"paintbackground"		"1"
		"labelText"		"#Steam_Login_RetrievePassword"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"ForgotPassword"
		"Default"		"0"
		"selected"		"0"
	}
	"Label2"
	{
		"ControlName"		"Label"
		"fieldName"		"Label2"
		"xpos"		"16"
		"ypos"		"240"
		"wide"		"184"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"borderset"		"LabelDull"
		"labelText"		"#Steam_Login_NoAccount"
		"textAlignment"		"east"
		"wrap"		"0"
	}
	"Label3"
	{
		"ControlName"		"Label"
		"fieldName"		"Label3"
		"xpos"		"16"
		"ypos"		"272"
		"wide"		"184"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"borderset"		"LabelDull"
		"labelText"		"#Steam_Login_PS3Players"		
		"textAlignment"		"east"
		"wrap"		"0"
	}
	"Label4"
	{
		"ControlName"		"Label"
		"fieldName"		"Label4"
		"xpos"		"16"
		"ypos"		"304"
		"wide"		"184"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"borderset"		"LabelDull"
		"labelText"		"#Steam_Login_ForgotPassword"
		"textAlignment"		"east"
		"wrap"		"0"
	}
	"Divider1"
	{
		"ControlName"		"Divider"
		"fieldName"		"Divider1"
		"xpos"		"25"
		"ypos"		"224"
		"wide"		"372"
		"tall"		"1"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"AlreadyLoggedIn"
	{
		"ControlName"		"Label"
		"fieldName"		"AlreadyLoggedIn"
		"xpos"		"40"
		"ypos"		"40"
		"wide"		"380"
		"tall"		"48"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"borderset"		"LabelDull"
		"labelText"		"#Steam_AccountAlreadyLoggedInNeedPassword"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"LoginProcessImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"LoginProcessImage"
		"xpos"		"24"
		"ypos"		"225"
		"wide"		"373"
		"tall"		"78"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"image"		"graphics/intel_security_01"
		"fillcolor"		""
		"gradientStart"		""
		"gradientEnd"		""
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	"LoginProcessThrobber"
	{
		"ControlName"		"ThrobberImagePanel"
		"fieldName"		"LoginProcessThrobber"
		"xpos"		"24"
		"ypos"		"225"
		"wide"		"373"
		"tall"		"78"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"0"
	}
	"LoginProcessLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"LoginProcessLabel"
		"xpos"		"104"
		"ypos"		"236"
		"wide"		"280"
		"tall"		"18"
		"AutoResize"		"1"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"0"
		"borderset"		"LabelDull"
		"labelText"		"#SteamGuardBanner"
		"textAlignment"		"west"
		"wrap"		"1"
		"style"		"loginprocess_style_head"
	}
	"LoginProcessText"
	{
		"ControlName"		"Label"
		"fieldName"		"LoginProcessText"
		"xpos"		"104"
		"ypos"		"254"
		"wide"		"280"
		"tall"		"34"
		"AutoResize"		"1"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"0"
		"borderset"		"LabelDull"
		"labelText"		"placeholder"
		"textAlignment"		"west"
		"wrap"		"1"
		"style"		"loginprocess_style_body"
	}

	colors {

		
		


	}

	styles {

		CSteamLoginDialog {
			minimum-height=506
			minimum-width=716
			render_bg
			{
		
				0="image(x0,y0-60,x1,y1,graphics/logindialog/zz1)"
				1="image(x1-382,y0+72,x1,y1,graphics/logindialog/z1)"
			
			}
			
		}

		FrameTitle {

			font-size=26
			font-family=cachetazo
			textcolor=none
			inset="24 54 0 0"
			minimum-height=100

		}
		
	

		TextEntry {

			font-size=18
			render_bg
			{
		
				0="image(x0-6,y0,x1,y1,graphics/logindialog/textentry)"
			
			}
			
			
		}

		Label {

			font-family=basefont
			font-size=18
			selectedtextcolor=white
			textcolor=white

		}

		Label:selected {

			
			font-family=basefont
			font-size=18
			

		}
		
		button {
			render_bg
			{
		
				0="image(x0,y0,x1,y1,graphics/logindialog/button)"
			
			}
		}
		button:hover {
			render_bg
			{
		
				0="image(x0,y0,x1,y1,graphics/logindialog/button)"
				1="image(x0-3,y0-2,x1,y1,graphics/logindialog/hover)"
			
			}
		}
		
		
	
	
		
		loginerror_style_body {
			
			font-size=18
			font-family=button
			bgcolor=none
			textcolor=white
			
			padding-top=290
			
		}
		divider1 {
			bgcolor=none
		}
	}

	layout {
	
	
		place {

			y=102
			x=-342
			control="UserNameLabel"
			align=right
			
			
		}	
	
		place {
			
			margin-top=8
			start=UserNameLabel
			dir=down
			x=4
			control="UserNameEdit"
			width=262
			height=32
			
	
		}
	    place {

			x=-4
			margin-top=16
			dir=down
			start="UserNameEdit"
			control="PasswordLabel"
	

		}	

		place {

			margin-top=8
			start="PasswordLabel"
			control="PasswordEdit"
			dir=down
			x=4
			width=262
			height=32
			

		}
						
		place {
			
			margin-top=8
			start="PasswordEdit"
			control="SavePasswordCheck"
			dir=down
			x=-4
			width=262
			height=26
			
		}		
		place {
			
			margin-top=14
			
			start="SavePasswordCheck"
			control=",LoginButton,CreateNewAccountButton,LostPasswordButton"
			dir=down
			spacing=12
			width=262
			height=32
			
		}

		place {

			
			control=""
			margin-bottom=183
			align=bottom
			margin-left=28
			



		}


		//////////ocultos
		place {

			control=",divider1,Label4,cancelbutton,ImagePanelLogo,Label2"
			height=0
			
			margin=9999
		}
	}
}