"Public/SubExtraFactorAuth.res"
{
	"BG_Security"
	{
		"ControlName"	"ImagePanel"
		"fieldName"	"BG_Security"
		"xpos"		"0"
		"ypos"		"20"
		"wide"		"360"
		"tall"		"344"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"image"		"graphics/bg_security_wizard"
		"fillcolor"		""
		"gradientStart"		""
		"gradientEnd"		""
		"gradientVertical"		"0"
		"scaleImage"		"0"
		"zpos"			"1"
	}
	
	"SubExtraFactorAuth"
	{
		"ControlName"		"SubExtraFactorAuth"
		"fieldName"		"SubExtraFactorAuth"
		"xpos"		"5"
		"ypos"		"20"
		"wide"		"320"
		"tall"		"450"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"WizardWide"		"0"
		"WizardTall"		"0"
		"zpos"			"3"
	}
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"24"
		"ypos"		"10"
		"wide"		"320"
		"tall"		"48"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#Steam_RecoverLocked_EnterCode"
		"textAlignment"		"west"
		"dulltext"		"1"
		"brighttext"		"0"
		"wrap"		"1"
		"zpos"			"3"
		"style"			"header"
	}
	"AuthCode"
	{
		"ControlName"		"TextEntry"
		"fieldName"		"AuthCode"
		"xpos"		"80"
		"ypos"		"50"
		"wide"		"190"
		"tall"		"50"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"textHidden"		"0"
		"editable"		"1"
		"maxchars"		"-1"
		"NumericInputOnly"	"0"
		"unicode"			"0"
		"zpos"			"3"
		"style"			"codeEntry"
	}
	"Label2"
	{
		"ControlName"		"Label"
		"fieldName"		"Label2"
		"xpos"		"80"
		"ypos"		"110"
		"wide"		"200"
		"tall"		"96"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#Steam_RecoverLocked_EnterCodeDetails"
		"textAlignment"		"north-west"
		"dulltext"		"1"
		"brighttext"		"0"
		"wrap"		"1"
		"zpos"			"3"
	}
	"IconKey"
	{
		"ControlName"	"ImagePanel"
		"fieldName"	"IconKey"
		"xpos"		"24"
		"ypos"		"50"
		"wide"		"48"
		"tall"		"48"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"image"		"graphics/icon_security_key"
		"fillcolor"		""
		"gradientStart"		""
		"gradientEnd"		""
		"gradientVertical"		"0"
		"scaleImage"		"0"
		"zpos"			"2"
	}
	"RememberThisComputer"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"RememberThisComputer"
		"xpos"		"24"
		"ypos"		"260"
		"wide"		"300"
		"tall"		"24"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"Remember This Computer?"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"0"
		"Default"		"0"
		"zpos"			"3"
	}	
	styles
	{
		header
		{
		font-size=14
		}
		
		codeEntry
		{
		font-size=36
		}
	}
	layout
	{
		place { control="frame_minimize,frame_maximize,frame_close" align=right width=40 height=40 margin-right=1 }
	}
}
 