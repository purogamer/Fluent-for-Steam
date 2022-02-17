"steam/cached/managedeviceauthdialog.res"
{
	styles
	{
		ListPanel
		{
			bgcolor=Header_Dark
			padding-left=8
			inset-right=0
		}
	}
	layout
	{
		place { control="Label1,LocalDeviceTokensList" dir=down width=max height=max x=8 y=42 margin-right=8 margin-bottom=44 spacing=8 }
		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="DeviceButton,CloseButton" region=bottom align=right height=28 spacing=8 }
	}
}