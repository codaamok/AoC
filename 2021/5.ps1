# Part 1
$data = Get-Content $pwd\day5.txt
$coordinates = @{}
$overlaps = @{}

foreach ($line in $data) {
    $x1,$y1,$x2,$y2 = $line -replace ' -> ', ',' -split ','
    
    if ($x1 -eq $x2) {
        foreach ($item in $y1..$y2) {
            $coordinate = "{0},{1}" -f $x1, $item
            $coordinates[$coordinate] += 1
            if ($coordinates[$coordinate] -gt 1) {
                $overlaps[$coordinate] += 1
            }
        }
    }
    elseif ($y1 -eq $y2) {
        foreach ($item in $x1..$x2) {
            $coordinate = "{0},{1}" -f $item, $y1
            $coordinates[$coordinate] += 1
            if ($coordinates[$coordinate] -gt 1) {
                $overlaps[$coordinate] += 1
            }
        }
    }
}

$overlaps.count

# Part 2
$data = Get-Content $pwd\day5.txt
$coordinates = @{}
$overlaps = @{}

foreach ($line in $data) {
    $x1,$y1,$x2,$y2 = $line -replace ' -> ', ',' -split ','
    
    if ($x1 -eq $x2) {
        foreach ($item in $y1..$y2) {
            $coordinate = "{0},{1}" -f $x1, $item
            $coordinates[$coordinate] += 1
            if ($coordinates[$coordinate] -gt 1) {
                $overlaps[$coordinate] += 1
            }
        }
    }
    elseif ($y1 -eq $y2) {
        foreach ($item in $x1..$x2) {
            $coordinate = "{0},{1}" -f $item, $y1
            $coordinates[$coordinate] += 1
            if ($coordinates[$coordinate] -gt 1) {
                $overlaps[$coordinate] += 1
            }
        }
    }
    else {
        for ($x = $y = 0; $x -lt ($x1..$x2).count; $x++, $y++) {
            $coordinate = "{0},{1}" -f  $(if ([int]$x1 -gt [int]$x2) { [int]$x1 - $x } else { [int]$x1 + $x }), 
                                        $(if ([int]$y1 -gt [int]$y2) { [int]$y1 - $y } else { [int]$y1 + $y })
            $coordinates[$coordinate] += 1
            if ($coordinates[$coordinate] -gt 1) {
                $overlaps[$coordinate] += 1
            }
        }
    }
}

$overlaps.count