"Friends/FriendsDialog.res"
{
	styles
	{
		AddFriendsButton
		{
			bgcolor="none"
			render_bg {}
			image="graphics/metro/icons/navbar/friends_add"
			padding-left=2
			padding-right=6
		}
		AddFriendsButton:hover
		{
			bgcolor=white05
		}
		AddFriendsButton:active
		{
			bgcolor=white10
		}

		FriendsSearchIcon
		{
			bgcolor=TextEntry
			render_bg{}
			image="graphics/search_lg"
			padding-left=12
		}

		PageTab
		{
			inset-left=2
			font-family=semibold
			textcolor="White45"
			font-style="Uppercase"
			font-weight=400
			bgcolor="none"
			render_bg
			{
				0="fill(x0,y1-1,x1,y1,Header_Dark)"
			}
		}
		PageTab:hover
		{
			textcolor=White75
		}
		PageTab:selected
		{
			textcolor=White
		}
	}

 	layout
 	{
		//Header
		region { name=top align=top y=40 height=40 }
		place { control="addFriendsButton" height=39 align=right margin-right=1 end-right=frame_minimize }
		place { control="MenuBar" height=38 width=38 x=1 y=1 }

		//Search
		place { control="friends_search_icon" region=top height=38 width=38 x=1 }
		place { control="friends_search" region=top start=friends_search_icon height=38 width=max }

		//Content
		place { start="friends_search_icon" control="FriendPanelSelf" x=8 y=4 align=left dir=down }
		place { start="FriendPanelSelf" control="DownLabel" dir=down margin=8 width=max margin-right=8 }
		place { start="DownLabel" control="NoFriendsAddFriendButton" dir=down align=left margin=8 }
		place { control="NoFriendsAddFriendButton" start=DownLabel dir=down align=left y=8 width=84 height=28 }
		place { start=FriendPanelSelf control="FriendsDialogSheet" x=-8 align=left width=max height=max dir=down margin-bottom=1 }
 	}
}
