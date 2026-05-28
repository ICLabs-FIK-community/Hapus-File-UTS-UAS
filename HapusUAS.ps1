Get-ChildItem -Path "D:\" -Recurse -File -ErrorAction SilentlyContinue | 
Where-Object {
    $_.Name -match "(?i)uas|ujian akhir semester"
} |
Remove-Item -Force
