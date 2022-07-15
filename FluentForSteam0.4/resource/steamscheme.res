///////////////////////////////////////////////////////////
// old-style vgui description file
// currently used only for the BaseSettings, Colors LayoutTemplates and Fonts sections
///////////////////////////////////////////////////////////
Scheme
{
	//////////////////////// COLORS ///////////////////////////
	// color details
	// this is a list of all the colors used by the scheme
	Colors
	{
		// base colors
		"White"				"255 255 255 255"
		"TransparentBlack"		"0 0 0 128"
		"Black"				"0 0 0 255"
		"Blank"				"1 1 1 0"
		"TestColor"			"255 0 0 255"

		// scheme-specific colors	
		"OffWhite"			"216 222 211 255"
		"DullGreen"			"216 222 211 255"
		"Maize"				"196 181 80 255"
		
		"LightGrayBG"			"121 126 121 255"
		"GrayBG"			"73 78 73 255"
		"GrayBG2"			"82 89 78 255"
		
		SecBG				GrayBG2

		"ClayBG"			"70 70 70 255"
		"ClayButtonBG"			"87 88 88 255"
		"ClayEnabled"			"85 88 82 255"
		"ClayKeyFocus"			"89 92 77 255"
		"ClayMouseDown"			"85 85 85 255"
		"ClayDisabledText"		"128 134 126 255"
		"ClayLightGreen"		"173 181 168 255"	// frame button (close X) etc
		"ClayDimLightGreen"		"166 172 162 255"	// frame button and title without focus etc
		"LightClayBG"			"104 106 101 255"	// property sheet interior, active tab
		"LightClayButtonBG"		"125 128 120 255"	// buttons on property sheet interior, active tab
		"DarkClayBG"			"47 49 45 255"		// shadow
		"p_ClayMouseDown"		"94 94 94 255"
		"ClaySheetBottom"		"92 89 87 255"

		"MaizeBG"			"145 134 60 255"	// background color of any selected text or menu item

		"GreenBG"			"76 88 68 255"
		"LightGreenBG"			"90 106 80 255"		// darker background color
		"DarkGreenBG"			"62 70 55 255"		// background color of text edit panes (chat, text entries, etc.)
		
		"DisabledText1"			"117 128 111 255"	// disabled text
		"DisabledText2"			"40 46 34 255"		// overlay color for disabled text (to give that inset look

		"NotificationBodyText"		"White"
		
		// button state text colors
		"Normal"			"143 146 141 255"
		"Over"				"196 181 80 255"		// same as Maize
		"Down"				"35 36 33 255"

		// background colors

		// titlebar colors
		"TitleDimText"			"136 145 128 255"
		"TitleBG"			"TestColor"
		"TitleDimBG"			"TestColor"
		
		// border colors
		"BorderBright"			"128 128 128 255"	// the lit side of a control
		"BorderDark"			"40 46 34 255"		// the dark/unlit side of a control
		"BorderSelection"		"0 0 0 255"		// the additional border color for displaying the default/selected button
	}
	

	///////////////////// BASE SETTINGS ////////////////////////
	//
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
	}
	
	//////////////////////// layout /////////////////////////////
	//
	// describes default layouts for controls that have and control their own children
	// works just like a normal settings .res file, except only positioning attributes are recognized
	LayoutTemplates
	{
		Frame
		{
			frame_menu
			{
				visible	0	// hidden
			}

			frame_title
			{
				xpos	0
				ypos	0
				wide	max
				tall	40
				AutoResize	1
			}

			frame_captiongrip
			{
				xpos	0
				ypos	0
				wide	max
				tall	40
				AutoResize	1
			}

			frame_minimize
			{
				xpos	r90
				xpos	22 [$OSX]
				ypos	1
				ypos	12 [$OSX]
				wide	46
				wide	24 [$OSX]
				tall	32
				tall	24 [$OSX]
				PinCorner	1
				PinCorner	0 [$OSX]
			}
			
			frame_maximize
			{
				xpos	r120
				xpos	43 [$OSX]
				ypos	1
				ypos	12 [$OSX]
				wide	46 
				wide	24 [$OSX]
				tall	32
				tall	24 [$OSX]
				
				PinCorner	1
				PinCorner	0 [$OSX]
			}			
			frame_close
			{
				xpos	r47
				xpos	1 [$OSX]
				ypos	1
				ypos	12 [$OSX]
				wide	46
				wide	24 [$OSX]
				tall	32
				tall	24 [$OSX]
				PinCorner	1
				PinCorner	0 [$OSX]
			}

			frame_brGrip
			{
				xpos	r10
				ypos	r10
				PinCorner	3
			}
		}

		PropertyDialog
		{
			sheet
			{
				xpos	9
				ypos	26
				wide	r9
				tall	r48
			}
			// these buttons are still a bit special - if some of them are hidden, they shuffle
			// across taking the place of other buttons to make sure there aren't gaps
			ApplyButton
			{
				xpos	r101
				ypos	r36
				wide	84
				tall	28
			}

			CancelButton
			{
				xpos	r193
				ypos	r36
				wide	84
				tall	28
			}

			OKButton
			{
				xpos	r294
				ypos	r36
				wide	84
				tall	28
			}
		}

		WizardPanel
		{
			subpanel
			{
				xpos	16
				ypos	40
				wide	r16
				tall	r48
				AutoResize	3
			}
			PrevButton
			{
				xpos	r276
				ypos	r36
				wide	84
				tall	28
				PinCorner	3
			}
			NextButton
			{
				xpos	r184
				ypos	r36
				wide	84
				tall	28
				PinCorner	3
			}
			CancelButton
			{
				xpos	r92
				ypos	r36
				wide	84
				tall	28
				PinCorner	3
			}
			FinishButton
			{
				xpos	r184
				ypos	r36
				wide	84
				tall	28
				PinCorner	3
			}
		}
	}

	//
	//////////////////////// FONTS /////////////////////////////
	//
	// !! legacy, should set fonts in the style for a control
	// this is just for reference by the code
	
	Fonts
	{
		"Default"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"13"
				"weight"	"0"
			}
		}
		"DefaultBold"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"15"
				"weight"	"1000"
			}
		}
		"DefaultUnderline"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"13"
				"weight"	"800"
				"underline" "1"
			}
		}
		"DefaultSmall"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"11"
				"weight"	"800"
			}
		}
		ListSmall
		{
			1
			{
				name		Arial
				tall		12
				weight		0
			}
		}
		"DefaultVerySmall"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"12"
				"weight"	"800"
			}
		}

		"DefaultLarge"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"18"
				"weight"	"0"
			}
		}
		"UiBold"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"14"
				"weight"	"1000"
			}
		}
		"HeadlineLarge"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"22"
				"weight"	"1000"
				"antialias" "1"
			}
		}
		"UiHeadline"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"13"
				"weight"	"0"
			}
		}
		"MenuLarge"
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"16"
				"weight"	"600"
				"antialias" "1"
			}
		}
		// this is the symbol font
		"Marlett"
		{
			"1"
			{
				"name"		"Marlett"
				"tall"		"14"
				"weight"	"0"
				"symbol"	"1"
			}
		}
		MarlettLarge
		{
			"1"
			{
				"name"		"Marlett"
				"tall"		"16"
				"weight"	"0"
				"symbol"	"1"
			}
	
		}
		"DefaultFixed"
		{
			"1"
			{
				"name"		"Lucida Console"
				"name"		"Monaco" [$OSX]
				"tall"		"10"
				"weight"	"0"
			}
		}
		"ConsoleText"
		{
			"1"
			{
				"name"		"Lucida Console"
				"name"		"Monaco" [$OSX]
				"tall"		"10"
				"weight"	"500"
			}
		}
		FriendsSmall
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"12"
				"weight"	"800"
			}
		}
		FriendsMedium
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"13"
				"weight"	"800"
			}
		}

		FriendsVerySmall
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"12"
				"weight"	"0"
			}
		}
		FriendsVerySmallUnderline
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"12"
				"weight"	"0"
				"underline"	"1"
			}
		}
		OverlayTaskbarFont
		{
			"1"
			{
				"name"		"Arial"
				"tall"		"16"
				"weight"	"1000"
			}
		}
	}
	

	//
	//////////////////// APPEARANCES //////////////////////////////
	//
	// !! currently unused, just left for reference
	Appearances
	{

		p_ListGiftSendInteriorBorder
		{
			inset				"0 0 0 0"
			render_bg
			{
					"1"		"image_tiled( x0, y0, x1, y0 + 5, graphics/shadowTop )"
					"2"		"fill( x0, y0 + 5, x1, y1, GrayBG )"			// body
					"3"		"image( x1-111, y1 - 132, x1-5, y1-24, graphics/gift_wizard_friends )"
			}
		}

		p_ListGiftSendScrollInteriorBorder
		{
			inset				"0 0 0 0"
			render_bg
			{
					"1"		"image_tiled( x0, y0, x1, y0 + 5, graphics/shadowTop )"
					"2"		"fill( x0, y0 + 5, x1, y1, GrayBG )"			// body
					"3"		"image( x1-111, y1 - 132, x1-5, y1-24, graphics/gift_wizard_friends )"
			}
		}


		ChatInputBorder	// for text entry fields and drop-down controls and  boxes in Chat
		{
			inset				"4 0 4 0"
			render_bg
			{
				"0"		"fill( x0 + 1, y0 + 1, x1 - 1, y1 - 1, DarkGray )"
				"1"		"image( x1 - 10, y0 + 10, x1, y1 - 10, graphics/btnStdRight )"		// right
				"2"		"image( x0, y0 + 10, x0 + 10, y1 - 10, graphics/btnStdLeft )"			// left
				"3"		"image( x0 + 10, y0, x1 - 10, y0 + 10, graphics/btnStdTop )"			// top
				"4"		"image( x0 + 10, y1 - 10, x1 - 10, y1, graphics/btnStdBottom )"		// bottom
				"5"		"image( x1 - 10, y0, x1, y0 + 10, graphics/btnStdTopRight )"			// topright
				"6"		"image( x0, y0, x0 + 10, y0 + 10, graphics/btnStdTopLeft )"			// topleft
				"7"		"image( x1 - 10, y1 - 10, x1, y1, graphics/btnStdBottomRight )"		// bottomright
				"8"		"image( x0, y1 - 10, x0 + 10, y1, graphics/btnStdBottomLeft )"		// bottomleft
			}		
		}
		ListPanelSlantBGWithBorder
		{
			inset				"1 1 1 1"
			render
				{
					"2"		"image( x1 - 3, y0, x1, y0 + 3, graphics/tabSquareTopRight )"		// topright
					"3"		"image( x0 , y0, x0 + 3, y0 + 3, graphics/tabSquareTopLeft )"		// topleft
					"4"		"image( x1 - 3, y1 - 3, x1, y1, graphics/tabStdBottomRight )"	// bottomright
					"5"		"image( x0, y1 - 3, x0 + 3, y1, graphics/tabStdBottomLeft )"	// bottomleft
					"6"		"image( x0 + 3, y0, x1 - 3, y0 + 1, graphics/tabStdTop )"		// top
					"7"		"image( x0, y0 + 3, x0 + 1, y1 - 3, graphics/tabStdLeft )"		// left
					"8"		"image( x1 - 1, y0 + 3, x1, y1 - 3, graphics/tabStdRight )"		// right
					"9"		"image( x0 + 3, y1 - 1, x1 - 3, y1, graphics/tabStdBottom )"	// bottom
				}
			render_bg
				{
					"1"		"image_tiled( x0 + 1, y0 + 1, x1 - 1, y0 + 90, graphics/FriendsListSlantBG )"
					"2"		"fill(   x0 + 1, y0 + 90, x1 - 1, y1 - 1, DarkGray )"			// body
				}
		}
		ListPanelSlantBGNoBorder
		{
			inset				"0 0 0 0"
			render_bg
				{
					"1"		"image_tiled( x0, y0, x1, y0 + 90, graphics/FriendsListSlantBG )"
					"2"		"fill(   x0, y0 + 90, x1, y1, DarkGray )"			// body
				}
		}
		ChatFriendTitlePanelDefault
		{
			render_bg
			{
			    "1"		"image( x0, y0 + 2, x0 + 2, y0 + 50, graphics/FriendsPanelLeftBG )" // left
			    "2"		"fill(  x0 + 2, y0 + 2, x1 - 2, y0 + 50, Friends.PanelDefault )"			// body
			    "3"		"image( x1 - 2, y0 + 2, x1, y0 + 50, graphics/FriendsPanelRightBG )" //right
			}
		}
		
		
		VoiceChatOffBG
		{
			inset				"1 1 1 1"
			render
				{
					"2"		"image( x1 - 3, y0, x1, y0 + 3, graphics/tabStdTopRight )"		// topright
					"3"		"image( x0 , y0, x0 + 3, y0 + 3, graphics/tabStdTopLeft )"		// topleft
					"4"		"image( x1 - 3, y1 - 3, x1, y1, graphics/tabStdBottomRight )"	// bottomright
					"5"		"image( x0, y1 - 3, x0 + 3, y1, graphics/tabStdBottomLeft )"	// bottomleft
					"6"		"image( x0 + 3, y0, x1 - 3, y0 + 1, graphics/tabStdTop )"		// top
					"7"		"image( x0, y0 + 3, x0 + 1, y1 - 3, graphics/tabStdLeft )"		// left
					"8"		"image( x1 - 1, y0 + 3, x1, y1 - 3, graphics/tabStdRight )"		// right
					"9"		"image( x0 + 3, y1 - 1, x1 - 3, y1, graphics/tabStdBottom )"	// bottom
				}
			render_bg
				{
					"0"		"fill( x0 + 1, y0 + 1, x1 - 1, y1 - 1, ClayBG )"
				}
		}
		VoiceChatOnBG
		{
			inset				"1 1 1 1"
			render
				{
					"2"		"image( x1 - 3, y0, x1, y0 + 3, graphics/tabStdTopRight )"		// topright
					"3"		"image( x0 , y0, x0 + 3, y0 + 3, graphics/tabStdTopLeft )"		// topleft
					"4"		"image( x1 - 3, y1 - 3, x1, y1, graphics/tabStdBottomRight )"	// bottomright
					"5"		"image( x0, y1 - 3, x0 + 3, y1, graphics/tabStdBottomLeft )"	// bottomleft
					"6"		"image( x0 + 3, y0, x1 - 3, y0 + 1, graphics/tabStdTop )"		// top
					"7"		"image( x0, y0 + 3, x0 + 1, y1 - 3, graphics/tabStdLeft )"		// left
					"8"		"image( x1 - 1, y0 + 3, x1, y1 - 3, graphics/tabStdRight )"		// right
					"9"		"image( x0 + 3, y1 - 1, x1 - 3, y1, graphics/tabStdBottom )"	// bottom
				}
			render_bg
				{
					"0"		"gradient( x0 + 1, y0 + 1, x1 - 1, y1 - 1, ChatGradientTop, ChatGradientBottom )"
				}
		}
		
		ChatInviteBG
		{
			inset				"1 1 1 1"
			render
				{
					"2"		"image( x1 - 3, y0, x1, y0 + 3, graphics/tabStdTopRight )"		// topright
					"3"		"image( x0 , y0, x0 + 3, y0 + 3, graphics/tabStdTopLeft )"		// topleft
					"4"		"image( x1 - 3, y1 - 3, x1, y1, graphics/tabSquareBottomRight )"	// bottomright
					"5"		"image( x0, y1 - 3, x0 + 3, y1, graphics/tabSquareBottomLeft )"	// bottomleft
					"6"		"image( x0 + 3, y0, x1 - 3, y0 + 1, graphics/tabStdTop )"		// top
					"7"		"image( x0, y0 + 3, x0 + 1, y1 - 3, graphics/tabStdLeft )"		// left
					"8"		"image( x1 - 1, y0 + 3, x1, y1 - 3, graphics/tabStdRight )"		// right
					"9"		"image( x0 + 3, y1 - 1, x1 - 3, y1, graphics/tabStdBottom )"	// bottom
				}
			render_bg
				{
					"0"		"fill( x0 + 1, y0 + 1, x1 - 1, y1 - 1, DarkGray )"
				}
		}
		
		FriendPanelDefault
		{
			render_bg
			{
			    "1"		"image( x0, y0 + 2, x0 + 2, y0 + 50, graphics/FriendsPanelLeftBG )" // left
			    "2"		"fill(  x0 + 2, y0 + 2, x1, y0 + 50, Friends.PanelDefault )"			// body
			}
		}

		FriendPanelMouseOver
		{
			render_bg
			{
			    "1"		"image( x0, y0 + 2, x0 + 2, y0 + 50, graphics/FriendsPanelLeftBG_Over )" // left
				"2"		"fill(  x0 + 2, y0 + 2, x1, y1, Friends.PanelOver )"			// body
			}
		}

		FriendPanelSelected
		{
			render_bg
			{
			    "1"		"image( x0, y0 + 2, x0 + 2, y0 + 50, graphics/FriendsPanelLeftBG_Down )" // left
			    "2"		"fill(  x0 + 2, y0 + 2, x1, y1, Friends.PanelSelected )"			// body
			}
		}
		
		FriendPanelAffordanceMouseover
		{
			render_bg
			{
				"1"		"fill(  x0 + 3, y0 + 1, x1 - 2, y1 - 2, DarkGray )"		//body
				"1"		"fill(  x0 + 2, y0 + 2, x1 - 1, y1 - 3, DarkGray )"		//body
			}
		}
		FriendPanelAffordanceMousedown
		{
			render_bg
			{
				"1"		"fill(  x0 + 3, y0 + 2, x1 - 2, y1 - 2, DarkGray )"		//body
				"1"		"fill(  x0 + 2, y0 + 3, x1 - 1, y1 - 3, DarkGray )"		//body
			}
		}
		FriendPanelAffordanceListMouseover
		{
			render_bg
			{
				"1"		"fill(  x0 + 1, y0, x1 - 1, y1, Friends.PanelDefault )"		//body
				"1"		"fill(  x0, y0 + 1, x1, y1 - 1, Friends.PanelDefault )"		//body
			}
		}

	}
}
