"public/ssasubpanel.res"
{
	"SSASubPanel"
	{
		"ControlName"		"CSSASubPanel"
		"fieldName"		"SSASubPanel"
		"xpos"		"8"
		"ypos"		"28"
		"wide"		"462"
		"tall"		"500"
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
		"ypos"		"16"
		"wide"		"431"
		"tall"		"400"
		"AutoResize"		"3"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"AgreeCheck"
	{
		"ControlName"		"Label"
		"fieldName"		"AgreeCheck"
		"xpos"		"16"
		"ypos"		"440"
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
		style="important"
	}
	"Print"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"PrintLink"
		"xpos"		"16"
		"ypos"		"475"
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
		place { control="SSA" width=max height=400 margin-top=20 margin-bottom=76 }
		region { name=bottom align=bottom height=76 margin=8 }
		place { control="AgreeCheck" region=bottom x=8 y=4 align=left width=max }
		place { start=AgreeCheck control="PrintLink" y=4 height=26 dir=down }
	}
}