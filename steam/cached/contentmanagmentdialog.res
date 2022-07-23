"steam/cached/contentmanagmentdialog.res"
{
	styles
	{
		ListPanelColumnHeader
		{
			padding-left=4
		}
		ListPanel
		{
			padding-left=8
		}
	}

	layout
	{	
		place { control="frame_captiongrip" width=max height=75 }

		place { control="Label1" x=16 y=40 width=max margin-right=8 }
		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="InstallFoldersList" width=max height=max margin-top=76 margin-bottom=44 }
		place { control="AddFolderButton" region="bottom" height=28 align=left }
		place { control="CloseButton" region="bottom" spacing=6 width=84 height=28 align=right }
	}
}