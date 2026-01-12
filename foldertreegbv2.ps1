$root = "\\?\C:\Path\To\Folder"
$maxDepth = 4

function Get-FolderSizeGB {
    param([string]$Path)
    try {
        $sizeBytes = (
            Get-ChildItem -LiteralPath $Path -File -ErrorAction SilentlyContinue -Force |
            Measure-Object Length -Sum
        ).Sum
        if ($sizeBytes) { [math]::Round($sizeBytes / 1GB, 2) } else { 0 }
    } catch { 0 }
}

function Process-Folder {
    param(
        [string]$Path,
        [int]$Depth
    )

    # Stop if depth limit reached
    if ($Depth -gt $maxDepth) { return }

    # Get folder info
    $folder = Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue
    if ($folder -eq $null) { return }

    # Output current folder
    [PSCustomObject]@{
        Depth    = $Depth
        Folder   = (' ' * ($Depth * 2)) + $folder.Name
        FullPath = $folder.FullName
        SizeGB   = Get-FolderSizeGB $folder.FullName
        Owner    = ""
    }

    # Recurse into subfolders
    $subfolders = Get-ChildItem -LiteralPath $Path -Directory -ErrorAction SilentlyContinue -Force
    foreach ($sub in $subfolders) {
        Process-Folder -Path $sub.FullName -Depth ($Depth + 1)
    }
}

# Run
Process-Folder -Path $root -Depth 0 |
Export-Csv "C:\Temp\folder-tree.csv" -NoTypeInformation -Encoding UTF8
