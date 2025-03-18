# Win11 Compatibility Checker Script
# Checks Windows 11 upgrade requirements and saves the report as <hostname>.txt

# Function to check Windows 11 compatibility
function Check-Windows11Compatibility {
    # Get System Info
    $OSVersion = (Get-ComputerInfo).WindowsVersion
    $HostName = $env:COMPUTERNAME
    $outputFile = "$PSScriptRoot\$HostName.txt"

    # Check if already on Windows 11
    if ($OSVersion -ge 22000) {
        Write-Output "This system is already running Windows 11."
        exit
    }

    # Ensure the device is running Windows 10
    if ($OSVersion -lt 19041) {
        Write-Output "This script only supports Windows 10."
        exit
    }

    # Initialize results
    $Results = @()

    # Check TPM (Trusted Platform Module)
    $TPM = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm
    if ($TPM -and $TPM.SpecVersion -match "2\.0") {
        $Results += "TPM 2.0: Passed"
    } else {
        $Results += "TPM 2.0: Failed - Not detected or not version 2.0"
    }

    # Check Secure Boot
    $SecureBoot = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
    if ($SecureBoot -eq $true) {
        $Results += "Secure Boot: Enabled"
    } else {
        $Results += "Secure Boot: Failed - Not enabled"
    }

    # Check RAM (Minimum 4GB)
    $RAM = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
    if ($RAM -ge 4) {
        $Results += "RAM: Passed ($RAM GB)"
    } else {
        $Results += "RAM: Failed - Only $RAM GB available (Minimum 4GB required)"
    }

    # Check Processor Architecture
    $Processor = Get-CimInstance Win32_Processor
    if ($Processor.AddressWidth -eq 64) {
        $Results += "Processor: Passed (64-bit detected)"
    } else {
        $Results += "Processor: Failed - 32-bit processor detected"
    }

    # Check Disk Partition (GPT required)
    $Disks = Get-Disk | Where-Object PartitionStyle -eq "GPT"
    if ($Disks) {
        $Results += "Disk Partition: Passed (GPT detected)"
    } else {
        $Results += "Disk Partition: Failed - Not using GPT"
    }

    # Save results to file
    Set-Content -Path $outputFile -Value "Windows 11 Compatibility Check Report - $HostName"
    Add-Content -Path $outputFile -Value "--------------------------------------------------"
    Add-Content -Path $outputFile -Value ($Results -join "`n")

    # Display results
    Write-Output "Windows 11 compatibility check completed."
    Write-Output "Report saved as $outputFile"
}

# Run the function
Check-Windows11Compatibility
