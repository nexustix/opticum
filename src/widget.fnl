(defn widget [a]
  (local self {})
  (local a (or a {}))

  ;name of widget
  (set self.name a.name)
  ;group of widget
  (set self.group a.group)

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
              ;(not self.hovered)
              ;(set self.selected false)))
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
