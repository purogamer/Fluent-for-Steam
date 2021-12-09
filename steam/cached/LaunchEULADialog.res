"steam/cached/LaunchEULADialog.res"
{
	layout
	{
		place { control=Label1 x=8 y=11 }
		place { control=HTML y=40 width=max height=max dir=down margin-bottom=44 }
		place { control=Label2 start=HTML y=8 }
		//Footer
		region { name=bottom align=bottom height=44 margin=8 }
		place { control="AcceptButton,DeclineButton" region=bottom align=right height=28 width=84 spacing=8 }
	}
}