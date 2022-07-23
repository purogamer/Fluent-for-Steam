"steam/cached/movelibrarydialog.res"
{
	layout
	{
		place { control="MoveFolderInfoLabel,InstallFolderLabel,InstallFolderCombo,ProgressBar,InfoLabel" x=16 y=44 dir=down spacing=6 margin-right=16 }

		//Footer
		region { name=bottom align=bottom height=44 margin=8 margin-right=8 }
		place { control="MoveButton,CloseButton" region=bottom align=right spacing=8 width=84 height=28 }
	}
}