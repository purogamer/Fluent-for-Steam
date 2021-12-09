"steam/cached/gameproperties_language.res"
{
	styles
	{
		CSubGamePropertiesLanguagePage
		{
			bgcolor=ClientBG
			render_bg
			{
				0="image(x0+16,y0+24,x1,y1, graphics/metro/labels/gameproperties/language)"
			}
		}
	}

	layout
	{
		place { control="320" x=16 y=36 margin-top=24 width=max margin-right=8 }
		place { start="320" control="UpdateCombo" y=6 width=290 dir=down }
	}
}