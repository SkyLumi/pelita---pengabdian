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
	


func _on_daftar_button_pressed() -> void:
	print("Tombol DAFTAR dipencet!")
	var tampungNama = namaInput.text
	var tampungNisn = nisnInput.text
	var tampungKataSandi = kataSandiInput.text
	
	# 2. Validasi simpel (biar gak kosong)
	if tampungNama.is_empty() or tampungNisn.is_empty() or tampungKataSandi.is_empty():
		print("Data gak boleh kosong!")
		# Nanti di sini bisa nampilin label error, dll.
		return # Stop, jangan lanjut nyimpen
		
	# 3. HASH PASSWORD-NYA (WAJIB!)
	var password_hash = tampungKataSandi.md5_text()
	
	# 4. Bikin objek ConfigFile
	var config = ConfigFile.new()
	
	# 5. Masukin datanya
	config.set_value("user", "nama", tampungNama)
	config.set_value("user", "nisn", tampungNisn)
	config.set_value("user", "password_hash", password_hash) # Simpen HASH-nya
	
	# 6. Simpen ke file lokal
	var file_path = "user://data_akun.cfg"
	var error = config.save(file_path)
	
	# 7. Kasih tau hasilnya
	if error != OK:
		print("ERROR: Gagal nyimpen data akun ke " + file_path)
	else:
		print("SUKSES! Data akun " + tampungNama + " berhasil disimpan.")
		
