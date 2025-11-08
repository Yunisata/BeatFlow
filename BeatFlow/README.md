# BeatFlow - Rhythm Mode & Beat Generation System

## Overview

BeatFlow is a sophisticated musical beat generation system built on the Stacks blockchain. It manages multiple rhythm modes, tracks producer statistics, and maintains an immutable record of all beats dropped on the platform.

## Core Concept

The contract operates around "modes" - distinct musical styles that apply different mathematical formulas to frequency inputs. Producers drop beats by providing two frequency values, which are processed according to the active mode to generate unique vibe signatures.

## Features

### 🎵 Multiple Rhythm Modes
- Three pre-configured musical styles
- Each mode has unique vibe calculations
- BPM ranges and rating systems
- Usage tracking and popularity metrics

### 👑 Boss Management
- Designated boss controls system settings
- Mode switching and creation authority
- BPM and quality threshold controls
- Emergency mute/unmute functionality

### 📈 Producer Statistics
- Individual performance tracking
- Best vibe records
- Average quality metrics
- Signature mode identification

### 🎧 Beat Collections
- Users can collect favorite beats
- Up to 20 beats per collection
- Community beat sharing

### 🛡️ Quality Control
- Configurable quality thresholds
- Frequency validation
- Energy level calculations
- Boss skill level system

## Rhythm Modes

### 1. Chill-Wave (ID: 1)
**Style**: Smooth flowing grooves with ambient textures

- **Formula**: x + y (additive harmony)
- **Rating**: 88/100
- **BPM Range**: 90 BPM
- **Energy**: Low to Medium
- **Best For**: Relaxation, study sessions, ambient sets
- **Characteristics**: Clean, harmonic, balanced frequencies

### 2. Trap-Snap (ID: 2)
**Style**: Hard hitting bass drops with crispy hi-hats

- **Formula**: x × y² (exponential bass multiplication)
- **Rating**: 95/100
- **BPM Range**: 150 BPM
- **Energy**: High to Extreme
- **Best For**: Clubs, festivals, high-energy performances
- **Characteristics**: Aggressive, powerful, bass-heavy

### 3. Glitch-Hop (ID: 3)
**Style**: Broken chaotic rhythms with digital artifacts

- **Formula**: 2x + y/2 (asymmetric glitch pattern)
- **Rating**: 82/100
- **BPM Range**: 110 BPM
- **Energy**: Medium
- **Best For**: Experimental sets, art installations, IDM
- **Characteristics**: Unpredictable, creative, digital

## Smart Contract Functions

### Read-Only Functions

#### `whats-live()`
Returns the currently active mode ID.
```clarity
(contract-call? .beat-flow whats-live)
;; Returns: uint
```

#### `peek-mode(uint)`
Get complete details about a specific mode.
```clarity
(contract-call? .beat-flow peek-mode u1)
;; Returns: (optional { name, style, hot, birth, drops, rating, bpm-range })
```

#### `all-modes()`
List all available rhythm modes.
```clarity
(contract-call? .beat-flow all-modes)
;; Returns: (list of mode data)
```

#### `peek-beat(uint)`
Retrieve details of a specific beat.
```clarity
(contract-call? .beat-flow peek-beat u1)
;; Returns: (optional { mode-id, maker, drop, vibe, freq-x, freq-y, quality, energy })
```

#### `total-beats()`
Get total number of beats dropped.
```clarity
(contract-call? .beat-flow total-beats)
;; Returns: uint
```

#### `who-boss()`
Returns the current boss's principal.
```clarity
(contract-call? .beat-flow who-boss)
;; Returns: principal
```

#### `is-muted()`
Check if system is muted.
```clarity
(contract-call? .beat-flow is-muted)
;; Returns: bool
```

#### `get-mode-count()`
Total number of modes created.
```clarity
(contract-call? .beat-flow get-mode-count)
;; Returns: uint
```

#### `get-bpm()`
Get global BPM setting.
```clarity
(contract-call? .beat-flow get-bpm)
;; Returns: uint
```

#### `get-threshold()`
Get quality threshold requirement.
```clarity
(contract-call? .beat-flow get-threshold)
;; Returns: uint
```

