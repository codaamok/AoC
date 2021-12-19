$data = Get-Content $pwd\14.txt

$template = $data[0]
$insertionRules = @{}
$data[2..$data.length] | ForEach-Object {
    $key, $value = $_.Split(' -> ')
    $insertionRules[$key] = $value
}

$Common = 1..10 | ForEach-Object {
    $newElements = for ($i = 0; $i -lt $template.Length-1; $i++) {
        $pair = $template.Substring($i, 2)
        $insertionRules[$pair]
    }
    $newTemplate = for ($i = 0; $i -lt $template.Length; $i++) {
        $template[$i]
        $newElements[$i]
    }
    $template = $newTemplate -join ''
    if ($_ -eq 10) {
        [char[]]$template
    }
} | Group-Object | Sort-Object -Property Count -Descending

$Common[0].Count - $Common[-1].Count
