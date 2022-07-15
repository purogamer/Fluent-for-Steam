"Steam/Cached/CDKeyLaunchDialog.res"
{
	layout
	{
		place { control="ReasonLabel" x=8 y=44 margin-right=8 width=max }
		place { start=ReasonLabel control="KeyList" y=6 dir=down width=max height=max margin-right=8 margin-bottom=48 }

		//Bottom
		region { name=bottom align=bottom height=44 margin=8 }
		place {	control="DontShowAgainCheck" region=bottom align=left height=28 }
		place {	control="LaunchButton,CopyButton,CloseButton" region=bottom spacing=6 align=right height=28 margin-right=8 }
	}
}