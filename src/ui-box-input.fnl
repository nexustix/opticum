(require-macros :nxoo2)

(local widget-rectangle (require :widget-rectangle))

(local utf8 (require :utf8))

(defn inputbox [a]
  (local self (widget-rectangle a))

  (set self.selectable true)

  (set self.font (love.graphics.getFont))

  (set self.text "")

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

        (set self.font (love.graphics.getFont))
        (set self.stable-len (- (/ self.transform.w (: self.font :getWidth "_")) 3))
        (set self.buffer.h (/ (- self.transform.h (: self.font :getHeight "|")) 2))
        (set self.buffer.w (/ (- self.transform.w (* self.stable-len (: self.font :getWidth "_"))) 4)))))

  (decorate self.on-draw []
    (super)
    (var tmp-text self.text)
    (set tmp-text (string.sub tmp-text (- self.stable-len)))
    (when (and self.selected self.cursor-visible)
      (set tmp-text (.. tmp-text "|")))

    (self.theme.colour :main-foreground)
    (love.graphics.printf tmp-text (+ self.transform.x self.buffer.w) (+ self.transform.y self.buffer.h) (- self.transform.w self.buffer.w))

    (love.graphics.setColor 1 1 1 1))

  (decorate self.on-event-textinput [e]
    (or
      (super e)
      (when self.selected
        (set self.text (.. self.text e.text)))))

  (decorate self.on-event-keypressed [e]
    (or
      (super e)
      (when self.selected
         (if (= e.key :backspace)
             (do
               (local byteoffset (utf8.offset self.text -1))
               (when byteoffset
                 (set self.text (string.sub self.text 1 (- byteoffset 1)))))
             (when (= e.key :return)
               (self.on-return self.text))))))


  ;(set self.on-event
  ;  (let [super self.on-event]
  ;    (fn [e]
  ;      (super e)
  ;      (if (= e.kind :textinput)
  ;          (when self.selected
  ;            (set self.text (.. self.text e.text)))

  ;          (= e.kind :keypressed
  ;             (when self.selected
  ;                (if (= e.key :backspace)
  ;                    (do
  ;                      (local byteoffset (utf8.offset self.text -1))
  ;                      (when byteoffset
  ;                        (set self.text (string.sub self.text 1 (- byteoffset 1)))))
  ;                    (when (= e.key :return)
  ;                      (self.on-return self.text)))))))))

  self)
