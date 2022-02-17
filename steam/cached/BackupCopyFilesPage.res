"steam/cached/BackupCopyFilesPage.res"
{
	layout
	{
		place { control=Label3 y=16 width=max }
		place { start=Label3 control=Label1 y=16 dir=down }
		place { start=Label1 control=Label4 x=16 }

		place { start=Label1 control=Label2 y=16 dir=down }
		place { start=Label2 control=TimeReminingLabel x=6 }
		place { start=Label2 control=TotalProgress y=6 dir=down }
	}
}