(local box-input (require :box-input))

(local ib (box-input))


(defn love.load []
  (love.keyboard.setKeyRepeat true))
  ;(local font (love.graphics.newFont "assets/font.ttf" 16))
  ;(love.graphics.setFont font))

(defn love.update [dt]
  (ib.on-update dt))
  ;(ib.update dt))

(defn love.draw []
  (ib.on-draw))
  ;(ib.draw))

(defn love.textinput [t]
  (ib.on-event {:kind "text" :text t}))

(defn love.keypressed [key scancode isrepeat]
  (ib.on-event {:kind "keypressed" :key key :scancode scancode :isrepeat isrepeat}))
