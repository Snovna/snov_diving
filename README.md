# snov_diving

Scuba diving gear system for FiveM. Players can equip and unequip diving gear via an inventory item. The gear degrades over time while diving underwater and warns the player at low durability levels. At 0% durability, the player drowns.

## Features

- Equip/unequip scuba gear with animation
- Gear durability decreases every 7 seconds while underwater
- Low air warnings at 30%, 20%, 10%, and 5%
- Player drowns when durability reaches 0%
- Prevents moving the diving gear item while actively diving
- Automatic version check

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)

## Installation

1. Place `snov_diving` in your resources folder.
2. Add `ensure snov_diving` to your `server.cfg`.
3. Add the diving gear item to your `ox_inventory` items (see `item.txt` for the item definition).

## Item Setup

Add the following to your ox_inventory items:

```lua
['diving_gear'] = {
    label = 'Taucherausruestung',
    weight = 750,
    durability = 100,
    stack = false,
    client = { event = 'snov_diving:use' }
},
```
