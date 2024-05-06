extends Node3D
class_name WieldableItemHolder

@export_group("Animation")
@export var animate_position: bool = true
@export var animate_rotation: bool = true
@export var rotation_lerp_speed: float = 2.0
@export var position_lerp_speed: float = 2.0

var item: Node3D

func _ready() -> void:
    Global.player.item_wield.connect(wield)
    Global.player.item_unwield.connect(unwield)

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

func wield(inventory_item: InventoryItem) -> void:
    if item:
        unwield()
    item = _create_item(inventory_item)
    assert(item, "[Inventory] Item '%s' not found in item atlas" % inventory_item.model.id)
    add_child(item)
    item.top_level = true
    var wield_method := Callable(item, "on_wield")
    if wield_method.is_valid():
        wield_method.call(Global.player.interactor)

func unwield() -> void:
    if !item:
        return
    var unwield_method := Callable(item, "on_unwield")
    if unwield_method.is_valid():
        unwield_method.call(Global.player.get_interactor())
    item.queue_free()
    item = null

func _create_item(inventory_item: InventoryItem) -> Node3D:
    var scene: PackedScene = InventoryAtlas.get_packed_scene(inventory_item.model)
    return scene.instantiate() if scene else null