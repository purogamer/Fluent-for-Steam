"Steam/cached/AccountPage.res"
{
	styles
	{
		checkbutton {
			image="graphics/checkbox_d"
		}
		checkbutton:selected {
			image="graphics/checkbox_s"
		}
		URLLabel {
			font-size=18
			font-family=basefont
			textcolor=darkblue
			padding-left=8
			padding-right=8
			font-style=none
			  render_bg {

				0="fill(x0+10,y0+0,x1-9,y1+1,135EF2xx12 )"
			
             			
				//////////////////////////for esquina "izquierda"  superior///////////////////////////////////////////
				5="image(x0+0,y0-0,x0,y0, materiales/135EF2%12/ti)"
      
	  			///////////////////for esquina "izquierda" inferior/////////////////////////////
				////////left, bottom  ,left bottom
				1="image(x0+0,y1-9,x0,y1, materiales/135EF2%12/ai)"

         	  
 							
			

					/////////////////////////for esquina derecha superior///////////////////////////////////////////////
				7="image(x1-9,y0,x1,y0, materiales/135EF2%12/td)"
				/////////////////////for esquina inferior derecha//////////////////////////////////////////////////////
				8="image(x1-9,y1-9,x1,y1, materiales/135EF2%12/ad)"
			}
		}
		URLLabel:hover {
			textcolor=bluesito
			
		}
		Divider
		{
			bgcolor=white12
		}
		label {
			font-size=18
			font-family=basefont
			textcolor=white
		}
		CAccountPage
		{
			render_bg
			{
				0="image(x0+7,y0+8,x1,y1,graphics/settings/accountpage/user)"
				1="image(x0+7,y0+225,x1,y1,graphics/settings/accountpage/email)"
				2="image(x0+7,y0+345,x1,y1,graphics/settings/accountpage/beta)"
				3="image(x0+7,y0+465,x1,y1,graphics/settings/accountpage/credentials)"
			}
		}
	}

	layout
	{
		region { name="user" margin-top=8 margin-left=7 width=555 height=211 }
		region { name="em4il" y=225 margin-left=7 width=555 height=114 } 
		region { name="bet4" y=345 margin-left=7 width=555 height=114 } 
		region { name="cr3dentials" y=465 margin-left=7 width=555 height=97 } 
		
		region { name=box margin-left=16 margin-top=240 margin-right=16 }
		

		//Account
		place { region=user control="AccountInfo," spacing=8 margin-top=12 margin-left=50  }
		place { region=user control="SecurityIcon" margin-left=12 margin-top=51}
		place { region=user start=SecurityIcon control="SecurityStatusState" margin-left=14 margin-top=3 spacing=8   }
		place { region=user start=SecurityStatusLabel control="" dir=right margin-left=4 }
		place { region=user control="VacInfoLink,AccountLink"  margin-left=16 margin-top=112 spacing=10 dir=right }
		place { region=user align=bottom control="ChangePasswordButton, ManageSecurityButton" margin-left=12 margin-right=8 margin-bottom=8 spacing=10 dir=right }
		
		//Email
		place { region=em4il control="EmailInfo" margin-top=12 margin-left=50  }
		place { region=em4il control="ChangeContactEmailButton,ValidateContactEmailButton" align=bottom margin-left=12 margin-right=8 margin-bottom=12 spacing=10 dir=right   }
		
		//Beta Participation
		place { region=bet4 control="BetaParticipationLabel,CurrentBetaLabel"spacing=8 height=30 margin-top=12 margin-left=50  }
		place { region=bet4 control="ReportBugLink" margin-left=16 align=bottom margin-bottom=18 dir=down }
		place { region=bet4 align=right  control="ChangeBetaButton" margin-left=14 margin-right=8 margin-top=72 }

		//Credentials
		place { region=cr3dentials control="Label1" margin-top=12 height=20 margin-left=50  }
		place { region=cr3dentials control="NoPersonalInfoCheck"  margin-left=12 margin-bottom=10 align=bottom  }

		//Hidden
		place { control=",SecurityStatusLabel,ContactEmailLabel,Divider1,Divider2,Label2,LogOutLabel,ChangeUserButton,,MachineLockAccountButton" dir=down margin-left=-999 }
	}
}