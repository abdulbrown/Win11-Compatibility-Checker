 Windows 11 Compatibility Checker

## Overview
This PowerShell script checks if your Windows 10 device meets the minimum system requirements for Windows 11.  

### **The script checks for:**
- TPM 2.0 availability
- Secure Boot status
- RAM size (Minimum 4GB required)
- Processor architecture (Must be 64-bit)
- Disk partition style (GPT required)
- Windows version

If your system **is already running Windows 11**, the script will notify you.  
If your system **is running Windows 10**, it will generate a **report** named `<hostname>.txt` in the same directory as the script.

---

## How to Run the Script

### **1. Run Without Execution Policy Bypass**
If your PowerShell execution policy allows scripts:
```powershell
.\Win11_Compatibility_Check.ps1
```
### **2. Run With Execution Policy Bypass**
If your PowerShell execution policy does not allows scripts:
```powershell
.\powershell -ExecutionPolicy Bypass -File .\Win11_Compatibility_Check.ps1
