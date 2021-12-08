$data = Get-Content -Path $pwd\aoc-day8.txt | ForEach-Object { $_.split(" | ")[1] }

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