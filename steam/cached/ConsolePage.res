"steam/cached/consolepage.res"
{
	"ConsolePage"
	{
		"ControlName"		"CConsolePage"
		"fieldName"		"ConsolePage"
		"xpos"		"1"
		"ypos"		"1"
		"wide"		"816"
		"tall"		"424"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		
		style=ConsolePage
	}
	"CompletionList"
	{
		"ControlName"		"Menu"
		"fieldName"		"CompletionList"
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
	"entry"
	{
		"ControlName"		"TabCatchingTextEntry"
		"fieldName"		"entry"
		"xpos"		"0"
		"ypos"		"400"
		"wide"		"816"
		"tall"		"24"
		"AutoResize"		"1"
		"PinCorner"		"2"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"textHidden"		"0"
		"editable"		"1"
		"maxchars"		"-1"
		"NumericInputOnly"		"0"
		"unicode"		"1"
	}
	"console"
	{
		"ControlName"		"CConsoleHistory"
		"fieldName"		"console"
		"xpos"		"0"
		"ypos"		"1"
		"wide"		"816"
		"tall"		"376"
		"AutoResize"		"3"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"maxchars"		"-1"
		"ScrollBar"		"1"
	}
	
	styles
	{
		ConsolePage
		{
	bgcolor=ClientBG
	
      font-size=18
      textcolor="white"
		}

		CConsoleHistory
    {
      font-family=monospace
      font-size=18
      textcolor="white75"
	  font-weight=600
      selectedtextcolor="White"
			padding=0
			inset=0
    }
	}
	layout
	{
		region{name="consolepage" margin=14}
		place { control="entry" margin-top=4 margin-right=12 margin-left=12 align=top height=32 width=max }
		place { region=consolepage control="console" start="entry" margin-top=2 height=max width=max dir=down }
	}
}
