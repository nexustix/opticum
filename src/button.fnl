(local widget (require :widget))

(defn button [a]
  (local self (widget a))

  (set self.text "hello world")

  (set self.font (love.graphics.getFont))
  (set self.buffer (- (/ (- self.transform.h (: self.font :getHeight)) 2) 2))

  (tset self :on-draw
    (let [super self.on-draw]
      (fn []
        (super)
        ;(love.graphics.setColor 1 1 1 1)
        (self.theme.colour :main-foreground)
        ;(love.graphics.print self.text self.transform.x self.transform.y))))
        (love.graphics.printf self.text self.transform.x (+ self.transform.y self.buffer) self.transform.w "center"))))

  (defn self.on-clicked []
    (if (= self.text "hello world")
        (set self.text "the cake is a lie")
        (set self.text "hello world")))

  self)
