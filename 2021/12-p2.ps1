function Get-CavePath {
    param(
        [System.Collections.Generic.List[String]]$Path,
        [String]$CaveNode,
        [hashtable]$CaveNodes    
    )

    foreach ($cave in $CaveNodes[$CaveNode].Where{$_ -ne "start"}) {

        if ($cave -eq "end") {
            $Path += "end"
            $Script:AllPaths += ($Path -join ',')
            $Path.RemoveAt($Path.Count-1)
            continue
        }
        elseif (($cave -cmatch '[a-z]')) {

            $smallCaves = $Path | 
                Where-Object { 
                    $_ -cmatch '[a-z]' -And $_ -notmatch 'start|end' 
                } | 
                Group-Object -AsHashTable

            if ($smallCaves) {
                $duoCave = $false
                foreach ($key in $smallCaves.Keys) {
                    if ($smallCaves[$key].Count -eq 2) {
                        $duoCave = $true
                    }
                }

                if ($smallCaves[$cave].Count -eq 2) {
                    continue
                }
                elseif ($smallCaves[$cave].Count -eq 1) {
                    if (-not $duoCave) {
                        $Path += $cave
                        if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                            $Path.RemoveAt($Path.Count-1)
                        }
                    }
                }
                else {
                    $Path += $cave
                    if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                        $Path.RemoveAt($Path.Count-1)
                    }
                }
            }
            else {
                $Path += $cave
                if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                    $Path.RemoveAt($Path.Count-1)
                }
            }
        }
        elseif ($cave -eq $Path[-1]) {
            # The last cave is the same as the current cave, therefore skip
            continue
        }
        else {
            # Append to existing path
            $Path += $cave
            if (-not (Get-CavePath -Path $Path -CaveNode $cave -CaveNodes $CaveNodes)) {
                $Path.RemoveAt($Path.Count-1)
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

[System.Collections.Generic.List[String]]$AllPaths = @()
foreach ($startingNode in $caveNodes["start"]) {
    [System.Collections.Generic.List[String]]$Path = "start", $startingNode
    Get-CavePath -Path $Path -CaveNodes $caveNodes -CaveNode $startingNode
}

$AllPaths.count
