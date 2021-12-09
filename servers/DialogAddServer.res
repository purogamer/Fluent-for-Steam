"Servers/DialogAddServer.res"
{
	"DialogAddServer"
	{
		"ControlName"		"CDialogAddServer"
		"fieldName"		"DialogAddServer"
		"xpos"		"516"
		"ypos"		"487"
		"wide"		"572"
		"tall"		"390"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"settitlebarvisible"		"1"
		"title"		"#ServerBrowser_AddServersTitle"
	}
	"GameTabs"
	{
		"ControlName"		"PropertySheet"
		"fieldName"		"GameTabs"
		"xpos"		"20"
		"ypos"		"175"
		"wide"		"526"
		"tall"		"150"
		"AutoResize"		"3"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"Servers"
	{
		"ControlName"		"ListPanel"
		"fieldName"		"Servers"
		"xpos"		"0"
		"ypos"		"28"
		"wide"		"526"
		"tall"		"122"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
	}
	"ServerNameText"
	{
		"ControlName"		"TextEntry"
		"fieldName"		"ServerNameText"
		"xpos"		"20"
		"ypos"		"74"
		"wide"		"330"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"textHidden"		"0"
		"editable"		"1"
		"maxchars"		"-1"
		"NumericInputOnly"		"0"
		"unicode"		"0"
	}
	"TestServersButton"
	{
		"ControlName"		"Button"
		"fieldName"		"TestServersButton"
		"xpos"		"356"
		"ypos"		"102"
		"wide"		"190"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"3"
		"paintbackground"		"1"
		"labelText"		"#ServerBrowser_FindGames"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"TestServers"
		"Default"		"0"
	}
	"OKButton"
	{
		"ControlName"		"Button"
		"fieldName"		"OKButton"
		"xpos"		"356"
		"ypos"		"74"
		"wide"		"190"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"2"
		"paintbackground"		"1"
		"labelText"		"#ServerBrowser_AddAddressToFavorites"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"OK"
		"Default"		"1"
	}
	"SelectedOKButton"
	{
		"ControlName"		"Button"
		"fieldName"		"SelectedOKButton"
		"xpos"		"336"
		"ypos"		"340"
		"wide"		"210"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#ServerBrowser_AddSelectedToFavorites"
		"textAlignment"		"west"
		"wrap"		"0"
		"Default"		"0"
	}
	"InfoLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"InfoLabel"
		"xpos"		"22"
		"ypos"		"46"
		"wide"		"330"
		"tall"		"20"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#ServerBrowser_EnterIPofServerToAdd"
		"textAlignment"		"west"
		"font"		"UiBold"
		"wrap"		"0"
	}
	"ExampleLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"ExampleLabel"
		"xpos"		"22"
		"ypos"		"106"
		"wide"		"328"
		"tall"		"74"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"appearance"		"LabelDull"
		"labelText"		"#ServerBrowser_Examples"
		"textAlignment"		"north-west"
		"wrap"		"0"
	}
	"CancelButton"
	{
		"ControlName"		"Button"
		"fieldName"		"CancelButton"
		"xpos"		"482"
		"ypos"		"131"
		"wide"		"64"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"4"
		"paintbackground"		"1"
		"labelText"		"#ServerBrowser_Cancel"
		"textAlignment"		"west"
		"wrap"		"0"
		"Command"		"Close"
		"Default"		"0"
	}
	styles
	{
		CDialogAddServer
		{
			minimum-height=200
		}
		ListPanel
		{
			bgcolor=Header_Dark
		}
		PageTab:selected
		{
			bgcolor=Header_Dark
		}
	}
	layout
	{
		region { name="header" margin=8 margin-top=0 y=40 }
		place { region=header control=InfoLabel,ServerNameText dir=down width=max height=28 spacing=8 margin-right=8 end-right=OKButton }
		place { region=header control=OKButton,TestServersButton start=ServerNameText margin-top=-28 dir=down align=right width=180 height=28 spacing=8 }
		
		place { control=GameTabs start=ServerNameText dir=down y=20 width=max height=max margin-right=8 margin-bottom=44 }
		
		//Bottom
		region { name=bottom align=bottom height=44 margin=8 }
		place {	control="SelectedOKButton,CancelButton" region=bottom align=right spacing=8 height=28 }
		
		//Hidden
		place { control="ExampleLabel" width=0 height=0 }
	}
}
