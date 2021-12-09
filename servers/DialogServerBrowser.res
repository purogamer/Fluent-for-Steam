"Servers/DialogServerBrowser.res"
{
	"CServerBrowserDialog"
	{
		"ControlName"		"Frame"
		"fieldName"		"CServerBrowserDialog"
		"xpos"		"1"
		"ypos"		"1"
		"wide"		"602"
		"tall"		"387"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"GameTabs"
	{
		"ControlName"		"PropertySheet"
		"fieldName"		"GameTabs"
		"xpos"		"20"
		"ypos"		"24"
		"wide"		"638"
		"tall"		"338"
		"autoResize"	"3"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
	}
	"StatusLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"StatusLabel"
		"xpos"		"1"
		"ypos"		"362"
		"wide"		"5000"
		"tall"		"24"
		"autoResize"		"1"
		"pinCorner"		"2"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"textAlignment"		"west"
		"dulltext"		"0"
		"zpos"	"-1"
		style="status"
	}

	styles
	{
		status
		{
			bgcolor="ClientBG"
			inset="8 0 0 0"
		}
	}
	layout
	{
		//List
		place { control="GameTabs" margin-top=12 height=max width=max }
		place [$OSX] { control="GameTabs" margin-top=39 height=max width=max }
		//Bottom
		place { control="StatusLabel" width=1 align=right }
	}
}