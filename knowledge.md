# Hinter - Project Knowledge

## Project Overview
Hinter is a short 3D adventure story game built in Godot 4.4 RC2. The player controls Hinter, a nomad who bought a shady RV that tends to explode when things break. Since the engine gave up, the player must push the trailer forward manually while traveling through a desert.

## Project Structure

### Core Systems
- **Game Manager**: Controls game states (GAMEPLAY, TRANSITION, MINIGAME)
- **Location Manager**: Handles location discovery and transitions
- **Task Manager**: Manages game tasks/objectives
- **Time Manager**: Controls day/night cycle
- **Transition Manager**: Handles screen transitions between areas
- **Events**: Central message bus for game events

### Player
- First-person controller with WASD movement
- Interaction system using raycasting
- Camera controls with mouse

### Interaction System
- Uses raycasting to detect interactable objects
- Supports both press and hold interactions
- Interactables can trigger various game events

### Minigame System
- Extensible framework for creating interactive minigames
- Base `MinigameElement` class for all gameplay elements
- `Minigame` class manages camera transitions and state
- Supports sequencing multiple elements in a single minigame
- Examples include QTE and SliderPuzzle elements

### UI
- Dialogue system for character speech
- Screen fade transitions
- Control prompts

## Game Mechanics
- Day/night cycle
- Location discovery
- Task completion
- Trailer pushing mechanic
- Sleep mechanic

## Documentation

- Official Godot documentation: https://docs.godotengine.org/en/stable/classes/index.html

## Code Style
- Use official GDScript style guide: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
- *Always* add type hints to *all* variable and function declarations 

## Verifying Changes

After any code (.gd scripts) changes, run these commands to verify correctness:

- Run `gdparse` to validate GDScript code on the syntax level

- Run `gdlint` to check for linting errors
