
(defn theme []
  (local self {})

  (set self.border-light [1.0 1.0 1.0 1.0])
  (set self.border-dark [0.2 0.2 0.2 1.0])

  (set self.content-background-idle [0.125490  0.176471  0.223529 1])
  (set self.content-background-hover [0.395588  0.477941  0.563235 1])
  (set self.content-background-selected  [0.207843  0.317647  0.431373 1])
  (set self.content-background-clicked [0.639216  0.639216  0.6392165 1])

  (set self.content-foreground-idle [0.1 0.1 0.1 1.0])
  (set self.content-foreground-hover [0.1 0.1 0.1 1.0])
  (set self.content-foreground-selected [0.1 0.1 0.1 1.0])
  (set self.content-foreground-clicked [0.1 0.1 0.1 1.0])

  (set self.main-background [0.0625 0.0625 0.0625 1])
  (set self.main-foreground [1 1 1 1])

  (defn self.colour [colour]
    (let [ctable (. self colour)]
      (if ctable
        (love.graphics.setColor (unpack ctable))
        (print (.. "<!> WARNING colour " colour " not found")))))

  self)
