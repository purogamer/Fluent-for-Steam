"friends/broadcastapprovebar.res"
{
	colors
	{
		invitebg="163 160 153 255"
	}

	controls
	{
		"BABar"			{	ControlName="BABar"	}
		"InviteLabel"		{	ControlName="Label"		labeltext="#Friends_BroadcastApprove"	mouseinputenabled=0		}
		"GameLabel"		{	ControlName="Label"		labeltext="%game%"						mouseinputenabled=0		}
		"ApproveLabel"		{	ControlName="URLLabel"		labeltext="#Friends_BroadcastApprove_Approve"	}
		"OrLabel"		{	ControlName="Label"		labeltext="#Friends_BroadcastApprove_Or"	}
		"IgnoreLabel"		{	ControlName="URLLabel"		labeltext="#Friends_BroadcastApprove_Ignore"	}
		"InviteImage"		{	ControlName="ImagePanel" image="resource/invite"				mouseinputenabled=0		}
		"CloseButton"		{	ControlName="Button"	labeltext="X"	command="Close"	}
	}

	styles
	{
		CBroadcastApproveBar
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
		
		URLLabel
		{
			font-style=lowercase
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
		place { control="InviteLabel,GameLabel" dir=down spacing=-2 margin-top=10 margin-right=2 margin-left=61 }
		place {control="ApproveLabel,OrLabel,IgnoreLabel" y=25 dir=right spacing=4 margin-left=61 }
		place { control="CloseButton" align=right margin=4 width=16 height=16 }
		//Hidden
		place { control="ClickHereLabel" width=1 align=right }
	}
}