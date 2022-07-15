"steam/cached/InstallSubConvertApps.res"
{
	"InstallSubConvertApps"
	{
		"ControlName"		"CInstallSubConvertApps"
		"fieldName"		"InstallSubConvertApps"
		"xpos"		"8"
		"ypos"		"48"
		"wide"		"388"
		"tall"		"300"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"1"
		"paintbackground"		"1"
		"WizardWide"		"0"
		"WizardTall"		"0"
	}
	"ProgressBar"
	{
		"ControlName"		"ProgressBar"
		"fieldName"		"ProgressBar"
		"xpos"		"24"
		"ypos"		"104"
		"wide"		"344"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"progress"		"0.489157"
	}
	"ProgressBarSingleDisk"
	{
		"ControlName"		"ProgressBar"
		"fieldName"		"ProgressBarSingleDisk"
		"xpos"		"26"
		"ypos"		"180"
		"wide"		"344"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"progress"		"0.705629"
		"variable"		"cd_progress"
	}
	"infolabel"
	{
		"ControlName"		"Label"
		"fieldName"		"InfoLabel"
		"xpos"		"24"
		"ypos"		"28"
		"wide"		"344"
		"tall"		"48"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"Installing from physical media"
		"textAlignment"		"north-west"
		"wrap"		"1"
	}
	"StatusLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"StatusLabel"
		"xpos"		"24"
		"ypos"		"74"
		"wide"		"344"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_InstallingWithTimeRemaining"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	"DiskProgressLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"DiskProgressLabel"
		"xpos"		"28"
		"ypos"		"155"
		"wide"		"280"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_InstallingFromDisk"
		"textAlignment"		"west"
		"wrap"		"0"
	}
	"BytesProgressLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"BytesProgressLabel"
		"xpos"		"26"
		"ypos"		"130"
		"wide"		"340"
		"tall"		"24"
		"AutoResize"		"0"
		"PinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"paintbackground"		"1"
		"labelText"		"#Steam_InstallBytesProgress"
		"textAlignment"		"west"
		"wrap"		"0"
	}
  styles
	{
	}
	layout
	{
		place { control=infolabel,StatusLabel x=16 y=32 width=max spacing=6 dir=down margin-right=16 }

		place { start=StatusLabel control=ProgressBar y=6 dir=down }
		place { start=ProgressBar control=BytesProgressLabel,DiskProgressLabel width=max spacing=6 dir=down margin-right=16 }
    place { start=DiskProgressLabel control=ProgressBarSingleDisk y=6 dir=down }
	}
}
