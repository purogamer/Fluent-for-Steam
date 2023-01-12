"steam/cached/BackupStartPage.res"
{
	styles
	{
		RadioButton {
			textcolor=white75
			minimum-width=643
		}
		RadioButton:hover {
			textcolor=white
		}
		RadioButton:selected {
			textcolor=white
		}
	   "Label"
		{
			font-size=18
			textcolor=white
			font-family=basefont
		}
	}
	layout
	{
		region { name="top" width=max margin=8 margin-top=30}
		place { control="Label1," region=top dir=down  width=max }
		place { region=top starT=label1 margin-top=6 spacing=2 dir=down control=RadioButtonBackup,RadioButtonRestore }
	}
}