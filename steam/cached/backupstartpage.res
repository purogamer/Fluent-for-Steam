"steam/cached/BackupStartPage.res"
{
	styles
	{
		Label
	    {
			textcolor=white
			font-family=light
			font-weight=300
	    }
	}
	layout
	{
		place {	control="Label1" x=6 y=16 }
		place {	control="RadioButtonBackup,RadioButtonRestore" start=Label1 width=360 x=0 y=6 dir=down spacing=0 }
	}
}