"public/LimitedUserDialog.res"
{
	"LimitedUserDialog"
	{
		"ControlName"		"CLimitedUserDialog"
		"fieldName"		"LimitedUserDialog"
		"xpos"		"1080"
		"ypos"		"631"
		"wide"		"400"
		"tall"		"308"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		""
	}
	"OKButton"
	{
		"ControlName"		"Button"
		"fieldName"		"OKButton"
		"xpos"		"288"
		"ypos"		"266"
		"wide"		"84"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#vgui_close"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"1"
	}
	"Label1"
	{
		"ControlName"		"Label"
		"fieldName"		"Label1"
		"xpos"		"40"
		"ypos"		"40"
		"wide"		"300"
		"tall"		"60"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Friends_SteamCommunity"
		"textAlignment"		"north-west"
		"font"		"HeadlineLarge"
		"wrap"		"1"
	}
	"LimitedFeature"
	{
		"ControlName"		"Label"
		"fieldName"		"LimitedFeature"
		"xpos"		"40"
		"ypos"		"105"
		"wide"		"280"
		"tall"		"58"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"feature name"
		"textAlignment"		"north-west"
		"font"		"HeadlineLarge"
		"wrap"		"1"
	}
	"Label3"
	{
		"ControlName"		"Label"
		"fieldName"		"Label3"
		"xpos"		"40"
		"ypos"		"167"
		"wide"		"320"
		"tall"		"80"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Limited_Explanation"
		"textAlignment"		"north-west"
		"font"		"UiBold"
		"wrap"		"1"
	}
	"URLLabel1"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"URLLabel1"
		"xpos"		"40"
		"ypos"		"238"
		"wide"		"280"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Limited_ForDetails"
		"textAlignment"		"west"
		"wrap"		"0"
		"URLText"		"https://support.steampowered.com/kb_article.php?ref=3330-IAGK-7663"
	}

	layout
	{
		place { control="Label1" y=44 align=top-center margin=16 }
		place { control="LimitedFeature" x=16 y=80 width=max margin-right=16 }
		place { start=LimitedFeature control="Label3" y=20 width=max dir=down margin-right=16 }
		place { start=Label3 control="URLLabel1" y=30 width=max dir=down margin-right=16 }
		
		region { name=bottom align=bottom height=44 margin=8 }
		place { control="OKButton" region=bottom align=right height=28 }
	}
}