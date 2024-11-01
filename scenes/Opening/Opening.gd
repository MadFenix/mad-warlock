extends "res://addons/maaacks_game_template/extras/scenes/Opening/Opening.gd"

@export var videos : Array[VideoStreamTheora]

func _add_textures_to_container(textures : Array[Texture2D]):
	for texture in textures:
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = texture
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.visible = false
		%ImagesContainer.call_deferred("add_child", texture_rect)
	for video in videos:
		var video_stream : VideoStreamPlayer = VideoStreamPlayer.new()
		video_stream.stream = video
		video_stream.visible = false
		video_stream.autoplay = true
		video_stream.loop = true
		%ImagesContainer.call_deferred("add_child", video_stream)

func _animate_images():
	for texture_rect in %ImagesContainer.get_children():
		texture_rect.show()
		%AnimationPlayer.play("FadeInOut")
		await(%AnimationPlayer.animation_finished)
		texture_rect.hide()
	_finished_animating()
