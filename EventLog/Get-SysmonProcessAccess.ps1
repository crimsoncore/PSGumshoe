function Get-SysmonProcessAccess {
    <#
    .SYNOPSIS
        Get Sysmon Access Procces EventLog Events (EventId 10).
    .DESCRIPTION
        Get Sysmon Process Access events either locally or remotely from a specified location.
        These events have an EventID of 10 and are for when a process acceses the memory space
        of a given process.
    .EXAMPLE
        PS C:\> Get-SysmonProcessAccess -TargetImage "C:\Windows\System32\lsass.exe"
        Check if any process has opened lsass.exe. This may be a malicious process trying to dump password hashes.
    .INPUTS
        System.IO.FileInfo
        System.String
    .OUTPUTS
        Sysmon.EventRecord.ProcessAccess
    #>
    [CmdletBinding(DefaultParameterSetName = 'Local')]
    param (
        # Log name for where the events are stored.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]
        $LogName = 'Microsoft-Windows-Sysmon/Operational',

        # The GUID value created by Sysmon that uniquely and universally identifies the process instance accesing a target process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $SourceProcessGuid,

        # The PID of the source process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $SourceProcessId,

        # The thread ID of the source process that identifies the process instance accesing a target process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $SourceThreadId,

        # The full path of the main executable image of the source process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $SourceImage,

        # The full path of the main executable image of the target process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $TargetImage,

        # The permission granted to the sourced process when accesing the target process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $GrantedAccess,

        # The call traced of the source procees acceing the target process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $CallTrace,

        # Specifies the path to the event log files that this cmdlet get events from. Enter the paths to the log files in a comma-separated list, or use wildcard characters to create file path patterns. Function supports files with the .evtx file name extension. You can include events from different files and file types in the same command.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="file",
                   ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,


        # Gets events from the event logs on the specified computer. Type the NetBIOS name, an Internet Protocol (IP) address, or the fully qualified domain name of the computer.
        # The default value is the local computer.
        # To get events and event logs from remote computers, the firewall port for the event log service must be configured to allow remote access.
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'Remote')]
        [string[]]
        $ComputerName,

        # Specifies a user account that has permission to perform this action.
        #
        # Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one generated by the Get-Credential cmdlet. If you type a user name, you will
        # be prompted for a password. If you type only the parameter name, you will be prompted for both a user name and a password.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Remote')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        # Specifies the maximum number of events that are returned. Enter an integer. The default is to return all the events in the logs or files.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [int64]
        $MaxEvents,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $StartTime,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $EndTime,

        # Changes the default logic for matching fields from 'and' to 'or'.
        [Parameter(Mandatory = $false)]
        [switch]
        $ChangeLogic,

        # Changes the query action from inclusion to exclusion when fields are matched.
        [Parameter(Mandatory = $false)]
        [switch]
        $Suppress
    )

    begin {}

    process {
        Search-SysmonEvent -EventId 10 -ParamHash $MyInvocation.BoundParameters

    }

    end {}
}