(require-macros :nxoo2)
(local widget (require :widget))

(defn widget-rectangle [a]
  (local self (widget a))

  (defn self.point-inside-p [p]
    (let [x (. p 1) y (. p 2)]
      (and
        (> x self.transform.x)
        (> y  self.transform.y)
        (< x (+ self.transform.x self.transform.w))
        (< y (+ self.transform.y self.transform.h)))))

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

    ;frame
    (if self.clicked
        (self.theme.colour :main-foreground)
        self.hovered
        (self.theme.colour :main-foreground)
        (self.theme.colour :main-foreground))
    (love.graphics.rectangle "line" (+ self.transform.x 1) (+ self.transform.y 1) (- self.transform.w 2) (- self.transform.h 2)))

  self)
