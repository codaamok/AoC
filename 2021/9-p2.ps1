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

    $result = @{
        up = @{
            Value = $up
            xy    = "{0},{1}" -f $x, ($y - 1)
        }
        right = @{
            Value = $right
            xy    = "{0},{1}" -f ($x + 1), $y
        }
        down = @{
            Value = $down
            xy    = "{0},{1}" -f $x, ($y + 1)
        }
        left = @{
            Value = $left
            xy    = "{0},{1}" -f ($x - 1), $y
        }
    }

    return $result
}

function Get-Basin {
    param(
        [int]$c,
        [string]$xy
    )

    $script:basinCounter++
    # Update exclusion tracker, regardless, because I don't want to go back on myself
    $script:basinExclTracker[$xy] += 1

    [int]$x, [int]$y = $xy -split ','

    $SurroundingNumbers = Get-SurroundingNumbers -x $x -y $y

    foreach ($direction in $SurroundingNumbers.Keys) {
        $number = $SurroundingNumbers[$direction]["Value"]
        $nextxy = $SurroundingNumbers[$direction]["xy"]
        $nextx, $nexty = $nextxy.Split(',')

        if ($null -ne $number -And [int]$number -lt 9 -And [int]$number -gt $c -And -not $script:basinExclTracker[$nextxy]) {
            Get-Basin -c $number -xy ("{0},{1}" -f $nextx, $nexty)
        }
    }
}

$heightmap = Get-Content $pwd\day9.txt

$script:heightmap = foreach ($line in $heightmap) {
    ,[int[]]($line -split '').Where{'' -ne $_}
}

$y = $heightmap.count
$x = $heightmap[0].count

$allBasins = for ($iy = 0; $iy -lt $y; $iy++) {
    for ($ix = 0; $ix -lt $x; $ix++) {
        $centre = $heightmap[$iy][$ix]

        $SurroundingNumbers = Get-SurroundingNumbers -x $ix -y $iy

        $foundLowPoint = $true
        foreach ($direction in $SurroundingNumbers.Keys) {
            if ($null -ne $SurroundingNumbers[$direction]["Value"] -and [int]$SurroundingNumbers[$direction]["Value"] -le [int]$centre) {
                $foundLowPoint = $false
                break
            }
        }

        if ($foundLowPoint) {
            "Found low point {0} in x{1} y{2}" -f $centre, $ix, $iy | Write-Verbose -Verbose
            $script:basinCounter = 0
            $script:basinExclTracker = @{}
            Get-Basin -c $centre -xy ("{0},{1}" -f $ix, $iy)
            $script:basinCounter
        }
    }
}

$r = $allBasins | Sort-Object -Descending | Select-Object -First 3

$r[0] * $r[1] * $r[2]
