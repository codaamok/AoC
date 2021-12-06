# Part 1

$fish = @{}

0..8 | ForEach-Object {
    $fish[$_] = 0
}

(Get-Content $pwd\aoc-day6.txt) -split ',' | ForEach-Object {
    $fish[[int]$_] += 1
}

for ($d = 0; $d -lt 80; $d++) {
    $respawn = 0
    for ($i = 0; $i -lt 9; $i++) {
        if ($i -eq 0) {
            $respawn += $fish[$i]
        }
        else {
            $fish[$i-1] += $fish[$i]
        }
        $fish[$i] = 0
    }
    $fish[6] += $respawn
    $fish[8] += $respawn
}

$sum = 0 

foreach ($key in $fish.keys) {
    $sum += $fish[$key]
}

$sum