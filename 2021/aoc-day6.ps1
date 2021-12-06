# Part 1

[int[]]$fishies = (Get-Content $pwd\aoc-day6.txt) -split ','

for ($d = 0; $d -lt 80; $d++) {
    $newFishies = 0
    for ($f = 0; $f -lt $fishies.count; $f++) {
        if ($fishies[$f] -eq -1) {
            $fishies[$f] = 6
            $newFishies += 8
        }
        else {
            $fishies[$f] -= 1
        }
    }
    $fishies += $newFishies
}

$fishies.count