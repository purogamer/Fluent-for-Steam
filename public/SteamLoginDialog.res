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

		button = "19 94 242 14"
		


	}

	styles {
		
		CheckButton
		{
			textcolor="white"
			font-family=button
			image=logindialog/Checkbox_none	
			
		}
		CheckButton:hover
		{
			image=logindialog/Checkbox_none_hover
		}
		CheckButton:selected
		{
			image=logindialog/Checkbox
		}
		CheckButton:selected:hover
		{
			image=logindialog/Checkbox_hover
		}
		CheckButton:disabled
		{
			textcolor="white"
			bgcolor="none"
			
		}
		CheckButton:selected:disabled
		{
			textcolor="White24"
			bgcolor="none"
			
		}

		TextEntry {

			font-size=18
			font-family=button
			
		}

		Label {

			font-family=button
			font-size=18
			textcolor=white

		}

		Label:hover {

			font-family=button
			font-size=18
			textcolor=white

		}
		
		
		button {

			textcolor=white
			font-family=button
			font-weight=400
			
			

		}

		button:hover {

			textcolor=bluesito
			font-weight=500
			render_bg {
				0="fill(x0+2,y0+2,x1-2,y1-2,button)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, bordescurvos/bblue/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, bordescurvos/bblue/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, bordescurvos/bblue/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, bordescurvos/bblue/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, bordescurvos/bblue/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, bordescurvos/bblue/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, bordescurvos/bblue/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,bordescurvos/bblue/ad)"
			}
			

		}

				
		Button:disabled
		{
			bgcolor="none"
			font-family=Button
			textcolor="white45"
			render_bg
			{
		
				0="fill(x0+2,y0+2,x1-2,y1-2,buttona)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, bordescurvos/b/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, bordescurvos/b/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, bordescurvos/b/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, bordescurvos/b/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, bordescurvos/b/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, bordescurvos/b/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, bordescurvos/b/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,bordescurvos/b/ad)"
			
			
			}
			
		}

		CSteamLoginDialog {
			minimum-height=540
			
		}
		FrameTitle {
			textcolor=white
			inset="9 0 0 7"
			render_bg {

				0="fill(x0,y0,x1,y1-6, white05)"
				1="fill(x0,y0,x1,y1-7, black)"
			}
		}

		
		loginerror_style_body {
			
			font-size=18
			font-family=button
			render_bg
			{
		
				0="fill(x0+2,y0+2,x1-2,y1-2,warninglogindialog)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, bordescurvos/warninglogindialog/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, bordescurvos/warninglogindialog/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, bordescurvos/warninglogindialog/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, bordescurvos/warninglogindialog/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, bordescurvos/warninglogindialog/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, bordescurvos/warninglogindialog/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, bordescurvos/warninglogindialog/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,bordescurvos/warninglogindialog/ad)"
			
			
			}
			textcolor=white
			padding=10
			padding-bottom=12
			minimum-height=80
		}
	}

	layout {
		
	
	
		place {
			control="frame_minimize, frame_close"
			margin-left=386
			spacing=-7
		}

		place {

			control="UserNameEdit"
			width=343
			height=34
			margin-top=100
			margin-left=69
			

		}

		place {

			
			control="UserNameLabel"
			margin-left=69
			margin-top=72
			

		}	
	
	
	    place {

			
			control="PasswordLabel"
			margin-left=69
			margin-top=157
			

		}	

		place {

			
			control="PasswordEdit"
			width=343
			height=34
			margin-top=184
			margin-left=69
			

		}
						
		region {

			name="botones"
			margin-left=69
			


		}

			
		place {

			region="botones"
			control="SavePasswordCheck,LoginButton"
			margin-bottom=201
			align=bottom
			width=343
			height=46
			dir=down



		}	

		place {

			
			control="divider1"
			margin-bottom=183
			align=bottom
			margin-left=28
			



		}

		place {
			
			region="botones"
			control="CreateNewAccountButton,LostPasswordButton"
			width=343
			height=46
			dir=down
			spacing=9
			margin-bottom=65
			align=bottom
		}

		place {

			control="ImagePanelLogo"
			align=bottom
			width=153
			margin-left=14


		}

		//////////ocultos
		place {

			control="Label2,cancelbutton,Label4"
			height=0
			
			margin=9999
		}
	}
}