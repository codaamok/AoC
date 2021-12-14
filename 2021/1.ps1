$depths = Get-Content $pwd\aoc-day1.txt

# Part 1

$j = 0
for ($i = 1; $i -lt $depths.Count; $i++) {
    if ($depths[$i-1] -lt $depths[$i]) {
        $j++
    }
}

# Part 2

$depthsNew = for ($i = 0; $i -lt $depths.Count; $i++) {
    if($null -ne $depths[$i+2]) {
        $depths[$i] + $depths[$i+1] + $depths[$i+2]
    }
}
$j = 0
for ($i = 1; $i -lt $depthsNew.Count; $i++) {
    if ($depthsNew[$i-1] -lt $depthsNew[$i]) {
        $j++
    }
}
