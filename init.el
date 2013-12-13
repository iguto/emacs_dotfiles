;; ============================================================
;; load-path追加
;; ============================================================
;; normal-top-level-add-subdirs-to-load-pathを指定すると、ディレクトリを再帰的にたどってくれます。
(let ((default-directory "~/.emacs.d/site-lisp/"))
  (setq load-path (cons default-directory load-path))
  (normal-top-level-add-subdirs-to-load-path))
;; ============================================================
;; 個別に設定していた頃のload-path設定
;; ============================================================
;; (add-to-list 'load-path "~/.emacs.d/site-lisp")

;; (add-to-list 'load-path "/usr/share/emacs/site-lisp")
;;(add-to-list 'load-path "/usr/share23/emacs/site-lisp/emacs-mozc")
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/remember-el")

;; ;; 最新のorg-mode statableへのパス
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-7.5/lisp")
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-7.5/contrib/lisp")

;; howm へのパス
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/howm")

;; ===========================================================
;; 補完に関する設定
;; ===========================================================
;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
;; 単語単位で補完する
;; p_hでpublic_htmlが補完できる． 区切り文字には .-_ が使える
;;(partial-completion-mode t)

;; ============================================================
;; 表示/設定
;; ============================================================
;; (tool-bar-mode nil)                  ; ツールバー非表示
;;(set-scroll-bar-mode nil)            ; スクロールバー非表示

;; (set-background-color "black")
;; (set-foreground-color "white")
;; (set-face-foreground 'font-lock-comment-face "green")
;; (set-face-foreground 'font-lock-string-face "blue")
;; (set-face-foreground 'font-lock-keyword-face "PaleGreen")
;; (set-face-foreground 'font-lock-function-name-face "green")
;; (set-face-foreground 'font-lock-warning-face "gold")
;; (set-face-background 'region "RosyBrown")
;; ;(set-frame-background-color "white") ; error on utrillo1
;; (set-face-background 'mode-line "skyblue")
;; (set-face-background 'mode-line "purple")
;; (set-face-background 'highlight "gray")


;; ;; ----現在行に色をつける----
;; (defface hlline-face
;;   '((((class color)
;;       (background dark))
;;      ;(:background "dark slate gray"))
;;      (:background "color-233"))
;;     (((class color)
;;       (background light))
;;      ;(:background "ForestGreen"))
;;      (:background "color-233"))
;;     (tool-bar-mode ()))
;;   "*Face used by hl-line.")
;; (setq hl-line-face 'hlline-face)
(global-hl-line-mode t)

;; ;; ---- 対応する括弧を強調 ----
(show-paren-mode t)

;; ;; ----下のエリアでの入力キー表示速度を早くする----
(setq echo-keystrokes 0.1)
(setq max-lisp-eval-depth 1000)

;; ========================================
;; org-mode用の設定(font-lock-mode)
;; ========================================
(add-hook 'org-mode-hook 'turn-on-font-lock) ;；org-mode の強調表示を有効にする
;; ----最近使ったファイルを記憶----
;; ********************
;; M-x recentf-open-files で最近開いたファイル一覧をバッファに表示する
;; 先頭10ファイルは数字を押して直接開ける
;; それ以前のファイルは移動してRETして開く
;; EmacsのバッファなのでC-sで検索できる
;; ********************
(require 'recentf-ext)
;; 最近使ったファイルを5000件記憶
(setq recentf-max-saved-items 5000)
;; 最近使ったファイルに加えないファイルを正規表現で指定する
(setq recentf-exclude '("TAGS$" "/var/tmp/"))

;; ============================================================
;; 機能追加
;; ============================================================

;; ========================================
;; クリップボード共有
;; ========================================
;; (setq x-select-enable-clipboard t)

;; ========================================
;; flymake
;; ========================================
;; ;; ---- リアルタイム文法チェック
;; ;;  flymake for ruby
(require 'flymake)
; I don't like the default colors :)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")
; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook
 'ruby-mode-hook
 '(lambda ()
    ; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))))

;; ;; ========================================
;; ;; flymake c++
;; ;; ========================================
;; (defun flymake-cc-init ()
;;   (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;          (local-file  (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
;; (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
;; (add-hook 'c++-mode-hook
;;           '(lambda ()
;;              (flymake-mode t)))

;; ============================================================
;; キーボードマクロ
;; ============================================================

;; ;; カーソル位置の上の行に新しい行を挿入する
;; (fset 'insert-newline-at-prevline
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("" 0 "%d")) arg)))
;; ;; キー割り当て: C-O
;; (global-set-key "\C-O" 'insert-newline-at-prevline)

;; 現在の次の行を開く
;; ;; カーソル位置の上の行に新しい行を挿入する
(fset 'open-nextline
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("" 0 "%d")) arg)))
(global-set-key "\C-o" 'nil)

;; ============================================================
;; キーバインド
;; ============================================================
;; ;; C-h をバックスペースに。
(global-set-key "\C-h" 'backward-delete-char)


;; ;; ============================================================
;; ;; コマンド拡張?
;; ;; ============================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-default-style (quote ((c-mode . "") (c++-mode . "") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(org-agenda-files nil)
 '(org-export-html-with-timestamp t)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "Ricty"))))
 '(cursor ((((class color) (background dark)) (:background "#00AA00")) (((class color) (background light)) (:background "#999999")) (t nil))))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))



;; ; タブ幅
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil) ; 空白でインデント
(defun indent-set ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset   2  ) ; ブロック内のインデント数
  (setq tab-width        2  ) ; タブのインデント数
)

;;(require 'untabify-file)

;; c-indent
(add-hook 'c-mode-common-hook
          '(lambda ()
             ;; センテンスの終了である ';' を入力したら、自動改行+インデント
             ;; (c-toggle-auto-hungry-state 1)
             (setq c-tab-always-indent nil)
             ;; RET キーで自動改行+インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
             (c-set-offset 'inline-open 0)
             (c-set-offset 'inline-close 0)
))


;; ============================================================
;; タブ, 全角スペース, 行末空白表示
;; ============================================================
(defface my-face-b-1 '((t (:background "NavajoWhite4"))) nil) ; 全角スペース
(defface my-face-b-2 '((t (:background "gray10"))) nil) ; タブ
(defface my-face-u-1 '((t (:background "SteelBlue" :underline t))) nil) ; 行末空白表示
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
 (font-lock-add-keywords major-mode '(("\t" 0 my-face-b-2 append)
 ("　" 0 my-face-b-1 append)
 ("[ \t]+$" 0 my-face-u-1 append)
 )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; (defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
;; (defface my-face-b-2 '((t (:background "gray26"))) nil)
;; (defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;; (defvar my-face-b-1 'my-face-b-1)
;; (defvar my-face-b-2 'my-face-b-2)
;; (defvar my-face-u-1 'my-face-u-1)
;; (defadvice font-lock-mode (before my-font-lock-mode ())
;;   (font-lock-add-keywords
;;    major-mode
;;    '(
;;      ("　" 0 my-face-b-1 append)
;;      ("\t" 0 my-face-b-2 append)
;;      ("[ ]+$" 0 my-face-u-1 append)
;;      )))
;; (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;; (ad-activate 'font-lock-mode)
;; (add-hook 'find-file-hooks '(lambda ()
;; (if font-lock-mode
;; nil
;; (font-lock-mode t))) t)


;; ;; ========================================
;; ;; ========================================
;; ;;   別ファイルに分けたい内容
;; ;; ========================================
;; ;; ========================================

;; ;; 外部elのインストールが必要な設定

;; ========================================
;; anything
;; ========================================
;; ---- anything.el ----
(require 'anything-startup)
(require 'anything-config)
(add-to-list 'anything-sources 'anything-c-source-emacs-commands) ;;'anything-c-source-complex-command-history)

(defun my-anything ()
  "Anything command for you.
It is automatically generated by `anything-migrate-sources'."
  (interactive)
  (anything-other-buffer
   '(anything-c-source-buffers+
     anything-c-source-recentf
     anything-c-source-files-in-current-dir+
     anything-c-source-locate)
   "*my-anything*"))
(define-key global-map (kbd "C-x b") 'my-anything)


;; ========================================
;; elisp install
;; ========================================
;; ----emacsから自動でlispをインストールできるようにする----
;; install-elispを読み込む
(require 'install-elisp)
;; install-elispがdlするlispの保存先を指定する
(setq install-elisp-repository-directory "~/.emacs.d/site-lisp/auto-install")

;; ---- 上位版の設定 ----
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/site-lisp/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; ;; ---- さらに上位版 ----
;; ;; 参考URL: http://d.hatena.ne.jp/rubikitch/20101209
;; ;; (save-window-excursion (shell-command (format "emacs-test -l %s %s &" buffer-file-name buffer-file-name)))
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get/")
;; (require 'el-get)
;; (load "2010-12-09-095707.el-get-ext.el")
;; ;; 初期化ファイルのワイルドカードを指定する
;; (setq el-get-init-files-pattern "~/emacs/init.d/[0-9]*.el")
;; (setq el-get-sources (el-get:packages))
;; (el-get)


;; 略語から定型文の挿入
;;(require 'yasnippet-config)
;; 推奨設定を関数にまとめている??
;;(yas/setup "~/.emacs.d/plugins/yasnippet-0.6.1c")
;; XXX エラー ファイルが見つからない？


;; ----------------------------------------
;; popwin  http://d.hatena.ne.jp/m2ym/searchdiary?word=*[Emacs]
;; ----------------------------------------
;; default setting
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;; settiong for popup *anything* buffer
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)

;; for dired buffer
(push '(dired-mode :position top) popwin:special-display-config)

(require 'dired-x)

;; ----------------------------------------
;; one-key  http://d.hatena.ne.jp/tomoya/20090415/1239809615
;; ----------------------------------------
;; (require 'one-key-default)              ;one-key.elも読み込む
;; (require 'one-key-config)
;; (one-key-default-setup-keys)

;; ----------------------------------------
;; tramp  リモートファイルを編集する
;; ----------------------------------------
(require 'tramp)
(setq tramp-default-method "scpx")

;; ;; ==========================================
;; ;; caroo.el カクー Webのドローツール
;; ;; ==========================================
;; (require 'cacoo)
;; (global-set-key (kbd "M--") 'toggle-cacoo-minor-mode)
;; (setq cacoo:api-key "D3OEYjRAfLAlmuk7K8lW")
;; (require 'cacoo-plugins)      ; 追加機能
;; ;; 追加設定
;; (setq cacoo:img-dir-ok t) ; 画像フォルダは確認無しで作る

;; ========================================
;; org-remenber メモツール
;; 参考:http://d.hatena.ne.jp/rubikitch/20090121/1232468026
;; ========================================
(require 'org-install)
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(org-remember-insinuate)
(setq org-directory "~/memo/")
(setq org-default-notes-file (concat org-directory "agenda.org"))
(setq org-remember-templates
      '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
        ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
        ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
        ))

;; ============================================================
;; edit-grep
;; ============================================================
(require 'grep-edit)

;; ============================================================
;; ruby-block endに対応するブロックを示す
;; ============================================================
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;; ============================================================
;; 行番号兼スクロールバー
;; ============================================================
;;(require 'yalinum)
;; (global-linum-mode t)
;;(global-yalinum-mode t)


;===================================
; Dired
;===================================
;; (require 'ls-lisp)
;; (let (current-load-list)
;;   (defadvice insert-directory
;;     (around reset-locale activate compile)
;;     (let ((system-time-locale "C"))
;;       ad-do-it)))

;; ============================================================
;; html-helper-mode
;; ============================================================
(require 'html-helper-mode)
(autoload 'htmp-helper-mode "html-helper-mode" "Yay HTML" t)

;; ============================================================
;; フォント
;; ============================================================
(add-to-list 'default-frame-alist '(font . "Ricty-11"))

;; ============================================================
;; flymake c/c++
;; ============================================================
(setq gcc-warning-options
      '("-Wall" "-Wextra" "-Wformat=2" "-Wstrict-aliasing=2" "-Wcast-qual"
      "-Wcast-align" "-Wwrite-strings" "-Wfloat-equal"
      "-Wpointer-arith" "-Wswitch-enum"
      ))
(setq gxx-warning-options
      `(,@gcc-warning-options "-Woverloaded-virtual" "-Weffc++")
      )
(setq gcc-cpu-options '("-msse" "-msse2" "-mmmx"))
(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name)))
       )
    (list "gcc" `(,@gcc-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c99" ,local-file))
    ))
(push '(".+\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
(add-hook 'c-mode-hook '(lambda () (flymake-mode t)) )

(defun flymake-c++-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" `(,@gxx-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c++0x" ,local-file))
    ))
(push '(".+\\.h$" flymake-c++-init) flymake-allowed-file-name-masks)
(push '(".+\\.cpp$" flymake-c++-init) flymake-allowed-file-name-masks)
(add-hook 'c++-mode-hook '(lambda () (flymake-mode t)) )
;; ============================================================
;;; dmacro.el の設定  キー操作の繰り返しを C-t で
;; ============================================================
(defconst *dmacro-key* "\C-t" "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)

;; ============================================================
;; csv-mode
;; ============================================================
;;; 20081206 csv-mode.el
;;; http://d.hatena.ne.jp/amt/20081206/CsvMode4Emacs
;;(add-to-list 'load-path "~/install/elisp/cvs-mode-el/")
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

;; ============================================================
;; mark-ring
;; ============================================================
;; enable to pop `mark-ring' repeatedly like C-u C-SPC C-SPC ...
(setq set-mark-command-repeat-pop t)

;; ============================================================
;; e2wm 複数ウィンドウを表示するマネージャ？
;; ============================================================
;最小の e2wm 設定例
(require 'e2wm)
(global-set-key (kbd "M-+") 'e2wm:start-management)

;; commentの設定
(defconst comment-styles
  '((plain	. (nil nil nil nil))
    (indent	. (nil nil nil t))
    (indent-or-triple
                . (nil nil nil multi-char))
    (aligned	. (nil t nil t))
    (multi-line	. (t nil nil t))
    (extra-line	. (t nil t t))
    (box	. (nil t t t))
    (box-multi	. (t t t t)))
  "Comment region styles of the form (STYLE . (MULTI ALIGN EXTRA INDENT)).
STYLE should be a mnemonic symbol.
MULTI specifies that comments are allowed to span multiple lines.
ALIGN specifies that the `comment-end' markers should be aligned.
EXTRA specifies that an extra line should be used before and after the
  region to comment (to put the `comment-end' and `comment-start').
INDENT specifies that the `comment-start' markers should not be put at the
  left margin but at the current indentation of the region to comment.
If INDENT is `multi-char', that means indent multi-character
  comment starters, but not one-character comment starters.")
;; comment-style (indent, multi-line, box)
(setq comment-style 'indent)
;; (setq comment-style 'indent-or-triple)
;; (setq comment-style 'aligned)
;; (setq comment-style 'multi-line)
;; (setq comment-style 'extra-line)
;; (setq comment-style 'box)
;; (setq comment-style 'box-multi)

 ;;;;;;;;;;;;;;;;;;;;
 ;; ウィンドウ移動  ;;
 ;;;;;;;;;;;;;;;;;;;;

;; 反対側のｳｨﾝﾄﾞｳにいけるように
(setq windmove-wrap-around t)
;; C-M-{p,n,f,b}でｳｨﾝﾄﾞｳ間を移動
(define-key global-map (kbd "C-M-p") 'windmove-up)
(define-key global-map (kbd "C-M-n") 'windmove-down)
(define-key global-map (kbd "C-M-f") 'windmove-right)
(define-key global-map (kbd "C-M-b") 'windmove-left)
;; !! ruby-modeのカーソル移動と競合してる？

;; ============================================================
;; 文字コード
;; ============================================================
(set-language-environment "japanese")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; ============================================================
;; mozc
;; ============================================================
(load-library "mozc")
(require 'mozc)
;;(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(global-set-key (kbd "C-\\") 'toggle-input-method)

;; ;; ============================================================
;; ;; Rsense
;; ;; ============================================================
(setq rsense-home "/opt/rsense-0.3")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
;; C-c . で補完
 (add-hook 'ruby-mode-hook
          (lambda ()
;;            (add-to-list 'ac-sources 'ac-source-rsense-method)
;;            (add-to-list 'ac-sources 'ac-source-rsense-constant)
             (local-set-key (kbd "C-c .") 'rsense-complete)
;;            ;; (local-set-key (kbd "C-c .") 'ac-complete-rsense)))
 ))
;; ac-sources
;; ac-source-rsense-method
;; ac-rsense-candidates

;; ac-source-rsense-constant
;; (candidates)

;;;;;;;;;;;;;;
;; inf-ruby ;;
;;;;;;;;;;;;;;
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)))

;;;;;;;;;;;;;;;;;;;;;;
;; ruby-electric.el ;;
;;;;;;;;;;;;;;;;;;;;;;

(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;;;;;;;;;
;; tab ;;
;;;;;;;;;
(setq tab-stop-list
      '(2 5 8 11 14 17 20 23 26 29 32 35 ...))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shell-script-mode indent ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq sh-basic-offset 2)
(setq sh-indentation 2)

;; ;;;;;;;;;;;;;;;;;;
;; ;; emacs-client ;;
;; ;;;;;;;;;;;;;;;;;;
;; ;; ref: http://d.hatena.ne.jp/khiker/20110508/gnus
;; (require 'server)
;; (unless (server-running-p)
;; (server-start))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view-mode: less like  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; change mode-line color on view-mode
;; (progn
;;  (require 'viewer)
;;  (viewer-stay-in-setup)
;;  (setq viewer-modeline-color-unwritable "tomato"
;;        viewer-modeline-color-view "orange")
;;  (viewer-change-modeline-color-setup))

;; ;; change keybind
;; (progn
;;  (setq pager-keybind
;;        `( ;; vi-like
;;          ("h" . backward-char)
;;          ("l" . forward-char)
;;          ("j" . next-line)
;;          ("k" . previous-line)
;;          ("b" . scroll-down)
;;          (" " . scroll-up)
;;          ("w" . forward-word)
;;          ("e" . backward-word)
;;          ("J" . ,(lambda () (interactive) (scroll-up 1)))
;;          ("K" . ,(lambda () (interactive) (scroll-down 1)))
;;          ))
;;  (defun define-many-keys (keymap key-table &optional includes)
;;    (let (key cmd)
;;      (dolist (key-cmd key-table)
;;        (setq key (car key-cmd)
;;              cmd (cdr key-cmd))
;;        (if (or (not includes) (member key includes))
;;          (define-key keymap key cmd))))
;;    keymap)
;;  (defun view-mode-hook--pager ()
;;    (define-many-keys view-mode-map pager-keybind))
;;  (add-hook 'view-mode-hook 'view-mode-hook--pager)
;;  (global-set-key [f11] 'view-mode)
;; )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; rcodetools: edit ruby file tool ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'anything)
;; (require 'anything-rcodetools)
;; ;; Command to get all RI entries.
;; (setq rct-get-all-methods-command "PAGER=cat fri -l")
;; ;; See docs
;; (define-key anything-map "\C-e" 'anything-execute-persistent-action)

;; ============================================================
;; whitespace-mode not work?
;; ============================================================
;; for whitespace-mode

;; (require 'whitespace)
;; ;; see whitespace.el for more details
;; (setq whitespace-style '(face tabs tab-mark spaces space-mark))
;; (setq whitespace-display-mappings
;;       '((space-mark ?\u3000 [?\u25a1])
;;         ;; WARNING: the mapping below has a problem.
;;         ;; When a TAB occupies exactly one column, it will display the        ;; character ?\xBB at that column followed by a TAB which goes to        ;; the next TAB column.
;;         ;; If this is a problem for you, please, comment the line below.
;;         (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
;; (setq whitespace-space-regexp "\\(\u3000+\\)")
;; (set-face-foreground 'whitespace-tab "#adff2f")
;; ;(set-face-background 'whitespace-tab 'nil)
;; ;(set-face-underline  'whitespace-tab t)
;; (set-face-foreground 'whitespace-space "#7cfc00")
;; (set-face-background 'whitespace-space 'nil)
;; (set-face-bold-p 'whitespace-space t)
;; (global-whitespace-mode 1)
;; (global-set-key (kbd "C-x w") 'global-whitespace-mode)


;; ============================================================
;; whitespace-mode
;; ============================================================

(require 'whitespace)
(setq whitespace-style
      '(face tabs tab-mark spaces space-mark newline newline-mark))

(setq whitespace-display-mappings      '(
        (space-mark ?\u3000 [?□])  ; 全角スペース
        (space-mark ?\u0020 [?\xB7])  ; 半角スペース
        (newline-mark ?\n   [?$ ?\n]) ; 改行記号
        ) )

(setq whitespace-space-regexp "\\([\x0020\x3000]+\\)" )
;正規表現に関する文書。 Emacs Lispには、正規表現リテラルがないことへの言及
;http://www.mew.org/~kazu/doc/elisp/regexp.html
;
;なぜか、全体をグループ化 \(\) しておかないと、うまくマッチしなかった罠
;
(set-face-foreground 'whitespace-space "blue")
(set-face-background 'whitespace-space 'nil)
(set-face-bold-p 'whitespace-space t)

(set-face-foreground 'whitespace-newline  "DimGray")
(set-face-background 'whitespace-newline 'nil)


;;
;; ruby-mode でencoding: utf-8 自動挿入をOFFにする
;;
(defun ruby-mode-set-encoding () ())






;;
;; 行末の空白を保存時に削除
;;
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;
;; ruby-electric-curliesの動作をカスタマイズ
;;  { _} だったカーソル位置を { _ } となるようにした
;;
(defun ruby-electric-curlies(arg)
  (interactive "P")
  (self-insert-command (prefix-numeric-value arg))
  (if (ruby-electric-is-last-command-char-expandable-punct-p)
      (cond ((ruby-electric-code-at-point-p)
             (save-excursion
               (if ruby-electric-newline-before-closing-bracket
                   (progn
                     (newline)
                     (insert "}")
                     (ruby-indent-line t))
                 (progn
                   (insert "  ")
                   (insert "}")
                 ))) (forward-char 1) )
            ((ruby-electric-string-at-point-p)
             (if (eq last-command-event ?{)
                 (save-excursion
                   (backward-char 1)
                   (or (char-equal ?\# (preceding-char))
                       (insert "#"))
                   (forward-char 1)
                   (insert "}")))))))


;;
;; menuを隠す
;;
(cond
 (window-system (tool-bar-mode -1))
 (t (menu-bar-mode -1)))


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;
;; modes for rails
;;
; rails-mode
;(require 'rails)
; rhtml-mode
(require 'rhtml-mode)
; カーソルキーが必要でよく使うキーバインドを変更
;(define-key rails-minor-mode-map "\C-c\C-p" 'rails-lib:run-primary-switch)
;(define-key rails-minor-mode-map "\C-c\C-n" 'rails-lib:run-secondary-switch)

;(define-key rails-minor-mode-map "\C-c\C-c" 'prefix)
;(define-prefix-command
;(message rails-minor-mode-global-prefix-key)
;(message rails-minor-mode-local-prefix-key)
;(setq rails-minor-mode-local-prefix-key "\C-c\C-c\C-c")


;; rinari
(setq rinari-minor-mode-prefixes (list "\C-c"))
;; HOWTO: $ ctags-exuberant -a -e -f TAGS --tag-relative -R app lib vendor
(setq rinari-tags-file-name "TAGS")
(require 'rinari)
(add-hook 'emacs-startup-hook
          (function (lambda ()
                      (global-rinari-mode))))
;;
;; yasnipet-bundle 自動補完
;;
(require 'yasnippet)
(yas/initialize)
;; (yas/load-directory
;;  (concat (file-name-directory (or load-file-name buffer-file-name))
;; 	 "snippets/rails-snippets/"))
(yas/global-mode t)
(yas/load-directory "~/.emacs.d/snippets/yasnippets-rails")

;; anything interface
(eval-after-load "anything-config"
  '(progn
     (defun my-yas/prompt (prompt choices &optional display-fn)
       (let* ((names (loop for choice in choices
                           collect (or (and display-fn (funcall display-fn choice))
                                       choice)))
              (selected (anything-other-buffer
                         `(((name . ,(format "%s" prompt))
                            (candidates . names)
                            (action . (("Insert snippet" . (lambda (arg) arg))))))
                         "*anything yas/prompt*")))
         (if selected
             (let ((n (position selected names :test 'equal)))
               (nth n choices))
           (signal 'quit "user quit!"))))
     (custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))
     (define-key anything-command-map (kbd "y") 'yas/insert-snippet)))
;; keybind
;; (setq yas-insert-snippet "\C-c \C-o")
;; (setq yas/insert-snippet)

;; (define-key yas-key-map (kbd "C-c C-i") 'yas-insert-snippet
(define-key global-map (kbd "C-c C-o") 'yas/insert-snippet)

;;
;; auto-complete
;;
(defvar rootpath (expand-file-name "~/.emacs.d"))
(setq load-path (cons (concat rootpath "/elisp")load-path))

;; submodule関連
(defvar elisp-package-dir (concat rootpath "/elisp"))
(defun submodule (dir)
  (push (format "%s/%s" elisp-package-dir dir) load-path))
(defun require-submodule (name &optional dir)
  (push (format "%s/%s" elisp-package-dir (if (null dir) name dir)) load-path)
  (require name))

;;;; auto-complete
;; 基本設定
(submodule "auto-complete")
(require-submodule 'popup "auto-complete/lib/popup")
(require-submodule 'fuzzy "auto-complete/lib/fuzzy")
(require 'auto-complete-config)
(defvar ac-dictionary-directories  "~/.emacs.d/elisp/auto-complete/dict" )
(ac-config-default)
;; カスタマイズ
(setq ac-auto-start 2)  ;; n文字以上の単語の時に補完を開始
(setq ac-delay 0.05)  ;; n秒後に補完開始
(setq ac-use-fuzzy t)  ;; 曖昧マッチ有効
(setq ac-use-comphist t)  ;; 補完推測機能有効
(setq ac-auto-show-menu 0.05)  ;; n秒後に補完メニューを表示
(setq ac-quick-help-delay 0.5)  ;; n秒後にクイックヘルプを表示
(setq ac-ignore-case nil)  ;; 大文字・小文字を区別する

;; auto-complete の候補に日本語を含む単語が含まれないようにする
;; http://d.hatena.ne.jp/IMAKADO/20090813/1250130343
(defadvice ac-word-candidates (after remove-word-contain-japanese activate)
  (let ((contain-japanese (lambda (s) (string-match (rx (category japanese)) s))))
    (setq ad-return-value
          (remove-if contain-japanese ad-return-value))))

;; other-window
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window  1))) ; ctrl押しっぱなしでも移動可能
(global-set-key (kbd "C-x C-n") (lambda () (interactive) (other-window  1))) ; ctrl押しっぱなしでも移動可能
(global-set-key (kbd "C-x C-p") (lambda () (interactive) (other-window -1))) ; 逆方向の移動
