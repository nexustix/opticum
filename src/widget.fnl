(defn widget [x y w h]
  (local self {})

  (set self.transform
    { :x x
      :y y
      :w w
      :h h})

  (set self.theme ((require :theme)))

  (set self.enabled true)
  (set self.selected false)
  (set self.hovered false)
  (set self.clicked false)

  (defn self.on-select [])
  (defn self.on-hover [])
  (defn self.on-click [])

  (defn self.on-update [dt]
    ;TODO get position from mouse move events instead
    ;TODO move point inside rect logic somewhere else
    (let [(mx my) (love.mouse.getPosition)]
      (if (and (> mx self.transform.x) (< mx (+ self.transform.x self.transform.w))
            (> my  self.transform.y) (< my (+ self.transform.y self.transform.h)))
          (set self.hovered true)
          (set self.hovered false)))

    (if (love.mouse.isDown 1)
        (when self.hovered
          (set self.clicked true)
          (when self.editable
            (set self.selected true)))
        (do
          (set self.clicked false))))

  (defn self.on-draw []
    ;body
    (if self.clicked
        (self.theme.colour :content-background-clicked)
        self.hovered
        (self.theme.colour :content-background-hover)
        self.selected
        (self.theme.colour :content-background-selected)
        (self.theme.colour :content-background-idle))
    (love.graphics.rectangle "fill" self.transform.x self.transform.y self.transform.w self.transform.h)

    ;frame
    (if self.clicked
        (self.theme.colour :content-foreground-clicked)
        self.hovered
        (self.theme.colour :content-foreground-hover)
        (self.theme.colour :content-foreground-idle))
    (love.graphics.rectangle "line" (+ self.transform.x 1) (+ self.transform.y 1) (- self.transform.w 2) (- self.transform.h 2)))

  (defn self.on-event [nxevent])
  self)
