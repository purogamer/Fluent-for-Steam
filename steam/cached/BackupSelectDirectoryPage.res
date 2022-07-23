"steam/cached/BackupSelectDirectoryPage.res"
{
	layout
	{
		place { control="Label2" y=24 width=max }
		place { start=Label2 control="Label1" y=6 width=max dir=down }
		place { start=Label1 control="DirectoryLabel" y=6 width=max height=28 margin-right=84 dir=down }
		place { start=DirectoryLabel control="Button1" x=6 width=84 height=28 }
		place { start=DirectoryLabel control="Label3,Label4" y=6 dir=down }
		place { start=Label3 control="SpaceRequiredLabel" x=16 }
		place { start=Label4 control="SpaceAvailableLabel" x=16 }
	}
}