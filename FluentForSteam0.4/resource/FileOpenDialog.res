"resource/FileOpenDialog.res"
{
	styles
	{
		ComboBox
		{
			bgcolor=TextEntry
			render_bg{}
		}
	}
	layout
	{
		//Top
		place { control="LookInLabel" x=8 y=48 align=left }
		place { start=LookInLabel control="FullPathEdit" x=6 width=max margin-right=69 }
		place { start=FullPathEdit control="FolderUpButton,NewFolderButton" x=6 width=24 height=24 spacing=6 margin-right=8 }
		//Bottom-First Row
		region { name="first" align=bottom width=max height=60 }
		place { region=first control="FileNameLabel" x=8 width=110 align=left margin-bottom=8 }
		place { region=first start=FileNameLabel control="FileNameEdit" width=max height=24 margin-bottom=8 margin-right=108 }
		place { region=first start=FileNameEdit control="OpenButton" align=right width=92 height=24 margin-bottom=8 margin-right=8 }
		//Bottom-Second Row
		region { name="second" align=bottom width=max height=30 }
		place { region=second control="FileTypeLabel" x=8 width=110 align=left margin-bottom=8 }
		place { region=second start=FileTypeLabel control="FileTypeCombo" width=max height=24 margin-bottom=8 margin-right=108 }
		place { region=second start=FileTypeCombo control="CancelButton" align=right width=92 height=24 margin-bottom=8 margin-right=8 }
	}
}