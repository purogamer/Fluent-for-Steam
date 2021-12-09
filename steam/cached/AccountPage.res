"Steam/cached/AccountPage.res"
{
	styles
	{
		Divider
		{
			bgcolor=white12
		}
	}

	layout
	{
		region { name=box margin-left=16 margin-right=16 }

		//Avatar
		place { region=box control="SecurityIcon" dir=right y=12 spacing=6 }

		///Information
		place { region=box control="LogOutLabel,AccountInfo" x=68 y=7 spacing=6 }
		place { region=box control="ContactEmailLabel,EmailInfo" x=68 y=24 spacing=6 }
		place { region=box control="SecurityStatusLabel,SecurityStatusState" x=68 y=41 spacing=6 }
		place { region=box control="Label2,VacInfoLink" x=68 y=58 spacing=6 }

		place { region=box control="NoPersonalInfoCheck" y=86 spacing=8 dir=down }

		//Security Information
		place { region=box start=NoPersonalInfoCheck control="ChangeUserButton,ManageSecurityButton,ChangePasswordButton,ChangeContactEmailButton,ValidateContactEmailButton,MachineLockAccountButton" margin-top=16 width=337 height=28 dir=down spacing=6 }

		//Beta Participation
		place { region=box control="Divider1" y=340 }
		place { region=box start=Divider1 control="BetaParticipationLabel" y=27 dir=down }
		place { region=box start=BetaParticipationLabel control="Divider2" y=32 height=1 dir=down }
		place { region=box start=BetaParticipationLabel control="ChangeBetaButton" x=6 y=-3 width=84 height=28 spacing=6 }
		place { region=box start=ChangeBetaButton control="CurrentBetaLabel" x=6 y=3 height=24 }

		//Hidden
		place { control="ReportBugLink,Label1,AccountLink" dir=down margin-left=-999 }
	}
}