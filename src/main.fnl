;(local box-input (require :ui-box-input))
;(local button (require :ui-button))
;(local viewport (require :ui-viewport))
(local progress-circle (require :opticum.ui-progress-circle))
(local gui-manager (require :opticum.gui-manager))
(local testgui (require :testgui))

(local theme ((require :opticum.theme)))

(local gm (gui-manager))

(each [k v (pairs testgui)]
  (gm.load-widget v))


;(local mid (gm.add-widget (viewport {:name "map" :x 10 :y 10 :w 300 :h 300 :theme theme})))
;(local map (gm.get-widget mid))
(local map (gm.find-widget "map"))

;(gm.add-widget (progress-circle {:name "test-progress-circle" :x 10 :y 10 :w 64 :h 64 :theme theme}))


(defn love.load []
  (love.keyboard.setKeyRepeat true)
  (love.graphics.setDefaultFilter :nearest :nearest 0)
  ;(love.graphics.setBlendMode :alpha)

  (local font (love.graphics.newFont "assets/Hermit-medium.otf" 16))
  (love.graphics.setFont font)

  ;(print map)

  (gm.setup))

(defn love.update [dt])

(defn love.draw []
  (theme.colour :main-background)
  (love.graphics.rectangle :fill 0 0 (love.graphics.getWidth) (love.graphics.getHeight))

  (map.enter)
  (love.graphics.clear)
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.rectangle "fill" 10 10 64 64)
  (map.leave))
