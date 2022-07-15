"Steam/Cached/SystemInfoPage.res"
{
	styles
	{
		RichText
		{
			bgcolor=Header_Dark
		}
	}
	layout
	{
		//Text
		place { control="Label1" y=16 width=max }
		//List
		place { control="ValveSurveySummaryText" start=Label1 dir=down y=16 width=max height=max margin-bottom=38 }
		//Bottom
		region { name=bottom align=bottom height=28 margin-top=0 }
		place {	control="URLLabel1" region=bottom height=28 margin-right=8 end-right=Button1 }
		place {	control="Button1" region=bottom align=right spacing=8 height=28 width=84 }
	}
}