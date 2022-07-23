"steam/cached/UpdateNewsDialog.res"
{
	styles {
		
           CUpdateNewsDialog {

          minimum-height=720
          minimum-width=695
      }
		 button {
            render_bg {

                 1="image( x0 , y0 , x1, y1, graphics/buttons/button )"
               
            }
             padding-left=125
             padding-right=125
           
        }
        
        button:hover {
            textcolor=white75
            render_bg {

                 1="image( x0 , y0 , x1, y1, graphics/buttons/button_h )"
               
            }
           
        }
        
        button:active {
            render_bg {

                 1="image( x0 , y0 , x1, y1, graphics/buttons/button_p )"
              
            }
           
        }
	}
	layout
	{
		place { control=frame_title height=33 align=top margin-top=9 margin-left=12 }
		place { control="HTMLSellPage" margin-top=33 margin-bottom=48 width=max height=max }
		region { name=buttxns align=bottom height=43}
		region { name="bottom" align=bottom height=44 margin=8 }
		place { region=buttxns control="PrevButton,NextButton," align=top-center margin-bottom=8 spacing=20 width=325 height=32 }
		place { control=CloseButton x=9999}
	}
}