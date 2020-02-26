# Cave Story Research Compendium
*A guide to Cave Story's file formats and important hacks*
 
**by fdeitylink**

**Last updated 2019-10-23**

## Rationale
* Learning more about Cave Story for my own edification
* File formats & important hacks weren't all published and collected
    * Actually, they *are* included with Miza, but I hadn't realized this when beginning

## Notes
* Some information may be incorrect - S.P. Gardebiter's guides are a bit old. Feel free to tell me of any information that is incorrect or in need of an update.
* Cave Story was made for Windows and x86 architecture, which leads to some nuances to look out for
    * Newlines are encoded as `\r\n` (affects TSC)
    * Multibyte data is encoded in little endian format

## Credits
Big thanks to all of the following people for much of the following information!
* Carrotlord for the TSC file format
* q3hardcore for the (C)Pixel requirement removal hack
* S.P. Gardebiter for the PXA file format values, the executable mapdata format, and the `npc.tbl` format
* Noxid for Booster's Lab
	* Used to determine how particular edits affected the files
	* Provided newest information, especially tileset and sound values for `npc.tbl`

*WIthout further ado, let's begin!*

## Flags
### Setting Flags
Bitwise OR the current flags with the flag to set

`flags |= flag`

### Unsetting Flags
Bitwise XOR the flag to set with `0b1111_1111`

Bitwise AND the current flags with that result

`flags &= (flag ^ 0xFF)`

### Checking Flags
Bitwise AND the current flags with the flag to check

Returns flag if it is set, `0` otherwise

`is_set = (flags & flag)`

