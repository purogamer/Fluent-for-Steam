"steam/cached/SetJumplistOptions.res"
{
	styles
	{
		Label
		{
			textcolor=white
			font-family=semibold
			font-style=uppercase
			bgcolor="none"
		}
	}

	layout 
	{
		place { control="Label1,ShowOnlineStatus,ShowAwayStatus,ShowInvisibleStatus,ShowBusyStatus,ShowAppearOfflineStatus,Label2,ShowStore,ShowCommunity,ShowFriendActivity,ShowMyGames,ShowServers,ShowMusicPlayer,ShowNews,ShowSettings,ShowScreenshots,ShowBigPicture,ShowFriends,ShowVR,ShowExit" dir=down width=max x=16 y=46 spacing=1 }
		region { name="bottom" align=bottom height=44 margin=8 }
		place { control="OKButton,CancelButton" region=bottom align=right width=84 height=28 spacing=8 }
		//Hidden
		place { control=Divider1,Divider2 width=1 align=right }
	}
}