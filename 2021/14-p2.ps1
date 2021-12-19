# I couldn't do this one on my own, so I read all the code from Nathan, Chris Dent, and Chris Kibble, so this spaghetti is mostly derived from their work!

# https://github.com/ChrisKibble/Advent-of-Code/blob/main/2021/Day14-part2.ps1
# https://github.com/indented-automation/AoC/blob/master/2021/14/Part1-2.ps1
# https://github.com/theznerd/AdventOfCode/blob/main/2021/Day14-Puzzle2.ps1

$data = Get-Content $pwd\14.txt

$insertionRules = @{}
$data[2..$data.length] | ForEach-Object {
    $key, $value = $_.Split(' -> ')
    $insertionRules[$key] = @(
        "{0}{1}" -f $key.Substring(0, 1), $value
        "{0}{1}" -f $value, $key.Substring(1, 1)
    )
}

$templateStr = $data[0]
$tracker = @{}
for ($i = 0; $i -lt $templateStr.Length-1; $i++) {
    $pair = $templateStr.Substring($i, 2)
    $tracker[$pair] += 1
}

1..40 | ForEach-Object {
    $trackerclone = $tracker.clone()

    foreach ($key in [string[]]$trackerclone.Keys) {
        $tracker[$key] -= $trackerclone[$key]
        foreach ($item in $insertionRules[$key]) {
            $tracker[$item] += $trackerclone[$key]
        }
    }
}

$total = @{}
$total[$templateStr[-1]] += 1
foreach ($key in [string[]]$tracker.Keys) {
    $total[$key[0]] += $tracker[$key]
}

$count = $total.GetEnumerator() | Measure-Object Value -Minimum -Maximum
$count.Maximum - $count.Minimum