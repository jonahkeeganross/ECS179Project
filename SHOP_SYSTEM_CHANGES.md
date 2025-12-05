# Shop System Implementation - Changes Summary

## 📋 Created Files

### 1. Shop UI System
- **`cursed-crown/Scripts/UI/Shop.gd`** (NEW)
  - Full shop logic implementation
  - Handles purchases, UI updates, pause/unpause
  - Size: 3.3 KB

- **`cursed-crown/Scenes/Shop.tscn`** (NEW)
  - Complete shop UI scene
  - Contains all buttons, labels, and layout
  - Size: 3.4 KB

### 2. Altar Interaction System
- **`cursed-crown/Scripts/Interactables/AltarInteraction.gd`** (NEW)
  - Handles player proximity detection
  - Opens shop when player presses F
  - Size: 1.6 KB

### 3. Modified Files

#### `cursed-crown/Scripts/player.gd` (MODIFIED)
**Added lines 5-7:**
```gdscript
@export var max_health: int = 100  # Shop: Max health for upgrades
@export var attack_damage: int = 10  # Shop: Base attack damage
@export var coins: int = 100  # Shop: Currency for purchasing upgrades
```

#### `cursed-crown/Scenes/altar.tscn` (MODIFIED)
- Changed root node from `Area2D` to `Node2D`
- Added `AltarInteraction` (Area2D) child with script
- Added interaction collision shape (CircleShape2D, radius: 80px)
- Added `InteractionPrompt` label: "Press F to open shop"

#### `cursed-crown/project.godot` (MODIFIED)
**Added lines 71-75:**
```ini
interact={
"deadzone": 0.5,
"events": [InputEventKey with physical_keycode: 70 (F key)]
}
```

#### `cursed-crown/Scenes/Crown.tscn` (MODIFIED)
- Added Shop ExtResource import (line 44)
- Added Shop instance at end of file

---

## 🎮 How to Test

### Step 1: Open in Godot Editor
1. Open **Godot 4**
2. Click **Import** or **Open Project**
3. Navigate to: `/Users/lizeying/Downloads/ECS179Project-TestingRoomDevelopment/cursed-crown/`
4. Select `project.godot`

### Step 2: View Created Files
In Godot's FileSystem panel (bottom-left), you should see:
- `res://Scenes/Shop.tscn` ⭐ NEW
- `res://Scripts/UI/Shop.gd` ⭐ NEW
- `res://Scripts/Interactables/AltarInteraction.gd` ⭐ NEW

### Step 3: Inspect Modified Files
Open these files in Godot to see the changes:
- **Player.gd**: Check lines 5-7 for new variables
- **altar.tscn**: Open scene, you'll see new AltarInteraction node
- **Crown.tscn**: Look for "Shop" node in scene tree

### Step 4: Run the Game
1. Press **F5** (or click Play button)
2. Move player near the altar
3. Look for prompt: "Press F to open shop"
4. Press **F key**
5. Shop UI should appear with pause
6. Try buying upgrades (you start with 100 coins)
7. Press **CLOSE** or **ESC** to exit shop

---

## 🔍 Visual Inspection Checklist

### In Godot Editor:

#### ✅ Shop.tscn Scene
1. Open `res://Scenes/Shop.tscn`
2. You should see this hierarchy:
   ```
   Shop (CanvasLayer)
   └── PanelContainer
       └── MarginContainer
           └── VBoxContainer
               ├── Title
               ├── CoinsLabel
               ├── HSeparator
               ├── UpgradesContainer
               │   ├── AttackUpgrade
               │   ├── HPUpgrade
               │   └── SpeedUpgrade
               └── CloseButton
   ```

#### ✅ Altar.tscn Scene
1. Open `res://Scenes/altar.tscn`
2. New structure should be:
   ```
   Altar (Node2D)
   ├── Sprite2D (altar visual)
   └── AltarInteraction (Area2D) ← NEW
       ├── CollisionShape2D ← NEW
       └── InteractionPrompt (Label) ← NEW
   ```

