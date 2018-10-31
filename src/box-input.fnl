(local widget (require :widget))

(local utf8 (require :utf8))

(defn inputbox []
  (local self (widget 10 10 120 40))

  ;(set self.theme ((require :theme)))

  (set self.font (love.graphics.getFont))
  (set self.text "")
  (set self.overflowing false)
  (set self.stable-len 0)

  (set self.counter 0)
  (set self.blinktime 50)
  (set self.cursor-visible false)

  (set self.editable true)

  (set self.buffer (- (/ (- self.transform.h (: self.font :getHeight)) 2) 2))

  (defn self.on-return [text]
    (set self.text ""))

  (tset self :on-update
    (let [super self.on-update]
      (fn []
        (super)

        (set self.counter (+ self.counter 1))

        (when (>= self.counter self.blinktime)
          (set self.cursor-visible (not self.cursor-visible))
          (set self.counter 0))

        (let [cur-len (+ (: self.font :getWidth self.text) (* self.buffer 2))]
          (if (> cur-len (- self.transform.w (* self.buffer 2)))
              (do)
              (set self.stable-len (# self.text)))))))

  (tset self :on-draw
    (let [super self.on-draw]
      (fn []
        (super)
        (var tmp-text self.text)
        (set tmp-text (string.sub tmp-text (- self.stable-len)))
        (when (and self.selected self.cursor-visible)
          (set tmp-text (.. tmp-text "|")))

        (love.graphics.setColor 1 1 1 1)
        (love.graphics.print tmp-text (+ self.transform.x self.buffer) (+ self.transform.y self.buffer))

        (love.graphics.setColor 1 1 1 1))))

  (defn self.on-event [e]
    (if (= e.kind :text)
        (when self.selected
          (set self.text (.. self.text e.text)))

        (= e.kind :keypressed
           (when self.selected
              ;(print e.key e.scancode e.isrepeat)
              ;(print self.stable-len)
              (if (= e.key :backspace)
                  (do
                    (local byteoffset (utf8.offset self.text -1))
                    ;(print byteoffset)
                    (when byteoffset
                      (set self.text (string.sub self.text 1 (- byteoffset 1)))))
                  (when (= e.key :return)
                    (self.on-return self.text)))))))



  self)
