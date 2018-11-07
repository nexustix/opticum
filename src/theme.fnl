(defn theme []
  (local self {})

  (defn oct [n]
    (/ n 255))

  (defn is-float? [n]
    (not (= (math.floor n) n)))

  (defn alpha [colour alpha]
    [(. colour 1) (. colour 2) (. colour 3) alpha])

  (set self.white [1.0 1.0 1.0 1.0])
  ;(set self.white (hsl 150 100 200))
  (set self.black [0.0 0.0 0.0 0.0])

  (set self.border-light [1.0 1.0 1.0 1.0])
  (set self.border-dark [0.2 0.2 0.2 1.0])

  ;(set self.main-background [(oct 16) (oct 16) (oct 16)])
  ;(set self.main-foreground [(oct 80) (oct 103) (oct 180)])
  (set self.main-background [(oct 16) (oct 16) (oct 16)])
  (set self.main-foreground [0.938889  0.515185  0.144445])

  ;(set self.content-background-idle [0.125490  0.176471  0.223529 1])
  ;(set self.content-background-hover [0.395588  0.477941  0.563235 1])
  ;(set self.content-background-selected  [0.207843  0.317647  0.431373 1])
  ;(set self.content-background-clicked [0.539216  0.539216  0.5392165 1])

  ;(set self.content-foreground-idle [0.1 0.1 0.1 1.0])
  ;(set self.content-foreground-hover [0.1 0.1 0.1 1.0])
  ;(set self.content-foreground-selected [0.1 0.1 0.1 1.0])
  ;(set self.content-foreground-clicked [0.1 0.1 0.1 1.0])

  (set self.main-foreground-dimmest  (alpha self.main-foreground (oct 32)))
  (set self.main-foreground-dimmer   (alpha self.main-foreground (oct 64)))
  (set self.main-foreground-dim      (alpha self.main-foreground (oct 128)))

  (set self.bg self.main-background)
  (set self.fg self.main-foreground)

  (set self.fgd self.main-foreground-dim)
  (set self.fgdd self.main-foreground-dimmer)
  (set self.fgddd self.main-foreground-dimmest)

  (defn self.colour [colour alpha]
    (let [ctable (. self colour)
          isfloaty (or (and alpha (is-float? alpha)) (not alpha))
          ;alpha (or (. ctable 4) alpha (and isfloaty 1) 255)]
          alpha (or (and ctable (. ctable 4)) alpha 255)]
      (if ctable
        (if isfloaty
          (love.graphics.setColor (. ctable 1) (. ctable 2) (. ctable 3) alpha)
          (love.graphics.setColor (. ctable 1) (. ctable 2) (. ctable 3) (oct alpha)))
        (print (.. "<!> WARNING colour " colour " not found"))
        [1 0 1 1])))

  self)
