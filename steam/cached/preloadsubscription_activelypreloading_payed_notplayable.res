"Steam/Cached/PreloadSubscription_ActivelyPreloading.res"
{
	styles
	{
		Label
		{
			font-family=light
			font-weight=300
			font-size=32
			textcolor=white
		}
		LabelDull
		{
			font-family=basefont
			font-size=16
			textcolor=White45
		}
		LabelBright
		{
			font-family=light
			font-weight=300
			font-size=32
			textcolor=white
		}
	}
	layout
	{
		place { control="frame_captiongrip" width=max height=90 }
		//Header
		region { name=clip height=89 }
		place { control="GameNameHeadline" x=15 y=7 margin-right=16 }
		place { region=clip control="Label3" x=16 y=43 margin-right=16 }
		//Content
		place { control="PreloadProgress" x=16 margin-right=16  width=max }
		place { control="PreloadInfo,PreloadProgress" align=top-center dir=down spacing=16 y=120 }
		place { control="PauseButton,Button1" align=top-center height=28 spacing=8 y=192 margin-top=8 }
		//Footer
		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="Button2" region=bottom align=right width=84 height=28 spacing=8 }
	}
}