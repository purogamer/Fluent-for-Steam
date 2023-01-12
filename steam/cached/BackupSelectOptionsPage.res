"steam/cached/BackupSelectOptionsPage.res"
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
		"Label2"
		{
			font-size=18
			textcolor=white
			font-family=basefont
		}
		
	}
	layout
	{
		region { name="top" width=max margin=8 height=250}
		place { control=Label5 region="top" dir=down  margin-top=32 width=max}
		place { start=Label5 control=Label2 y=16 width=max dir=down }

		place { start=Label2 control=ArchiveName y=6 width=max height=32 dir=down }
		place { start=ArchiveName control=Label1 y=6 height=24 dir=down }

		place { start=Label1 control=CustomFileSizeEntry x=6 width=140 height=24 }
		place { start=CustomFileSizeEntry control=CustomFileSizeLabel x=2 height=24 }
		place { start=Label1 control=SizeCombo align=right }

		place { start=Label1 control=Label4 y=6 dir=down }
		place { start=Label4 control=Label3 x=6 y=12 }
	}
}