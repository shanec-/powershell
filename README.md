# PowerShell

This repository hosts the collection of utility PowerShell scripts that don't fit into any other repository.

## Team Foundation Server

Scripts related to interacting with Team Foundation Server (TFS). This includes both the Visual Studio Online as well as the on-premises versions. These are hosted within the `TFS` folder.

### Get-FilesModifiedByChangeset

This script is useful in figuring out the files that changed in a given timeline. The timeline can be provided in the from of a date range or start and end changeset ids.

The script uses the REST endpoint in for its implementation. Therefore it would only work with the VSO (Visual Studio Online) version.

  Usage:

    .\Get-FilesModifiedByChangeset.ps1 http://mytfsaccount.visualstudio.com/defaultcollection -startChangesetId 100 -endChangesetId 500

## Miscellaneous

The `/Misc` folder contains scripts that do not fit into any of the other categories.

### Get-DirectVideoUrl

Helper Script to extract the direct-download url of external video services (mainly youtube.com) using the the keepvid.com service. 

  Usage:

    .\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I"
    .\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I http://www.youtube.com/watch?v=R4ajQ-foj2Q"
    .\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I http://www.youtube.com/watch?v=R4ajQ-foj2Q" -filename "C:\inputDownloadList.txt"

### New-DefaultGitIgnore

Script initializes a new `.gitignore` using with the github Visual Studio template.

## External

These functions as based off of Donovan Brown's utility helper scripts. I have collated them into a single file - `DonovanBrown-Utils.ps1` so that I can merge them into my own PowerShell profile.

As described on Donovan's blog posts, the script can be loaded up as part of the profile using the following statement.

Edit the profile:

    code $profile

And adding the following line to the end of the file:

    . C:\Users\me\Documents\WindowsPowerShell\Scripts\utils.ps1

### Backup-Location

Provides an easy way to navigate backward in a folder structure from within a console window.
Source: [http://donovanbrown.com/post/Why-cd-when-you-can-just-backup](http://donovanbrown.com/post/Why-cd-when-you-can-just-backup)

  Usage:

    bu 4
    bu 2

### set-as

Source : [http://donovanbrown.com/post/Shorten-your-PowerShell-directory-path](http://donovanbrown.com/post/Shorten-your-PowerShell-directory-path)

Provides the ability to be map a folder as a drive. This one should come in pretty handy.

From within the folder location execute the function `set-as` and pass in a unique name as an identifier for the drive.

  Usage:

    set-as pr