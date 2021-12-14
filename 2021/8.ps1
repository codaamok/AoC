$data = Get-Content -Path $pwd\day8.txt | ForEach-Object { $_.split(" | ")[1] }

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
$data = Get-Content -Path $pwd\day8.txt

$displayNumbers = @{}

$displayOutputNumbers = foreach ($line in $data) {
    $signals, $outputNumbers = $line.Split(' | ')

    $signals = $signals.Split(' ') | Sort-Object { $_.length }

    $displayNumbers[1] = [char[]]$signals[0]
    $displayNumbers[4] = [char[]]$signals[2]
    $displayNumbers[7] = [char[]]$signals[1]
    $displayNumbers[8] = [char[]]$signals[9]

    switch -Regex (0..9) {
        2 { # 2 has 1 segment in common with 1, 2 segments in common with 4, and 2 segments in common with 7 = 5
            $currentNumber = $_
            $displayNumbers[$currentNumber] = [char[]]$signals.Where{ 
                [char[]]$cArray = $_
                $cArray.count -eq 5 -And 
                [char[]]($cArray.Where{ $displayNumbers[1] -contains $_ }).Count -eq 1 -And 
                [char[]]($cArray.Where{ $displayNumbers[4] -contains $_ }).Count -eq 2 -And
                [char[]]($cArray.Where{ $displayNumbers[7] -contains $_ }).Count -eq 2
            }[0]
        }
        3 { # 3 has 2 segments in common with 1, 3 segments in common with 4, and 3 segments in common with 7 = 8
            $currentNumber = $_
            $displayNumbers[$currentNumber] = [char[]]$signals.Where{ 
                [char[]]$cArray = $_
                $cArray.count -eq 5 -And 
                [char[]]($cArray.Where{ $displayNumbers[1] -contains $_ }).Count -eq 2 -And 
                [char[]]($cArray.Where{ $displayNumbers[4] -contains $_ }).Count -eq 3 -And
                [char[]]($cArray.Where{ $displayNumbers[7] -contains $_ }).Count -eq 3
            }[0]
        }
        5 { # 5 has 1 segment in common with 1, 3 segments in common with 4, and 2 segments in common with 7 = 6
            $currentNumber = $_
            $displayNumbers[$currentNumber] = [char[]]$signals.Where{ 
                [char[]]$cArray = $_
                $cArray.count -eq 5 -And 
                [char[]]($cArray.Where{ $displayNumbers[1] -contains $_ }).Count -eq 1 -And 
                [char[]]($cArray.Where{ $displayNumbers[4] -contains $_ }).Count -eq 3 -And
                [char[]]($cArray.Where{ $displayNumbers[7] -contains $_ }).Count -eq 2
            }[0]
        }
        0 { # 0 has 2 segments in common with 1, 3 segments in common with 4, and 3 segments in common with 7 = 8
            $currentNumber = $_
            $displayNumbers[$currentNumber] = [char[]]$signals.Where{ 
                [char[]]$cArray = $_
                $cArray.count -eq 6 -And 
                [char[]]($cArray.Where{ $displayNumbers[1] -contains $_ }).Count -eq 2 -And 
                [char[]]($cArray.Where{ $displayNumbers[4] -contains $_ }).Count -eq 3 -And
                [char[]]($cArray.Where{ $displayNumbers[7] -contains $_ }).Count -eq 3
            }[0]
        }
        6 { # 6 has 1 segment in common with 1, 3 segmenst in common with 4, and 2 segments in common with 7 = 6 
            $currentNumber = $_
            $displayNumbers[$currentNumber] = [char[]]$signals.Where{ 
                [char[]]$cArray = $_
                $cArray.count -eq 6 -And 
                [char[]]($cArray.Where{ $displayNumbers[1] -contains $_ }).Count -eq 1 -And 
                [char[]]($cArray.Where{ $displayNumbers[4] -contains $_ }).Count -eq 3 -And
                [char[]]($cArray.Where{ $displayNumbers[7] -contains $_ }).Count -eq 2
            }[0]
        }
        9 { # 9 has 2 segments in common with 1, 4 segments in common with 4, and 3 segments in common with 7 = 9
            $currentNumber = $_
            $displayNumbers[$currentNumber] = [char[]]$signals.Where{ 
                [char[]]$cArray = $_
                $cArray.count -eq 6 -And 
                [char[]]($cArray.Where{ $displayNumbers[1] -contains $_ }).Count -eq 2 -And 
                [char[]]($cArray.Where{ $displayNumbers[4] -contains $_ }).Count -eq 4 -And
                [char[]]($cArray.Where{ $displayNumbers[7] -contains $_ }).Count -eq 3
            }[0]
        }
    }
    
    $displayOutputNumber = foreach ($number in $outputNumbers.Split(' ')) {
        $sortedOutput = ([char[]]$number | Sort-Object) -join ''
        foreach ($number in 0..9) {
            $sortedNumber = ($displayNumbers[$number] | Sort-Object) -join ''
            if ($sortedOutput -eq $sortedNumber) {
                [string]$number
                break
            }
        }
        
    }

    1 * ($displayOutputNumber -join '')
}

$total = 0
foreach ($number in $displayOutputNumbers) {
    $total += $number
}
$total