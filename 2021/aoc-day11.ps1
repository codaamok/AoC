
function Get-AdjacentCoordinates {
    param (
        [String]$xy,
        [Switch]$AsObject # Used for testing
    )

    [int]$x, [int]$y = $xy -split ','

    # Determine top, top right, and top left
    if (($y - 1) -lt 0) {
        $top = $null
        $topright = $null 
        $topleft = $null
    }
    else {
        $top = "{0},{1}" -f $x, ($y - 1)

        if (($x + 1) -ge $Script:grid[0].Count) {
            $topright = $null
        }
        else {
            $topright = "{0},{1}" -f ($x + 1), ($y - 1)
        }

        if (($x - 1) -lt 0) {
            $topleft = $null
        }
        else {
            $topleft = "{0},{1}" -f ($x - 1), ($y - 1)
        }
    }

    # Determine right
    if (($x + 1) -ge $Script:grid[0].Count) {
        $right = $null
    }
    else {
        $right = "{0},{1}" -f ($x + 1), $y
    }

    # Determine bottom, bottom right, and bottom left
    if (($y + 1) -ge $Script:grid.Count) {
        $bottom = $null
        $bottomright = $null 
        $bottomleft = $null
    }
    else {
        $bottom = "{0},{1}" -f $x, ($y + 1)

        if (($x + 1) -ge $Script:grid[0].Count) {
            $bottomright = $null
        }
        else {
            $bottomright = "{0},{1}" -f ($x + 1), ($y + 1)
        }

        if (($x - 1) -lt 0) {
            $bottomleft = $null
        }
        else {
            $bottomleft = "{0},{1}" -f ($x - 1), ($y + 1)
        }
    }

    # Determine left
    if (($x - 1) -lt 0) {
        $left = $null
    }
    else {
        $left = "{0},{1}" -f ($x - 1), $y
    }

    if ($AsObject) {
        [PSCustomObject]@{
            top = $top
            topright = $topright
            right = $right
            bottomright = $bottomright
            bottom = $bottom
            bottomleft = $bottomleft
            left = $left
            topleft = $topleft
        }
    }
    else {
        ($top,$topright,$right,$bottomright,$bottom,$bottomleft,$left,$topleft).Where{$null -ne $_}
    }
}

function Invoke-RareBioluminescentDumboOctopusStep {
    param (
        [Parameter(ValueFromPipeline)]
        [String]$xy
    )
    [int]$x, [int]$y = $xy -split ','

    if ($script:grid[$y][$x] -eq 9) {
        $script:grid[$y][$x] = 0
        $Script:flashTracker[$xy] += 1
        $script:flashes++
        Get-AdjacentCoordinates -xy $xy | ForEach-Object {
            Invoke-RareBioluminescentDumboOctopusStep -xy $_
        }
    }
    else {
        # Only increment the energy of surrounding octopuses so long as they
        # have not previously flashed in the same step
        if (-not ($Script:flashTracker.ContainsKey($xy))) {
            $script:grid[$y][$x] += 1
        }
    }
}

$octopuses = Get-Content $pwd\aoc-day11.txt

$grid = foreach ($line in $octopuses) {
    ,[int[]]($line -split '').Where{'' -ne $_}
}

$y = $grid.count
$x = $grid[0].count
$steps = 100
$flashes = 0

for ($s = 0; $s -lt $steps; $s++) {
    $flashTracker = @{}
    for ($iy = 0; $iy -lt $y; $iy++) {
        for ($ix = 0; $ix -lt $x; $ix++) {
            $xy = "{0},{1}" -f $ix, $iy
            Invoke-RareBioluminescentDumboOctopusStep -xy $xy
        }
    }
}

$flashes

$grid.ForEach{$_ -join ''}