"steam/cached/BackupSelectGamesPage.res"
{
	Styles
	{

	"Label"
		{
			font-size=18
			textcolor=white
			font-family=basefont
		}
	}
	layout
	{
		region { name="top" width=max margin=8 height=250}
		place { start=Label2  region=top  height=max control=AppChecklist width=max dir=down }
		
		place { control="Label1" region=top dir=down  margin-top=30  width=max }
		place { region=top  control=Label2 start=Label1 margin-top=6 dir=down }
		place { region=top control=SpaceRequiredLabel start=label2 margin-left=2 dir=right}
		
	}
}