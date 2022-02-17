"friends/friendaliasesdialog.res"
{
	controls
	{
		FriendAliasesDialog
		{
			title			"#Friends_FriendAliases_Title"
			wide			"348"
			tall			"288"
		}
		CloseButton
		{
			ControlName 	"Button"
			labelText		"#vgui_close"
			Command			"Close"
			PinCorner		"2"
		}
		Caption
		{
			ControlName		"Label"
			labelText		"#Friends_FriendAliasesInfo"
		}

		Label1 { ControlName="Label" labelText="%FriendNameOld1%" }
		Label2 { ControlName="Label" labelText="%FriendNameOld2%" }
		Label3 { ControlName="Label" labelText="%FriendNameOld3%" }
		Label4 { ControlName="Label" labelText="%FriendNameOld4%" }
		Label5 { ControlName="Label" labelText="%FriendNameOld5%" }
		Label6 { ControlName="Label" labelText="%FriendNameOld6%" }
		Label7 { ControlName="Label" labelText="%FriendNameOld7%" }
		Label8 { ControlName="Label" labelText="%FriendNameOld8%" }
		Label9 { ControlName="Label" labelText="%FriendNameOld9%" }
		Label10 { ControlName="Label" labelText="%FriendNameOld10%" }

		Date1 { ControlName="Label" labelText="%FriendDate1%" }
		Date2 { ControlName="Label" labelText="%FriendDate2%" }
		Date3 { ControlName="Label" labelText="%FriendDate3%" }
		Date4 { ControlName="Label" labelText="%FriendDate4%" }
		Date5 { ControlName="Label" labelText="%FriendDate5%" }
		Date6 { ControlName="Label" labelText="%FriendDate6%" }
		Date7 { ControlName="Label" labelText="%FriendDate7%" }
		Date8 { ControlName="Label" labelText="%FriendDate8%" }
		Date9 { ControlName="Label" labelText="%FriendDate9%" }
		Date10 { ControlName="Label" labelText="%FriendDate10%" }

		FriendAliasesNone
		{
			ControlName	"Label"
			labelText	"#Friends_FriendAliases_None"
			textAlignment	"north-west"
		}
	}

	styles
	{
		//Hidden
		Button
		{
			textcolor="none"
			bgcolor="none"
		}
	}

	layout
	{
		place { control="frame_captiongrip" width=max height=76 }
		place { control=Caption x=16 y=44 margin-right=1 }

		//Content
		region { name=container y=71 margin=16 }
		place { control=FriendAliasesNone,Label1,Label2,Label3,Label4,Label5,Label6,Label7,Label8,Label9,Label10 region=container dir=down spacing=4 }
		place { control=Date1,Date2,Date3,Date4,Date5,Date6,Date7,Date8,Date9,Date10 region=container align=right dir=down spacing=4 }

		//Hidden
		place { control=CloseButton width=1 align=right }
	}
}