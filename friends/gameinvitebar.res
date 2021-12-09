"friends/gameinvitebar.res"
{
	controls
	{
		"GameInviteBar"		{	ControlName="GameInviteBar"		}
		"InviteLabel"		{	ControlName="Label"		labeltext="#friends_game_invite"		mouseinputenabled=0		}
		"GameLabel"			{	ControlName="Label"		labeltext="%game%"						mouseinputenabled=0		}
		"ClickHereLabel"	{	ControlName="Label"		labeltext="#friends_game_invite_action"	mouseinputenabled=0		}
		"InviteImage"		{	ControlName="ImagePanel" image="resource/invite"				mouseinputenabled=0		}
		"CloseButton"		{	ControlName="Button"	labeltext="X"	command="Close"	}
	}

	styles
	{
		CGameInviteBar
		{
			bgcolor=White10
			render_bg {}
		}

		Label
		{
			textcolor=white
			font-family=semibold
			font-style=regular
		}

		Button
		{
			textcolor="none"
			bgcolor="none"
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/tab_close_def)"
			}
		}
		Button:hover
		{
			bgcolor="none"
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/tab_close_hov)"
			}
		}
		Button:active
		{
			bgcolor="none"
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/tab_close_hov)"
			}
		}
	}

	layout
	{
		place { control="InviteImage" x=6 y=2 width=50 height=50 }
		place { control="InviteLabel,GameLabel" width=max dir=down spacing=-2 margin-top=10 margin-right=2 margin-left=61 }

		place { control="CloseButton" align=right margin=4 width=16 height=16 }

		place { control="ClickHereLabel" width=1 align=right }
	}
}