# Define password (change this to your desired password)
$password = "YourSecurePassword"

# Check if a text file with folder paths was provided
if (-not $args[0]) {
    Write-Host "Usage: EncryptFoldersFromList.ps1 <path_to_folder_list.txt>" -ForegroundColor Red
    exit
}

$folderListFile = $args[0]

# Validate that the list file exists
if (-not (Test-Path -Path $folderListFile -PathType Leaf)) {
    Write-Host "Error: Folder list file not found: $folderListFile" -ForegroundColor Red
    exit
}

# Read all folder paths from the text file
$folderPaths = Get-Content -Path $folderListFile | Where-Object { $_ -ne "" }

foreach ($folder in $folderPaths) {
    # Validate folder exists
    if (-not (Test-Path -Path $folder -PathType Container)) {
        Write-Host "Folder does not exist, skipping: $folder" -ForegroundColor Yellow
        continue
    }

    Write-Host "`nProcessing folder: $folder" -ForegroundColor Green

    # Get all files in the folder (add -Recurse below to include subfolders)
    $files = Get-ChildItem -Path $folder -File

    foreach ($file in $files) {
        Write-Host "Encrypting file: $($file.FullName)"

        # Run AESCrypt to encrypt the file
        & aescrypt.exe -e $file.FullName -p $password

        # Optional: Check for success/error
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Successfully encrypted: $($file.Name)`n"
        } else {
            Write-Host "❌ Failed to encrypt: $($file.Name). Error code: $LASTEXITCODE`n" -ForegroundColor Red
        }
    }
}
