"friends/voicebar.res"
{
	controls
	{
		"VoiceBar"
		{
			"ControlName"		"CVoiceBar"
		}
		"micvolume"
		{
			"ControlName"		"CVoiceTraffic"
		}
		"SpeakerVolume"
		{
			"ControlName"		"CVoiceTraffic"
		}
		"action2"
		{
			"ControlName"		"Button"
			style="Chat_MenuButton_withChrome"
		}
		"StatusLabel"
		{
			"ControlName"		"Label"
			style="status_label"
		}
		"VoiceImage"
		{
			"ControlName"		"ImagePanel"
			style="voice_image"
		}
	}

	styles
	{
		CVoiceBar
		{
			bgcolor=White10
			render_bg
			{
				0="image(x0+6,y0+9,x1,y1,graphics/metro/icons/chat/phone)"
				1="fill(x1,y0,x1+19,y1,White10)"
			}
			padding-right=-30
		}
		status_label
		{
			inset="0 0 0 0"
			textcolor=white
			font-family=semibold
		}
		voice_image
		{
			textcolor="none"
			bgcolor="none"
			render_bg{}
			render{}
		}
		CVoiceTraffic
		{
		}
	}

	layout
	{
		region { name=container height=54 }
		//Content
		place { control="VoiceImage" x=6 y=9 }
		place { control="StatusLabel" align=left-center x=61 y=0 height=18 end-right=action2 margin-right=8 }
		place { control="micvolume,speakervolume" align=left-center x=61 width=60 height=18 }

		//Button
		place { control="action2" height=30 margin=11 margin-right=4 align=right }
	}
}