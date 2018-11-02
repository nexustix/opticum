(defn widget [a]
  (local self {})
  (local a (or a {}))

  ;size and location of the widget
  (set self.transform
    { :x (or a.x 10)
      :y (or a.y 10)
      :w (or a.w 10)
      :h (or a.h 10)})

  ;theme of the widget
  (set self.theme (or a.theme ((require :theme))))
  (set self.shadow false)

  ;can the user interact with this element
  (set self.enabled true)
  ;is the element selectable
  (set self.selectable false)
  ;is the element selected
  (set self.selected false)
  ;is the user hovering over the element
  (set self.hovered false)
  ;is the element clicked
  (set self.clicked false)

  ;user has selected the element
  (defn self.on-selected [])
  ;user has hovered over the element
  (defn self.on-hovered [])
  ;user has clicked on the element
  (defn self.on-clicked [])


  (defn self.point-inside-p [p])

  (defn self.on-update [dt])

  (defn self.on-draw [])

  (defn self.on-event [e]
    (if (= e.kind :mousepressed)
        (do
          (if (and self.selectable self.hovered)
              (do
                (set self.selected true)
                (set self.clicked true)
                true)
              (do
                (set self.clicked self.hovered)
                self.hovered)))
        (= e.kind :mousereleased)
        (do
          (if (and self.hovered self.clicked)
              (do
                (self.on-clicked)
                (set self.clicked false)
                true)
              (set self.clicked false)))
        (= e.kind :mousemoved)
        (do
          (set self.hovered (self.point-inside-p [e.x e.y])))))

  self)

    ;(if (and (= e.kind :mousepressed) (= e.button 1))
    ;    (if self.hovered
    ;        (do
    ;          (set self.clicked true)
    ;          (when self.enabled
    ;            (set self.selected true))
    ;          true))

    ;    (and (= e.kind :mousereleased) (= e.button 1))
    ;    (do
    ;      (set self.clicked false)
    ;      (when self.hovered
    ;        (self.on-clicked)
    ;        true))
    ;    (and (= e.kind :mousemoved)
    ;      (if (and (> e.x self.transform.x) (< e.x (+ self.transform.x self.transform.w))
    ;            (> e.y  self.transform.y) (< e.y (+ self.transform.y self.transform.h)))
    ;          (if (not self.hovered)
    ;              (do
    ;                (self.on-hovered)
    ;                (set self.hovered true)
    ;                true)
    ;              true)
    ;          (set self.hovered false)))))
  ;self)
