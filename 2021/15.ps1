function Get-SurroundingCoordinates {
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

    $result = [PSCustomObject]@{
        up    = [PSCustomObject]@{
            value = $up
            x     = $x
            y     = $y - 1
        }
        right = [PSCustomObject]@{
            value = $right
            x     = $x + 1
            y     = $y
        }
        $down = [PSCustomObject]@{
            value = $down
            x     = $x
            y     = $y + 1
        }
        left  = [PSCustomObject]@{
            value = $left
            x     = $x - 1
            y     = $y
        }
    }

    return $result
}

function Find-PathToTheEnd {
    param (
        [Int]$Risk,
        [Int]$x,
        [Int]$y,
        [String]$FinalPosition,
        [String[]]$Visited
    )
    $xy = "{0},{1}" -f $x, $y
    $Risk += $script:map[$y][$x]
    $Visited += $xy
    
    if ($FinalPosition -eq $xy) {
        "Risk total: {0}" -f $Risk | Write-Verbose -Verbose
        $script:path += $Risk
        return
    }

    $SurroundingXY = Get-SurroundingCoordinates -x $x -y $y

    foreach ($direction in "up","right","down","left") {
        $nextxy = "{0},{1}" -f $SurroundingNumbers.$direction.x, $SurroundingNumbers.$direction.y
        if ($null -ne $SurroundingXY.$direction.value -And $Visited -notcontains $nextxy) {
            Find-PathToTheEnd -Risk $Risk -x $SurroundingXY.$direction.x -y $SurroundingXY.$direction.y -FinalPosition $FinalPosition -Visited $Visited
        }
    }
}

$map = Get-Content $pwd\day15.txt
$script:path = @()

$script:map = foreach ($line in $heightmap) {
    ,[int[]]($line -split '').Where{'' -ne $_}
}

$y = $map.count
$x = $map[0].count
$endxy = "{0},{1}" -f $x-1, $y-1

for ($iy = 0; $iy -lt $y; $iy++) {
    for ($ix = 0; $ix -lt $x; $ix++) {
        $xy = "{0},{1}" -f $ix, $iy

    }
}