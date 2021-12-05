# Part 1

$data = Get-Content $pwd\aoc-day4.txt

$bingoNumbers = $data[0] -split ','

$lines = ($data[2..$data.Count]).Where{ -not [String]::IsNullOrWhiteSpace($_) }

$boards = for ($l = 0; $l -lt $lines.Count; $l++) {
    if ($l % 5 -eq 0) {
        $board = @()
    }

    $numbers = $lines[$l].Split(' ').Where{ -not [String]::IsNullOrEmpty($_) }

    for ($n = 0; $n -lt 5; $n++) {
        $board += [ordered]@{
            $numbers[$n] = [PSCustomObject]@{
                row    = $l % 5 + 1
                col    = $n + 1
                marked = $false
            }
        }
    }
    
    if ($l % 5 -eq 4) {
        ,$board
    }
}

:FindFirstBoardToWin foreach ($bingoNumber in $bingoNumbers) {
    foreach ($board in $boards) {
        if ($board.$bingoNumber) {
            ($board.$bingoNumber).marked = $true

            # Check to see if this board 'has bingo' since a new number has been marked as true
            foreach ($n in 1..5) {
                foreach ($item in "row","col") {
                    if ($board.GetEnumerator().values.Where{$_.$item -eq $n -And $_.marked -eq $true}.count -eq 5) {
                        $unmarkedNumbersSum = 0
                        foreach ($key in $board.keys) {
                            if (-not ($board.$key).marked) {
                                $unmarkedNumbersSum += [int]$key
                            }
                        }
                        break FindFirstBoardToWin
                    }
                }
            }
        }
    }
}

"Board {0} was the first to win" -f $boards.IndexOf($board) | Write-Host

$unmarkedNumbersSum * $bingoNumber