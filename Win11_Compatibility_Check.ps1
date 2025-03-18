# Windows 11 Compatibility Checker Script
# Author: AB
# Version: 1.0

# Get the current Windows version
$osVersion = (Get-WmiObject Win32_OperatingSystem).Version
$hostname = $env:COMPUTERNAME
$outputFile = "$hostname.txt"

# Function to check Secure Boot status
function Check-SecureBoot {
    try {
        $secureBoot = Confirm-SecureBootUEFI
        if ($secureBoot -eq $true) { return "Enabled" }
        else { return "Disabled" }
    } catch {
        return "Not Supported"
    }
}

# Function to check TPM version
function Check-TPM {
    $tpm = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm -ErrorAction SilentlyContinue
    if ($tpm -and $tpm.SpecVersion -match "2\.0") {
        return "TPM 2.0 Available"
    } else {
        return "TPM Not Found or Incompatible"
    }
}

# Function to check if partition is GPT
function Check-Partition {
    $disk = Get-Disk | Where-Object PartitionStyle -eq "GPT"
    if ($disk) { return "GPT (Compatible)" }
    else { return "MBR (Not Compatible)" }
}

# Function to check RAM size (Minimum 4GB)
function Check-RAM {
    $ramSize = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB
    if ($ramSize -ge 4) { return "$ramSize GB (Compatible)" }
    else { return "$ramSize GB (Not Compatible)" }
}

# Function to check CPU architecture
function Check-Processor {
    $arch = (Get-WmiObject Win32_Processor).Architecture
    switch ($arch) {
        9 { return "x64 (Compatible)" }
        0 { return "x86 (Not Compatible)" }
        6 { return "IA64 (Not Compatible)" }
        Default { return "Unknown Architecture" }
    }
}

# Windows 11 Check
if ($osVersion -like "10.*") {
    $result = @"
Windows 11 Compatibility Report for: $hostname

Operating System: Windows 10 (Eligible for Upgrade)
TPM Status: $(Check-TPM)
Secure Boot: $(Check-SecureBoot)
Processor Architecture: $(Check-Processor)
RAM Size: $(Check-RAM)
Disk Partition: $(Check-Partition)

Note: If all checks are "Compatible", your device meets the requirements for Windows 11.
"@

    # Save to file
    $result | Out-File -Encoding utf8 $outputFile
    Write-Host "Compatibility check completed. Results saved to $outputFile" -ForegroundColor Green
} elseif ($osVersion -like "10.0.2*") {
    Write-Host "This system is already running Windows 11." -ForegroundColor Cyan
} else {
    Write-Host "This script must be run on Windows 10." -ForegroundColor Red
}
