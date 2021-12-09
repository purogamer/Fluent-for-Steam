"steam/cached/BackupSelectOptionsPage.res"
{
	layout
	{
		place { control=Label5 y=16 width=max }
		place { start=Label5 control=Label2 y=16 width=max dir=down }

		place { start=Label2 control=ArchiveName y=6 width=max dir=down }
		place { start=ArchiveName control=Label1 y=6 height=24 dir=down }

		place { start=Label1 control=CustomFileSizeEntry x=6 width=140 height=24 }
		place { start=CustomFileSizeEntry control=CustomFileSizeLabel x=2 height=24 }
		place { start=Label1 control=SizeCombo align=right }

		place { start=Label1 control=Label4 y=6 dir=down }
		place { start=Label4 control=Label3 x=6 y=12 }
	}
}