#### ✅ Player.tscn Scene
1. Open `res://Scenes/Player.tscn`
2. Select Player node
3. In Inspector panel, look for new exported variables:
   - Max Health: 100
   - Attack Damage: 10
   - Coins: 100

#### ✅ Crown.tscn (Main Scene)
1. Open `res://Scenes/Crown.tscn`
2. In Scene tree, you should see "Shop" node at root level

---

## 🧪 Testing Scenarios

### Test 1: Proximity Detection
- **Action**: Walk near altar
- **Expected**: "Press F to open shop" appears
- **Action**: Walk away
- **Expected**: Prompt disappears

### Test 2: Shop Opening
- **Action**: Near altar, press F
- **Expected**:
  - Shop UI appears
  - Game pauses
  - Shows "Coins: 100"

### Test 3: Purchase Upgrades
- **Action**: Click "BUY" on Attack upgrade
- **Expected**:
  - Coins decrease to 50
  - Console message: "Shop: Attack upgraded! New damage: 15"
  - Button becomes disabled if not enough coins

### Test 4: Shop Closing
- **Action**: Press ESC or click CLOSE
- **Expected**:
  - Shop UI disappears
  - Game unpauses
  - Player can move again

---

## 📊 File Statistics

| File | Status | Size | Lines |
|------|--------|------|-------|
| Scripts/UI/Shop.gd | NEW | 3.3 KB | ~135 lines |
| Scenes/Shop.tscn | NEW | 3.4 KB | ~100 lines |
| Scripts/Interactables/AltarInteraction.gd | NEW | 1.6 KB | ~60 lines |
| Scripts/player.gd | MODIFIED | +3 lines | Added 3 variables |
| Scenes/altar.tscn | MODIFIED | +16 lines | Restructured |
| project.godot | MODIFIED | +6 lines | Added input action |
| Scenes/Crown.tscn | MODIFIED | +2 lines | Added Shop instance |

---

## 🎯 Key Features Implemented

✅ **Shop UI System**
- Professional panel-based layout
- 3 upgrade buttons (Attack/HP/Speed)
- Dynamic coin display
- Auto-disable buttons when insufficient coins

✅ **Altar Interaction**
- Proximity detection (80px radius)
- Visual prompt system
- F key to interact
- Clean enter/exit handling

✅ **Player Integration**
- Currency system (coins)
- Upgradeable stats (attack, health, speed)
- All variables exported for easy testing

✅ **Game Flow**
- Pause game when shop opens
- Unpause when shop closes
- ESC key support for quick exit

---

## 🔧 Customization Guide

### Change Upgrade Costs/Values
Edit `cursed-crown/Scripts/UI/Shop.gd` lines 5-12:
```gdscript
const ATTACK_COST = 50    # Change cost
const ATTACK_BONUS = 5    # Change upgrade amount
```

### Change Interaction Key
Edit `cursed-crown/project.godot`:
- Find `interact` section (line 71)
- Change `physical_keycode` to different key:
  - E key = 69
  - F key = 70 (current)
  - R key = 82

### Change Starting Coins
Edit `cursed-crown/Scripts/player.gd` line 7:
```gdscript
@export var coins: int = 100  # Change this number
```

### Change Interaction Range
Edit `cursed-crown/Scenes/altar.tscn`:
- Open in Godot
- Select `AltarInteraction/CollisionShape2D`
- In Inspector, change `Shape > Radius` (currently 80)

---

## 📝 Notes

- **Interaction key is F** (not E) because E is used for attack3
- Shop is added as a group "shop" for easy finding
- Player is added to group "Player" (capital P)
- System uses Character base class's `movement_speed` variable
- All purchases are instant and permanent (no save/load yet)

---

## 🚀 Next Steps

After testing, you can:
1. Add sound effects to purchases
2. Add more upgrade types
3. Implement save/load for purchased upgrades
4. Add visual feedback animations
5. Create upgrade level indicators
6. Add item shop system

---

Generated: December 1, 2025
Implementation: Complete ✅
