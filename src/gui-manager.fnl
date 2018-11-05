(require-macros :nxoo2)

(local box-input (require :ui-box-input))
(local button (require :ui-button))
(local viewport (require :ui-viewport))

(defn gui-manager [the-love]
  (local self {})
  (set self.widgets {})
  (set self.counter 0)

  (set self.dragging [false false false])

  ;(let [(x y) (love.mouse.getPosition)]
  ;  (set self.dragging
  ;    { :lx x
  ;      :ly y
  ;      :rx x
  ;      :ry y
  ;      :mx x
  ;      :my y}))


  (defn alldo [todo args exclusively]
    (var done false)
    (for [i self.counter 1 -1]
      (when (not (and exclusively done))
        (set done ((. (. self.widgets i) todo) (unpack args))))))

  (defn self.add-widget [widget]
    (set self.counter (+ self.counter 1))
    (tset self.widgets self.counter widget)
    self.counter)

  (defn self.load-widget [a]
    (if (= a.kind :button)
        (self.add-widget (button a))
        (= a.kind :box-input)
        (self.add-widget (box-input a))
        (= a.kind :viewport)
        (self.add-widget (viewport a))
        (print "<!> error loading widget")))

  (defn self.get-widget [numid]
    (. self.widgets (or numid 0)))

  (defn self.find-widget [name]
    (var found false)
    (each [k v (pairs self.widgets)]
      (when (= v.name name)
        (set found v)))
    found)

  (defn self.setup [tlove]
    (local tlove (or tlove love))
    (set tlove.update
      (let [super (or tlove.update (fn []))]
        (fn [dt]
          (super dt)
          (alldo :on-update [dt]))))

    (decorate tlove.draw []
      (super)
      (alldo :on-draw []))

    (decorate tlove.textinput [t]
      (super t)
      (alldo :on-event [{:kind "text" :text t}] true))

    (decorate tlove.keypressed [key scancode isrepeat]
      (super key scancode isrepeat)
      (alldo :on-event [{:kind "keypressed" :key key :scancode scancode :isrepeat isrepeat}] true))

    (decorate tlove.mousepressed [x y button istouch presses]
      (super x y button istouch presses)
      (tset self.dragging button true)
      (alldo :on-event [{:kind "mousepressed" :x x :y y :button button :istouch istouch :presses presses}] true))

    (decorate tlove.mousereleased [x y button istouch presses]
      (super x y button istouch presses)
      (tset self.dragging button false)
      (alldo :on-event [{:kind "mousereleased" :x x :y y :button button :istouch istouch :presses presses}] true))

    (decorate tlove.mousemoved [x y dx dy istouch]
      (super x y dx dy istouch)
      (each [k v (pairs self.dragging)]
        (when v
          (alldo :on-event [{:kind "mousedragged" :x x :y y :dx dx :dy dy :istouch istouch}] true)))
      (alldo :on-event [{:kind "mousemoved" :x x :y y :dx dx :dy dy :istouch istouch}] true)))
  self)
