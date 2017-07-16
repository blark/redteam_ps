function Get-DNSARecords {
    <#
    .SYNOPSIS
        Dumps A Records from a Microsoft Windows DNS server.
    .DESCRIPTION
        This script dumps the conent of MicrosoftDNS_AType to a CSV file.
    .PARAMETER Server
        The name of the Computer you want to run the command against.
    .PARAMETER CSVPath
        The location and filename of a file to save the output to (defaults to .\dns.csv).
    .PARAMETER UserName
        Username to authenticate to the server with (optional). If not supplied, the current user context is used.
        **If a username is supplied -Password must also be provided.**
    .PARAMETER Password
        Password to use for authentication (optional).
    .EXAMPLE
        Get-DNSARecords -Server 192.168.1.1 -CSVPath c:\users\public\downloads\dns.csv -UserName Administrator -Password Password123
    .LINK
        https://gist.github.com/blark/510cc216416a6160d703bedc7f880b4b
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$Server,
        [string]$CSVPath="dns.csv",
        [string]$UserName,
        [string]$Password
    )
    # Set up a hash table to to store parameters for Get-WmiObject
    $params=@{'Class'='MicrosoftDNS_AType'
		      'NameSpace'='Root\MicrosoftDNS'
              'ComputerName'=$Server
    }
    if ($UserName -and $Password) {
    # Convert username:password to credential object
        $SecPassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $Credentials = New-Object -Typename System.Management.Automation.PSCredential -ArgumentList $UserName, $SecPassword
        $params.Add("Credential", $Credentials)
    }
    Write-Output "Acquiring MicrosoftDNS_AType WmiObject..."
    $dnsRecords = Get-WmiObject @params | Select-Object -Property OwnerName,RecordData,@{n="Timestamp";e={([datetime]"1.1.1601").AddHours($_.Timestamp)}}
    Write-Output ("Found *{0}* records." -f $dnsRecords.Count)
    Write-Output ("Writing to {0}..." -f $CSVPath)
    $dnsRecords | Export-CSV -not $CSVPath
    Write-Output "Done."
}