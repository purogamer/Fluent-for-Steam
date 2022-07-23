"steam/cached/BackupRestoreGamesPage.res"
{
	layout
	{
		place { control=Label2 y=16 width=max }
		place { start=Label2 control=Label1 y=6 width=max dir=down }
		place { start=Label1 control=DirectoryLabel y=6 width=max dir=down margin-right=76 }
		place { start=DirectoryLabel control=Button1 x=6 width=84 }
		place { start=DirectoryLabel control=Label3 y=6 dir=down }
		place { start=Label3 control=RestoreGameLabel x=6 }
	}
}