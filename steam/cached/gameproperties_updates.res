"steam/cached/gameproperties_updates.res"
{
	"GamePropertiesUpdates"
	{
		"ControlName"		"CSubGamePropertiesUpdatesPage"
		"fieldName"		"GamePropertiesUpdates"
		"xpos"		"0"
		"ypos"		"28"
		"wide"		"500"
		"tall"		"298"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"UpdateCombo"
	{
		"ControlName"		"ComboBox"
		"fieldName"		"UpdateCombo"
		"xpos"		"24"
		"ypos"		"44"
		"wide"		"334"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"textHidden"		"0"
		"editable"		"0"
		"maxchars"		"-1"
		"NumericInputOnly"		"0"
		"unicode"		"0"
	}
	"UpdateNewsURL"
	{
		"ControlName"		"URLLabel"
		"fieldName"		"UpdateNewsURL"
		"xpos"		"31"
		"ypos"		"116"
		"wide"		"418"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_Game_UpdateNewsURL"
		"textAlignment"		"north-west"
		"wrap"		"0"
		"URLText"		"http://www.steampowered.com/platform/update_history/Day of Defeat Source.html"
	}
	"UpdateInfoText"
	{
		"ControlName"		"Label"
		"fieldName"		"UpdateInfoText"
		"xpos"		"31"
		"ypos"		"74"
		"wide"		"328"
		"tall"		"42"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"borderset"		"LabelDull"
		"labelText"		"#Steam_GameProperties_NeverUpdateInfo"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"320"
	{
		"ControlName"		"Label"
		"fieldName"		"320"
		"xpos"		"24"
		"ypos"		"20"
		"wide"		"320"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_Automatic_Updates"
		"textAlignment"		"west"
		"associate"		"UpdateCombo"
		"wrap"		"0"
	}
	"Divider1"
	{
		"ControlName"		"Divider"
		"fieldName"		"Divider1"
		"xpos"		"20"
		"ypos"		"148"
		"wide"		"450"
		"tall"		"2"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"CloudLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"CloudLabel"
		"xpos"		"20"
		"ypos"		"152"
		"wide"		"450"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_CloudLabel"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	"CloudInfoLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"CloudInfoLabel"
		"xpos"		"20"
		"ypos"		"176"
		"wide"		"450"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_CloudInfo"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}	
	"EnableCloudCheck"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"EnableCloudCheck"
		"xpos"		"17"
		"ypos"		"208"
		"wide"		"420"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"3"
		"paintbackground"		"1"
		"labelText"		"#Steam_EnableCloudForApp"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"CloudUsageLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"CloudUsageLabel"
		"xpos"		"45"
		"ypos"		"238"
		"wide"		"418"
		"tall"		"28"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_CloudUsage"
		"textAlignment"		"west"
		"wrap"		"1"
		style	CloudUsageLabelStyle
	}	

	"CloudEnableLinkLabel"
	{
		"ControlName"	"URLLabel"
		"fieldName"		"CloudEnableLinkLabel"
		"labelText"		"#Steam_CloudEnableLink"
		"URLText"		"steam://settings/downloads"
		"tall"			"28"
	}
	"CloudEnableLinkLabelExtraText"
	{
		"controlname"	"Label"
		"Labeltext"		"#Steam_CloudEnableLinkContinued"
		"tall"			"28"
	}
	styles
	{
		CloudUsageLabelStyle:disabled
		{
			textcolor=White25
		}
		CSubGamePropertiesUpdatesPage
		{
			bgcolor=ClientBG
			render_bg
			{
				0="image(x0+16,y0+24,x1,y1, graphics/metro/labels/gameproperties/automaticupdates)"
				1="image(x0+16,y0+137,x1,y1, graphics/steamcloud)"
			}
		}
	}
	layout
	{
		place { control="UpdateCombo,UpdateNewsURL" x=16 y=42 margin-top=24 dir=down spacing=8	}
		place { control="CloudInfoLabel,EnableCloudCheck,CloudUsageLabel" start=UpdateNewsURL y=35 margin-top=24 dir=down spacing=8	}
		place { control="CloudEnableLinkLabel,CloudEnableLinkLabelExtraText" x=20 y=268 height=28 dir=right spacing=4 wrap=1 }
		//Hidden
		place { control="320,Divider1,UpdateInfoText,CloudLabel" height=0 }
	}
}