#### `get-producer-stats(principal)`
View producer performance statistics.
```clarity
(contract-call? .beat-flow get-producer-stats 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; Returns: (optional { total-drops, best-vibe, avg-quality, last-drop, signature-mode })
```

#### `get-popularity(uint)`
Check mode popularity score.
```clarity
(contract-call? .beat-flow get-popularity u2)
;; Returns: uint
```

#### `get-collection(principal)`
View user's beat collection.
```clarity
(contract-call? .beat-flow get-collection 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
;; Returns: (list of beat IDs)
```

#### `get-skill()`
Get boss skill level.
```clarity
(contract-call? .beat-flow get-skill)
;; Returns: uint
```

#### `get-max-freq()`
Get maximum allowed frequency.
```clarity
(contract-call? .beat-flow get-max-freq)
;; Returns: uint
```

### State-Changing Functions (Boss Only)

#### `switch(uint)`
Switch to a different rhythm mode.
```clarity
(contract-call? .beat-flow switch u2)
;; Returns: (ok uint) or error
;; Errors: ERR-NOT-BOSS, ERR-MUTED, ERR-NO-MODE, ERR-DUP
```

#### `add-mode(uint, string-ascii, string-ascii)`
Create a new rhythm mode.
```clarity
(contract-call? .beat-flow add-mode u4 "dubstep-wobble" "Heavy bass wobbles with syncopated drums")
;; Returns: (ok uint) or error
;; Errors: ERR-NOT-BOSS, ERR-BAD-BEAT, ERR-ID-EXISTS
```

#### `rate-mode(uint, uint)`
Update mode rating (0-100).
```clarity
(contract-call? .beat-flow rate-mode u1 u93)
;; Returns: (ok bool) or error
;; Errors: ERR-NOT-BOSS, ERR-NO-MODE, ERR-INVALID-FREQ
```

#### `set-bpm(uint)`
Set global BPM (60-200 range).
```clarity
(contract-call? .beat-flow set-bpm u140)
;; Returns: (ok uint) or error
;; Errors: ERR-NOT-BOSS, ERR-INVALID-FREQ
```

#### `set-threshold(uint)`
Set minimum quality threshold (0-100).
```clarity
(contract-call? .beat-flow set-threshold u60)
;; Returns: (ok uint) or error
;; Errors: ERR-NOT-BOSS, ERR-INVALID-FREQ
```

#### `crown(principal)`
Transfer boss role to new address.
```clarity
(contract-call? .beat-flow crown 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
;; Returns: (ok principal) or error
;; Errors: ERR-NOT-BOSS
```

#### `mute()`
Mute all beat dropping.
```clarity
(contract-call? .beat-flow mute)
;; Returns: (ok bool) or error
;; Errors: ERR-NOT-BOSS
```

#### `unmute()`
Resume beat dropping.
```clarity
(contract-call? .beat-flow unmute)
;; Returns: (ok bool) or error
;; Errors: ERR-NOT-BOSS
```

### State-Changing Functions (Anyone)

#### `drop(uint, uint)`
Drop a beat using two frequency values.
```clarity
(contract-call? .beat-flow drop u440 u523)
;; Returns: (ok uint) - the calculated vibe signature
;; Errors: ERR-MUTED, ERR-INVALID-FREQ, ERR-LOW-QUALITY
```

#### `collect(uint)`
Add a beat to your collection.
```clarity
(contract-call? .beat-flow collect u1)
;; Returns: (ok bool) or error
;; Errors: ERR-NO-MODE, ERR-INVALID-FREQ
```

## Usage Examples

### Basic Beat Dropping
```clarity
;; Check active mode
(contract-call? .beat-flow whats-live)
;; Returns: u1 (chill-wave)

;; Drop a beat with frequencies
(contract-call? .beat-flow drop u440 u220)
;; Returns: (ok u660) - chill-wave uses addition

;; View your beat
(contract-call? .beat-flow peek-beat u1)
```

### Mode Switching for Different Styles
```clarity
;; Boss switches to trap for heavy set
(contract-call? .beat-flow switch u2)

;; Now beats have exponential intensity
(contract-call? .beat-flow drop u100 u50)
;; Returns: (ok u250000) - trap-snap uses 100 × 50²
```

