;; BeatFlow Smart Contract
;; Advanced rhythm mode and beat generation system
;; Version 1.0.0

;; ============================================================================
;; Error Constants
;; ============================================================================
(define-constant ERR-NOT-BOSS (err u100))
(define-constant ERR-BAD-BEAT (err u101))
(define-constant ERR-NO-MODE (err u102))
(define-constant ERR-DUP (err u103))
(define-constant ERR-ID-EXISTS (err u104))
(define-constant ERR-MUTED (err u105))
(define-constant ERR-INVALID-FREQ (err u106))
(define-constant ERR-MODE-INACTIVE (err u107))
(define-constant ERR-LOW-QUALITY (err u108))

;; ============================================================================
;; Data Variables
;; ============================================================================

;; Boss who controls the system
(define-data-var boss principal tx-sender)

;; Currently live mode
(define-data-var live-mode uint u1)

;; Total number of modes created
(define-data-var mode-count uint u3)

;; System mute status
(define-data-var muted bool false)

;; Total beats dropped
(define-data-var total-beats uint u0)

;; Boss's skill level
(define-data-var boss-skill uint u10)

;; Global BPM (beats per minute)
(define-data-var global-bpm uint u120)

;; Quality threshold for beats
(define-data-var quality-threshold uint u50)

;; Maximum frequency allowed
(define-data-var max-frequency uint u10000)

;; ============================================================================
;; Data Maps
;; ============================================================================

;; Mode definitions with properties
(define-map modes
  uint
  {
    name: (string-ascii 50),
    style: (string-ascii 200),
    hot: bool,
    birth: uint,
    drops: uint,
    rating: uint,
    bpm-range: uint
  }
)

;; Beat logs with detailed info
(define-map beats
  uint
  {
    mode-id: uint,
    maker: principal,
    drop: uint,
    vibe: uint,
    freq-x: uint,
    freq-y: uint,
    quality: uint,
    energy: uint
  }
)

;; Producer statistics
(define-map producer-stats
  principal
  {
    total-drops: uint,
    best-vibe: uint,
    avg-quality: uint,
    last-drop: uint,
    signature-mode: uint
  }
)

;; Mode popularity tracking
(define-map mode-popularity
  uint
  uint
)

;; User's beat collection
(define-map beat-collection
  principal
  (list 20 uint)
)

;; Collaboration records
(define-map collabs
  { beat-id: uint, collab-num: uint }
  principal
)

;; ============================================================================
;; Counters
;; ============================================================================

;; Beat counter
(define-data-var beat-count uint u0)

;; ============================================================================
;; Initial Setup
;; ============================================================================

;; Initialize default modes
(map-set modes u1 {
  name: "chill-wave",
  style: "Smooth flowing grooves with ambient textures",
  hot: true,
  birth: block-height,
  drops: u0,
  rating: u88,
  bpm-range: u90
})

(map-set modes u2 {
  name: "trap-snap", 
  style: "Hard hitting bass drops with crispy hi-hats",
  hot: false,
  birth: block-height,
  drops: u0,
  rating: u95,
  bpm-range: u150
})

(map-set modes u3 {
  name: "glitch-hop",
  style: "Broken chaotic rhythms with digital artifacts",
  hot: false,
  birth: block-height,
  drops: u0,
  rating: u82,
  bpm-range: u110
})

;; Initialize popularity
(map-set mode-popularity u1 u0)
(map-set mode-popularity u2 u0)
(map-set mode-popularity u3 u0)

;; ============================================================================
;; Private Helper Functions
;; ============================================================================

;; Verify boss authorization
(define-private (boss-check (who principal))
  (is-eq who (var-get boss))
)

;; Check if system is operational
(define-private (sound-on)
  (not (var-get muted))
)

;; Calculate beat quality
(define-private (calc-quality (x uint) (y uint))
  (let
    (
      (harmonic-ratio (if (> x u0) (/ y x) u0))
      (balance (if (< harmonic-ratio u2) u100 u50))
    )
    balance
  )
)

