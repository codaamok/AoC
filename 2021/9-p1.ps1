function Get-SurroundingNumbers {
    param(
        [int]$x,
        [int]$y
    )

    $up    = $y - 1
    $right = $x + 1
    $down  = $y + 1
    $left  = $x - 1

    # Only care about negatives because you can index arrays using negative numbers
    if ($up -lt 0) {
        $up = $null
    }
    else {
        $up = $script:heightmap[$up][$x]
    }

    # I don't think this was necessary, mostly as a precaution
    # I think I could go out of range on the first index reference here, and the second out of range reference would just return null
    if ($right -ge $script:heightmap[0].Count) {
        $right = $null
    }
    else {
        $right = $script:heightmap[$y][$right]
    }

    # Only care about negatives because you can index arrays using negative numbers
    if ($left -lt 0) {
        $left = $null
    }
    else {
        $left = $script:heightmap[$y][$left]
    }

    # This was needed, however, because you can reference a child index reference if the parent is out of range / null
    if ($down -ge $script:heightmap.Count) {
        $down = $null
    }
    else {
        $down = $script:heightmap[$down][$x]
    }

    return @{up = $up; right = $right; down = $down; left = $left}
}

$script:heightmap = Get-Content $pwd\day9.txt

$heightmap = foreach ($line in $heightmap) {
    ,[int[]]($line -split '').Where{'' -ne $_}
}

$y = $heightmap.count
$x = $heightmap[0].count

$riskLevels = for ($iy = 0; $iy -lt $y; $iy++) {
    for ($ix = 0; $ix -lt $x; $ix++) {
        $centre = $heightmap[$iy][$ix]

        $SurroundingNumbers = Get-SurroundingNumbers -x $ix -y $iy

        $foundLowPoint = $true
        foreach ($key in $SurroundingNumbers.Keys) {
            if ($null -ne $SurroundingNumbers[$key] -and [int]$SurroundingNumbers[$key] -le [int]$centre) {
                $foundLowPoint = $false
                break
            }
        }

        if ($foundLowPoint) {
            "Found low point {0} in x{1} y{2}" -f $centre, $ix, $iy | Write-Verbose -Verbose
            # Increase by 1 to get risk level
            [int]$centre + 1
        }
    }
}

$total = 0
foreach ($riskLevel in $riskLevels) {
    $total += $riskLevel
}
$total