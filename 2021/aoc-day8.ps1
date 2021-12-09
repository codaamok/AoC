$data = Get-Content -Path $pwd\aoc-day8.txt | ForEach-Object { $_.split(" | ")[1] }

# Part 1
$i = 0
foreach ($line in $data) {
    foreach ($digit in $line.split(' ')) {
        switch ($digit.length) {
            2 { $i++ } # 1
            3 { $i++ } # 7
            4 { $i++ } # 4
            7 { $i++ } # 8
        }
    }
}
$i

# Part 2, inspired by Nathan Ziehnert's after giving up and reading his code
# https://github.com/theznerd/AdventOfCode/blob/main/2021/Day08-Puzzle2.ps1
$data = Get-Content -Path $pwd\aoc-day8.txt

$numbers = @{}

foreach ($line in $data) {
    $1 = [Regex]::Match($line, ' (\w{2}) ').Groups[1].Value
    $4 = [Regex]::Match($line, ' (\w{4}) ').Groups[1].Value
    $7 = [Regex]::Match($line, ' (\w{3}) ').Groups[1].Value
    $8 = [Regex]::Match($line, ' (\w{8}) ').Groups[1].Value

    $signals, $output = $line.Split(' | ')

    $signals = $signals.Split(' ')

    switch -Regex (1..9) {
        [1478] { 
            $numbers[$_] = [char[]](Get-Variable $_ -ValueOnly)
        }
        default {
            $numbers[$_] = 
        }
    }

    foreach ($number  in 1..9) {
        $numbers[$number] = $signals.Where{ [char[]]$cArray = $_; $cArrray.count -eq 2 -and $ }
    }
}
