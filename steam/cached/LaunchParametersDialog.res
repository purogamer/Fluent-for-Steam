"Steam/Cached/LaunchParametersDialog.res"
{
	styles
	{
		Label
		{
			textcolor=White
		}
	}
	layout
	{
		place { control="frame_captiongrip" width=max height=75 }
		place { control=label1 x=16 y=42 width=max margin-right=8 dir=down }
		place { control=LaunchOptions x=16 y=92 width=max margin-right=8 dir=down }
		//Bottom
		region { name=bottom align=bottom height=44 margin=8 }
		place { control="Button2,Button1" region=bottom align=right spacing=6 height=28 width=84 }
	}
}