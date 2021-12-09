"public/ssadialog.res"
{
	"SSADialog"
	{
		"ControlName"		"CSSADialog"
		"fieldName"		"SSADialog"
		"xpos"		"8"
		"ypos"		"28"
		"wide"		"482"
		"tall"		"515"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"WizardWide"		"0"
		"WizardTall"		"0"
	}

	"SSA"
	{
		"ControlName"		"SSAHTML"
		"fieldName"		"SSA"
		"xpos"		"16"
		"ypos"		"30"
		"wide"		"451"
		"tall"		"365"
		"AutoResize"		"3"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}

	"AgreeLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"AgreeLabel"
		"xpos"		"16"
		"ypos"		"405"
		"wide"		"385"
		"tall"		"48"
		"AutoResize"		"0"
		"PinCorner"		"2"
		"visible"		"1"
		"enabled"		"0"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"appearance"		"LabelBright"
		"labelText"		"#SteamUI_SSA_Agree"
		"textAlignment"		"west"
		"wrap"		"1"
		"style" "important"
	}
	
	"Print"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"PrintLink"
		"xpos"		"16"
		"ypos"		"440"
		"wide"		"180"
		"tall"		"48"
		"autoResize"		"0"
		"pinCorner"		"2"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#Steam_ClickToPrint"
		"textAlignment"		"West"
		"dulltext"		"0"
		"brighttext"		"0"
		"wrap"		"1"
		"URLText"		""
	}

	"AgreeButtom"
	{
		"ControlName"		"Button"
		"fieldName"		"AgreeButton"
		"xpos"		"265"
		"ypos"		"480"
		"wide"		"84"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"3"
		"labelText"		"#Steam_Legal_SSANext"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"Command"		"agree"
		"Default"		"0"
	}

	"CancelButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CancelButton"
		"xpos"		"365"
		"ypos"		"480"
		"wide"		"84"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"labelText"		"#Steam_Legal_SSADisagree"
		"textAlignment"		"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"Command"		"close"
		"Default"		"0"
	}

	styles
	{
		Important
		{
			font-family=basefont
			font-size=14
			font-weight=400
			textcolor="white50"
		}
	}
	layout
	{
		place { control="SSA" width=max height=max margin=8 margin-top=40 margin-bottom=44 }
		region { name=bottom align=bottom height=44 margin=8 }
		place { control="PrintLink" region=bottom x=8 y=4 height=28 }
		place { control="AgreeButton,CancelButton" region=bottom align=right spacing=8 height=28 }
	}
}