;; ========================================
;; cygwin用 キーバインド再定義
;; ========================================
;;;; for terminal key translate (only mintty?)
(unless window-system
  (define-key input-decode-map "\e[1;5k" (kbd "C-;"))
  (define-key input-decode-map "\e[1;5l" (kbd "C-,"))
  (define-key input-decode-map "\e[1;5n" (kbd "C-."))
  (define-key input-decode-map "\e[1;5q" (kbd "C-!"))
  (define-key input-decode-map "\e[1;5r" (kbd "C-@"))
  (define-key input-decode-map "\e[1;5s" (kbd "C-#"))
  (define-key input-decode-map "\e[1;5t" (kbd "C-$"))
  (define-key input-decode-map "\e[1;5u" (kbd "C-%"))
  (define-key input-decode-map "\e[1;5v" (kbd "C-&"))
  (define-key input-decode-map "\e[1;5w" (kbd "C-'"))
  (define-key input-decode-map "\e[1;5x" (kbd "C-("))
  (define-key input-decode-map "\e[1;5y" (kbd "C-)"))
  (define-key input-decode-map "\e[59;5e" (kbd "C-:"))
  (define-key input-decode-map "\e[1;6k" (kbd "C-S-;"))
  (define-key input-decode-map "\e[1;6l" (kbd "C-S-,"))
  (define-key input-decode-map "\e[1;6m" (kbd "C-S--"))
  (define-key input-decode-map "\e[1;6n" (kbd "C-S-."))
  (define-key input-decode-map "\e[1;6q" (kbd "C-S-!"))
  (define-key input-decode-map "\e[1;6r" (kbd "C-S-@"))
  (define-key input-decode-map "\e[1;6s" (kbd "C-S-#"))
  (define-key input-decode-map "\e[1;6t" (kbd "C-S-$"))
  (define-key input-decode-map "\e[1;6u" (kbd "C-S-%"))
  (define-key input-decode-map "\e[1;6v" (kbd "C-S-&"))
  (define-key input-decode-map "\e[1;6w" (kbd "C-S-'"))
  (define-key input-decode-map "\e[1;6x" (kbd "C-S-("))

  (define-key input-decode-map "\e[1;8k" (kbd "C-M-S-;"))
  (define-key input-decode-map "\e[1;8l" (kbd "C-M-S-,"))
  (define-key input-decode-map "\e[1;8m" (kbd "C-M-S--"))
  (define-key input-decode-map "\e[1;8n" (kbd "C-M-S-."))
  (define-key input-decode-map "\e[1;8q" (kbd "C-M-S-!"))
  (define-key input-decode-map "\e[1;8r" (kbd "C-M-S-@"))
  (define-key input-decode-map "\e[1;8s" (kbd "C-M-S-#"))
  (define-key input-decode-map "\e[1;8t" (kbd "C-M-S-$"))
  (define-key input-decode-map "\e[1;8u" (kbd "C-M-S-%"))
  (define-key input-decode-map "\e[1;8v" (kbd "C-M-S-&"))
  (define-key input-decode-map "\e[1;8w" (kbd "C-M-S-'"))
  (define-key input-decode-map "\e[1;8x" (kbd "C-M-S-("))
  (define-key input-decode-map "\e[1;8y" (kbd "C-M-S-)"))

  (define-key input-decode-map "" (kbd "C-~"))
  (define-key input-decode-map "" (kbd "C-|"))
  (define-key input-decode-map "" (kbd "C-`"))
  (define-key input-decode-map "" (kbd "C-}"))

  (define-key input-decode-map "\e[1;7k" (kbd "C-M-;")))
