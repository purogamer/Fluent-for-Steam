"steam/cached/BackupSelectDirectoryPage.res"
{
	styles {
		textentry{
			font-size=18
			textcolor=white75
			font-family=basefont
		}
		textentry:selected{
			font-size=18
			textcolor=white
			font-family=basefont
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
		region { name="top" width=max margin=8 height=250}
		place { control="Label2" region="top"  dir=down  margin-top=32 width=max  }
		place { start=Label2 control="Label1" region="top"  dir=down  width=max  }
		place { start=Label1 control="DirectoryLabel" y=6 region="top"  width=max height=32 margin-right=84 dir=down }
		place { start=DirectoryLabel control="Button1" x=6  region="top"  width=84 height=32 }
		place { start=DirectoryLabel control="Label3,Label4" region="top"  y=6 dir=down }
		place { start=Label3 control="SpaceRequiredLabel" region="top"   x=16 }
		place { start=Label4 control="SpaceAvailableLabel" region="top"   x=16 }
	}
}