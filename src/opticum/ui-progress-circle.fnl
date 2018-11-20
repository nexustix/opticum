(require-macros :nxoo2)

(local widget-rectangle (require :opticum.widget-rectangle))

(defn conv-interval [value old-min old-max new-min new-max]
  (+ (/ (* (- value old-min) (- new-max new-min)) (- old-max old-min)) new-min))

(defn progress-cirlce [a]
  (local self (widget-rectangle a))

  (set self.linew 4)

  (set self.tx (+ self.transform.x (/ self.transform.w 2)))
  (set self.ty (+ self.transform.y (/ self.transform.h 2)))
  (set self.tr (- (/ self.transform.w 2) (/ self.linew 2) 2))

  ;values to calculate start/stop location
  (set self.tmin 0)
  (set self.tmax 840)

  ;start/stop location
  (set self.cmin 315)
  (set self.cmax 945)


  (set self.min 0)
  (set self.max 100)
  (set self.cur 50)

  (set self.begin (conv-interval self.cmin self.tmin self.tmax math.pi (- math.pi)))
  (set self.end (conv-interval self.cmax self.tmin self.tmax math.pi (- math.pi)))

  (defn self.stencil []
    (love.graphics.circle "line" self.tx self.ty self.tr))

  (decorate self.on-update [dt]
    (super dt)
    (set self.cur (% (+ self.cur (* 30 dt)) self.max)))

  (decorate self.on-draw []
    (self.theme.colour :fgddd)
    (love.graphics.rectangle "fill" self.transform.x self.transform.y self.transform.w self.transform.h)
    (self.theme.colour :fg)
    (let [lwidth-back (love.graphics.getLineWidth)]
      (love.graphics.setLineWidth self.linew)
      (love.graphics.stencil self.stencil)
      (love.graphics.setStencilTest :greater 0)

      (self.theme.colour :fg 128)
      (love.graphics.arc "line" self.tx self.ty self.tr self.begin self.end)

      (self.theme.colour :fg)
      (local foo (conv-interval self.cur self.max self.min self.begin self.end))
      (love.graphics.arc "line" self.tx self.ty self.tr foo self.end)

      (love.graphics.setStencilTest)
      (love.graphics.setLineWidth lwidth-back)))

  self)
