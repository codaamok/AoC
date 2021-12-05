function Get-DeepClone {
    # https://powershellexplained.com/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about/#deep-copies
    [cmdletbinding()]
    param(
        $InputObject
    )
    process
    {
        if($InputObject -is [hashtable]) {
            $clone = @{}
            foreach($key in $InputObject.keys)
            {
                $clone[$key] = Get-DeepClone $InputObject[$key]
            }
            return $clone
        } else {
            return $InputObject
        }
    }
}

function Get-FinalScore {
    param (
        [Object]$Board,
        [int]$BingoNumber
    )
    foreach ($item in $Board.GetEnumerator().Where{-not $_.value.marked}) {
        $unmarkedSum += [int]$item.key
    }
    $unmarkedSum * $BingoNumber
}

$data = Get-Content $pwd\aoc-day4.txt
$bingoNumbers = $data[0] -split ','
$lines = ($data[2..$data.Count]).Where{ -not [String]::IsNullOrWhiteSpace($_) }

$boards = for ($l = 0; $l -lt $lines.Count; $l++) {
    if ($l % 5 -eq 0) {
        $board = @{}
    }

    $numbers = $lines[$l].Split(' ').Where{ -not [String]::IsNullOrEmpty($_) }

    for ($n = 0; $n -lt 5; $n++) {
        $board[[int]$numbers[$n]] = @{
            row    = $l % 5 + 1
            col    = $n + 1
            marked = $false
        }
    }
    
    if ($l % 5 -eq 4) {
        ,$board
    }
}

$boardWinningStatus = @{}
$foundFirstBoard = $false

:parentloop foreach ($bingoNumber in $bingoNumbers) {
    for ($b = 0; $b -lt 100; $b++) {
        $boardWinningStatus[$b] = $false
        $board = $boards[$b]
        if ($board[[int]$bingoNumber]) {
            ($board[[int]$bingoNumber]).marked = $true

            # Check to see if this board 'has bingo' since a new number has been marked as true
            foreach ($n in 1..5) {
                foreach ($item in "row","col") {
                    if ($board.values.Where{$_.$item -eq $n -And $_.marked -eq $true}.count -eq 5) {
                        $boardWinningStatus[$b] = $true
                        $numOfWinningBoards = ($boardWinningStatus.Values -match "True").count
                        if ($numOfWinningBoards -eq 1 -And -not $foundFirstBoard) {
                            $foundFirstBoard = $true
                            $firstBoard = Get-DeepClone $boards[$b]
                            $firstBoardBingoNumber = $bingoNumber
                        }
                        elseif ($numOfWinningBoards -eq $boards.Count) {
                            $lastBoard = Get-DeepClone $boards[$b]
                            $lastBoardBingoNumber = $bingoNumber
                            break parentloop
                        }
                    }
                }
            }
        }
    }
}

# Part 1 answer
"First winning board final score: {0}" -f (Get-FinalScore $firstBoard $firstBoardBingoNumber)

# Part 2 answer
"Last winning board final score: {0}" -f (Get-FinalScore $lastBoard $lastBoardBingoNumber)