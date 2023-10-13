extends VBoxContainer

const settings_menu = preload("settings_menu.tscn")
const about_menu = preload("about_menu.tscn")

const NumberField = preload("res://src/small_editors/number_field.tscn")

@onready var zoom_reset_button: Button = %ZoomReset
@onready var viewport: SubViewport = $ViewportContainer/Viewport
@onready var controls: TextureRect = %Checkerboard/Controls
@onready var grid_visuals: Control = $ViewportContainer/Viewport/SnapLines
@onready var grid_button: Button = %LeftMenu/Snapping
@onready var grid_popup: Popup = %LeftMenu/GridPopup
@onready var more_button: Button = %LeftMenu/MoreOptions
@onready var more_popup: Popup = %LeftMenu/MorePopup

func update_zoom_label(zoom_level: float) -> void:
	await get_tree().process_frame
	zoom_reset_button.text = String.num(zoom_level * 100,
			2 if zoom_level < 0.1 else 1 if zoom_level < 10.0 else 0) + "%"


func _on_settings_pressed() -> void:
	more_popup.hide()
	var settings_menu_instance := settings_menu.instantiate()
	get_tree().get_root().add_child(settings_menu_instance)

func _on_snap_button_pressed() -> void:
	var show_grid_button := CheckBox.new()
	show_grid_button.text = tr(&"#show_grid")
	show_grid_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	show_grid_button.button_pressed = grid_visuals.visible
	show_grid_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	show_grid_button.pressed.connect(toggle_grid_visuals)
	
	var show_handles_button := CheckBox.new()
	show_handles_button.text = tr(&"#show_handles")
	show_handles_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	show_handles_button.button_pressed = controls.visible
	show_handles_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	show_handles_button.pressed.connect(toggle_handles_visuals)
	
	grid_popup.set_btn_array([show_grid_button, show_handles_button] as Array[Button])
	grid_popup.popup(Utils.calculate_popup_rect(
			grid_button.global_position, grid_button.size, grid_popup.size, true))

func _on_more_options_pressed() -> void:
	var open_repo_button := Button.new()
	open_repo_button.text = tr(&"#repo_button_text")
	open_repo_button.icon = load("res://visual/icons/Link.svg")
	open_repo_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	open_repo_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	open_repo_button.pressed.connect(open_godsvg_repo)
	
	var about_button := Button.new()
	about_button.text = "About"
	about_button.icon = load("res://visual/icon.png")
	about_button.expand_icon = true
	about_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	about_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	about_button.pressed.connect(open_about)
	
	more_popup.set_btn_array([open_repo_button, about_button] as Array[Button])
	more_popup.popup(Utils.calculate_popup_rect(
			more_button.global_position, more_button.size, more_popup.size, true))

func open_godsvg_repo() -> void:
	more_popup.hide()
	OS.shell_open("https://github.com/MewPurPur/GodSVG")

func open_about() -> void:
	more_popup.hide()
	var about_menu_instance := about_menu.instantiate()
	get_tree().get_root().add_child(about_menu_instance)

func toggle_grid_visuals() -> void:
	grid_visuals.visible = not grid_visuals.visible

func toggle_handles_visuals() -> void:
	controls.visible = not controls.visible