### Creating Custom Mode
```clarity
;; Boss creates experimental mode
(contract-call? .beat-flow add-mode u4 "acid-house" "303-inspired squelchy basslines")

;; Rate it
(contract-call? .beat-flow rate-mode u4 u91)

;; Set appropriate BPM
(contract-call? .beat-flow set-bpm u128)
```

### Building Collection
```clarity
;; Find great beat
(contract-call? .beat-flow peek-beat u5)

;; Add to collection
(contract-call? .beat-flow collect u5)

;; View collection
(contract-call? .beat-flow get-collection tx-sender)
```

## Frequency Guide

Frequencies represent musical notes in Hz:

| Note | Frequency | Use Case |
|------|-----------|----------|
| C2 | 65 | Sub-bass |
| C3 | 130 | Bass |
| A4 | 440 | Concert pitch |
| C5 | 523 | Melody |
| C6 | 1046 | High melody |
| C7 | 2093 | Harmonics |

### Example Combinations
- **Deep Bass**: drop(65, 130) - Fat sub-bass
- **Melodic**: drop(440, 523) - Harmonic melody
- **High Energy**: drop(1046, 2093) - Bright highs

## Quality & Energy

### Quality Calculation
Quality is based on harmonic ratio between frequencies. Balanced ratios score higher.

### Energy Calculation
Energy = (freq-x + freq-y) / 10, capped at 100.

Higher frequencies = more energy = more intense beats.

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | ERR-NOT-BOSS | Not authorized as boss |
| u101 | ERR-BAD-BEAT | Invalid beat specification |
| u102 | ERR-NO-MODE | Mode doesn't exist |
| u103 | ERR-DUP | Already using specified mode |
| u104 | ERR-ID-EXISTS | Mode ID already registered |
| u105 | ERR-MUTED | System is muted |
| u106 | ERR-INVALID-FREQ | Invalid frequency value |
| u107 | ERR-MODE-INACTIVE | Mode is not active |
| u108 | ERR-LOW-QUALITY | Beat quality below threshold |

## Data Structures

### Mode
```clarity
{
  name: (string-ascii 50),           ;; Mode name
  style: (string-ascii 200),         ;; Description
  hot: bool,                         ;; Currently active?
  birth: uint,                       ;; Creation block
  drops: uint,                       ;; Times used
  rating: uint,                      ;; Quality rating
  bpm-range: uint                    ;; Typical BPM
}
```

### Beat
```clarity
{
  mode-id: uint,                     ;; Mode used
  maker: principal,                  ;; Producer
  drop: uint,                        ;; Block height
  vibe: uint,                        ;; Calculated signature
  freq-x: uint,                      ;; First frequency
  freq-y: uint,                      ;; Second frequency
  quality: uint,                     ;; Quality score
  energy: uint                       ;; Energy level
}
```

### Producer Statistics
```clarity
{
  total-drops: uint,                 ;; Total beats
  best-vibe: uint,                   ;; Highest vibe
  avg-quality: uint,                 ;; Average quality
  last-drop: uint,                   ;; Last beat block
  signature-mode: uint               ;; Favorite mode
}
```

## Integration Guide

```javascript
// Connect to contract
const contract = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.beat-flow';

// Drop a beat
await callPublic('drop', [440, 523]);

// Check stats
const stats = await callReadOnly('get-producer-stats', [userAddress]);

// View mode
const mode = await callReadOnly('peek-mode', [1]);
```

## Musical Theory

- **Harmonic Ratios**: Simple ratios (2:1, 3:2) sound more consonant
- **Frequency Ranges**: Sub-bass (20-60Hz), Bass (60-250Hz), Mids (250-2kHz), Highs (2kHz+)
- **BPM Standards**: Ambient (60-90), House (120-130), Trap (140-160), Drum & Bass (160-180)

## Roadmap

- [ ] Multi-frequency support (3+ inputs)
- [ ] Collaboration system
- [ ] Beat NFT minting
- [ ] Sample marketplace
- [ ] Live performance mode
- [ ] Cross-chain beat sharing
