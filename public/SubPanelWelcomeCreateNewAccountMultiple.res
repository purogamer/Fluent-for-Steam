"Public/SubPanelWelcomeCreateNewAccountMultiple.res"
{
	"SubPanelWelcomeCreateNewAccount"
	{
		"ControlName"		"WizardSubPanel"
		"fieldName"		"SubPanelWelcomeCreateNewAccount"
		"xpos"		"10"
		"ypos"		"28"
		"wide"		"412"
		"tall"		"370"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"WizardWide"		"0"
		"WizardTall"		"0"
	}
	"AccountNotes"
	{
		"ControlName"		"Label"
		"fieldName"		"AccountNotes"
		"xpos"		"24"
		"ypos"		"108"
		"wide"		"350"
		"tall"		"148"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_ChosenCreateDuplicate"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"headline"
	{
		"ControlName"		"Label"
		"fieldName"		"headline"
		"xpos"		"79"
		"ypos"		"59"
		"wide"		"292"
		"tall"		"48"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#SteamUI_ChosenCreateMultipleHeadline"
		"textAlignment"		"north-west"
		"font"		"uiheadline"
		"wrap"		"1"
		style="Important"
	}
	"IconInfo"
	{
		"ControlName"		"ImagePanel"
		"fieldName"		"IconInfo"
		"xpos"		"16"
		"ypos"		"38"
		"wide"		"56"
		"tall"		"56"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"0"
		"image"		"resource/icon_info"
		"gradientVertical"		"0"
		"scaleImage"		"0"
	}
	styles
	{
		Important
		{			
			font-family=semibold
			font-size=18
			font-weight=400
			textcolor="White75"
		}
	}
	layout
	{
		place{ start=IconInfo control=headline y=16 width=max margin-right=8 }
	}
}