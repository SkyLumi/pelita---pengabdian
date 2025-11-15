# Script ini nempel di node utama halaman Login abang (misal: 'SceneLogin')
extends Control

# == KONEKSI KE NODE ==
# Ganti path-nya sesuai struktur node di scene Login abang
@onready var nisnInput = $LoginContainer/NisnInput
@onready var passwordInput = $LoginContainer/KataSandiInput

# (OPSIONAL TAPI BAGUS) Bikin node Label buat nampilin error
@onready var errorLabel = $ErrorLabel


func _ready():
    # (Opsional) Sembunyiin label error pas baru mulai
    if errorLabel:
        errorLabel.hide()
    
    # (Opsional) Bikin fokus langsung ke field NISN
    nisnInput.grab_focus()


# == FUNGSI DARI SINYAL ==
# Sambungin sinyal 'pressed()' dari tombol 'MASUK' abang ke sini
func _on_masuk_button_pressed():

    # (Opsional) Sembunyiin error tiap kali tombol dipencet
    if errorLabel:
        errorLabel.hide()

    # 1. Ambil inputan dari user
    var nisn_login = nisnInput.text
    var password_login = passwordInput.text
    
    # 2. Validasi (Cek biar gak kosong)
    if nisn_login.is_empty() or password_login.is_empty():
        print("Login Gagal: Field tidak boleh kosong")
        _tampilkan_error("NISN dan Password tidak boleh kosong!")
        return

    # 3. Bikin path file-nya
    var file_path = "user://akun_" + nisn_login + ".cfg"
    
    # 4. CEK FILENYA ADA APA NGGAK
    if not FileAccess.file_exists(file_path):
        print("Login Gagal: NISN " + nisn_login + " tidak ditemukan.")
        _tampilkan_error("NISN tidak terdaftar.")
        return

    # 5. Kalo ada, load filenya
    var config = ConfigFile.new()
    var error = config.load(file_path)
    
    # Cek kalo ada error pas ngebaca file
    if error != OK:
        print("GAWAT: Gagal ngebaca file " + file_path)
        _tampilkan_error("Terjadi error. Hubungi admin.")
        return
        
    # 6. Ambil data dari file
    var nama_tersimpan = config.get_value("user", "nama", "Murid")
    var hash_tersimpan = config.get_value("user", "password_hash", "")
    
    # 7. Hash password yang BARU diinput user
    var hash_input_baru = password_login.md5_text()
    
    # 8. BANDINGIN HASH-NYA (Ini bagian paling penting)
    if hash_input_baru == hash_tersimpan:
        
        # == LOGIN BERHASIL ==
        print("Login BERHASIL! Selamat datang, " + nama_tersimpan)
        
        # Di sini abang bisa nyimpen data murid ke 'global singleton'
        # biar semua scene tau siapa yang lagi main.
        # Global.murid_aktif = { "nisn": nisn_login, "nama": nama_tersimpan }
        
        # Pindah scene ke game utama
        # get_tree().change_scene_to_file("res://scene_game_utama.tscn")
        
    else:
        # == LOGIN GAGAL ==
        print("Login Gagal: Password salah.")
        _tampilkan_error("Password salah.")


# (OPSIONAL) Fungsi bantu nampilin error
func _tampilkan_error(pesan_error: String):
    if errorLabel:
        errorLabel.text = pesan_error
        errorLabel.show()
