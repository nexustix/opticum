(defn gui-manager [the-love]
  (local self {})
  (set self.widgets {})
  (set self.counter 1)

  (defn self.add-widget [widget]
    (tset self.widgets self.counter widget)
    (set self.counter (+ self.counter 1)))

  (defn alldo [todo args exclusively]
    (var done false)
    (for [i (- self.counter 1) 1 -1]
      ;(print i)
      (when (not (and exclusively done))
        (set done ((. (. self.widgets i) todo) (unpack args))))))

  (defn self.setup [tlove]
    (local tlove (or tlove love))
    (set tlove.update
      (let [super (or tlove.update (fn []))]
        (fn [dt]
          (super dt)
          (alldo :on-update []))))

    (set tlove.draw
      (let [super (or tlove.draw (fn []))]
        (fn []
          (super)
          (alldo :on-draw []))))

    (set tlove.textinput
      (let [super (or tlove.textinput (fn []))]
        (fn [t]
          (super t)
          (alldo :on-event [{:kind "text" :text t}] true))))

    (set tlove.keypressed
      (let [super (or tlove.keypressed (fn []))]
        (fn [key scancode isrepeat]
          (super key scancode isrepeat)
          (alldo :on-event [{:kind "keypressed" :key key :scancode scancode :isrepeat isrepeat}] true))))

    (set tlove.mousepressed
      (let [super (or tlove.mousepressed (fn []))]
        (fn [x y button istouch presses]
          (super x y button istouch presses)
          (alldo :on-event [{:kind "mousepressed" :x x :y y :button button :istouch istouch :presses presses}] true))))

    (set tlove.mousereleased
      (let [super (or tlove.mousereleased (fn []))]
        (fn [x y button istouch presses]
          (super x y button istouch presses)
          (alldo :on-event [{:kind "mousereleased" :x x :y y :button button :istouch istouch :presses presses}] true))))

    (set tlove.mousemoved
      (let [super (or tlove.mousemoved (fn []))]
        (fn [x y dx dy istouch]
          ;(super x y dx dy istouch)
          (alldo :on-event [{:kind "mousemoved" :x x :y y :dx dx :dy dy :istouch istouch}] true)))))

  self)
