"steam/cached/UpdateNewsDialog.res"
{
	layout
	{
		place { control=frame_title align=bottom }
		place { control="HTMLSellPage" margin-top=40 margin-bottom=44 width=max height=max }

		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="PrevButton,NextButton,CloseButton" region=bottom align=right width=84 height=28 spacing=8 }
	}
}