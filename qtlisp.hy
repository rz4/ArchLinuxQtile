;-
(require [hy.contrib.walk [let]])

;- STATIC
(setv form "(do (require [qtlisp [*]] [hy.contrib.walk [let]]) (fn [QTILE] {}))")

;--
(defmacro clear []
  `(do (import os)
       (os.remove (+ (os.path.expanduser "~") "/.cache/qtile/prompt_history"))
       (QTILE.restart)))

;--
(defmacro cmd [&rest args]
  `(QTILE.cmd-spawn ~(lfor a args (name a))))

;--
(defmacro terminal [&rest args]
  (macroexpand
    `(cmd alacritty -e bash -c ~@args)))

;--
(defmacro WWW [&optional [url None] &rest code]
  (setv url (if url [url] []))
  (macroexpand
    `(do (try (QTILE.delete-group "WWW") (except []))
         (QTILE.add-group "WWW")
         (.cmd_toscreen (get QTILE.groups-map "WWW"))
         (cmd qutebrowser -w ~@url)
         (QTILE.layout.flip))))
