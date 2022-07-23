"steam/cached/JoinGameDialogExpanded.res"
{
	styles
	{
		Label
		{
			font-family=light
			font-weight=300
			textcolor=white
			font-size=32
		}
	}
	layout
	{
		region { name=top margin=16 margin-top=42 }

		//Installation
		place { region=top control=ReadyToPlayInfoLabel,InfoLabel,Progress,ReadyToPlayTimeLabel,AutoLaunchCheckBox y=8 spacing=8 dir=down }

		//Footer
		region { name=bottom align=bottom height=44 margin=8 }
		place { region=bottom control=Button1 height=28 align=left }
		place { region=bottom control=PlayButton,CloseButton height=28 spacing=8 align=right }

		//Hidden
		place { control=ContentHostingLabel,BannerAd,ThrobberThrobberThrobber width=1 align=right }
	}
}