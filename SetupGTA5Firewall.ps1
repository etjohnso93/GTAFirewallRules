param 
(
    #name for inbound rule
    [string]$outBoundRuleName = "GTA 5 Session Block Outbound",

    #name for outboud rule
    [string]$inboundRuleName = "GTA 5 Session Block Inbound",

    #path to GTA 5 executable
    [string]$gta5Path = "%ProgramFiles% (x86)\Steam\steamapps\common\Grand Theft Auto V\GTA5.exe"
)

#list of friends public ip address
# Example
#$ipv4AllowList = @(
#                   '120.0.0.1',
#                   '123.0.45.32',
#                   '44.44.44.1',
#                   '120.0.0.144'
#                   )
#or leave empty to block all and have a solo public session

$ipv4AllowList = @('67.63.75.160','70.121.244.219','20.20.20.20')

function SetupRules ($gtaExePath, $ipv4Ranges, $ruleName, $isInbound)
{
    if (Get-NetFirewallRule -DisplayName $ruleName)
    {
        Remove-NetFirewallRule -DisplayName $ruleName
    }

    foreach($ipRange in $ipv4Ranges)
    {
        Write-Host($ipRange)
    }

    if ($isInbound)
    {
        New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Block -Protocol UDP -LocalPort Any -RemotePort Any -Program $gtaExePath -RemoteAddress $ipv4Ranges
    }
    else
    {
        New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Action Block -Protocol UDP -LocalPort Any -RemotePort Any -Program $gtaExePath -RemoteAddress $ipv4Ranges
    }
}

function IpAddressAddOrSubtract ($ipv4Address, $value)
{
    $bytes = ([IPAddress]$ipv4Address).GetAddressBytes()

    if ([BitConverter]::IsLittleEndian)
    {
        [Array]::Reverse($bytes)
    }

    $addressAsInt = [BitConverter]::ToUInt32($bytes, 0) + $value
    $bytes = [BitConverter]::GetBytes([UInt32]$addressAsInt)
    
    if ([BitConverter]::IsLittleEndian)
    {
        [Array]::Reverse($bytes)
    }

    $addressAsInt = [BitConverter]::ToUInt32($bytes, 0)

    return ([IPAddress]$addressAsInt).ToString()
}

function Get-IpAddressRanges ($ipv4WhiteList)
{
    $ipv4Ranges = New-Object System.Collections.Generic.List[System.Object]
    $sortedList = @($ipv4WhiteList | Sort-Object -Property { [System.Version]$_ })

    for ($i = 0; $i -lt $sortedList.Count + 1; $i++)
    {
        $start = '0.0.0.0';
        if ($i -gt 0)
        {
            $start = $sortedList[$i - 1]
            $start = IpAddressAddOrSubtract $start 1           
        } 

        $end = '255.255.255.255'

        if($i -lt $sortedList.Count)
        {
            $end = $sortedList[$i];
            
            $end = IpAddressAddOrSubtract $end -1
        }
        
        $ipv4Ranges.Add($start + '-' + $end)
    }

    return $ipv4Ranges
}

$ipAddressRanges = Get-IpAddressRanges $ipv4AllowList 

#setup inbound rules
SetupRules $gta5Path $ipAddressRanges $inboundRuleName $true

#setup outbout rules
SetupRules $gta5Path $ipAddressRanges $outBoundRuleName $false