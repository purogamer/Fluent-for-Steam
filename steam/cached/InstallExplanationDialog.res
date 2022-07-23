"Steam/cached/InstallExplanationDialog.res"
{
	styles
	{
		Button
		{
			minimum-width=84
		}
	}
	layout
	{
		//Content
		place { control="ExplanationHTML" width=max height=max margin-top=40 margin-bottom=44 }
		//Footer
		region { name=bottom align=bottom height=44 margin=8 }
		place { control="InstallButton,Button1" region=bottom align=right height=28 spacing=8 }
	}
}