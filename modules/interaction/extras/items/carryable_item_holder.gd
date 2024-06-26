@tool

extends Node3D
class_name CarryableItemHolder

signal item_carried(item: Node3D)
signal item_dropped

@export var can_drop: bool = true
@export var drop_interaction: Interaction
@export var drop_delay: float = 0.1

@export_group("Animation")
@export var animate_position: bool = true:
    set(value):
        animate_position = value
        notify_property_list_changed()

@export var animate_rotation: bool = true:
    set(value):
        animate_rotation = value
        notify_property_list_changed()

var rotation_lerp_speed: float = 2.0
var position_lerp_speed: float = 2.0
var item: Node3D

func _process(delta: float) -> void:
    await get_tree().process_frame
    _update_transform(delta)

func _update_transform(delta: float) -> void:
    if !item:
        return
    if animate_position:
        item.position = item.position.slerp(global_position, delta * 10 * position_lerp_speed)
    else:
        item.global_position = global_position
    if animate_rotation:
        item.rotation.y = lerp_angle(item.rotation.y, global_rotation.y, delta * 10 * rotation_lerp_speed)
        item.rotation.x = lerp_angle(item.rotation.x, global_rotation.x, delta * 10 * rotation_lerp_speed)
        item.rotation.z = lerp_angle(item.rotation.z, global_rotation.z, delta * 10 * rotation_lerp_speed)
    else:
        item.global_rotation = global_rotation

func carry(interactor: Interactor, _item: Node3D) -> void:
    item = _item
    item.top_level = true
    interactor.is_raycasting = false
    item_carried.emit(item)
    var grab_method := Callable(item, "on_grab")
    if grab_method.is_valid():
        grab_method.call(interactor)
    if can_drop:
        await get_tree().create_timer(drop_delay).timeout
        interactor.push(drop_interaction)

func drop(interactor: Interactor) -> void:
    interactor.pop(drop_interaction)
    var drop_method := Callable(item, "on_drop")
    if drop_method.is_valid():
        drop_method.call(interactor)
    item_dropped.emit()
    interactor.is_raycasting = true
    item.top_level = false
    item = null

#region Editor

func _get_property_list() -> Array[Dictionary]:
    var position_lerp_speed_usage: int = PROPERTY_USAGE_NO_EDITOR
    var rotation_lerp_speed_usage: int = PROPERTY_USAGE_NO_EDITOR
    if animate_position:
        position_lerp_speed_usage = PROPERTY_USAGE_DEFAULT
    if animate_rotation:
        rotation_lerp_speed_usage = PROPERTY_USAGE_DEFAULT
    var properties: Array[Dictionary] = [{
            "name": "position_lerp_speed",
            "type": TYPE_FLOAT,
            "usage": position_lerp_speed_usage,
        }, {
            "name": "rotation_lerp_speed",
            "type": TYPE_FLOAT,
            "usage": rotation_lerp_speed_usage,
        }
    ]
    return properties

#endregion Editor