## TSC File Format
* The encoding character is the middle character in the file (i.e. the character at `floor(file_size / 2)`.
	* For example, if the file size is 313 bytes, the encoding character is at the 156th byte.
* During encoding, all characters in the file, except for the encoding character itself, have the value of the encoding character added to them.
	* To be clear, the encoding character itself, at the middle of the file, is *not* encoding, but other instances of it can be. If the encoding character was `a`, that one instance of `a` would not be encoded, but others would be.
* To encode a TSC file, add the value of the encoding character to all characters *except* for the encoding character.
	* To be clear, do not encode the middle byte of the file
* It then follows that to decode a TSC file, subtract the value of the encoding character from each character	
* Also note that newlines in TSC files are Windows-style (`"\r\n"`), so they take up two bytes that should each be treated as independent characters when encoding and decoding.

## Removing the `(C)Pixel` Requirement

| Offset    | Old Value | New Value |
|-----------|-----------|-----------|
| `0x1136C` | `0x74`    | `0xEB`    |
| `0x8C4D8` | `0x28`    | `0x00`    |

In every `.pbm` file, find the `(C)Pixel` at the end and replace the `(` with the null character (`0x00`)

## Enabling bitmaps

| Offset                          | Old Value | New Value |
|---------------------------------|-----------|-----------|
| `0x8C286`, `0x8C30A`, `0x8C32E` | `0x70`    | `0x62`    |
| `0x8C287`, `0x8C30B`, `0x8C32F` | `0x62`    | `0x6D`    |
| `0x8C288`, `0x8C30C`, `0x8C330` | `0x6D`    | `0x70`    |

## `npc.tbl` Format
* Cave Story has 361 (`0x169`) entities numbered from 0 to 360
* `npc.tbl` contains 11 sets of data. The starting address of each set is a multiple of `0x169`.
* Each set of data contains the corresponding value for each entity, in order.
    * For example: At offset `0x02D2` is the Health data for entity 0. At offset `0x02D4` is the Health data for entity 1.

| Offset      | Description            | Size per Entity (bytes) |
| ------------|------------------------|-------------------------|
| `0x0000`    | Flags                  | 2                       |
| `0x02D2`    | Health                 | 2                       |
| `0x05A4`    | Tileset Number         | 1                       |
| `0x070D`    | Death Sound            | 1                       |
| `0x0876`    | Hurt Sound             | 1                       |
| `0x09DF`    | Death Smoke            | 1                       |
| `0x0B48`    | Experience             | 4                       |
| `0x10EC`    | Damage                 | 4                       |
| `0x1690`    | Collision Bounding Box | 4                       |
| `0x1C34`    | Display Bounding Box   | 4                       |

### Flags
#### Byte 1
* `0x01`: Solid
* `0x02`: No effect about Tile 44
* `0x04`: Invulnerable (Blink Sound)
* `0x08`: Ignore solid
* `0x10`: Bouncing at top
* `0x20`: Shootable
* `0x40`: Special Solid
* `0x80`: Rear and top no damage

#### Byte 2
* `0x01`: Call Event on Contact
* `0x02`: Call Event on Death
* `0x04`: Drop Hearts and EXP [Unused]
* `0x08`: Visible if FlagID is set
* `0x10`: Spawn with Alternate Direction
* `0x20`: Call Event on Interaction
* `0x40`: Invisible if FlagID is set	
* `0x80`: Show Damage Numbers ? ("Interactable" in Booster's Lab)

### Tilesets
* `0x00`: title.pbm
* `0x01`: '2004.12 Studio Pixel'
* `0x02`: Current map tileset
* `0x03`: [Unused]
* `0x04`: [Unused]
* `0x05`: [Unused]
* `0x06`: Fade.pbm
* `0x07`: [Unused]
* `0x08`: ItemImage.pbm
* `0x09`: Map System Buffer
* `0x0A`: Screen Buffer
* `0x0B`: Arms.pbm
* `0x0C`: ArmsImage.pbm
* `0x0D`: MNA Text Buffer
* `0x0E`: StageImage.pbm
* `0x0F`: Loading.pbm
* `0x10`: MyChar.pbm
* `0x11`: Bullet.pbm
* `0x12`: [Unused]
* `0x13`: Caret.pbm
* `0x14`: Npc/NpcSym.pbm
* `0x15`: Map NPC Set 1
* `0x16`: Map NPC Set 2
* `0x17`: Npc/NpcRegu.pbm
* `0x18`: [Unused]
* `0x19`: [Unused]
* `0x1A`: TextBox.pbm
* `0x1B`: Face.pbm
* `0x1C`: Current Map BG
* `0x1D`: Damage # Buffer
* `0x1E`: Textbox Buffer 1
* `0x1F`: Textbox Buffer 2
* `0x20`: Textbox Buffer 3
* `0x21`: [???]
* `0x22`: [Unused]	
* `0x23`: Credits Buffer 1
* `0x24`: Credits Buffer 2
* `0x25`: Credits Buffer 3
* `0x26`: [Unused]
* `0x27`: [Unused]
	
### Hurt / Death Sounds
* `0x00`: [Nothing]
* `0x01`: Blip
* `0x02`: Message Typing
* `0x03`: Bonk
* `0x04`: Weapon Switching
* `0x05`: Menu Prompt?
* `0x06`: Critter hop
* `0x07`: Silent?
* `0x08`: Low charge sound
* `0x09`: [Nothing?]
* `0x0A`: [Nothing?]
* `0x0B`: Door
* `0x0C`: Block Destroy
* `0x0D`: [Nothing?]
* `0x0E`: Get EXP
* `0x0F`: Quote Jump
* `0x10`: Taking Damage
* `0x11`: Death
* `0x12`: [Menu?]
* `0x13`: [Nothing?]
* `0x14`: Health/Ammo Refill
* `0x15`: Bubble
* `0x16`: Chest open
* `0x17`: Thud
* `0x18`: Walking
* `0x19`: Enemy killed?
* `0x1A`: Quake
* `0x1B`: Level up
* `0x1C`: Shot hit
* `0x1D`: Teleport
* `0x1E`: Critter jump
* `0x1F`: Ting
* `0x20`: Polar Star lvl
* `0x21`: Fireball
* `0x22`: Fireball bounce
* `0x23`: Explosion
* `0x24`: [Nothing?]
* `0x25`: No Ammo
* `0x26`: Get item?
* `0x27`: [*bvng*] Em fire? - taken from BL, what is em?
* `0x28`: Water
* `0x29`: Water
* `0x2A`: Get Missile [Beep]
* `0x2B`: Computer [Beep]
* `0x2C`: Missile Hit
* `0x2D`: EXP Bounce
* `0x2E`: Ironhead Shot
* `0x2F`: Explosion 2?
* `0x30`: Bubble pop
* `0x31`: Spur lvl 1
* `0x32`: Sqeek!
* `0x33`: Squeal!
* `0x34`: Roar
* `0x35`: Eyoww
* `0x36`: Thud
* `0x37`: Squeek
* `0x38`: Splash
* `0x39`: Little damage sound
* `0x3A`: [*chik*]
* `0x3B`: Spur Charge (lowest)
* `0x3C`: Spur Charge (lower)
* `0x3D`: Spur Charge (higher)
* `0x3E`: Spur lvl 2
* `0x3F`: Spur lvl 3
* `0x40`: Spur MAX
* `0x41`: Spur full?
* `0x42`: [Nothing?]
* `0x43`: [Nothing?]
* `0x44`: [Nothing?]
* `0x45`: [Nothing?]
* `0x46`: Tiny Explosion
* `0x47`: Medium Explosion
* `0x48`: Large Explosion
* `0x49`: [Nothing?]
* `0x4A`: [Nothing?]
* `0x4B`: [Nothing?]
* `0x4C`: [Nothing?]
* `0x4D`: [Nothing?]
* `0x4E`: [Nothing?]
* `0x4F`: [Nothing?]
* `0x50`: [Nothing?]
* `0x51`: [Nothing?]
* `0x52`: [Nothing?]
* `0x53`: [Nothing?]
* `0x54`: [Nothing?]
* `0x55`: [Nothing?]
* `0x56`: [Nothing?]
* `0x57`: [Nothing?]
* `0x58`: [Nothing?]
* `0x59`: [Nothing?]
* `0x5A`: [Nothing?]
* `0x5B`: [Nothing?]
* `0x5C`: [Nothing?]
* `0x5D`: [Nothing?]
* `0x5E`: [Nothing?]
* `0x5F`: [Nothing?]
* `0x60`: [Nothing?]
* `0x61`: [Nothing?]
* `0x62`: [Nothing?]
* `0x63`: [Nothing?]
* `0x64`: Bubbler lvl 3
* `0x65`: Lightning
* `0x66`: Sandcroc Bite
* `0x67`: Curly Charge
* `0x68`: Hit Invisible Block
* `0x69`: Puppy Bark 
* `0x6A`: Blade whoosh
* `0x6B`: Block Move
* `0x6C`: Power Critter Jump
* `0x6D`: Critter Fly
* `0x6E`: Power Critter Fly
* `0x6F`: Thud
* `0x70`: Bigger thud
* `0x71`: [*pshew*] Helicopter?
* `0x72`: Core hurt
* `0x73`: Core thrust
* `0x74`: Core super charge
* `0x75`: Nemesis?
* `0x76`: [Nothing?]
* `0x77`: [Nothing?]
* `0x78`: [Nothing?]
* `0x79`: [Nothing?]
* `0x7A`: [Nothing?]
* `0x7B`: [Nothing?]
* `0x7C`: [Nothing?]
* `0x7D`: [Nothing?]
* `0x7E`: [Nothing?]
* `0x7F`: [Nothing?]
* `0x80`: [Nothing?]
* `0x81`: [Nothing?]
* `0x82`: [Nothing?]
* `0x83`: [Nothing?]
* `0x84`: [Nothing?]
* `0x85`: [Nothing?]
* `0x86`: [Nothing?]
* `0x87`: [Nothing?]
* `0x88`: [Nothing?]
* `0x89`: [Nothing?]
* `0x90`: [Nothing?]
* `0x91`: [Nothing?]
* `0x92`: [Nothing?]
* `0x93`: [Nothing?]
* `0x94`: [Nothing?]
* `0x95`: [Nothing?]
* `0x96`: BASS01
* `0x97`: SNARE01
* `0x98`: HICLOSE
* `0x99`: HIOPEN
* `0x9A`: TOM01
* `0x9B`: PER01

### Smoke
* `0x01`: None
* `0x02`: Small amount
* `0x03`: Medium amount
* `0x04`: Large amount

### Bounding Box Addresses
*From the beginning of each entity's section*
* `0x00`: Left
* `0x01`: Top
* `0x02`: Right
* `0x03`: Bottom

## Map Formats

### Map Metadata
* Applies to freeware executable and CS+ `stage.tbl` file 
* Begins at offset `0x937B0` in freeware executable

| Offset (from beginning of each map section) | Description               | Size (bytes) |
|---------------------------------------------|---------------------------|--------------|
| `0x00`                                      | Tileset name              | 32           |
| `0x20`                                      | Filename                  | 32           |
| `0x40`                                      | Background Scrolling Type | 4            |
| `0x44`                                      | Background Name           | 32           |
| `0x64`                                      | NPC Spritesheet 1         | 32           |
| `0x84`                                      | NPC Spritesheet 2         | 32           |
| `0xA4`                                      | Major Boss                | 1            |
| `0xA5`                                      | Map Name                  | 35           |

#### Background Scrolling Types
* `0x00`: No Scrolling
* `0x01`: Slow Scrolling
* `0x02`: Equal Scrolling
* `0x03`: Water-Style
* `0x04`: Null
* `0x05`: Auto Scrolling
* `0x06`: Cloud-Style [Gravity: Left]
* `0x07`: Cloud-Style [Gravity: Normal]

#### Major Bosses
* `0x00`: No Major Boss
* `0x01`: Omega
* `0x02`: Balfrog
* `0x03`: Monster X
* `0x04`: The Core
* `0x05`: Iron Head
* `0x06`: Dragon Sisters
* `0x07`: Undead Core
* `0x08`: Heavy Press
* `0x09`: Ballos

### PXM File Format
**Note:** Maps must have a minimum size of 21x16

| Offset           | Description                                   | Size (bytes) |
|------------------|-----------------------------------------------|--------------|
| `0x00`           | `"PXM"`                                       | 3            |
| `0x03`           | `0x10`                                        | 1            |
| `0x04`           | Map length                                    | 2            |
| `0x06`           | Map height                                    | 2            |
| Rest of the file | Tile index (left to right then top to bottom) | 1            |

### PXE File Format

| Offset           | Description                                   | Size (bytes) |
|------------------|-----------------------------------------------|--------------|
| `0x00`           | `"PXE"`                                       | 3            |
| `0x03`           | `0x00`                                        | 1            |
| `0x04`           | Entity count                                  | 4            |
| Rest of the file | Entity                                        | 12           |

#### Entity Format

| Offset (from beginning of each entity section) | Description  | Size (bytes) |
|------------------------------------------------|--------------|-------------|
| `0x00`                                         | x coordinate | 2           |
| `0x02`                                         | y coordinate | 2           |
| `0x06`                                         | flag number  | 2           |
| `0x08`                                         | event number | 2           |
| `0x0A`                                         | type         | 2           |
| `0x0C`                                         | flags        | 2           |

### PXA File Format
* No header
* Array of tile types corresponding to tiles in a tileset (left to right then top to bottom)
* Tilesets have up to 16x16 tiles, so PXA files are always 256 bytes - fill in `0x00` for tiles not in the tileset

#### Flags
* `0x01`: Special
* `0x02`: Special
* `0x04`: Special
* `0x08`: Special
* `0x10`: Slope
* `0x20`: Water
* `0x40`: Foreground
* `0x80`: Wind

#### Null (`0x00`)
* `0x00`: Null
* `0x01`: Background Tile
* `0x02`: Background Water
* `0x03`: Background NPC-Blocker Tile [Unused]
* `0x04`: Background NPC-Blocker Tile [Unused]
* `0x05`: Background Shoot-Passer Tile [Unused]
* `0x06`: Background Tile [Unused]
* `0x07`: Background Tile [Unused]
* `0x08`: Background Tile [Unused]
* `0x09`: Background Tile [Unused]
* `0x0A`: Background Tile [Unused]
* `0x0B`: Background Tile [Unused]
* `0x0C`: Background Tile [Unused]
* `0x0D`: Background Tile [Unused]
* `0x0E`: Background Tile [Unused]
* `0x0F`: Background Tile [Unused]

#### Slope (`0x10`)
* `0x10`: Background Tile [Unused]
* `0x11`: Background Tile [Unused]
* `0x12`: Background Tile [Unused]
* `0x13`: Background Tile [Unused]
* `0x14`: Background Tile [Unused]
* `0x15`: Background Tile [Unused]
* `0x16`: Background Tile [Unused]
* `0x17`: Background Tile [Unused]
* `0x18`: Background Tile [Unused]
* `0x19`: Background Tile [Unused]
* `0x1A`: Background Tile [Unused]
* `0x1B`: Background Tile [Unused]
* `0x1C`: Background Tile [Unused]
* `0x1D`: Background Tile [Unused]
* `0x1E`: Background Tile [Unused]
* `0x1F`: Background Tile [Unused]

#### Water (`0x20`)
* `0x20`: Null [Unused]
* `0x21`: Null [Unused]
* `0x22`: Null [Unused]
* `0x23`: Null [Unused]
* `0x24`: Null [Unused]
* `0x25`: Null [Unused]
* `0x26`: Null [Unused]
* `0x27`: Null [Unused]
* `0x28`: Null [Unused]
* `0x29`: Null [Unused]
* `0x2A`: Null [Unused]
* `0x2B`: Null [Unused]
* `0x2C`: Null [Unused]
* `0x2D`: Null [Unused]
* `0x2E`: Null [Unused]
* `0x2F`: Null [Unused]

#### Slope + Water (`0x30`)
* `0x30`: Null [Unused]
* `0x31`: Null [Unused]
* `0x32`: Null [Unused]
* `0x33`: Null [Unused]
* `0x34`: Null [Unused]
* `0x35`: Null [Unused]
* `0x36`: Null [Unused]
* `0x37`: Null [Unused]
* `0x38`: Null [Unused]
* `0x39`: Null [Unused]
* `0x3A`: Null [Unused]
* `0x3B`: Null [Unused]
* `0x3C`: Null [Unused]
* `0x3D`: Null [Unused]
* `0x3E`: Null [Unused]
* `0x3F`: Null [Unused]

#### Foreground (`0x40`)
* `0x40`: Foreground Tile
* `0x41`: Solid Tile
* `0x42`: 10 Damage Foreground Tile
* `0x43`: Special Block Tile
* `0x44`: Foreground NPC-Blocker Tile
* `0x45`: Foreground Tile [Unused]
* `0x46`: Character-Blocker Tile [Unused]
* `0x47`: Foreground Tile [Unused]
* `0x48`: Foreground Tile [Unused]
* `0x49`: Foreground Tile [Unused]
* `0x4A`: Foreground Tile [Unused]
* `0x4B`: Foreground Tile [Unused]
* `0x4C`: Foreground Tile [Unused]
* `0x4D`: Foreground Tile [Unused]
* `0x4E`: Foreground Tile [Unused]
* `0x4F`: Foreground Tile [Unused]

#### Foreground + Slope (`0x50`)
* `0x50`: Slope Tile
* `0x51`: Slope Tile
* `0x52`: Slope Tile
* `0x53`: Slope Tile
* `0x54`: Slope Tile
* `0x55`: Slope Tile
* `0x56`: Slope Tile
* `0x57`: Slope Tile
* `0x58`: Foreground Tile [Unused]
* `0x59`: Foreground Tile [Unused]
* `0x5A`: Foreground Tile [Unused]
* `0x5B`: Foreground Tile [Unused]
* `0x5C`: Foreground Tile [Unused]
* `0x5D`: Foreground Tile [Unused]
* `0x5E`: Foreground Tile [Unused]
* `0x5F`: Foreground Tile [Unused]

#### Foreground + Water (`0x60`)
* `0x60`: Foreground Water
* `0x61`: Solid Tile [Unused]
* `0x62`: 10 Damage Foreground Water Tile [Red]
* `0x63`: Foreground Tile [Unused]
* `0x64`: Foreground NPC-Blocker Tile [Unused]
* `0x65`: Foreground Tile [Unused]
* `0x66`: Foreground Tile [Unused]
* `0x67`: Foreground Tile [Unused]
* `0x68`: Foreground Tile [Unused]
* `0x69`: Foreground Tile [Unused]
* `0x6A`: Foreground Tile [Unused]
* `0x6B`: Foreground Tile [Unused]
* `0x6C`: Foreground Tile [Unused]
* `0x6D`: Foreground Tile [Unused]
* `0x6E`: Foreground Tile [Unused]
* `0x6F`: Foreground Tile [Unused]

#### Foreground + Slope + Water (`0x70`)
* `0x70`: Slope Tile [Water]
* `0x71`: Slope Tile [Water]
* `0x72`: Slope Tile [Water]
* `0x73`: Slope Tile [Water]
* `0x74`: Slope Tile [Water]
* `0x75`: Slope Tile [Water]
* `0x76`: Slope Tile [Water]
* `0x77`: Slope Tile [Water]
* `0x78`: Foreground Tile [Unused]
* `0x79`: Foreground Tile [Unused]
* `0x7A`: Foreground Tile [Unused]
* `0x7B`: Foreground Tile [Unused]
* `0x7C`: Foreground Tile [Unused]
* `0x7D`: Foreground Tile [Unused]
* `0x7E`: Foreground Tile [Unused]
* `0x7F`: Foreground Tile [Unused]

#### Wind (`0x80`)
* `0x80`: Wind [Left]
* `0x81`: Wind [Up]
* `0x82`: Wind [Right]
* `0x83`: Wind [Down]
* `0x84`: Null [Unused]
* `0x85`: Null [Unused]
* `0x86`: Null [Unused]
* `0x87`: Null [Unused]
* `0x88`: Null [Unused]
* `0x89`: Null [Unused]
* `0x8A`: Null [Unused]
* `0x8B`: Null [Unused]
* `0x8C`: Null [Unused]
* `0x8D`: Null [Unused]
* `0x8E`: Null [Unused]
* `0x8F`: Null [Unused]

#### Wind + Slope (`0x90`)
* `0x90`: Null [Unused]
* `0x91`: Null [Unused]
* `0x92`: Null [Unused]
* `0x93`: Null [Unused]
* `0x94`: Null [Unused]
* `0x95`: Null [Unused]
* `0x96`: Null [Unused]
* `0x97`: Null [Unused]
* `0x98`: Null [Unused]
* `0x99`: Null [Unused]
* `0x9A`: Null [Unused]
* `0x9B`: Null [Unused]
* `0x9C`: Null [Unused]
* `0x9D`: Null [Unused]
* `0x9E`: Null [Unused]
* `0x9F`: Null [Unused]

#### Wind + Water (`0xA0`)
* `0xA0`: Water Wind [Left]
* `0xA1`: Water Wind [Up]
* `0xA2`: Water Wind [Right]
* `0xA3`: Water Wind [Down]
* `0xA4`: Null [Unused]
* `0xA5`: Null [Unused]
* `0xA6`: Null [Unused]
* `0xA7`: Null [Unused]
* `0xA8` :Null [Unused]
* `0xA9`: Null [Unused]
* `0xAA`: Null [Unused]
* `0xAB`: Null [Unused]
* `0xAC`: Null [Unused]
* `0xAD`: Null [Unused]
* `0xAE`: Null [Unused]
* `0xAF`: Null [Unused]

#### Wind + Slope + Water (`0xB0`)
* `0xB0`: Null [Unused]
* `0xB1`: Null [Unused]
* `0xB2`: Null [Unused]
* `0xB3`: Null [Unused]
* `0xB4`: Null [Unused]
* `0xB5`: Null [Unused]
* `0xB6`: Null [Unused]
* `0xB7`: Null [Unused]
* `0xB8`: Null [Unused]
* `0xB9`: Null [Unused]
* `0xBA`: Null [Unused]
* `0xBB`: Null [Unused]
* `0xBC`: Null [Unused]
* `0xBD`: Null [Unused]
* `0xBE`: Null [Unused]
* `0xBF`: Null [Unused]

#### Wind + Foreground (`0xC0`)
* `0xC0`: Null [Unused]
* `0xC1`: Null [Unused]
* `0xC2`: Null [Unused]
* `0xC3`: Null [Unused]
* `0xC4`: Null [Unused]
* `0xC5`: Null [Unused]
* `0xC6`: Null [Unused]
* `0xC7`: Null [Unused]
* `0xC8`: Null [Unused]
* `0xC9`: Null [Unused]
* `0xCA`: Null [Unused]
* `0xCB`: Null [Unused]
* `0xCC`: Null [Unused]
* `0xCD`: Null [Unused]
* `0xCE`: Null [Unused]
* `0xCF`: Null [Unused]

#### Wind + Foreground + Slope (`0xD0`)
* `0xD0`: Null [Unused]
* `0xD1`: Null [Unused]
* `0xD2`: Null [Unused]
* `0xD3`: Null [Unused]
* `0xD4`: Null [Unused]
* `0xD5`: Null [Unused]
* `0xD6`: Null [Unused]
* `0xD7`: Null [Unused]
* `0xD8`: Null [Unused]
* `0xD9`: Null [Unused]
* `0xDA`: Null [Unused]
* `0xDB`: Null [Unused]
* `0xDC`: Null [Unused]
* `0xDD`: Null [Unused]
* `0xDE`: Null [Unused]
* `0xDF`: Null [Unused]

#### Wind + Foreground + Water (`0xE0`)
* `0xE0`: Null [Unused]
* `0xE1`: Null [Unused]
* `0xE2`: Null [Unused]
* `0xE3`: Null [Unused]
* `0xE4`: Null [Unused]
* `0xE5`: Null [Unused]
* `0xE6`: Null [Unused]
* `0xE7`: Null [Unused]
* `0xE8`: Null [Unused]
* `0xE9`: Null [Unused]
* `0xEA`: Null [Unused]
* `0xEB`: Null [Unused]
* `0xEC`: Null [Unused]
* `0xED`: Null [Unused]
* `0xEE`: Null [Unused]
* `0xEF`: Null [Unused]

#### Wind + Foreground + Slope + Water (`0xF0`)
* `0xF0`: Null [Unused]
* `0xF1`: Null [Unused]
* `0xF2`: Null [Unused]
* `0xF3`: Null [Unused]
* `0xF4`: Null [Unused]
* `0xF5`: Null [Unused]
* `0xF6`: Null [Unused]
* `0xF7`: Null [Unused]
* `0xF8`: Null [Unused]
* `0xF9`: Null [Unused]
* `0xFA`: Null [Unused]
* `0xFB`: Null [Unused]
* `0xFC`: Null [Unused]
* `0xFD`: Null [Unused]
* `0xFE`: Null [Unused]
* `0xFF`: Null [Unused]
