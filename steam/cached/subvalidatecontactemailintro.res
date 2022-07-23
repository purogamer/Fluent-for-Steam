"steam/cached/SubValidateContactEmailIntro.res"
{
	"SubValidateContactEmailIntro"
	{
		"ControlName"		"CSubValidateContactEmailIntro"
		"fieldName"		"SubValidateContactEmailIntro"
		"xpos"		"5"
		"ypos"		"20"
		"wide"		"320"
		"tall"		"300"
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
		"tall"		"80"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#SteamUI_ValidateEmailDescription"
		"textAlignment"		"north-west"
		"dulltext"		"1"
		"brighttext"		"0"
		"wrap"		"1"
	}
	
		"URLLabel1"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"URLLabel1"
		"xpos"		"25"
		"ypos"		"112"
		"wide"		"310"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_TroubleshooterLink"
		"textAlignment"		"west"
		"wrap"		"0"
		"URLText"		"https://support.steampowered.com/kb_article.php?ref=5151-RUAS-1543"
	}
	
	layout
	{
		place { control=HasBeenValidated x=24 y=12 }
		place { control=URLLabel1 x=24 y=100 }
	}
}
 