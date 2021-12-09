"steam/cached/SettingsSubVoice.res"
{
	styles
	{
		CSettingsSubVoice
		{
			render_bg
			{
				0="image(x0+16,y0+8,x1,y1, graphics/metro/labels/settings/device)"
				1="image(x0+16,y0+135,x1,y1, graphics/metro/labels/settings/voicechat)"
			}
		}
	}
	layout
	{
		region { name=box margin-left=16 margin-right=16 }

		//First
		place { region=box control="Label1" x=0 y=36 dir=down spacing=6 }
		place { region=box control="DeviceName" start=Label1 y=8 dir=down spacing=6 width=320 }
		place { region=box control="ChangeDeviceButton,ReinitAudio" width=156 margin-top=85 spacing=6 y=8 dir=right }

		//When Active
		place { region=box control="WhenActiveLabel,TransmitMethodRadioButton1,TransmitMethodRadioButton2,TransmitMethodRadioButton3,PushToTalkKeyLabel,PushToTalkKeyEntry" y=161 dir=down spacing=1 }
		
		place { region=box start=PushToTalkKeyEntry control="MicrophoneLabel,SpeakerLabel" y=6 dir=down spacing=6 }
		place { region=box start=MicrophoneLabel control=MicrophoneVolume x=16 }
		place { region=box start=MicrophoneVolume control=SpeakerVolume dir=down }
		
		place { region=box start=SpeakerLabel control="MicMeter" y=12 dir=down }
		place { region=box start=MicMeter control="MicMeter2" margin-left=-160 }

		place { region=box start=MicMeter control=TestMicrophone x=6 }
		place { region=box start=MicMeter control=MicBoost y=6 dir=down }

		//Hidden
		place { control="RepairAudio,Divider1,Divider2" dir=down margin-left=-999 }
	}
}