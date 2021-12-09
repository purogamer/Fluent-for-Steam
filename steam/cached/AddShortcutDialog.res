"steam/cached/AddShortcutDialog.res"
{
	styles
	{
		"ListPanelColumnHeader CheckButton"
		{
			inset-left=1
			inset-top=-1
		}
		ListPanelCheckBox
		{
			padding-left=4
		}
	}

	layout
	{
		place { control="AppList" height=max width=max x=1 margin-right=1 margin-top=76 margin-bottom=44 }
		place { control="Label1" x=16 y=42 width=max margin-right=8 }

		region { name="right" align=bottom height=44 }
		place { control="BrowseButton,AddSelectedButton,CloseButton" region=right height=28 spacing=6 margin=8 align=right }	
	}
}