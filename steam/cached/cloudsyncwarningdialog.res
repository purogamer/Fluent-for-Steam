"steam/cached/cloudsyncwarningdialog.res"
{
	styles
	{
		CSyncFailureDialog
		{
			bgcolor=ClientBG
			render_bg
			{
				0="image(x0+38,y0+44,x1,y1, graphics/cloudsync)"
				1="fill( x0, y1-44, x1, y1-43, frameBorder )"
				2="fill( x0, y1-43, x1, y1, Header_Dark )"
			}
		}
	}
	layout
	{
		//Padding
		region { name=top margin=38 margin-top=0 }

		//Image and URL
		place { region=top control=ImagePanel1 width=max height=40 y=62 margin-top=24 dir=right }

		//Info
		place { region=top start=ImagePanel1 control=Label3 y=24 margin-top=-6 width=max dir=down }

		//Footer
		region { name=bottom align=bottom height=44 margin=8 }
		place { region=bottom control=ContinueButton,CancelButton height=28 spacing=8 align=right	 }

		//Hidden
		place { control=Label1,Divider1 width=1 align=right }
	}
}