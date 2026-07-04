# 3D Horror Game 🎮👻

A first-person 3D horror exploration game built with **Godot Engine 4.5**. Wander through an eerie abandoned house and its surroundings, navigating a dark open world filled with atmospheric fog, dimly lit environments, and unsettling scenery.

---
[Youtube](https://www.youtube.com/watch?v=WjgdnDVzd40&list=PLBFg2OWUD47PpNR7lZwW6VUz8uBKtPf6l&index=1)
## Features

- 🕹️ **First-Person Exploration** – Immersive first-person perspective with smooth mouse-look controls
- 🏚️ **Detailed Abandoned House** – Highly detailed interior environment with multiple rooms (bedrooms, kitchen, bathroom, and more)
- 🚗 **Driveable Area with Vehicles** – Explore the surroundings alongside a collection of low-poly cars
- 🌫️ **Atmospheric Horror Ambiance** – Fog effects, dim directional lighting, and a moody panoramic skybox
- 📱 **Mobile Support** – Virtual joystick for touchscreen devices (Android)
- 🎭 **Animated Player Character** – Rigged 3D character with idle, walk, and run animations
- ⌨️ **AZERTY Keyboard Support** – Compatible with both QWERTY and AZERTY keyboard layouts

---

## Built With

| Technology | Purpose |
|---|---|
| [Godot Engine 4.5](https://godotengine.org/) | Game engine |
| GDScript | Game scripting language |
| OpenGL Compatibility Renderer | Cross-platform rendering (desktop & mobile) |
| [Virtual Joystick addon](https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot) | Mobile touch input |
| Mixamo | Player character rig & animations |

---

## Prerequisites

- **Godot Engine 4.5** – Download from [godotengine.org](https://godotengine.org/download)

No other dependencies or build tools are required. Godot handles everything natively.

---
Inventory system
<img width="1150" height="647" alt="image" src="https://github.com/user-attachments/assets/da38793e-60e5-48c4-9b64-8ccf358dac07" />
pick up system
<img width="1151" height="647" alt="image" src="https://github.com/user-attachments/assets/80ff801f-0212-4819-89a3-9d96d2d48334" />
lights system
<img width="1146" height="643" alt="Capture d&#39;écran 2026-03-19 022927" src="https://github.com/user-attachments/assets/9259daf7-e984-4283-98a6-d6826f55c17b" />
fpc/fpv 
<img width="1148" height="643" alt="Capture d&#39;écran 2026-02-17 141110" src="https://github.com/user-attachments/assets/8eef8db4-d4f7-4cb6-8e69-b25342ef0841" />


## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yassine-mathlouthi/3d-horror-game.git
cd 3d-horror-game
```

### 2. Open in Godot

1. Launch **Godot Engine 4.5**
2. Click **Import** in the Project Manager
3. Navigate to the cloned folder and select `project.godot`
4. Click **Import & Edit**

### 3. Run the game

- Press **F5** or click the **▶ Play** button in the Godot editor to start the game
- The main scene (`scenes/world.tscn`) will launch automatically

---

## Controls

### Desktop (Keyboard & Mouse)

| Action | Key / Input |
|---|---|
| Move Forward | `W` or `Z` (AZERTY) |
| Move Backward | `S` |
| Move Left | `A` or `Q` (AZERTY) |
| Move Right | `D` |
| Run | Hold `Shift` |
| Jump | `Space` |
| Look Around | Mouse movement |

> **Note:** The mouse is captured automatically when the game starts for an immersive experience.

### Mobile (Touchscreen)

A virtual joystick is available on touchscreen devices (e.g., Android) for movement control.

---

## Project Structure

```
3d-horror-game/
├── addons/
│   └── virtual_joystick/        # Touch input plugin for mobile
├── assets/
│   ├── sky/                     # Panoramic skybox (EXR format)
│   ├── models/
│   │   ├── Abandoned_House/     # Detailed horror house (Blender/FBX/GLB)
│   │   └── mixamo_base.glb      # Rigged player character
│   └── Designersoup Low Poly Car Pack Volume 1 updated/  # Vehicle models
├── scenes/
│   ├── world.tscn               # Main game scene (entry point)
│   ├── player.tscn              # Player character with movement script
│   ├── abandoned_house.tscn     # Abandoned house environment
│   ├── car.tscn                 # Car model scene
│   ├── beatall.tscn             # Additional vehicle scene
│   └── touch_controllers.tscn  # Mobile joystick UI
├── icon.svg                     # Project icon
└── project.godot                # Godot project configuration
```

---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature-name`)
6. Open a Pull Request

---

## License

This project is open source. Please check the repository for any license details or contact the author for usage rights regarding included assets (3D models, textures, skybox).

---

## Author

**Yassine Mathlouthi** – [@yassine-mathlouthi](https://github.com/yassine-mathlouthi)
