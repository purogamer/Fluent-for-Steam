"friends/ChatRoomDlg.res"
{
	controls
	{
		"ChatRoomDlg"
		{
			"ControlName"		"CChatRoomDlg"
			"title"		"#Friends_Chat_Group_Title"
		}
		"TextEntry"
		{
			"ControlName"		"TextEntry"
			"tabPosition"		"1"
			"editable"		"1"
			"maxchars"		"2048"
			"unicode"		"1"
			style="Textentryfocus_chat"
		}
		"ChatHistory"
		{
			"ControlName"		"RichText"
			"maxchars"		"-1"
			"ScrollBar"		"1"
			style="listpanel"
		}
		"SendButton"
		{
			"ControlName"		"Button"
			"labelText"		"#Friends_Chat_Send"
			"Default"		"1"
		}
		"StatusLabel"
		{
			"ControlName"		"Label"
			"wrap"		"0"
		}
		"VoiceBar"
		{
			"ControlName"		"CVoiceBar"
		}
		"TitlePanel"
		{
			"ControlName"		"CChatTitlePanel"
			"zpos"		"-2"
			width=400
		}
		"UserList"
		{
			"ControlName"		"CFriendsListSubPanel"
			style="FriendsList"
			"linespacing"		"50"
			wide=200
		}
		"Splitter"
		{
			"ControlName"		"CChatSplitter"
			resizepanel="UserList"
			zpos=1
		}
		"VoiceChat"
		{
			"ControlName"		"Button"
			style="Chat_MenuButton_withChrome"
			
		}
	}

	styles
	{
		CChatSplitter
		{
			bgcolor=black24
			render_bg
			{
        		1="fill( x0-1, y0, x0, y1, frameBorder )"
        		2="fill( x1, y0, x1+1, y1, frameBorder )"
      		}
		}

		label
		{
			textcolor=White45
			font-style=uppercase
			bgcolor=ClientBG
			render_bg
			{
				1="fill( x0, y0-1, x1, y0+1, Black25 )"
			}
		}

		Chat_MenuButton_withChrome
		{
			bgcolor="none"
			render_bg{}
			image="graphics/tab_close_def"
			padding-left=-4
		}
		Chat_MenuButton_withChrome:hover
		{
			bgcolor="none"
			image="graphics/tab_close_hov"
		}
		Chat_MenuButton_withChrome:active
		{
			bgcolor="none"
			image="graphics/tab_close_hov"
		}
	} 

	layout
	{
		//Voice Chat Close Button
		place { control="VoiceChat" y=55 align=right margin=4 width=16 height=16 dir=right end-right=Splitter }

		//Title Panel
		place { control="TitlePanel" x=0 y=0 height=56 width=max margin-right=16 end-right=ChatActionsButton }

		//Menu Button
		place { control="ChatActionsButton" height=54 width=54 align=right dir=right }

		//Bar Height Override
		place { control="GameInviteBar,TradeInviteBar,ChatInfoBar,VoiceBar,BIBar,BABar" height=54 }

		place { control="Splitter" width=4 }
		place { control="Splitter,UserList" align=right y=55 height=max spacing=4 margin-bottom=61 }

		//Voice Chat Bar
		place { control="VoiceBar" y=55 width=max height=54 dir=down end-right=VoiceChat }

		//Bar Position Info
		place { control="TradeInviteBar,GameInviteBar,ChatInfoBar,BIBar,BABar,ChatHistory" start=VoiceBar end-right=Splitter y=0 width=max height=max align=right dir=down margin-bottom=61 margin-right=1 }

		//Regions
		region { name=bottom1 align=bottom height=71 width=max margin=8 }
		region { name=bottom align=bottom height=40 }

		//Text Box
		place { control="TextEntry" region=bottom height=max width=max end-right=EmoticonButton }

		//Emoticon Menu
		place { control="EmoticonButton" region=bottom height=max align=right margin-right=1 }

		//Last Message Received
		place { control="StatusLabel" region=bottom1 height=25 }

		//Hidden
		place { control="SendButton" width=1 align=right }
	}
}