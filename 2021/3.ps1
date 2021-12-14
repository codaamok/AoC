# Chris Dent helped lots on the stream!

$diagReport = Get-Content $pwd\day3.txt

# Part 1

$a = $b = $c = $d = $e = $f = $g = $h = $i = $j = $k = $l = @()

foreach ($line in $diagReport) {
    switch (0..11) {
        0 { $a += $line[$_] }
        1 { $b += $line[$_] }
        2 { $c += $line[$_] }
        3 { $d += $line[$_] }
        4 { $e += $line[$_] }
        5 { $f += $line[$_] }
        6 { $g += $line[$_] }
        7 { $h += $line[$_] }
        8 { $i += $line[$_] }
        9 { $j += $line[$_] }
        10 { $k += $line[$_] }
        11 { $l += $line[$_] }
    }
}

$gamma = $epsilon = '0b'

foreach ($array in $a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l) {
    $gamma += $array | Group-Object | 
        Sort-Object -Property count -Descending | 
        Select-Object -First 1 -ExpandProperty Name
    $epsilon += $array | Group-Object | 
        Sort-Object -Property count | 
        Select-Object -First 1 -ExpandProperty Name
}

1 * $gamma * $epsilon

# Part 2

$oxygen = $co2 = '0b'
# true is the bit criteria for oxygen, false is the bit criteria for co2
foreach ($bool in $true,$false) {
    $diagReport = Get-Content $pwd\day3.txt
    # Determine oxygen generator rating
    for ($i = 0; $i -lt 12; $i++) {
        # Get all bits in the current position
        $col = foreach ($line in $diagReport) {
            $line[$i]
        } 

        # All of the bits, grouped and sorted by count
        $bits = $col | Group-Object |
            Sort-Object -Property Count -Descending:$bool

        # The definition of 'common' and 'uncommon' here is inverted when $bool is false,
        # because the sort is inverted
        $commonBits = $bits[0]
        $uncommonBits = $bits[1]

        if ($commonBits.Count -eq $uncommonBits.Count) {
            switch ($bool) {
                $true  { $commonBit = "1" }
                $false { $commonBit = "0" }
            }
        }
        else {
            $commonBit = $commonBits.Name
        }

        # Get all numbers that contain the most common bit in the current position
        [string[]]$diagReport = foreach ($line in $diagReport) {
            if ($line[$i] -eq $commonBit) {
                $line
            }
        }

        if ($diagReport.Count -eq 1) {
            switch ($bool) {
                $true  { $oxygen += $diagReport[0] }
                $false { $co2    += $diagReport[0] }
            }
            break
        }
    }
}

1 * $oxygen * $co2
