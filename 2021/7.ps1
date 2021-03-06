# Part 1

[int[]]$crabs = (Get-Content $pwd\day7.txt) -split ','

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
# Thanks to Chris Kibble for helping me on this one

[int[]]$crabs = (Get-Content $pwd\day7.txt) -split ','

[int]$min = ($crabs | Measure-Object -Minimum).Minimum
[int]$max = ($crabs | Measure-Object -Maximum).Maximum

$allfuel = for ($p = $min; $p -lt $max+1; $p++) {
    $fuel = 0
    foreach ($crab in $crabs) {
        $x = [Math]::Abs($p - $crab - 1)
        $fuel += $x * ($x + 1) / 2
    }
    $fuel
}

($allfuel | Measure-Object -Minimum).Minimum
