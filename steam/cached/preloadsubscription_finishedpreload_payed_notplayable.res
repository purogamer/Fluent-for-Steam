"Steam/Cached/PreloadSubscription_FinishedPreload_Payed_NotPlayable.res"
{
	styles
	{
		LabelBright
		{
			textcolor=white
			font-family=light
			font-size=32
			font-weight=300
		}
		ProgressBar
		{
			textcolor="none"
			bgcolor="none"
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/metro/icons/preload/complete)"
			}
			render{}
		}
	}
	layout
	{
		place { control="frame_captiongrip" width=max height=90 }
		//Header
		place { control="Label1" x=15 y=7 margin-right=16 }
		place { control="Label4" x=16 y=43 margin-right=16 }
		//Content
		place { control="PreloadProgress" width=120 }
		place { control="Label2,PreloadProgress" align=top-center dir=down spacing=16 y=120 }
		//Footer
		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="Button1" region=bottom align=right width=84 height=28 spacing=8 }
	}
}