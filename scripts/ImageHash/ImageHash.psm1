$env:ExecutablePath = 'img-hash.exe'

<#
    .Synopsis
    Generates hashes for images.
    .Description
    Generates hashes for images.
    .Parameter Path
    Specifies one or more image paths.
    .Parameter Type
    Specifies the hashing function being used.
    .Parameter Format
    Specifies the hash format being returned.
    .Example
    Get-ImageHash -Path C:\Temp\Test.jpg -Type Perceptual
#>
function Get-ImageHash {
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $Path,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Average', 'Perceptual')]
        [string] $Type,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Bytes', 'Hex')]
        [string] $Format
    )

    $paths = @()
    foreach ($item in $Path) {
        if (Test-Path -Path $item -PathType Leaf) {
            $paths += (Get-ChildItem -Path $item -File).FullName
        }
    }
    return (& $env:ExecutablePath -f $Type.ToLower() $paths | ConvertFrom-Json).$Format
}

<#
    .Synopsis
    Gets image metadata (exif).
    .Description
    Gets image metadata (exif).
    .Parameter Path
    Specifies one or more image paths.
    .Example
    Get-ImageMetadata -Path C:\Temp\Test.jpg
#>
function Get-ImageMetadata {
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $Path
    )

    $paths = @()
    foreach ($item in $Path) {
        $paths += (Get-ChildItem -Path $item -File).FullName
    }

    return (& $env:ExecutablePath -e $paths | ConvertFrom-Json).exif
}

<#
    .Synopsis
    Exports image hashes (and metadata) for images.
    .Description
    Exports image hashes (and metadata) for images.
    .Parameter Path
    Specifies one or more image paths.
    .Parameter HashType
    Specifies the hashing function being used.
    .Parameter Destination
    Specifies the destination directory for the export file.
    .Parameter BatchSize
    Specifies how many images are processed at once.
    .Example
    Export-ImageData -Path C:\Temp\* -HashType Perceptual -Destination C:\Temp
#>
function Export-ImageData {
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $Path,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Average', 'Perceptual')]
        [string] $HashType,
        [string] $Destination,
        [int] $BatchSize = 50
    )

    $paths = @()
    foreach ($item in $Path) {
        $paths += (Get-ChildItem -Path $item -File).FullName
    }

    if ([string]::IsNullOrEmpty($Destination)) {
        $Destination = $env:TEMP
    }
    $exportFile = "$Destination\img-hash_$(New-Guid).json"

    # get image files
    $item = @{
        Path    = $Path
        File    = $true
        Recurse = $true
        Include = @('*.jpg', '*.jpeg', '*.png', '*.bmp', '*.webp')
    }
    $images = Get-ChildItem @item
    
    # split image file array into chunks of <BatchSize>
    $batch = @()
    for ($i = 0; $i -lt $images.Count; $i += $BatchSize) {
        $batch += , ($images | Select-Object -Skip $i -First $BatchSize)
    }

    $exp = [System.Collections.Generic.List[PSCustomObject]]::New()

    $i = 0
    Write-Progress -Activity "Exporting image metadata (batch size: $($batch[0].Count))" -Status "$i / $($images.Count) (0%)" -PercentComplete 0
    $batch | ForEach-Object {
        $i += $_.Count
        $pctComplete = [math]::Floor(($i / $images.Count * 100))
        Write-Progress -Activity "Exporting image metadata (batch size: $($_.Count))" -Status "$i / $($images.Count) ($pctComplete%)" -PercentComplete $pctComplete

        [System.Collections.Generic.List[PSCustomObject]] $data = (& img-hash.exe -f $HashType.ToLower() -e $_.FullName | ConvertFrom-Json)
        $exp.AddRange($data)
    }

    New-Item -Path $exportFile -ItemType File | Set-Content -Value ($exp | ConvertTo-Json)

    return $exportFile
}

Export-ModuleMember -Function Get-ImageHash, Get-ImageMetadata, Export-ImageData