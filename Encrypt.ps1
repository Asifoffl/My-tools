# Define password (change this to your desired password)
$password = "Password"

# Get all files in the current directory
$files = Get-ChildItem -File

foreach ($file in $files) {
    # Skip the script itself if it's in the same folder
    if ($file.Name -eq "EncryptAll.ps1") {
        Write-Host "Skipping script file: $($file.Name)"
        continue
    }

    Write-Host "Encrypting file: $($file.FullName)"

    # Run AESCrypt to encrypt the file
    & aescrypt.exe -e $file.FullName -p $password

    # Optional: Check for success/error
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully encrypted: $($file.Name)`n"
    } else {
        Write-Host "Failed to encrypt: $($file.Name). Error code: $LASTEXITCODE`n" -ForegroundColor Red
    }
}