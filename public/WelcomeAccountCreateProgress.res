"Steam/WelcomeAccountCreateProgr"
{
	"AccountCreateProgressDialog"
	{
		"ControlName"		"Frame"
		"fieldName"		"AccountCreateProgressDialog"
		"wide"		"300"
		"tall"		"94"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"FakeButton"
	{
		"ControlName"		"Button"
		"fieldName"		"FakeButton"
		"xpos"		"-100"
		"ypos"		"-100"
		"wide"		"64"
		"tall"		"24"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"0"
		"tabPosition"		"0"
		"labelText"		"Cancel"
		"textAlignment"		"west"
		"default"		"0"
	}
	"InfoLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"InfoLabel"
		"xpos"		"28"
		"ypos"		"38"
		"wide"		"240"
		"tall"		"48"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		""
		"textAlignment"		"west"
		"dulltext" "1"
		"wrap"			"1"
	}

	styles
	{
		Label
		{
			textcolor=White75
			font-size=26
		}
	}
	layout
	{
		place { control="InfoLabel" y=42 align=top-center margin=8 }
		region { name="bottom" align=bottom height=42 margin=8 }
		place { control="FakeButton" region=bottom align=right width=96 height=24 }
	}
}