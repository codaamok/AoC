$content = Get-Content $pwd\13.txt
$coords = @{}

foreach ($xy in ($content -match '\d+,\d+')) {
    $x, $y = $xy.Split(',') -as [int[]]
    $coords[$xy] = @{
        x = $x
        y = $y
    }
}
$instructions = [Regex]::Matches($content, '[xy]=\d+').Value

foreach ($instruction in $instructions) {
    $axis, [int]$line = $instruction.Split('=')

    # Recalculate x and y
    $x = $y = 0
    foreach ($xy in $coords.Keys) {
        $_x, $_y = $xy.Split(',') -as [int[]]
        if ($_x -gt $x) { $x = $_x }
        if ($_y -gt $y) { $y = $_y }
    }

    if ($axis -eq "y") {
        for ($ix = 0; $ix -lt ($x + 1); $ix++) {
            for ($iy = $line + 1; $iy -lt ($y + 1); $iy++) {
                $xy = "{0},{1}" -f $ix, $iy
                if ($coords[$xy]) {
                    $newy = $line - ($iy - $line)
                    $newxy = "{0},{1}" -f $ix, $newy
                    $coords[$newxy] = @{
                        x = $ix
                        y = $newy
                    }
                    $coords.Remove($xy)
                }
            }
        }
    }
    else {
        for ($ix = $line + 1; $ix -lt ($x + 1); $ix++) {
            for ($iy = 0; $iy -lt ($y + 1); $iy++) {
                $xy = "{0},{1}" -f $ix, $iy
                if ($coords[$xy]) {
                    $newx = $line - ($ix - $line)
                    $newxy = "{0},{1}" -f $newx, $iy
                    $coords[$newxy] = @{
                        x = $newx
                        y = $iy
                    }
                    $coords.Remove($xy)
                }
            }
        }
    }
}

# Draw with the co-ords

# Recalculate x and y
$x = $y = 0
foreach ($xy in $coords.Keys) {
    $_x, $_y = $xy.Split(',') -as [int[]]
    if ($_x -gt $x) { $x = $_x }
    if ($_y -gt $y) { $y = $_y }
}

$picture = [String[][]]::New([int]$y+1, [int]$x+1)

for ($ix = 0; $ix -lt ($x + 1); $ix++) {
    for ($iy = 0; $iy -lt ($y + 1); $iy++) {
        $xy = "{0},{1}" -f $ix, $iy
        if ($coords[$xy]) {
            $picture[$iy][$ix] = "#"
        }
        else {
            $picture[$iy][$ix] = "-"
        }
    }
}

0..$picture.count | ForEach-Object { 
    $picture[$_] -join ''
}
