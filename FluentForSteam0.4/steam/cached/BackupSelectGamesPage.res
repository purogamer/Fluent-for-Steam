"steam/cached/BackupSelectGamesPage.res"
{
	layout
	{
		place { control=Label1 y=16 width=max }
		place { start=Label1 control=AppChecklist y=6 width=max dir=down }

		place { start=AppChecklist control=Label2 y=6 dir=down }
		place { start=Label2 control=SpaceRequiredLabel x=6 }
	}
}