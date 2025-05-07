# Define password (change this to your desired password)
$password = "Password"

# Check if a directory path was provided as an argument
if (-not $args[0]) {
    Write-Host "Usage: EncryptDirectory.ps1 <directory_path>" -ForegroundColor Red
    exit
}

$targetDir = $args[0]

# Validate the directory exists
if (-not (Test-Path -Path $targetDir -PathType Container)) {
    Write-Host "Error: Directory does not exist: $targetDir" -ForegroundColor Red
    exit
}

# Get all files in the specified directory (add -Recurse to include subfolders)
$files = Get-ChildItem -Path $targetDir -File

foreach ($file in $files) {
    # Skip the script itself if it's inside the target directory
    if ($file.Name -eq "EncryptDirectory.ps1" -or $file.Name -eq "EncryptAll.ps1") {
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
