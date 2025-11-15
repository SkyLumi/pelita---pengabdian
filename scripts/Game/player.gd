extends CharacterBody2D

# == SESUAIIN INI ==
# Ukur 1 kotak di map abang itu berapa pixel (misal 64x64)
const TILE_SIZE = 80
const MOVE_SPEED = 0.2 # Kecepatan geser 1 kotak (makin kecil makin cepet)

# "Kunci" biar gak bisa gerak pas lagi gerak
var is_moving = false

# Ambil "tongkat" RayCast-nya
@onready var raycast = $RayCast2D


func _process(_delta):
    # Kalo lagi gerak, stop, jangan cek input
    if is_moving:
        return

    # Cek input (cuma sekali pencet)
    if Input.is_action_just_pressed("ui_right"):
        attempt_move(Vector2.RIGHT)
        
    elif Input.is_action_just_pressed("ui_left"):
        attempt_move(Vector2.LEFT)
        
    elif Input.is_action_just_pressed("ui_up"):
        attempt_move(Vector2.UP)
        
    elif Input.is_action_just_pressed("ui_down"):
        attempt_move(Vector2.DOWN)


# Fungsi baru: Coba gerak, cek tembok dulu
func attempt_move(direction: Vector2):
    
    # 1. Arahin "tongkat" RayCast ke arah kita mau jalan
    # Pindahin targetnya sejauh 1 kotak (TILE_SIZE)
    raycast.target_position = direction * TILE_SIZE
    
    # 2. Paksa RayCast buat ngecek sekarang juga
    raycast.force_raycast_update()
    
    # 3. Cek hasilnya: APAKAH NABRAK?
    if raycast.is_colliding():
        print("NABRAK TEMBOK! Gak jadi gerak.")
        return # Stop, gak usah lanjut ke Tween

    # --- Kalo GAK NABRAK (aman, jalan raya) ---
    
    # 4. Kunci inputnya
    is_moving = true
    
    # 5. Tentukan mau pindah ke mana
    var target_position = global_position + (direction * TILE_SIZE)
    
    # 6. Bikin animasi pindahnya (Tween)
    var tween = get_tree().create_tween()
    tween.tween_property(self, "global_position", target_position, MOVE_SPEED)
    
    # 7. Tunggu animasinya selesai
    await tween.finished
    
    # 8. Buka lagi kuncinya, siap nerima input baru
    is_moving = false
