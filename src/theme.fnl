
(defn theme []
  (local self {})

  (defn oct [n]
    (/ n 255))

  (set self.border-light [1.0 1.0 1.0 1.0])
  (set self.border-dark [0.2 0.2 0.2 1.0])

  (set self.content-background-idle [0.125490  0.176471  0.223529 1])
  (set self.content-background-hover [0.395588  0.477941  0.563235 1])
  (set self.content-background-selected  [0.207843  0.317647  0.431373 1])
  (set self.content-background-clicked [0.539216  0.539216  0.5392165 1])

  (set self.content-foreground-idle [0.1 0.1 0.1 1.0])
  (set self.content-foreground-hover [0.1 0.1 0.1 1.0])
  (set self.content-foreground-selected [0.1 0.1 0.1 1.0])
  (set self.content-foreground-clicked [0.1 0.1 0.1 1.0])

  ;(set self.main-background [(oct 16) (oct 16) (oct 16)])
  ;(set self.main-foreground [(oct 80) (oct 103) (oct 180)])
  (set self.main-background [(oct 16) (oct 16) (oct 16)])
  (set self.main-foreground [0.938889  0.515185  0.144445])

  (defn self.colour [colour alpha isfloaty]
    (let [ctable (. self colour)
          alpha (or (. ctable 4) alpha (and isfloaty 1) 255)]
      (if ctable
        (if isfloaty
          (love.graphics.setColor (. ctable 1) (. ctable 2) (. ctable 3) alpha)
          (love.graphics.setColor (. ctable 1) (. ctable 2) (. ctable 3) (oct alpha)))
        (print (.. "<!> WARNING colour " colour " not found")))))

  self)
