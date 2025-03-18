# Windows 11 Compatibility Checker

## Overview
This PowerShell script checks if your device meets the minimum requirements for Windows 11. It performs checks for:
- TPM 2.0
- Secure Boot
- Processor Architecture
- RAM (Minimum 4GB)
- Disk Partition (GPT)
- Windows Version

If your device is **already running Windows 11**, it will notify you.  
If your device is running **Windows 10**, it will generate a report `<hostname>.txt` with the results.

---

## How to Run

### **1. Run Without Execution Policy Bypass**
If your PowerShell execution policy allows scripts:
```powershell
.\Win11_Compatibility_Check.ps1
```
### **2. Run With Execution Policy Bypass**
If your PowerShell execution policy does not allows scripts:
```powershell
.\powershell -ExecutionPolicy Bypass -File .\Win11_Compatibility_Check.ps1
