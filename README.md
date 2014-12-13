PowerShell
==========
This repository hosts the collection of PowerShell scripts that I develop and use frequently.  

###Team Foundation Server
Scripts related to interacting with Team Foundation Server (TFS). This includes both the Visual Studio Online as well as the on-premises versions. These are hosted within the `TFS` folder.

####Get-FilesModifiedByChangeset

This script is useful in figuring out the files that changed in a given timeline. The timeline can be provided in the from of a date range or start and end changeset ids.

The script uses the REST endpoint in for its implementation. Therefore it would only work with the VSO (Visual Studio Online) version.

	Usage:
		.\Get-FilesModifiedByChangeset.ps1 http://mytfsaccount.visualstudio.com/defaultcollection -startChangesetId 100 -endChangesetId 500 

###Miscellaneous
The `/Misc` folder contains scripts that do not fit into any of the other categories.

####Get-DirectVideoUrl
Helper Script to extract the direct-download url of external video services (mainly youtube.com) using the the keepvid.com service. 

	Usage:
    	.\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I"
    	.\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I http://www.youtube.com/watch?v=R4ajQ-foj2Q"
    	.\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I http://www.youtube.com/watch?v=R4ajQ-foj2Q" -filename "C:\inputDownloadList.txt"




