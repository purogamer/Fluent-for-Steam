"steam/cached/BackupRestoreGamesPage.res"
{
	styles {
		label {
			textcolor=white
			font-size=18
		}
		"CBackupwizard FrameCloseButton" {
			render_bg{}
			render {}
			bgcolor=none
		}
		"CBackupwizard FrameCloseButton:hover"{
			render_bg{}
			render {}
			bgcolor=none
		}
	}
	layout
	{
			region { name="top" width=max margin=8 height=250}
		place { control="Label2" region="top"  dir=down  margin-top=32 width=max  }
		place { start=Label2 control="Label1" region="top"  dir=down  width=max  }
		place { start=Label1 control="DirectoryLabel" y=6 region="top"  width=max height=32 margin-right=84 dir=down }
		place { start=DirectoryLabel control="Button1" x=6  region="top"  width=84 height=32 }
		place { start=DirectoryLabel control="Label3" region="top"  y=6 dir=down }
		place { start=Label3 control="RestoreGameLabel" region="top"   x=16 }
	
	}
}