"steam/cached/SettingsSubOverlay.res"
{
	layout
	{
		//Steam Community
		place { control=Label2,EnableOverlayCheck x=8 y=60 width=max spacing=8 dir=down }
		//Press Shortcut Keys
		place { start=EnableOverlayCheck control=Label1,HotKeySelector y=8 width=180 spacing=8 dir=down }
		//Screenshots
		place { y=36 margin-top=24 width=300 start=HotKeySelector control=ScreenshotLabel,ScreenshotHotKeySelector,ScreenshotNotifyCheck,ScreenshotPlaySoundCheck,ScreenshotSaveUncompressedCheck spacing=8 dir=down }
		place { control=SetScreenshotFolderButton start=ScreenshotSaveUncompressedCheck y=8 height=28 dir=down }
		//Browser	
		place { x=324 y=36 margin-top=24 width=180 start=HotKeySelector control=OverlayHomePageLabel,OverlayHomePage spacing=8 dir=down }
		//Hidden
		place { control=ScreenshotActionLabel width=1 align=right }
	}
}