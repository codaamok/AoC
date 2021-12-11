# Part 1

# Everything within a chunk must resolve
# If chunk length is zero, every encapsulating bracket in the same direction must resolve
# e.g. [([])) is corruption
# e.g. ({<>}< is *not* corruption

# ^ not sure if that's true... what if I find all single chunks, and work outwards?

$navigationSubsystem = Get-Content .\aoc-day10.txt
$incompleteLines = @()
$corruptLines = @()

$pairs = @{
    "{" = "}"
    "[" = "]"
    "<" = ">"
    "(" = ")"
}

foreach ($line in $navigationSubsystem) {
    for ($i = 0; $i -lt $line.length; $i++) {
        for ($y = $i+1; $y -lt $line.length; $y++) {
            $ignore = 0
            switch ($line[$y]) {
                $line[$i] { 
                    $ignore++ 
                }
                $pairs[$chair] { 
                    # deduce corruption
                }
                default {

                }
            }
        }
    }
    
    switch -Regex([char[]]$line) {
        "\[|\{|<|\(" {
            $symbols[$_] += 1
        }
        "\]|\}|>|\)" {
            $symbols[$_] -= 1
        }
    }

    foreach ($key in $symbols.Keys) {
        if ($symbols[$key] -ne 0) {
            $incompleteLines += $line
        }
        else {
            $corruptLines += $line
        }
    }
}
