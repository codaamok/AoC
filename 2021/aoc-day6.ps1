# Part 1
$days = 80

# Part 2
#$days = 256

$sum = $d = 0
$fish = @{}

(Get-Content $pwd\aoc-day6.txt) -split ',' | ForEach-Object {
    $fish[[int]$_] += 1
}

do {
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

    $d++
} while ($d -lt $days)

$fish.values | ForEach-Object { $sum += $_ }

$sum