;; Calculate beat energy
(define-private (calc-energy (x uint) (y uint))
  (let
    (
      (total-freq (+ x y))
      (intensity (/ total-freq u10))
    )
    (if (> intensity u100) u100 intensity)
  )
)

;; Update producer statistics
(define-private (update-producer-stats (producer principal) (vibe uint) (quality uint) (mode-id uint))
  (let
    (
      (current-stats (default-to 
        { total-drops: u0, best-vibe: u0, avg-quality: u0, last-drop: u0, signature-mode: u1 }
        (map-get? producer-stats producer)))
      (new-total (+ (get total-drops current-stats) u1))
      (new-best (if (> vibe (get best-vibe current-stats)) vibe (get best-vibe current-stats)))
      (new-avg (/ (+ (* (get avg-quality current-stats) (get total-drops current-stats)) quality) new-total))
    )
    (map-set producer-stats producer {
      total-drops: new-total,
      best-vibe: new-best,
      avg-quality: new-avg,
      last-drop: block-height,
      signature-mode: mode-id
    })
  )
)

;; Validate frequency range
(define-private (valid-freq? (freq uint))
  (and (> freq u0) (<= freq (var-get max-frequency)))
)

;; ============================================================================
;; Read-Only Functions
;; ============================================================================

;; Get live mode
(define-read-only (whats-live)
  (var-get live-mode)
)

;; Get mode details
(define-read-only (peek-mode (id uint))
  (map-get? modes id)
)

;; List all modes
(define-read-only (all-modes)
  (list
    (peek-mode u1)
    (peek-mode u2)
    (peek-mode u3)
  )
)

;; Get beat details
(define-read-only (peek-beat (id uint))
  (map-get? beats id)
)

;; Total beats dropped
(define-data-var total-beats-counter uint u0)
;; Get boss
(define-read-only (who-boss)
  (var-get boss)
)

;; Check mute status
(define-read-only (is-muted)
  (var-get muted)
)

;; Get mode count
(define-read-only (get-mode-count)
  (var-get mode-count)
)

;; Get global BPM
(define-read-only (get-bpm)
  (var-get global-bpm)
)

;; Get quality threshold
(define-read-only (get-threshold)
  (var-get quality-threshold)
)

;; Get producer statistics
(define-read-only (get-producer-stats (producer principal))
  (map-get? producer-stats producer)
)

;; Get mode popularity
(define-read-only (get-popularity (mode-id uint))
  (default-to u0 (map-get? mode-popularity mode-id))
)

;; Get user's beat collection
(define-read-only (get-collection (user principal))
  (default-to (list) (map-get? beat-collection user))
)

;; Get boss skill level
(define-read-only (get-skill)
  (var-get boss-skill)
)

;; Get max frequency
(define-read-only (get-max-freq)
  (var-get max-frequency)
)

;; ============================================================================
;; Public Functions - Boss Only
;; ============================================================================

