"friends/tradeinvitebar.res"
{
	controls
	{
		"InviteLabel"		{	ControlName="Label"		labeltext="#friends_trade_invite"			mouseinputenabled=0	group="recv"	}
		"ClickHereLabel"	{	ControlName="Label"		labeltext="#friends_trade_invite_action"	mouseinputenabled=0	group="recv" }

		"InviteSentLabel"			{	ControlName="Label"		labeltext="#friends_trade_invite_sent"			mouseinputenabled=0	group="send"	}
		"WaitingForResponseLabel"	{	ControlName="Label"		labeltext="#friends_trade_invite_sent_waiting"	mouseinputenabled=0	group="send" }
		
		"InviteImage"			{	ControlName="ImagePanel" image="resource/icon_trade_request"				mouseinputenabled=0	group="recv" }
		"InviteSentImage"		{	ControlName="ImagePanel" image="resource/icon_trade_request"				mouseinputenabled=0	group="send" }
				
		"CloseButton"		{	ControlName="Button"	labeltext="X"	command="Close"	}
	}
	
	styles
	{
		CTradeInviteBar
		{
      bgcolor=White10
			render_bg {}
		}
		
		Button
    {
			textcolor=none
			bgcolor=none
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/tab_close_def)"
			}
    }

		Button:hover
    {
			bgcolor=none
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/tab_close_hov)"
			}
    }
		
		Button:active
		{
			bgcolor=none
			render_bg
			{
				0="image(x0,y0,x1,y1,graphics/tab_close_hov)"
			}
		}

		Label
		{
			textcolor=white
			font-family=semibold
			font-style=regular
		}
	}
	layout
	{
		place { control="InviteImage,InviteSentImage" x=6 y=2 width=50 height=50 }
		place { control="InviteLabel,ClickHereLabel,InviteSentLabel,WaitingForResponseLabel" width=max dir=down spacing=-2 margin-top=10 margin-right=2 margin-left=61 }
		place { control="CloseButton" align=right margin=4 width=16 height=16 }
	}
}
