function Get-CavePath {
    param(
        [hashtable]$Path,
        [String]$CaveNode,
        [hashtable]$CaveNodes    
    )

    foreach ($cave in $CaveNodes[$CaveNode]) {
        # 'duo cave' is dumb name for a small cave already explored twice
        $duoCave = $false
        foreach ($key in $Path.Keys.Where{$_ -cmatch '[a-z]'}) {
            if ($key -cmatch '[a-z]' -And $Path[$key] -eq 2) {
                $duoCave = $true
            }
        }

        if ($cave -eq "end") {
            $Script:AllPaths++
            continue
        }
        elseif ($cave -eq "start") {
            continue
        }
        elseif ($cave -cmatch '[a-z]') {
            if ($Path[$cave] -eq 2) {
                continue
            }
            elseif ($Path[$cave] -eq 1) {
                if ($duoCave) {
                    continue
                }
                else {
                    $Path[$cave] += 1
                    $Path["lastCave"] = $cave
                    if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                        if ($Path[$cave] -le 1) {
                            $Path.Remove($cave)
                        }
                        else {
                            $Path[$cave] -= 1
                        }
                    }
                }
            }
            else {
                $Path[$cave] += 1
                $Path["lastCave"] = $cave
                if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                    if ($Path[$cave] -le 1) {
                        $Path.Remove($cave)
                    }
                    else {
                        $Path[$cave] -= 1
                    }
                }
            }

        }
        elseif ($cave -eq $Path["lastCave"]) {
            # The last cave is the same as the current cave, therefore skip
            continue
        }
        else {
            # Append to existing path
            $Path[$cave] += 1
            $Path["lastCave"] = $cave
            if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                if ($Path[$cave] -le 1) {
                    $Path.Remove($cave)
                }
                else {
                    $Path[$cave] -= 1
                }
            }
        }
    }
}

$caves = Get-Content -Path $pwd\12.txt
$caveNodes = @{}
foreach ($cave in $caves) {
    $a, $b = $cave -split '-'

    if (-not $caveNodes.ContainsKey($a)) {
        $caveNodes[$a] = @()
    }
    $caveNodes[$a] += $b

    if (-not $caveNodes.ContainsKey($b)) {
        $caveNodes[$b] = @()
    }
    $caveNodes[$b] += $a
}

$AllPaths = 0
foreach ($startingNode in $caveNodes["start"]) {
    $Path = @{
        "start" = 1
        $startingNode = 1
        lastCave = $startingNode
    }
    Get-CavePath -Path $Path -CaveNodes $caveNodes -CaveNode $startingNode
}
$AllPaths
