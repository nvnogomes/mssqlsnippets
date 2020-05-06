<#
.Synopsis
   File archiver
.DESCRIPTION
   Archives all files that match the given regex. 
   The files archived will be deleted from the original location.
.EXAMPLE
   New-Archive -BaseDirectory "C:\Pdfs" -FileRegex "*.pdf" -ArchivePrefix "PdfArchive"
#>
function New-Archive {
    [CmdletBinding()]
    Param (
        # BaseDirectory Directory to be the used as base to the commands
        [Parameter(Mandatory=$true)]
        [string]
        $BaseDirectory,

        # FileRegex Files in the base directory to be archived
        [Parameter(Mandatory=$true)]
        [string]
        $FileRegex,


        # ArchivePrefix Prefix to the archive to be created
        [Parameter(Mandatory=$true)]
        [string]
        $ArchivePrefix 
    )
    Begin {
        # setup variables
        $RegexExp = Join.Path -Path $directory -ChildPath $FileRegex
        $archiveDirectory = Join-Path -Path $directory -childPath "archive"
        $archiveFilename =  $ArchivePrefix + (Get-Date -Format "yyyyMMdd") + ".zip"

        md $archiveDirectory -Force | Out-Null
    }

    Process {

        # create archive
        $compress = @{
            Path= $RegexExp
            CompressionLevel = "Fastest"
            DestinationPath = Join-Path -Path $archiveDirectory -ChildPath $archiveFilename
            Force = $true
        }
        Compress-Archive @compress

    }

    End {
        # delete archived documents
        Remove-Item -Path $RegexExp
    }
}
Export-ModuleMember -Function New-Archive