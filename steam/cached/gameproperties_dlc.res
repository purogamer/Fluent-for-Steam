"steam/cached/gameproperties_dlc.res"
{
	styles
	{
		CSubGamePropertiesDLCPage
		{
		}
	}
	
	layout
	{
		//Hidden
		place { control="DescriptionLabel" height=0 }
		
		place { control="ContentList" width=max height=max margin-bottom=44 }
		place { control="StoreDLCURL" start=ContentList width=max height=24 dir=down }
	}
}