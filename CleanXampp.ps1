# -------------------------
# PowerShell Script - Reset XAMPP with Backup Restore
# -------------------------

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 1. Tentukan lokasi XAMPP
$xamppPath = "C:\xampp"
$htdocsPath = Join-Path $xamppPath "htdocs"
$mysqlDataPath = Join-Path $xamppPath "mysql\data"
$mysqlBackupPath = Join-Path $xamppPath "mysql\backup"
$phpmyadminConfig = Join-Path $xamppPath "phpMyAdmin\config.inc.php"

Write-Host "🚧 Memulai proses reset XAMPP..." -ForegroundColor Cyan

# 2. Hentikan proses XAMPP, Apache, dan MySQL
Write-Host "🔧 Menutup proses XAMPP..." -ForegroundColor Cyan
$services = @("xampp-control", "httpd", "mysqld")

foreach ($service in $services) {
    $proc = Get-Process -Name $service -ErrorAction SilentlyContinue
    if ($proc) {
        Stop-Process -Name $service -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Proses '$service' berhasil dihentikan." -ForegroundColor Yellow
    } else {
        Write-Host "ℹ️ Proses '$service' tidak ditemukan atau sudah mati." -ForegroundColor Gray
    }
}

Start-Sleep -Seconds 2

# 3. Hapus database MySQL
Write-Host "`n🗑️ Menghapus database MySQL..." -ForegroundColor Yellow
if (Test-Path $mysqlDataPath) {
    $items = Get-ChildItem "$mysqlDataPath\*"
    if ($items.Count -gt 0) {
        Remove-Item -Recurse -Force "$mysqlDataPath\*" -ErrorAction SilentlyContinue
        Write-Host "✅ Semua isi folder mysql\data telah dihapus." -ForegroundColor Green
    } else {
        Write-Host "ℹ️ Folder mysql\data sudah kosong." -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Folder mysql\data tidak ditemukan!" -ForegroundColor Red
}

# 4. Hapus file project di htdocs
Write-Host "`n🗑️ Menghapus semua file di htdocs..." -ForegroundColor Yellow
if (Test-Path $htdocsPath) {
    $items = Get-ChildItem "$htdocsPath\*"
    if ($items.Count -gt 0) {
        Remove-Item -Recurse -Force "$htdocsPath\*" -ErrorAction SilentlyContinue
        Write-Host "✅ Semua isi folder htdocs telah dihapus." -ForegroundColor Green
    } else {
        Write-Host "ℹ️ Folder htdocs sudah kosong." -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Folder htdocs tidak ditemukan!" -ForegroundColor Red
}

# 6. Buat ulang folder mysql\data dan isi dari backup
Write-Host "`n📁 Membuat ulang mysql\data dan mengisi dari backup..." -ForegroundColor Cyan

if (-Not (Test-Path $mysqlDataPath)) {
    New-Item -ItemType Directory -Path $mysqlDataPath | Out-Null
    Write-Host "✅ Folder mysql\data berhasil dibuat ulang." -ForegroundColor Green
} else {
    Write-Host "ℹ️ Folder mysql\data sudah ada." -ForegroundColor Gray
}

# Copy isi dari mysql\backup ke mysql\data
if (Test-Path $mysqlBackupPath) {
    Write-Host "📦 Menyalin isi dari mysql\backup ke mysql\data..." -ForegroundColor Yellow
    Copy-Item -Path "$mysqlBackupPath\*" -Destination $mysqlDataPath -Recurse -Force
    Write-Host "✅ Isi backup berhasil disalin ke folder data." -ForegroundColor Green
} else {
    Write-Host "❌ Folder backup tidak ditemukan. Tidak ada yang disalin." -ForegroundColor Red
}

# 7. Buat ulang folder htdocs jika hilang
Write-Host "`n📁 Memastikan folder htdocs tersedia..." -ForegroundColor Cyan
if (-Not (Test-Path $htdocsPath)) {
    New-Item -ItemType Directory -Path $htdocsPath | Out-Null
    Write-Host "✅ Folder htdocs berhasil dibuat ulang." -ForegroundColor Green
} else {
    Write-Host "ℹ️ Folder htdocs sudah ada." -ForegroundColor Gray
}

# 8. Selesai
Write-Host "`n🎉 SEMUA SELESAI! XAMPP telah dikembalikan seperti baru dengan data default." -ForegroundColor Cyan
Write-Host "💡 Silakan buka kembali XAMPP dan jalankan MySQL untuk generate ulang struktur database internal." -ForegroundColor Green
