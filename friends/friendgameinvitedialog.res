"Friends/friendgameinvitedialog.res"
{
	controls
	{
		"FriendGameInviteDialog"
		{
			"ControlName"   "CFriendGameInviteDialog"
			"fieldName"   "FriendGameInviteDialog"
			"xpos"    "2123"
			"ypos"    "549"
			"wide"    "356"
			"tall"    "746"
			"AutoResize"    "1"
			"PinCorner"   "0"
			"visible"   "1"
			"enabled"   "1"
			"tabPosition"   "0"
			"paintbackground"   "1"
			"settitlebarvisible"    "1"
			style="FriendsPanel"   
			closeonescape=1
		}		

		"BuddyList"
		{
			"ControlName"   "CFriendsListSubPanel"
			"fieldName"   "BuddyList"
			"AutoResize"    "3"
			"PinCorner"   "0"
			"visible"   "1"
			"enabled"   "1"
			"tabPosition"   "0"
			"paintbackground"   "0"
			"linespacing"   "48"
			style="FriendsList"
		}
		
		"CloseButton"
		{
			"ControlName"   "Button"
			"fieldName"   "CloseButton"
			"xpos"    "10"
			"ypos"    "707"
			"wide"    "150"
			"tall"    "24"
			"AutoResize"    "0"
			"PinCorner"   "2"
			"visible"   "1"
			"enabled"   "1"
			"tabPosition"   "0"
			"paintbackground"   "1"
			"labelText"   "#Friends_InviteToGame_Close"
			"textAlignment"   "west"
			"wrap"    "0"
			"Default"   "0"
			"selected"    "0"
		}
	}

	styles
	{
		FriendsList {
			render_bg
			{
				
				0="fill(x0+2,y0+7,x1-2,y1-7,ClientBG)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0,y1-7,x0,y1, materiales/clientbg8px/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				12="fill(x0+7,y1-7,x1-7,y1-1, ClientBG)"
				////////////////////parte inferior/////////////////////////////////////////
				9="fill(x0+7,y1-1,x1-7,y1, 757575xx40)"

                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+7,x0+2,y1-7, materiales/clientbg8px/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0,y0,x0,y0, materiales/clientbg8px/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				10="fill(x0+7,y0+1,x1-7,y0+7, ClientBG)"
				 ////////////////////////Parte del medio superior//////////////////////////////
				6="fill(x0+7,y0,x1-7,y0+1, 757575xx40)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+7,x1+3,y1-7, materiales/clientbg8px/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-7,y0,x1,y0, materiales/clientbg8px/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-7,y1-7,x1,y1,materiales/clientbg8px/ad)"
			
			
			}
		}
		
		Button
		{
			bgcolor="none"
			font-family=Button
			textcolor="white"
			padding-left="8"
			padding-bottom="2"
			padding-top="2"
			padding-right="7"
			font-size=18
			inset="-3 0 0 0"
				render_bg
			{
		
				0="fill(x0+2,y0+2,x1-2,y1-2,FFFFFFxx8)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, materiales/button/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, materiales/button/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, materiales/button/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, materiales/button/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, materiales/button/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, materiales/button/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, materiales/button/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,materiales/button/ad)"
			
			
			}
			
		
		}
		Button:hover
		{
			
			textcolor=white
			font-weight=500
				render_bg
			{
		
				0="fill(x0+2,y0+2,x1-2,y1-2,FFFFFFxx11)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, materiales/button/hover/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, materiales/button/hover/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, materiales/button/hover/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, materiales/button/hover/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, materiales/button/hover/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, materiales/button/hover/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, materiales/button/hover/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,materiales/button/hover/ad)"
			
			
			}
			
			
		}
		Button:active
		{
			bgcolor="none"
			textcolor="white75"
			 render_bg
			{
				0="fill(x0+2,y0+2,x1-2,y1-2,1F1F1FXxx100)"

			
				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, materiales/b/activo/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, materiales/b/activo/am)"
			
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, materiales/b/activo/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, materiales/b/activo/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2,materiales/b/activo/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4,materiales/b/activo/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, materiales/b/activo/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2, materiales/b/activo/ad)"
			}
		}

		Button:disabled
		{
			bgcolor="none"
			font-family=Button
			textcolor="white45"
			padding-left="8"
			padding-bottom="2"
			padding-top="2"
			padding-right="7"
			font-size=14
			inset="-3 0 0 0"
			render_bg
			{
		
				0="fill(x0+2,y0+2,x1-2,y1-2,buttona)"

				///////////////////esquina izquierda inferior/////////////////////////////
				1="image(x0-1,y1-4,x0+2,y1+4, materiales/b/ai)"

				////////////////////parte inferior/////////////////////////////////////////
				2="image_tiled(x0+4,y1-2,x1-4,y1+4, materiales/b/am)"
				
                ////////////medio de parte izquierda///////////////////////////////////////////////////
				3="image_tiled(x0-3,y0+4,x0+2,y1-4, materiales/b/mi)"
				
				//////////////////////////esquina izquierda superior///////////////////////////////////////////
				5="image(x0-1,y0-0,x0+2,y0+3, materiales/b/ti)"

                ////////////////////////Parte del medio superior//////////////////////////////
				6="image_tiled(x0+4,y0-2,x1-4,y0+2, materiales/b/tm)"

                //////////////medio derecha/////////////////////////////////////////////////////////////////////
				4="image_tiled(x1-2,y0+4,x1+3,y1-4, materiales/b/md)"

				/////////////////////////esquina derecha superior///////////////////////////////////////////////
				7="image(x1-4,y0-0,x1+3,y0+2, materiales/b/td)"

				/////////////////////esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-4,y1-4,x1+3,y1+2,materiales/b/ad)"
			
			
			}
			
		}
		FrameTitle {

			font-size=26
			font-family=cachetazo
			textcolor=white
			inset="10 12 0 0"
			minimum-height=42

		}
		RootMenu
		{
			bgcolor="red"
		} 
		FriendsTitle 
		{
			textcolor=white
		}
		FrameCloseButton {
			bgcolor="none"
			render_bg {}
			render {}
			image=""
		}
		FrameCloseButton:hover {
			bgcolor="none"
			render_bg {}
			render {}
			image=""
		}
		FrameCloseButton:active {
			bgcolor="none"
			render_bg {}
			render {}
			image=""
		}
	}

 	layout
 	{
		place { control="BuddyList" align=left margin-left=12 margin-right=12 margin-top=70 margin-bottom=81 width=max height=max }
		region { name=bottom align=bottom height=81 margin=24 }
		
		place { region=bottom control="CloseButton"  width=max height=32 }
 	}
}