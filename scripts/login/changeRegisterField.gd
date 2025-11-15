extends Control

@onready var selector = $Selector
@onready var nama = $LineTextList/Nama
@onready var namaInput = $LineTextList/NamaInput
@onready var nisn = $LineTextList/Nisn
@onready var nisnInput = $LineTextList/NisnInput
@onready var kataSandi = $LineTextList/KataSandi
@onready var kataSandiInput = $LineTextList/KataSandiInput
@onready var daftar = $LineTextList/Daftar


func _ready():
    namaInput.grab_focus()
    
    _on_nama_input_focus_entered()

func _on_nama_input_focus_entered():
    _move_selector_to(nama)

func _on_nisn_input_focus_entered():
    _move_selector_to(nisn)

func _on_kataSandi_input_focus_entered():
    _move_selector_to(kataSandi)

func _on_daftar_button_focus_entered():
    _move_selector_to(daftar)

func _move_selector_to(button_node):
    var target_y = button_node.global_position.y
    
    var center_y = target_y + (button_node.size.y / 2)
    selector.global_position.y = center_y - (selector.size.y / 2)
    


# == FUNGSI DARI SINYAL ==
# Ini fungsi yang kepanggil pas tombol 'DAFTAR' abang dipencet
# Pastiin sinyal 'pressed()' dari tombolnya udah nyambung ke sini
func _on_daftar_button_pressed():
    
    # 1. Ambil semua teks dari inputan
    var tampungNama = namaInput.text
    var tampungNisn = nisnInput.text
    var tampungKataSandi = kataSandiInput.text
    
    # 2. Validasi (Cek biar gak kosong)
    if tampungNama.is_empty() or tampungNisn.is_empty() or tampungKataSandi.is_empty():
        print("ERROR: Data gak boleh kosong!")
        # Nanti di sini abang bisa nampilin Label error
        return # Stop, jangan lanjut
        
    # 3. Bikin path file pake NISN
    # Ini kuncinya: "user://akun_123.cfg", "user://akun_456.cfg", dst.
    var file_path = "user://akun_" + tampungNisn + ".cfg"
    
    # 4. CEK PENTING: NISN udah kedaftar belom?
    if FileAccess.file_exists(file_path):
        print("ERROR: NISN " + tampungNisn + " sudah terdaftar!")
        # Tampilkan label error "NISN sudah dipakai"
        return # Stop, jangan ditimpa

    # 5. Kalo aman, baru kita HASH password-nya
    var password_hash = tampungKataSandi.md5_text()
    
    # 6. Bikin objek ConfigFile
    var config = ConfigFile.new()
    
    # 7. Masukin datanya ke section [user]
    config.set_value("user", "nama", tampungNama)
    config.set_value("user", "nisn", tampungNisn)
    config.set_value("user", "password_hash", password_hash) # Simpen HASH-nya
    
    # 8. Simpen filenya
    var error = config.save(file_path)
    
    # 9. Kasih feedback
    if error != OK:
        print("GAWAT: Gagal nyimpen data ke " + file_path)
    else:
        print("SUKSES! Murid '" + tampungNama + "' (NISN: " + tampungNisn + ") berhasil didaftarkan.")
        
        # (Opsional) Kalo sukses, pindah ke scene Login
        get_tree().change_scene_to_file("res://scenes/MainMenu/login_screen.tscn")
        
