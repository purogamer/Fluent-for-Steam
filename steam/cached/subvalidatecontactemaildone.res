"steam/cached/SubValidateContactEmailDone.res"
{
	"SubValidateContactEmailDone"
	{
		"ControlName"		"CSubValidateContactEmailDone"
		"fieldName"		"SubValidateContactEmailDone"
		"xpos"		"5"
		"ypos"		"29"
		"wide"		"360"
		"tall"		"220"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"WizardWide"		"0"
		"WizardTall"		"0"
	}
	"HasBeenValidated"
	{
		"ControlName"		"Label"
		"fieldName"		"HasBeenValidated"
		"xpos"		"24"
		"ypos"		"24"
		"wide"		"320"
		"tall"		"72"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"Working."
		"textAlignment"		"south-west"
		"dulltext"		"1"
		"brighttext"		"0"
		"wrap"		"1"
	}
	"NotReceived"
	{
		"ControlName"		"Label"
		"fieldName"		"NotReceived"
		"xpos"		"24"
		"ypos"		"84"
		"wide"		"320"
		"tall"		"20"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#SteamUI_ValidateEmailNotReceived"
		"textAlignment"		"north-west"
		"dulltext"		"1"
		"brighttext"		"0"
		"wrap"		"1"
	}
	"SupportURLLabel"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"SupportURLLabel"
		"xpos"		"24"
		"ypos"		"104"
		"wide"		"320"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_VisitSteamSupport"
		"textAlignment"		"north-west"
		"wrap"		"0"
		"URLText"		"https://support.steampowered.com/kb_article.php?ref=5151-RUAS-1543#noemail"
	}
	
	layout
	{
		place { control=HasBeenValidated width=320 height=72 x=24 y=12 }
	}
}
 