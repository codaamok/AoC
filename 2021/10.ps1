# Part 1

function Remove-Chunks {
    param(
        [String]$String
    )
    $r = '\[\]|\{\}|<>|\(\)'
    while ($String -match $r) {
        $String = $String -replace $r
    }
    if ($String.Length -eq 0) { $true }
    else { $String }
}

$navigationSubsystem = Get-Content .\day10.txt

$Score = @{
    ")" = 3
    "]" = 57
    "}" = 1197
    ">" = 25137
}

$symbols = @{
    "{" = "}"
    "[" = "]"
    "<" = ">"
    "(" = ")"
}

$corruptLines = @()
$illegalChars = @()
$incompleteLines = @()

foreach ($line in $navigationSubsystem) {
    $foundCorruptLine = $false
    $encounteredChars = @{}

    $tmpLine = $line
    $tmpLine = Remove-Chunks $tmpLine

    :mybreak for ($s = 0; $s -lt $tmpLine.Length; $s++) {
        if ($symbols.Values -contains $tmpLine[$s]) {
            $illegalChars += $Score[[string]$tmpLine[$s]]
            $foundCorruptLine = $true
            $corruptLines += $line
            break
        }

        if ($encounteredChars[$tmpLine[$s]]) {
            continue
        }
        else {
            $encounteredChars[$tmpLine[$s]] += 1
            for ($f = $s + 1; $f -lt $tmpLine.Length; $f++) {
                if ($tmpLine[$f] -eq $symbols[$tmpLine[$s]]) {
                    $result = Remove-Chunks $tmpLine.Substring($s, $f)
                    if ($result -eq $true) {
                        $s = $f + 1
                        break
                    }
                    else {
                        # Find first illegal character
                        foreach ($char in [char[]]$result) {
                            if ($symbols.Values -contains [string]$char) {
                                $illegalChars += $Score[[string]$char]
                                break
                            }
                        }
                        $corruptLines += $line
                        $foundCorruptLine = $true
                        break mybreak
                    }
                }
            }
        }
    }

    if (-not $foundCorruptLine) {
        $incompleteLines += $line
    }
}

$sum = 0
$illegalChars | Group-Object -NoElement | ForEach-Object {
    $sum += [int]$_.count * [int]$_.name
}
$sum

# Part 2

$Score = @{
    ")" = 1
    "]" = 2
    "}" = 3
    ">" = 4
}

$Scores = foreach ($line in $incompleteLines) {
    $tmpLine = Remove-Chunks $line
    $completingChars = @()
    for ($f = $tmpLine.Length - 1; $f -ne -1; $f--) {
        $completingChars += $symbols[[string]$tmpLine[$f]]
        $tmpLine += $symbols[[string]$tmpLine[$f]]
    }

    $sum = 0
    foreach ($char in $completingChars) {
        $sum = $sum * 5
        $sum += $Score[[string]$char]
    }
    $sum
}

$index = ($Scores.count - 1) / 2
($Scores | Sort-Object)[$index]