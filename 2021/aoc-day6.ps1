# Part 1

[int[]]$fishies = (Get-Content $pwd\aoc-day6.txt) -split ','

for ($d = 0; $d -lt 80; $d++, ([int[]]$n = @())) {
    Write-Host "Working on day $d"
    for ($f = 0; $f -lt $fishies.count; $f++) {
        $fishies[$f] -= 1
        if ($fishies[$f] -eq -1) {
            $fishies[$f] = 6
            $n += 8
        }
    }
    if ($n -ne 0) {
        $fishies += $n
    }
}

$fishies.count