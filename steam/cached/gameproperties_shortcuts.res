"steam/cached/gameproperties_shortcuts.res"
{
	styles
	{
		Label
		{
			font-family=semilight
			font-size=28
			textcolor=white
		}
	}
	layout
	{
		place { control=IconPlaceholder x=8 y=20 height=28 }
		place { start=IconPlaceholder control=Name,Button1 x=40 height=28 spacing=6 }

		//Target
		place { control=Label2 x=8 y=100 height=28 }
		place { start=Label2 control=Target x=5 y=4 height=28 }

		//Start In
		place { control=Label3 x=8 y=150 height=28 }
		place { start=Label3 control=StartIn x=5 y=4 height=28 }

		place { control=LaunchOptionsButton,FindTarget x=8 y=200 height=28 spacing=6 }
		place { start=LaunchOptionsButton control=EnableDesktopGameTheater,IsVRShortcut y=3 dir=down width=max margin-right=8 }
	}
}