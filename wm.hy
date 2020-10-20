;- Requires
(require [hy.contrib.walk [let]])

;- Imports
(import hy 
        [hy.contrib.hy-repr [hy-repr]]
        [libqtile.config [Screen Group Key]]
        [libqtile.command [lazy]]
        [libqtile [layout bar widget hook]]
        [libqtile.notify [notifier]]
        [libqtile.utils [guess-terminal]]
        [qtlisp [form]])

;- STATIC
(setv FG "#657B83"
      BG "#F3F2F2"
      BC "#B6C3C8"
      CC "#282828"
      FONT1 "overpass-extralight"
      FONT2 "overpass-heavy"
      FONT3 "overpass-extrabold")

;--
(defn create-prompt []
  (widget.Prompt :foreground FG
                 :prompt "\u03BB: "
                 :ignore-dups-history True
                 :font FONT2
                 :fontsize 12
                 :cursor-color CC))
 
;--
(defn get-widgets []
  [(widget.GroupBox :active BC
                    :inactive FG
                    :foreground FG
                    :highlight-method "block"
                    :spacing 0
                    :padding-y 10
                    :margin-x 0
                    :font FONT1)
   (widget.Sep :foreground FG :padding 5)
   (create-prompt)
   (widget.Sep :foreground FG :padding 5)
   (widget.Notify :foreground FG :font FONT1)
   (widget.Spacer)
   (widget.WindowName :foreground FG :font FONT3)
   (widget.Clock :foreground FG :font FONT1 :format "%B %d, %Y  %H:%M:%S")
   (widget.Sep :foreground FG :padding 5)
   (widget.CheckUpdates :foreground FG :font FONT1 :colour-have-updates CC)
   (widget.Net :foreground FG :font FONT1)
   (widget.Wlan :foreground FG :font FONT1)])
  
;--
(defn get-bar []
  (bar.Bar :widgets (get-widgets)
           :size 24
           :background BG
           :margin 0))

;--
(defn get-groups []
  (lfor i ['HOME] (Group (name i))))

;-- 
(defn get-layouts []
  [(layout.MonadTall :margin 32
                     :border-width 4
                     :border-normal BC
                     :border-focus FG)])

;--
(defn create-screens []
 [(Screen :top (get-bar))])

;--
(let [screens (create-screens)]
  (defn get-screens [] screens))

;--
(defn set-wallpaper []
  (.set-wallpaper (widget.Wallpaper :wallpaper "Desktop.jpg")))

;--
(defn get-extension-defaults [] {})

;-----

;--
(defn qtlisp-eval [qtile]
  (fn [cmd]
    (let [code (.format form cmd)
          out ((hy.eval (hy.read-str code) (globals)) qtile)]
      (.show notifier (hy-repr out)))))
    
;--
(defn run-prompt [qtile]
  (let [prompt (get qtile.widgets_map "prompt")
        eval-cmd (qtlisp-eval qtile)]
    (.start-input prompt "" eval-cmd "file")))

;--
(defn get-keys []
  (let [mod "mod4" alt "mod1"]
    [(Key [mod 'shift] 'space (.flip lazy.layout))
     (Key [mod 'shift] 'r (.normalize lazy.layout))
     (Key [mod 'shift] 'Up (.shuffle-up lazy.layout))
     (Key [mod 'shift] 'Down (.shuffle-down lazy.layout))
     (Key [mod 'shift] 'Left (.shrink lazy.layout))
     (Key [mod 'shift] 'Right (.grow lazy.layout))
     (Key [mod alt] 'e (.shutdown lazy))
     (Key [mod alt] 'r (.restart lazy))
     (Key [mod alt] 'Delete (.kill lazy.window))
     (Key [mod alt] 'Left (.prev-group lazy.screen))
     (Key [mod alt] 'Right (.next-group lazy.screen))
     (Key [mod] 'Left (.left lazy.layout))
     (Key [mod] 'Right (.right lazy.layout))
     (Key [mod] 'Up (.up lazy.layout))
     (Key [mod] 'Down (.down lazy.layout))
     (Key [mod] 'space (lazy.function run-prompt))
     (Key [mod] 'Return (lazy.spawn (guess-terminal)))]))

  
