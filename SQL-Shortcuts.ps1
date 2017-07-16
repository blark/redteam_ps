#
# A bunch of MSSQL shortcuts
#

Import-Module Sqlps -DisableNameChecking

function Get-Databases {
    Invoke-Sqlcmd -Query "sp_databases"
}

function Get-Tables {
    Param (
        [Parameter(Mandatory=$True)][String]$Database
    )
    $params = @{
        "Query"=("SELECT TABLE_NAME FROM [{0}].INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'" -f $Database)
    }
    Invoke-Sqlcmd @params | Format-Table -Wrap -AutoSize
}

function Get-DBInfo {
    Param (
        [Parameter(Mandatory=$True)][String]$OutPath
    )
    Begin {
        Write-Output "Getting database list."
        $DBs = Get-Databases
        ("# {0} Database List`n{1}" -f $env:computername,($DBs|Out-String)) |
        Out-File -FilePath $OutPath
    }
    Process {
        ForEach ($item in $DBs) {
            $d = $item.DATABASE_NAME
            Write-Output ("Dumping table information for: {0}" -f $d)
            $t = Get-Tables -Database $d
            ("## {0}`n{1}" -f $d,($t|Out-String)) | Out-File -Append -FilePath $OutPath
        }
    }
    End {
        Write-Output "Done."
    }
}
