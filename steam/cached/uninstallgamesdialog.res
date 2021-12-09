"steam/cached/UninstallGamesDialog.res"
{
	layout
	{
		place{ control=frame_captiongrip width=max height=max }

		place{ control=UninstallInfoLabel x=16 width=max align=left-center end-right=Throbber }
		place{ start=UninstallInfoLabel control=Throbber align=right margin-right=16 }
	}
}