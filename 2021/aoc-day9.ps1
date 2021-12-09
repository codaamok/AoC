# Part 1
$heightmap = Get-Content $pwd\aoc-day9.txt

$heightmap = foreach ($line in $heightmap) {
    ,[int[]]($line -split '').Where{'' -ne $_}
}

$x = $heightmap.count
$y = $heightmap[0].count

$riskLevels = for ($ix = 0; $ix -lt $x; $ix++) {
    for ($iy = 0; $iy -lt $y; $iy++) {
        $centre = $heightmap[$ix][$iy]

        $up    = $ix - 1
        $right = $iy + 1
        $down  = $ix + 1
        $left  = $iy - 1

        # Only care about negatives because you can index arrays using negative numbers
        if ($up -lt 0) {
            $up = $null
        }
        else {
            $up = $heightmap[$up][$iy]
        }

        if ($right -ge $y) {
            $right = $null
        }
        else {
            $right = $heightmap[$ix][$right]
        }

        # Only care about negatives because you can index arrays using negative numbers
        if ($left -lt 0) {
            $left = $null
        }
        else {
            $left = $heightmap[$ix][$left]
        }

        if ($down -ge $x) {
            $down = $null
        }
        else {
            $down = $heightmap[$down][$iy]
        }

        $foundLowPoint = $true
        foreach ($item in $up,$right,$down,$left) {
            if ($null -ne $item -and [int]$item -le [int]$centre) {
                $foundLowPoint = $false
                break
            }
        }

        if ($foundLowPoint) {
            "Found low point {0} in x{1} y{2}" -f $centre,($ix+1),($iy+1) | Write-Verbose -Verbose
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