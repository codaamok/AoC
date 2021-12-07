# Part 1

[int[]]$crabs = (Get-Content $pwd\aoc-day7.txt) -split ','

[int]$min = ($crabs | Measure-Object -Minimum).Minimum
[int]$max = ($crabs | Measure-Object -Maximum).Maximum

$allfuel = for ($p = $min; $p -lt $max+1; $p++) {
    $fuel = 0
    foreach ($crab in $crabs) {
        $fuel += [Math]::Abs($p - $crab)
    }
    $fuel
}

($allfuel | Measure-Object -Minimum).Minimum

# Part 2

[int[]]$crabs = (Get-Content $pwd\aoc-day7.txt) -split ','

[int]$min = ($crabs | Measure-Object -Minimum).Minimum
[int]$max = ($crabs | Measure-Object -Maximum).Maximum

$allfuel = for ($p = $min; $p -lt $max+1; $p++) {
    $fuel = 0
    foreach ($crab in $crabs) {
        $fuel += (1..[Math]::Abs($p - $crab - 1) | Measure-Object -Sum).Sum
    }
    $fuel
}

($allfuel | Measure-Object -Minimum).Minimum
