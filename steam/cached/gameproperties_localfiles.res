"steam/cached/gameproperties_localfiles.res"
{
	styles
	{
		CSubGamePropertiesLocalFilesPage
		{
			render_bg
			{
				0="image(x0+16,y0+24,x1,y1, graphics/metro/labels/gameproperties/localfiles)"
			}
		}
	}
	layout
	{
		place { control="BuildIDLabel,DiskUsageLabel" x=16 y=36 margin-top=24 dir=down spacing=8 }
		place { control="BackupButton,DeleteButton,VerifyButton,DefragButton,OpenInstallFolder,MoveInstallFolder" start="DiskUsageLabel" y=8 width=256 height=28 dir=down spacing=8 }
	}
}