# Get the script's current directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define log file path
$LogFile = "$ScriptDir\Deleted_files.log"

# Get the current date
$CurrentDate = Get-Date

# Get files older than 30 days
$FilesToDelete = Get-ChildItem -Path $ScriptDir -File | Where-Object { $_.LastWriteTime -lt $CurrentDate.AddDays(-30) }

# Loop through and delete files
foreach ($File in $FilesToDelete) {
    try {
        $FilePath = $File.FullName
        Remove-Item -Path $FilePath -Force
        # Log successful deletion
        "$CurrentDate - Deleted: $FilePath" | Out-File -Append -FilePath $LogFile
    } catch {
        # Log any errors
        "$CurrentDate - Error deleting: $FilePath - $_" | Out-File -Append -FilePath $LogFile
    }
}
