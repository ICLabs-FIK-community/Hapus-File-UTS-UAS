# 🗑️ Panduan Pembersihan Berkas Ujian (UTS & UAS) Rekursif Otomatis

Panduan ini menjelaskan penggunaan dua skrip pembersihan otomatis untuk komputer Laboratorium (LAB): **`HapusUTS.ps1`** dan **`HapusUAS.ps1`**. Kedua skrip ini dirancang untuk memindai seluruh penyimpanan di drive **`D:\`** secara rekursif dan menghapus berkas-berkas ujian mahasiswa secara instan.

Sangat berguna bagi Administrator LAB untuk menyegarkan kondisi PC laboratorium setelah sesi ujian tengah semester (UTS) maupun ujian akhir semester (UAS) berakhir.

---

## ⚠️ PERINGATAN KEAMANAN PENTING!

> [!CAUTION]
> **TINDAKAN INI BERSIFAT DESTRUKTIF & PERMANEN!**
> Kedua skrip ini menggunakan perintah `Remove-Item -Force` yang akan menghapus semua file yang cocok secara langsung tanpa memindahkannya ke Recycle Bin dan **tanpa konfirmasi** (*prompt*). Pastikan seluruh data ujian penting milik mahasiswa sudah disalin atau diunggah ke server utama sebelum menjalankan skrip pembersihan!

---

## 🔍 Logika Pencarian & Cara Kerja

Masing-masing skrip bekerja dengan mencocokkan nama berkas menggunakan ekspresi reguler (*Regular Expression* / Regex) secara case-insensitive (tidak sensitif huruf besar/kecil) pada drive `D:\`:

| Nama Skrip | Sasaran Pembersihan | Pola Kata Kunci (Regex) | Jalur Pemindaian |
| :--- | :--- | :--- | :--- |
| **`HapusUTS.ps1`** | Ujian Tengah Semester | `(?i)uts` atau `ujian tengah semester` | `D:\` (Rekursif) |
| **`HapusUAS.ps1`** | Ujian Akhir Semester | `(?i)uas` atau `ujian akhir semester` | `D:\` (Rekursif) |

---

## 🚀 Cara Penggunaan

Kedua skrip dapat dijalankan menggunakan metode terpusat via **NetSupport** atau secara **Manual** langsung pada PC client.

### 🖥️ Metode 1: Menggunakan NetSupport (Quick Access)
Metode tercepat bagi **Administrator LAB** untuk menghapus berkas ujian secara massal pada seluruh PC praktikan secara serentak dari PC Server Guru/Dosen.

1. Buka **NetSupport School Console** di komputer server.
2. Pilih seluruh komputer client target yang ingin dibersihkan.
3. Buka fitur **Quick Launch / Quick Access**.
4. Masukkan perintah berikut di kolom perintah (sesuai jenis ujian yang ingin dihapus):

   * **Untuk Menghapus UTS:**
     ```cmd
     "PowerShell.exe" -ExecutionPolicy Bypass -File "C:\Users\LAB CV-00\Documents\HapusUTS.ps1"
     ```
   * **Untuk Menghapus UAS:**
     ```cmd
     "PowerShell.exe" -ExecutionPolicy Bypass -File "C:\Users\LAB CV-00\Documents\HapusUAS.ps1"
     ```
5. Klik **Execute** atau **Jalankan**.

> [!IMPORTANT]
> Pastikan berkas skrip terkait (`HapusUTS.ps1` atau `HapusUAS.ps1`) sudah disalin terlebih dahulu ke folder `C:\Users\LAB CV-00\Documents\` di setiap PC client sebelum perintah dijalankan.

---

### 💻 Metode 2: Secara Manual (Langsung pada PC Client)

#### **Cara A: Klik Kanan (Instan)**
1. Temukan berkas skrip (`HapusUTS.ps1` atau `HapusUAS.ps1`) di folder client (misalnya di folder `C:\Users\LAB CV-00\Documents\`).
2. Klik kanan pada berkas skrip tersebut.
3. Pilih opsi **"Run with PowerShell"**.
4. Klik **Yes** jika muncul jendela konfirmasi sistem.

#### **Cara B: Melalui PowerShell Administrator**
1. Cari **PowerShell** di menu Start, klik kanan dan pilih **Run as Administrator**.
2. Masukkan perintah berikut untuk mengaktifkan izin eksekusi skrip:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Jalankan skrip dengan memanggil jalur lengkapnya:
   * **Eksekusi UTS:**
     ```powershell
     & "C:\Users\LAB CV-00\Documents\HapusUTS.ps1"
     ```
   * **Eksekusi UAS:**
     ```powershell
     & "C:\Users\LAB CV-00\Documents\HapusUAS.ps1"
     ```

---

## ⚙️ Panduan Kustomisasi Skrip (Opsional)

Anda dapat mengedit isi skrip menggunakan Notepad atau VS Code untuk mengubah perilaku pembersihan:

### 1. Mengubah Jalur Pemindaian
Secara default, skrip memindai seluruh drive `D:\`. Jika ingin mengarahkan ke drive lain (seperti drive `E:\` atau folder tertentu), ubah parameter `-Path "D:\"` pada baris ke-1 skrip:
```powershell
# Contoh mengarahkan pembersihan ke drive E:\
Get-ChildItem -Path "E:\" -Recurse -File -ErrorAction SilentlyContinue |
```

### 2. Menambah Kata Kunci Penyaringan
Jika ingin mendeteksi kata kunci lain (misalnya `"tugas"`, `"praktikum"`, atau `"kuis"`), Anda dapat menambahkan kata kunci tersebut di baris pencocokan regex menggunakan pemisah tanda pipa (`|`):
```powershell
# Contoh mendeteksi UTS, UAS, dan Tugas sekaligus
$_.Name -match "(?i)uts|ujian tengah semester|uas|ujian akhir semester|tugas"
```
