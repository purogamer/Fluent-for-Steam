"steam/cached/gameproperties_betas.res"
{
	styles
	{
		CSubGamePropertiesBetasPage
		{
			bgcolor=ClientBG
			render_bg
			{
				0="image(x0+16,y0+24,x1,y1, graphics/metro/labels/gameproperties/betas)"
			}
		}
	}

	layout
	{
		place { control="GamePropertiesBetas" width=max }
		place { control="Label1" x=16 y=36 margin-top=24 width=max margin-right=8 }
		place { start="Label1" control="UpdateCombo" y=6 width=290 dir=down }
		place { start="UpdateCombo" control="PasswordLabel" y=6 width=max dir=down margin-right=8 }
		place { start="PasswordLabel" control="PasswordEntry" y=6 width=290 dir=down }
		place { control="CheckPasswordButton" start=PasswordEntry y=6 width=106 dir=down spacing=6 }
		place { control="BetaResultsLabel" start=CheckPasswordButton y=6 width=max dir=down spacing=6 margin-right=8 }
	}
}