;; Switch to different mode
(define-public (switch (new-id uint))
  (let
    (
      (who tx-sender)
      (now (var-get live-mode))
      (data (map-get? modes new-id))
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (asserts! (sound-on) ERR-MUTED)
    (asserts! (is-some data) ERR-NO-MODE)
    (asserts! (not (is-eq now new-id)) ERR-DUP)
    
    ;; Cool current mode
    (match (map-get? modes now)
      curr (map-set modes now 
        (merge curr { hot: false }))
      false
    )
    
    ;; Heat new mode and increment drops
    (match data
      fresh (map-set modes new-id
        (merge fresh { 
          hot: true,
          drops: (+ (get drops fresh) u1)
        }))
      false
    )
    
    ;; Update live mode
    (var-set live-mode new-id)
    
    ;; Update popularity
    (map-set mode-popularity new-id 
      (+ (get-popularity new-id) u1))
    
    (ok new-id)
  )
)

;; Add new mode
(define-public (add-mode (id uint) (name (string-ascii 50)) (style (string-ascii 200)))
  (let
    (
      (who tx-sender)
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (asserts! (> (len name) u0) ERR-BAD-BEAT)
    (asserts! (is-none (map-get? modes id)) ERR-ID-EXISTS)
    
    (map-set modes id {
      name: name,
      style: style,
      hot: false,
      birth: block-height,
      drops: u0,
      rating: u50,
      bpm-range: u120
    })
    
    ;; Increment mode count
    (var-set mode-count (+ (var-get mode-count) u1))
    
    ;; Initialize popularity
    (map-set mode-popularity id u0)
    
    (ok id)
  )
)

;; Update mode rating
(define-public (rate-mode (id uint) (rating uint))
  (let
    (
      (who tx-sender)
      (mode-data (map-get? modes id))
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (asserts! (is-some mode-data) ERR-NO-MODE)
    (asserts! (<= rating u100) ERR-INVALID-FREQ)
    
    (match mode-data
      data (map-set modes id (merge data { rating: rating }))
      false
    )
    
    (ok true)
  )
)

;; Set global BPM
(define-public (set-bpm (bpm uint))
  (let
    (
      (who tx-sender)
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (asserts! (and (>= bpm u60) (<= bpm u200)) ERR-INVALID-FREQ)
    
    (var-set global-bpm bpm)
    (ok bpm)
  )
)

;; Set quality threshold
(define-public (set-threshold (threshold uint))
  (let
    (
      (who tx-sender)
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (asserts! (<= threshold u100) ERR-INVALID-FREQ)
    
    (var-set quality-threshold threshold)
    (ok threshold)
  )
)

;; Transfer boss role
(define-public (crown (new-boss principal))
  (let
    (
      (who tx-sender)
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (var-set boss new-boss)
    (ok new-boss)
  )
)

;; Mute system
(define-public (mute)
  (let
    (
      (who tx-sender)
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (var-set muted true)
    (ok true)
  )
)

;; Unmute system
(define-public (unmute)
  (let
    (
      (who tx-sender)
    )
    (asserts! (boss-check who) ERR-NOT-BOSS)
    (var-set muted false)
    (ok true)
  )
)

;; ============================================================================
;; Public Functions - Anyone
;; ============================================================================

;; Drop a beat
(define-public (drop (freq-x uint) (freq-y uint))
  (let
    (
      (now (var-get live-mode))
      (id (+ (var-get beat-count) u1))
      (vibe (calc-vibe now freq-x freq-y))
      (quality (calc-quality freq-x freq-y))
      (energy (calc-energy freq-x freq-y))
    )
    (asserts! (sound-on) ERR-MUTED)
    (asserts! (valid-freq? freq-x) ERR-INVALID-FREQ)
    (asserts! (valid-freq? freq-y) ERR-INVALID-FREQ)
    (asserts! (>= quality (var-get quality-threshold)) ERR-LOW-QUALITY)
    
    ;; Increment beat count
    (var-set beat-count id)
    
    ;; Log beat
    (map-set beats id {
      mode-id: now,
      maker: tx-sender,
      drop: block-height,
      vibe: vibe,
      freq-x: freq-x,
      freq-y: freq-y,
      quality: quality,
      energy: energy
    })
    
    ;; Update statistics
    (update-producer-stats tx-sender vibe quality now)
    
    ;; Update total beats
    (var-set total-beats (+ (var-get total-beats) u1))
    
    (ok vibe)
  )
)

;; Add beat to collection
(define-public (collect (beat-id uint))
  (let
    (
      (user tx-sender)
      (current-collection (get-collection user))
      (beat-exists (is-some (map-get? beats beat-id)))
    )
    (asserts! beat-exists ERR-NO-MODE)
    (asserts! (< (len current-collection) u20) ERR-INVALID-FREQ)
    
    (map-set beat-collection user 
      (unwrap-panic (as-max-len? (append current-collection beat-id) u20)))
    (ok true)
  )
)

;; ============================================================================
;; Private Calculation Functions
;; ============================================================================

;; Calculate vibe based on mode
(define-private (calc-vibe (mode uint) (x uint) (y uint))
  (if (is-eq mode u1)
    ;; Chill-wave: simple harmony
    (+ x y)
    (if (is-eq mode u2)
      ;; Trap-snap: explosive bass
      (* x (* y y))
      ;; Glitch-hop: broken rhythm
      (+ (* x u2) (/ y u2))
    )
  )
)