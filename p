import bpy
import math

# Clear existing scene
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# Set up scene units and render settings
bpy.context.scene.unit_settings.system = 'METRIC'
bpy.context.scene.render.engine = 'CYCLES'  # For better materials
bpy.context.scene.cycles.samples = 128  # Adjust for quality vs. speed

# Create materials
def create_material(name, color, metallic=0.0, roughness=0.5):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs['Base Color'].default_value = color
    bsdf.inputs['Metallic'].default_value = metallic
    bsdf.inputs['Roughness'].default_value = roughness
    return mat

purple_wall_mat = create_material("PurpleWall", (0.3, 0.1, 0.5, 1))
purple_floor_mat = create_material("PurpleFloor", (0.4, 0.2, 0.6, 1))
gold_mat = create_material("Gold", (0.8, 0.6, 0.2, 1), metallic=1.0, roughness=0.1)
glass_mat = create_material("Glass", (0.9, 0.9, 1.0, 0.1), roughness=0.0)  # Transparent
glass_mat.node_tree.nodes["Principled BSDF"].inputs['Transmission'].default_value = 1.0

# Create room (walls and floor)
bpy.ops.mesh.primitive_cube_add(size=10, location=(0, 0, 5))  # Room cube
room = bpy.context.active_object
room.name = "Room"
room.scale = (1, 1, 0.5)  # Flatten to room shape
room.data.materials.append(purple_wall_mat)

# Floor
bpy.ops.mesh.primitive_plane_add(size=10, location=(0, 0, 0))
floor = bpy.context.active_object
floor.name = "Floor"
floor.data.materials.append(purple_floor_mat)

# Shelves (along walls)
for i in range(3):
    bpy.ops.mesh.primitive_cube_add(size=8, location=(0, 4.5, 2 + i*1.5))
    shelf = bpy.context.active_object
    shelf.name = f"Shelf_{i}"
    shelf.scale = (1, 0.1, 0.1)
    shelf.data.materials.append(gold_mat)

# Perfume bottles (cylinders on shelves)
for i in range(10):
    bpy.ops.mesh.primitive_cylinder_add(radius=0.1, depth=0.5, location=(i*0.8 - 4, 4.5, 2 + (i%3)*1.5))
    bottle = bpy.context.active_object
    bottle.name = f"Bottle_{i}"
    bottle.data.materials.append(glass_mat)
    # Add liquid inside (smaller cylinder)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.08, depth=0.4, location=bottle.location)
    liquid = bpy.context.active_object
    liquid.name = f"Liquid_{i}"
    liquid.data.materials.append(create_material(f"PurpleLiquid_{i}", (0.5, 0.2, 0.7, 1)))
    liquid.parent = bottle

# Decor: Orchids (simple spheres)
for i in range(5):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.2, location=(i*1.5 - 3, -3, 1))
    orchid = bpy.context.active_object
    orchid.name = f"Orchid_{i}"
    orchid.data.materials.append(create_material("Orchid", (0.6, 0.3, 0.8, 1)))

# Lighting: Chandelier (point light) and ambient
bpy.ops.object.light_add(type='POINT', location=(0, 0, 8))
light = bpy.context.active_object
light.data.energy = 1000
light.data.color = (0.5, 0.3, 0.7)  # Purple tint

# Camera setup
bpy.ops.object.camera_add(location=(5, -5, 3), rotation=(math.radians(60), 0, math.radians(45)))
camera = bpy.context.active_object
bpy.context.scene.camera = camera

# Basic animation: Rotate bottles slowly
for obj in bpy.data.objects:
    if "Bottle" in obj.name:
        obj.animation_data_create()
        obj.keyframe_insert(data_path="rotation_euler", frame=1)
        obj.rotation_euler.z += math.radians(360)
        obj.keyframe_insert(data_path="rotation_euler", frame=120)  # 2-second loop at 60fps

# Set timeline for animation
bpy.context.scene.frame_start = 1
bpy.context.scene.frame_end = 120

print("Scene created! Render or animate as needed.")
