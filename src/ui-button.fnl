(require-macros :nxoo2)
(local widget-rectangle (require :widget-rectangle))

(defn button [a]
  (local self (widget-rectangle a))

  (set self.text "hello world")

  (set self.font (love.graphics.getFont))
  (set self.buffer (- (/ (- self.transform.h (: self.font :getHeight)) 2) 2))

  (decorate self.on-draw []
        (super)
        (self.theme.colour :main-foreground)
        (love.graphics.printf self.text self.transform.x (+ self.transform.y self.buffer) self.transform.w "center"))

  (defn self.on-clicked []
    (if (= self.text "hello world")
        (set self.text "the cake is a lie")
        (set self.text "hello world")))

  self)
