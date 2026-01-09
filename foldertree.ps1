$root = "C:\Path\To\Folder"

# Function to get folder size in MB (recursive)
function Get-FolderSizeMB {
    param([string]$Path)
    try {
        $sizeBytes = (Get-ChildItem $Path -File -Recurse -ErrorAction SilentlyContinue |
                        Measure-Object -Property Length -Sum).Sum
        return [math]::Round($sizeBytes / 1MB, 2)
    } catch {
        return 0
    }
}

# Build folder tree with size and indentation
Get-ChildItem $root -Directory -Recurse | ForEach-Object {
    $folder = $_
    
    # Depth for indentation
    $depth = ($folder.FullName.Substring($root.Length) -split '\\').Count - 1

    [PSCustomObject]@{
        Depth    = $depth
        Folder   = (' ' * ($depth * 2)) + $folder.Name
        FullPath = $folder.FullName
        SizeMB   = Get-FolderSizeMB $folder.FullName
        Owner    = ""   # Placeholder for manual entry
    }
} | Export-Csv "C:\Temp\folder-tree.csv" -NoTypeInformation -Encoding UTF8
