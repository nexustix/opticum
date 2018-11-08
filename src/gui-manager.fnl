(require-macros :nxoo2)

(local box-input (require :ui-box-input))
(local button (require :ui-button))
(local viewport (require :ui-viewport))
(local progress-circle (require :ui-progress-circle))

(defn gui-manager [the-love]
  (local self {})
  (set self.widgets {})
  (set self.counter 0)

  (set self.dragging [false false false])

  (defn alldo [todo args exclusively]
    (var done false)
    ;HACK
    (local exclusively false)
    (local args (or args []))
    (for [i self.counter 1 -1]
      (when (not (and exclusively done))
        (set done ((. (. self.widgets i) todo) (unpack args)))
        (when (and (. args 1) (= (type (. args 1)) :table))
          (tset (. args 1) :consumed done)))))

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
        (= a.kind :progress-circle)
        (self.add-widget (progress-circle a))
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
      (local e {:kind "textinput" :text t})
      (alldo :on-event [e] true)
      (alldo :on-event-textinput [e] true))

    (decorate tlove.keypressed [key scancode isrepeat]
      (super key scancode isrepeat)
      (local e {:kind "keypressed" :key key :scancode scancode :isrepeat isrepeat})
      (alldo :on-event [e] true)
      (alldo :on-event-keypressed [e] true))

    (decorate tlove.mousepressed [x y button istouch presses]
      (super x y button istouch presses)
      (tset self.dragging button true)
      (local e {:kind "mousepressed" :x x :y y :button button :istouch istouch :presses presses})
      (alldo :on-event [e] true)
      (alldo :on-event-mousepressed [e] true))

    (decorate tlove.mousereleased [x y button istouch presses]
      (super x y button istouch presses)
      (tset self.dragging button false)
      (local e {:kind "mousereleased" :x x :y y :button button :istouch istouch :presses presses})
      (alldo :on-event [e] true)
      (alldo :on-event-mousereleased [e] true))

    (decorate tlove.mousemoved [x y dx dy istouch]
      (super x y dx dy istouch)
      (each [k v (pairs self.dragging)]
        (when v
          (local e {:kind "mousedragged" :x x :y y :dx dx :dy dy :istouch istouch :buttons self.dragging})
          (alldo :on-event [e] true)
          (alldo :on-event-mousedragged [e] true)))
      (local e {:kind "mousemoved" :x x :y y :dx dx :dy dy :istouch istouch})
      (alldo :on-event [e] true)
      (alldo :on-event-mousemoved [e] true)))
  self)
