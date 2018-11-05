(require-macros :nxoo2)
(local widget-rectangle (require :widget-rectangle))


(defn viewport [a]
  (local self (widget-rectangle a))

  (set self.canvas (love.graphics.newCanvas self.transform.w self.transform.h))

  (set self.selectable true)
  (set self.scrollable true)

  ;scroll x and y
  (set self.transform.sx (or self.transform.sx 0))
  (set self.transform.sy (or self.transform.sy 0))

  (defn self.scroll [rx ry]
    (set self.transform.sx (+ self.transform.sx (or rx 0)))
    (set self.transform.sy (+ self.transform.sy (or ry 0))))

  (defn self.enter []
    (love.graphics.setCanvas self.canvas)
    (love.graphics.push)
    (love.graphics.translate self.transform.sx self.transform.sy))

  (defn self.leave []
    (love.graphics.pop)
    (love.graphics.setCanvas))

  (decorate self.on-draw []
    ;(super))
    (self.theme.colour :fg 128)
    (love.graphics.rectangle "fill" self.transform.x self.transform.y self.transform.w self.transform.h)

    (let [(mode alphamode) (love.graphics.getBlendMode)]
      (self.theme.colour :white)
      (love.graphics.setBlendMode "alpha" "premultiplied")
      (love.graphics.draw self.canvas self.transform.x self.transform.y)
      (love.graphics.setBlendMode mode alphamode)))

  (decorate self.on-event [e]
    (or
      (super e)
      (if (= e.kind :mousedragged)
          (when self.selected
            (self.scroll e.dx e.dy)))))



  self)
