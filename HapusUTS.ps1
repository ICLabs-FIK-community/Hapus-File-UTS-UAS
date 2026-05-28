Get-ChildItem -Path "D:\" -Recurse -File -ErrorAction SilentlyContinue | 
Where-Object {
    $_.Name -match "(?i)uts|ujian tengah semester"
} |
Remove-Item -Force