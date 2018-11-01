(defn widget [a]
  (local self {})

  (set self.transform
    { :x (or a.x 10)
      :y (or a.y 10)
      :w (or a.w 10)
      :h (or a.h 10)})

  (set self.theme (or a.theme ((require :theme))))

  (set self.enabled true)
  (set self.selected false)
  (set self.hovered false)
  (set self.clicked false)

  (defn self.on-selected [])
  (defn self.on-hovered [])
  (defn self.on-clicked [])

  (defn self.on-update [dt])
    ;TODO get position from mouse move events instead
    ;TODO move point inside rect logic somewhere else
    ;(let [(mx my) (love.mouse.getPosition)]
    ;  (if (and (> mx self.transform.x) (< mx (+ self.transform.x self.transform.w))
    ;        (> my  self.transform.y) (< my (+ self.transform.y self.transform.h)))
    ;      (set self.hovered true)
    ;      (set self.hovered false))))

  (defn self.on-draw []
    ;body
    (if self.clicked
        (self.theme.colour :main-foreground 200)
        self.hovered
        (self.theme.colour :main-foreground 128)
        self.selected
        (self.theme.colour :main-foreground 80)
        (self.theme.colour :main-foreground 64))
    (love.graphics.rectangle "fill" self.transform.x self.transform.y self.transform.w self.transform.h)

    frame
    (if self.clicked
        (self.theme.colour :main-foreground)
        self.hovered
        (self.theme.colour :main-foreground)
        (self.theme.colour :main-foreground))
    (love.graphics.rectangle "line" (+ self.transform.x 1) (+ self.transform.y 1) (- self.transform.w 2) (- self.transform.h 2)))

  (defn self.on-event [e]

    (if (and (= e.kind :mousepressed) (= e.button 1))
        (if self.hovered
            (do
              (set self.clicked true)
              (when self.enabled
                (set self.selected true))
              true))

        (and (= e.kind :mousereleased) (= e.button 1))
        (do
          (set self.clicked false)
          (when self.hovered
            (self.on-clicked)
            true))
        (and (= e.kind :mousemoved)
          (if (and (> e.x self.transform.x) (< e.x (+ self.transform.x self.transform.w))
                (> e.y  self.transform.y) (< e.y (+ self.transform.y self.transform.h)))
              (if (not self.hovered)
                  (do
                    (self.on-hovered)
                    (set self.hovered true)
                    true)
                  true)
              (set self.hovered false)))))

  self)
