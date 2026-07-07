# 3D Horror Game

![Godot 4.5](https://img.shields.io/badge/Godot-4.5-478CBF?style=for-the-badge&logo=godot-engine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-Game%20Logic-355570?style=for-the-badge&logo=godot-engine&logoColor=white)
![Renderer](https://img.shields.io/badge/Renderer-OpenGL%20Compatibility-222222?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Desktop%20%7C%20Android-2E7D32?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In%20Development-B8860B?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-v0.1.1-1565C0?style=for-the-badge)

A first-person 3D horror exploration game built with **Godot Engine 4.5**. Explore an abandoned house, collect items, move through dark rooms, and survive a tense atmosphere inspired by slow-paced horror games like **Granny**.

The project focuses on first-person exploration, item interaction, mobile controls, atmospheric lighting, and an optimized Godot 3D scene setup.

[Watch The Development Playlist On YouTube](https://www.youtube.com/watch?v=WjgdnDVzd40&list=PLBFg2OWUD47PpNR7lZwW6VUz8uBKtPf6l&index=1)

---

## Highlights

- **First-person horror controller** with mouse look, slower horror-style movement, running, jumping, and camera bob.
- **Interaction system** for picking up items such as keys using a camera-based raycast.
- **Grid inventory UI** with item boxes, icons, empty slots, and a dark horror-style overlay.
- **Detailed abandoned house environment** with rooms, props, lights, and collision.
- **Atmospheric rendering** using fog, dark lighting, and a panoramic sky.
- **Mobile-ready input** using a virtual joystick addon.
- **Animated player character** using a Mixamo rig and animation player.
- **AZERTY/QWERTY-friendly controls** configured in Godot input actions.

---

## Screenshots

### Inventory System

<img width="1150" height="647" alt="image" src="https://github.com/user-attachments/assets/da38793e-60e5-48c4-9b64-8ccf358dac07" />

### Pickup System

<img width="1151" height="647" alt="image" src="https://github.com/user-attachments/assets/80ff801f-0212-4819-89a3-9d96d2d48334" />

### Lighting And Atmosphere

<img width="1146" height="643" alt="Capture d&#39;écran 2026-03-19 022927" src="https://github.com/user-attachments/assets/9259daf7-e984-4283-98a6-d6826f55c17b" />

### First-Person Exploration

<img width="1148" height="643" alt="Capture d&#39;écran 2026-02-17 141110" src="https://github.com/user-attachments/assets/8eef8db4-d4f7-4cb6-8e69-b25342ef0841" />

---

## Current Version

| Item | Version / Status |
|---|---|
| Project version | v0.1.1 |
| Project status | In development |
| Godot version | Godot Engine 4.5 |
| Language | GDScript |
| Renderer | OpenGL Compatibility |
| Main scene | `scenes/world.tscn` |
| Target platforms | Desktop, Android |

---

## Versioning

Versions use `major.minor.patch`, for example `v0.1.0`.

- Use `patch` for bug fixes: `v0.1.0` to `v0.1.1`.
- Use `minor` for new features: `v0.1.1` to `v0.2.0`.
- Use `major` for big stable releases: `v0.9.0` to `v1.0.0`.

To bump the version on GitHub, run the **Bump Version** workflow from the repository's **Actions** tab and choose `patch`, `minor`, or `major`. The workflow updates `project.godot`, updates this README, commits the change, and creates a matching Git tag.

---

## Built With

| Technology | Purpose |
|---|---|
| [Godot Engine 4.5](https://godotengine.org/) | Game engine |
| GDScript | Gameplay scripting |
| OpenGL Compatibility Renderer | Desktop and mobile rendering support |
| [Virtual Joystick Godot Addon](https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot) | Touchscreen movement controls |
| Mixamo | Player character rig and animations |

---

## Gameplay Systems

### Player Controller

The player uses a first-person `CharacterBody3D` controller with:

- Walking and running speeds tuned for a horror game.
- Mouse-look camera control with vertical look limits.
- Camera bob while moving.
- Hidden first-person body mesh to avoid seeing the player head through the camera.
- Wider capsule collision to reduce wall clipping.

Main files:

- `script/player.gd`
- `scenes/player.tscn`

### Interaction System

The interaction system uses a camera-based physics raycast. When the player looks at an object that has an `interact()` method, the UI prompt appears and the object can be used.

Example use case:

- Look at the key.
- Press the interact key.
- The key is added to inventory.
- The key object is removed from the world.

Main files:

- `script/player.gd`
- `script/key.gd`

### Inventory System

The inventory is an autoload singleton. Items are stored globally and the UI updates through a signal instead of rebuilding every frame.

Main files:

- `script/Inventory.gd`
- `script/item_list.gd`
- `scenes/item_list.tscn`
- `INVENTORY_UI_EXPLAINED.md`

---

## Getting Started

### Prerequisites

- **Godot Engine 4.5** from [godotengine.org](https://godotengine.org/download)

No npm, Python, Unity, Unreal, or external build tools are required.

### Clone The Repository

```bash
git clone https://github.com/yassine-mathlouthi/3d-horror-game.git
cd 3d-horror-game
```

### Open In Godot

1. Launch **Godot Engine 4.5**.
2. Click **Import** in the Project Manager.
3. Select the project folder.
4. Choose `project.godot`.
5. Click **Import & Edit**.

### Run The Game

1. Press **F5** in the Godot editor.
2. Godot will load the main scene: `scenes/world.tscn`.

---

## Controls

### Desktop

| Action | Key / Input |
|---|---|
| Move forward | `W` or `Z` |
| Move backward | `S` |
| Move left | `A` or `Q` |
| Move right | `D` |
| Run | Hold `Shift` |
| Jump | `Space` |
| Interact | `E` |
| Open inventory | Configured as `Inventory` input action |
| Look around | Mouse movement |

The mouse is captured automatically when the game starts.

### Mobile

The project includes a virtual joystick addon for touchscreen movement. Mobile support is currently focused on Android-style touch controls.

---

## Project Structure

```text
3d-horror-game/
├── addons/
│   └── virtual_joystick/                  # Touch input plugin
├── assets/
│   ├── Icons/                             # Inventory/item icons
│   ├── Key/                               # Key model and textures
│   ├── sky/                               # Panoramic sky texture
│   ├── models/
│   │   ├── Abandoned_House/               # Main horror house model and textures
│   │   └── mixamo_base.glb                # Animated player model
│   └── Designersoup Low Poly Car Pack Volume 1 updated/
│       └── *.fbx                          # Vehicle models
├── scenes/
│   ├── world.tscn                         # Main game scene
│   ├── player.tscn                        # Player controller scene
│   ├── abandoned_house.tscn               # Horror house scene
│   ├── key.tscn                           # Pickup key scene
│   ├── item_list.tscn                     # Inventory UI scene
│   ├── car.tscn                           # Vehicle scene
│   ├── beatall.tscn                       # Additional vehicle scene
│   └── touch_controllers.tscn             # Mobile controls scene
├── script/
│   ├── player.gd                          # Movement, camera, interaction
│   ├── Inventory.gd                       # Global inventory autoload
│   ├── item_list.gd                       # Inventory grid UI logic
│   ├── key.gd                             # Key pickup behavior
│   ├── item.gd                            # Item resource definition
│   └── scene_runtime_optimizer.gd         # Runtime scene/light optimization
├── INVENTORY_UI_EXPLAINED.md              # Detailed inventory UI documentation
├── key_item.tres                          # Example item resource
├── icon.svg                               # Project icon
└── project.godot                          # Godot project configuration
```

---

## Optimization Notes

The project includes several optimization improvements:

- Inventory UI updates only when inventory changes.
- Inline scene scripts were moved to `.gd` files.
- The player script caches important nodes instead of repeatedly resolving them.
- The world floor uses a mesh plus collision shape instead of runtime CSG.
- Large imported assets have shadow mesh generation disabled where appropriate.
- The house scene uses runtime light and visibility optimization.
- The sky texture import is size-limited to reduce memory pressure.

---

## Roadmap

- Add enemy AI and patrol behavior.
- Add locked doors and key-based progression.
- Add item descriptions and usable inventory items.
- Add sound effects, footsteps, and ambient horror audio.
- Add save/load support.
- Add mobile UI polish.
- Add main menu and pause menu.
- Add game over and objective system.

---

## Development Notes

- The project uses Godot input actions instead of hardcoded key checks where possible.
- The inventory action is named `Inventory`.
- The interaction action is named `interact`.
- Pickup objects should expose an `interact()` method.
- The main scene is configured in `project.godot`.

---

## Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test the project in Godot.
5. Commit your changes.
6. Open a pull request.

Example:

```bash
git checkout -b feature/new-horror-system
git commit -m "Add new horror system"
git push origin feature/new-horror-system
```

---

## License

This project is open source. Check the repository license before reusing code or assets.

Some included assets, models, textures, animations, or addons may have their own licenses. Review asset licenses before redistribution or commercial use.

---

## Author

**Yassine Mathlouthi**

- GitHub: [@yassine-mathlouthi](https://github.com/yassine-mathlouthi)
- YouTube playlist: [Development Videos](https://www.youtube.com/watch?v=WjgdnDVzd40&list=PLBFg2OWUD47PpNR7lZwW6VUz8uBKtPf6l&index=1)
