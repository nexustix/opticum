(require-macros :nxoo2)

(local widget-rectangle (require :widget-rectangle))

(local utf8 (require :utf8))

(defn inputbox [a]
  (local self (widget-rectangle a))

  (set self.selectable true)

  ;(set self.theme ((require :theme)))

  (set self.font (love.graphics.getFont))
  ;(set self.font (love.graphics.newFont 16))

  (set self.text "")
  ;(set self.overflowing false)
  ;(set self.stable-len 0)
  (set self.stable-len (/ self.transform.w (: self.font :getWidth "_")))
  (set self.buffer
    { :w 10
      :h 10})

  (set self.counter 0)
  (set self.blinktime 50)
  (set self.cursor-visible false)

  (set self.editable true)

  (defn self.on-return [text]
    (set self.text ""))

  (set self.on-update
    (let [super self.on-update]
      (fn []
        (super)

        (set self.counter (+ self.counter 1))

        (when (>= self.counter self.blinktime)
          (set self.cursor-visible (not self.cursor-visible))
          (set self.counter 0))

        ;(let [cur-len (+ (: self.font :getWidth self.text) (* self.buffer 2))]
        ;  (if (> cur-len (- self.transform.w (* self.buffer 2)))
        ;      (do)
        ;      (set self.stable-len (# self.text)))))))
        (set self.font (love.graphics.getFont))
        (set self.stable-len (- (/ self.transform.w (: self.font :getWidth "_")) 3))
        (set self.buffer.h (/ (- self.transform.h (: self.font :getHeight "|")) 2))
        (set self.buffer.w (/ (- self.transform.w (* self.stable-len (: self.font :getWidth "_"))) 4)))))

  ;(set self.on-draw
  ;  (let [super self.on-draw]
  ;    (fn []
  (decorate self.on-draw []
    (super)
    (var tmp-text self.text)
    (set tmp-text (string.sub tmp-text (- self.stable-len)))
    (when (and self.selected self.cursor-visible)
      (set tmp-text (.. tmp-text "|")))

    (self.theme.colour :main-foreground)
    (love.graphics.printf tmp-text (+ self.transform.x self.buffer.w) (+ self.transform.y self.buffer.h) (- self.transform.w self.buffer.w))

    (love.graphics.setColor 1 1 1 1))

  (set self.on-event
    (let [super self.on-event]
      (fn [e]
        (super e)
        ;(print e.kind)
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
                        (self.on-return self.text)))))))))

  self)
