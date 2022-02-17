"steam/cached/SettingsSubDownloads.res"
{
	layout
	{
		//Internet Connection
		place { control="Label4,InternetSpeed,PingRateLabel,PingRateCombo,Label5,DownloadRegionCombo" width=310 y=60 x=8 margin-right=8 margin-top=0 margin-bottom=8 dir=down spacing=8 }
		//Steam Cloud
		place { control="Label8,EnableCloudCheck,EnableScreenshotsCheck" start=DownloadRegionCombo width=max y=36 margin-top=24 margin-right=8 margin-bottom=8 dir=down spacing=8 }
		//Steam Library Folders
		place { control="ManageInstalledAppsButton" start=EnableScreenshotsCheck align=left dir=down width=168 height=28 y=8 }
		//Hidden
		place { control=Label3,RegionInfoLabel,PingRateInfo,Divider1,Divider2,Label7 width=1 align=right }
	}
}