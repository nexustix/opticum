(local box-input (require :box-input))
(local button (require :button))
(local gui-manager (require :gui-manager))


(local theme ((require :theme)))

(local gm (gui-manager))

(gm.add-widget (box-input {:x 10 :y 10 :w 300 :h 40 :theme theme}))
(gm.add-widget (button {:x 10 :y 64 :w 300 :h 40 :theme theme}))

(gm.add-widget (button {:x 10 :y 256 :w 300 :h 40 :theme theme}))
(gm.add-widget (button {:x 200 :y 270 :w 300 :h 40 :theme theme}))


(defn love.load []
  (love.keyboard.setKeyRepeat true)
  (love.graphics.setDefaultFilter :nearest :nearest 0)
  (love.graphics.setBlendMode :alpha)

  (local font (love.graphics.newFont "assets/Hermit-medium.otf" 16))
  (love.graphics.setFont font)

  (gm.setup))


(defn love.draw []
  (theme.colour :main-background)
  (love.graphics.rectangle :fill 0 0 (love.graphics.getWidth) (love.graphics.getHeight)))
