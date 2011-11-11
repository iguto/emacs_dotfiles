;;; -*- coding: utf-8; mode: emacs-lisp; indent-tabs-mode: nil -*-
;;; simple-hatena-mode.el --- Emacs interface to Hatena::Diary Writer

;; Copyright (C) 2007 Kentaro Kuribayashi
;; Author: Kentaro Kuribayashi <kentarok@gmail.com>
;; Keywords: blog, hatena, ãõ€•¦õ€ˆ˜ª

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; * simple-hatena-mode.elãõ€®ã‚ƒ„ã¦

;; ã“ãõ€”ˆƒ‘ãƒƒã‚å®´ƒè‹¥‚å¾õ€•¦€ã€Œãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥€ã‚’Emacsã‹ã‚‰ç¯å¸¥ˆã‚‹ã‚ˆã†
;; ãõ€®—ã€ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒ¼/ã‚é•ƒõ€®ƒè‹¥ƒ—æ—ãƒ¨¨˜ã‚’è†‚â‰¦˜ãõ€±›è´‹–é•™ã‚‹ãŸã‚ãõ€”ˆƒï¼œ‚å¾ƒï½ƒƒè‹¥ƒâ‰ªƒ¼
;; ãƒ‰ã€simple-hatena-modeã‚’æç®´›ã—ãéšœ™ã€‚simple-hatena-modeãõ€•¦€
;; html-helper-modeãõ€”‹æ¬¾ç”Ÿãƒâ‰ªƒè‹¥ƒ‰ãõ€‹”—ãõ€ˆš®šè‡‚õ€Œ²•ã‚Œãõ€ˆ˜„ãéšœ™ãõ€”ˆÑ€
;; html-helper-modeãŒæç®´›ã™ã‚‹å„è…®õ€”‹©Ÿèƒç´”‚‚åˆõ€Œ¶”õ€‹”Ñãéšœ™ã€‚
;;
;; ã‚ã‚ƒƒæ½Ÿ‚é´»ƒˆãƒè‹¥ƒõ€®€èõ€’¬®šæ–å·³•è†ˆ‰ãõ€®ã‚ƒ„ãõ€ˆ˜õ€•¦€ç¯ãƒ¤¸‹ãõ€”ˆƒšãƒè‹¥‚å¾‚’ã”è€Ñã ã•ã„ã€‚
;; http://coderepos.org/share/wiki/SimpleHatenaMode

;;; Code:

;;;; * ãƒçœ¼‚ï¼œƒè‹¥‚å¾ƒÑƒ³

(defconst simple-hatena-version "0.15"
  "simple-hatena-mode.elãõ€”ˆƒçœ¼‚ï¼œƒè‹¥‚å¾ƒÑƒæ½Ÿ€‚")

(defun simple-hatena-version ()
  "simple-hatena-mode.elãõ€”ˆƒçœ¼‚ï¼œƒè‹¥‚å¾ƒÑƒæ½Ÿ‚’èŒµõ€‹˜ãšã™ã‚‹ã€‚"
  (interactive)
  (let ((version-string
         (format "simple-hatena-mode-v%s" simple-hatena-version)))
    (if (interactive-p)
        (message "%s" version-string)
      version-string)))

;;;; * ãƒõ€ˆ˜ƒè‹¥‚åŸõ€®‚ˆã‚‹ã‚õ€®‚é´»‚å¸¥ƒžã‚ã‚ƒ‚å†´Œåõˆ•«ƒç´”õ€Ž•â”ƒçµŽš

;; ã‚õ€®‚é´»‚å¸¥ƒžã‚ã‚ƒ‚é˜ª¤‰æ•°
(defvar simple-hatena-bin "hw.pl"
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥õ€”ˆƒ‘ã‚é´»‚’æŒ‡çµŽšã™ã‚‹ã€‚")

(defvar simple-hatena-root "~/.hatena"
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥õ€”ˆƒ‡ãƒè‹¥‚å¸¥‚’è‡€õ€”ˆãƒ‡ã‚ï½ƒƒõ€‘Œ‚õ€•¦ƒˆãƒõ€Žõ€”ˆƒõ€®ƒè‹¥ƒˆã‚’æŒ‡
çµŽšã™ã‚‹ã€‚")

(defvar simple-hatena-default-id nil
  "*ãõ€•¦õ€ˆ˜ƒ€ãƒõ€Œ²Ñ‚æˆŽã†ãƒ‡ãƒ•ã‚õ€Œ²ƒõ€®ƒˆãõ€”ˆõ€•¦õ€ˆ˜ªidã‚’æŒ‡çµŽšã™ã‚‹ã€‚

ã“ãõ€”Š¤‰æ•é•Œèõ€’¬®šã•ã‚Œãõ€ˆ˜„ã‚‹å ç¿«ˆã€simple-hatenaã‚ã‚‹ã„ã¯
simple-hatena-groupçµŽŸèŒµŒæ™‚ãõ€®€èõ€’¬®šã•ã‚ŒãŸidãŒç¯å¸¥‚ã‚Œã‚‹ãŸã‚ã€idã‚’éå¾¡Šž
ã™ã‚‹ç¶½…è€ãŒãõ€Ž„ã€‚

ã“ã®idã‚’ç´Š‰æ›çœ¼™ã‚‹ãõ€®õ€•¦€simple-hatena-change-default-idã‚’çµŽŸèŒµŒã™ã‚‹ã€‚")

(defvar simple-hatena-default-group nil
  "*ãƒ‡ãƒ•ã‚õ€Œ²ƒõ€®ƒˆã‚é•ƒõ€®ƒè‹¥ƒ—åã‚’æŒ‡çµŽšã™ã‚‹ã€‚")

(defvar simple-hatena-use-timestamp-permalink-flag t
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥õ€”ˆƒ‘ãƒè‹¥ƒžãƒõ€Žƒæ½Ÿ‚õ€•¦õ€®€ã‚å¸¥‚ã‚ƒƒ ã‚é´»‚å¸¥ƒæ½Ÿƒ—ã‚’ç¯å¸¥†
ã‹ãõ€Œ²†ã‹ã‚’æŒ‡çµŽšã™ã‚‹ãƒ•ãƒõ€Œ²‚é•€‚")

(defvar simple-hatena-time-offset nil
  "*æ—ãƒ¤»˜ã‚’èˆè†Š—ã™ã‚‹éš›ãõ€²”õ€‹”„ã‚‹ã‚õ€Žƒ•ã‚ç¥‰ƒƒãƒˆã€‚
6 ãõ€³â”ƒçµŽšã™ã‚‹ãõ€‹–ˆå‰6æ™‚ãéšœÑƒ‰æ—ãƒ£õ€”‹—ãƒ¤»˜ãõ€‹”—ãõ€ˆ›‰å®´‚ã‚Œã‚‹")

;; ãõ€•¦õ€ˆ˜ƒ€ãƒõ€Œ²õ€®‚ãŸã™ã‚õ€Žƒ—ã‚æ¿€ƒÑƒ³
(defvar simple-hatena-option-useragent (simple-hatena-version)
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥õ€”ˆƒõ€ˆ˜ƒè‹¥‚åŸ‚õ€‹”ƒè‹¥‚å¾‚Ñƒæ½Ÿƒˆã‚õ€Žƒ—ã‚æ¿€ƒÑƒæ½Ÿ‚’æŒ‡çµŽšã™
ã‚‹ã€‚

çµŽŸèŒµŒæ™‚ãõ€®€-aã‚õ€Žƒ—ã‚æ¿€ƒÑƒæ½Ÿõ€‹”—ãõ€ˆ™æˆŽã‚ã‚Œã‚‹ã€‚")

(defvar simple-hatena-option-debug-flag nil
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥‚’ã€ãƒ‡ãƒãƒƒã‚é•ƒâ‰ªƒè‹¥ƒ‰ãÑƒ®ŸèŒµŒã™ã‚‹ã‹åõ€ˆ˜‹ã‚’æŒ‡
çµŽšã™ã‚‹ãƒ•ãƒõ€Œ²‚é•€‚

ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒå¼±®ŸèŒµŒæ™‚ãõ€®€-dã‚õ€Žƒ—ã‚æ¿€ƒÑƒæ½Ÿõ€‹”—ãõ€ˆ˜‚ãŸã•ã‚Œã€ãéšœŸã€
ããõ€”Š ç¿«ˆã€çµŽŸèŒµŒè…Ÿæžœã‚’ãƒãƒƒãƒ•ã‚ï¼œõ€³ï¼›è…“å†´™ã‚‹ã€‚

ãƒ‡ãƒãƒƒã‚é•ƒâ‰ªƒè‹¥ƒ‰ã‚’ã‚õ€Žƒ³/ã‚õ€Žƒ•ã™ã‚‹ãõ€®õ€•¦€
simple-hatena-toggle-debug-modeã‚’çµŽŸèŒµŒã™ã‚‹ã€‚")

(defvar simple-hatena-option-timeout 30
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥õ€”ˆ‚å¸¥‚ã‚ƒƒ ã‚â‰ª‚õ€ˆ˜ƒˆã‚’æŒ‡çµŽšã™ã‚‹ã€‚

çµŽŸèŒµŒæ™‚ãõ€®€-Tã‚õ€Žƒ—ã‚æ¿€ƒÑƒæ½Ÿõ€‹”—ãõ€ˆ™æˆŽã‚ã‚Œã‚‹ã€‚")

(defvar simple-hatena-option-cookie-flag t
  "*ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥õ€”ˆƒõ€’ª‚é•‚ã‚ƒƒæ½Ÿõ€®€cookieã‚’åˆõ€Œ¶”õ€‹”™ã‚‹ã‹ãõ€Œ²†ã‹
ã‚’æŒ‡çµŽšã™ã‚‹ãƒ•ãƒõ€Œ²‚é•€‚

çµŽŸèŒµŒæ™‚ãõ€®€-cã‚õ€Žƒ—ã‚æ¿€ƒÑƒæ½Ÿõ€‹”—ãõ€ˆ™æˆŽã‚ã‚Œã‚‹ã€‚")

(defvar simple-hatena-process-buffer-name "*SimpleHatena*"
  "*ãõ€•¦õ€ˆ˜ƒ€ãƒõ€Œ²‚’çµŽŸèŒµŒã™ã‚‹ãƒ—ãƒõ€’ª‚ç¥‰‚é´»õ€”ˆƒãƒƒãƒ•ã‚â‰¦ã€‚")

;; ã‚õ€’ªƒè‹¥ƒã‚ã‚ƒƒæ½Ÿƒ‰
(setq simple-hatena-mode-map (make-keymap))

(define-key simple-hatena-mode-map (kbd "C-c C-v") 'simple-hatena-version)
(define-key simple-hatena-mode-map (kbd "C-c C-p") 'simple-hatena-submit)
(define-key simple-hatena-mode-map (kbd "C-c C-c") 'simple-hatena-trivial-submit)
(define-key simple-hatena-mode-map (kbd "C-c   *") 'simple-hatena-timestamp)
(define-key simple-hatena-mode-map (kbd "C-c C-i") 'simple-hatena-change-default-id)
(define-key simple-hatena-mode-map (kbd "C-c C-g") 'simple-hatena-change-default-group)
(define-key simple-hatena-mode-map (kbd "C-c C-n") 'simple-hatena-find-diary-for)
(define-key simple-hatena-mode-map (kbd "C-c C-b") 'simple-hatena-go-back)
(define-key simple-hatena-mode-map (kbd "C-c C-f") 'simple-hatena-go-forward)
(define-key simple-hatena-mode-map (kbd "C-c C-d") 'simple-hatena-toggle-debug-mode)
(define-key simple-hatena-mode-map (kbd "C-c C-e") 'simple-hatena-exit)
(define-key simple-hatena-mode-map (kbd       "*") 'simple-hatena-electric-asterisk)

;; ãƒ•ãƒƒã‚¯
(defvar simple-hatena-mode-hook nil
  "simple-hatena-modeé–‹ç´®‹æ™‚ãõ€”ˆƒ•ãƒƒã‚õ€•¦€‚")
(defvar simple-hatena-before-submit-hook nil
  "æ—ãƒ¨¨˜ã‚’æŠ•è…®å¸¥™ã‚‹ç›ç¿«‰ãõ€”ˆƒ•ãƒƒã‚¯")
(defvar simple-hatena-after-submit-hook nil
  "æ—ãƒ¨¨˜ã‚’æŠ•è…®å¸¥—ãŸç›ç¿«¾Œãõ€”ˆƒ•ãƒƒã‚¯")

;; ãƒ•ã‚õ€Œ²ƒæ½Ÿƒˆãƒõ€’ªƒƒã‚¯

(defvar simple-hatena-font-lock-keywords nil)
(defvar simple-hatena-slag-face 'simple-hatena-slag-face)
(defvar simple-hatena-subtitle-face 'simple-hatena-subtitle-face)
(defvar simple-hatena-inline-face 'simple-hatena-inline-face)
(defvar simple-hatena-markup-face 'simple-hatena-markup-face)
(defvar simple-hatena-link-face 'simple-hatena-link-face)

(defface simple-hatena-slag-face
  '((((class color) (background light)) (:foreground "IndianRed"))
    (((class color) (background dark)) (:foreground "wheat")))
  "çµ¨é ³‹å‡å†´—ã®*ã‚å¸¥‚ã‚ƒƒ ã‚é´»‚å¸¥ƒæ½Ÿƒ—orã‚é´»ƒõ€Œ²ƒƒã‚°*éƒõ€‹–ˆ†ãõ€”ˆƒ•ã‚Ñ‚ã‚ƒ‚é´»€‚")

(defface simple-hatena-subtitle-face
  '((((class color) (background light)) (:foreground "DarkOliveGreen"))
    (((class color) (background dark)) (:foreground "wheat")))
  "çµ¨é ³‹å‡å†´—ãõ€”ˆƒ•ã‚Ñ‚ã‚ƒ‚é´»€‚")

(defface simple-hatena-inline-face
  '((((class color) (background light)) (:foreground "MediumBlue" :bold t))
    (((class color) (background dark)) (:foreground "wheat" :bold t)))
  "idè˜ç¾ˆ•ã‚„[keyword:Emacs]è†ˆ‰ã®face")

(defface simple-hatena-markup-face
  '((((class color) (background light)) (:foreground "DarkOrange" :bold t))
    (((class color) (background dark)) (:foreground "IndianRed3" :bold t)))
  "ãõ€•¦õ€ˆ˜õ€Žõ€”ˆƒžãƒè‹¥‚õ€•¦‚â‰ªƒƒãƒ—ãõ€”ˆƒ•ã‚Ñ‚ã‚ƒ‚é´»€‚")

(defface simple-hatena-link-face
  '((((class color) (background light)) (:foreground "DeepPink"))
    (((class color) (background dark)) (:foreground "wheat")))
  "ãƒõ€Žƒæ½Ÿ‚õ€•¦õ€”ˆƒ•ã‚Ñ‚ã‚ƒ‚é´»€‚")

;;;; * çµŽŸèŒ–…

(eval-when-compile
  (require 'cl)
  (require 'derived)
  (require 'font-lock)
  (require 'html-helper-mode))

(defconst simple-hatena-filename-regex
   "/\\([^/]+\\)/\\(diary\\|group\\)/\\([^/]+\\)?/?\\([0-9][0-9][0-9][0-9]\\)-\\([01][0-9]\\)-\\([0-3][0-9]\\)\.txt"
  "æ—ãƒ¨¨˜ãƒ•ã‚ï¼œ‚ã‚ƒƒõ€®õ€”‹õ€‘ªè€é «õ€‹˜æ†—€‚ãƒžãƒƒãƒã—ãŸå ç¿«ˆã€ç¯ãƒ¤¸‹ãõ€”ˆ‚ã‚ƒƒæ½Ÿƒ‡ãƒƒã‚õ€•¦‚é´»õ€®‚ˆ
ã‚Šãƒ•ã‚ï¼œ‚ã‚ƒƒõ€±ƒ…å å®´‚’å–ç·‡—ãÑã‚‹ã€‚

  0. ãƒžãƒƒãƒã—ãŸå…õ€‹•½“
  1. ãõ€•¦õ€ˆ˜ªid
  2. diary/group
  3. 2ãŒgroupãõ€”Š ç¿«ˆãõ€•¦€ã‚é•ƒõ€®ƒè‹¥ƒ—åã€‚ãã†ãÑõ€Ž„å ç¿«ˆã¯nil
  4. ç¶›´(YYYY)
  5. æœˆ(MM)
  6. æ—¥(DD)")

;; ãõ€•¦õ€ˆ˜ªIDãõ€”‹õ€‘ªè€é «õ€‹˜¾
;; > http://d.hatena.ne.jp/keyword/%A4%CF%A4%C6%A4%CAID
;; > ç´ŠÑ„–‡çµ–—ã‚ã‚‹ã„ãõ€•¨°æ–‡çµ–—ãõ€”ˆ‚â‰ªƒõ€®ƒ•ã‚ï¼œƒ™ãƒƒãƒˆãƒ»0-9ãõ€”‹•åŒ»­—ãƒç¥‰€Œ-ã€ãƒç¥‰€Œ_ã€(ã„ãšã‚Œã‚‚
;; åŠèŒ¹’)ãõ€”ˆ„ãšã‚Œã‹ã‚’3-32æ–‡çµ–—ç­õ€ˆ˜é´»Ÿã‚‚ã®(ãŸã ã—æœ€åˆãõ€”‹–‡çµ–—ãõ€•¦‚â‰ªƒõ€®ƒ•ã‚ï¼œƒ™ãƒƒãƒˆã§
;; ã‚ã‚‹ã“ã¨)ã‹ã‚‰æˆã‚‹ã€‚
(defconst simple-hatena-id-regex
  "^[A-z][\-_A-z0-9]+[A-z0-9]$"
  "")

;; ãõ€•¦õ€ˆ˜õ€Ž‚é•ƒõ€®ƒè‹¥ƒ—åãõ€”‹õ€‘ªè€é «õ€‹˜¾
;; > http://g.hatena.ne.jp/group?mode=append
;; > éšˆã‚â‰ªƒõ€®ƒ•ã‚ï¼œƒ™ãƒƒãƒˆãÑƒ§‹ãéšœ‚Šã€ã‚â‰ªƒõ€®ƒ•ã‚ï¼œƒ™ãƒƒãƒˆã‹æ•åŒ»­—ãÑ…µ‚ã‚ã‚‹3æ–‡çµ–—ç¯ãƒ¤¸Šã€
;; > 24æ–‡çµ–—ç¯ãƒ¥†…ãõ€”ŠŠèŒ¹’è‹æŽ©•åŒ»­—éš‰
;; ãõ€‹—›å¾‹ã‚Œãõ€ˆ˜„ã‚‹ãŒã€Œ-ã€ã‚‚ç¯å¸¥ˆã‚‹ã€‚
(defconst simple-hatena-group-regex
  "^[A-z][\-A-z0-9]+[A-z0-9]$"
  "")

;; simple-hatena-modeã‚’ã€html-helper-modeãõ€”‹æ¬¾ç”Ÿãƒâ‰ªƒè‹¥ƒ‰ãõ€‹”—ãõ€ˆš®šè‡‚õ€Œ²™ã‚‹ã€‚
(define-derived-mode simple-hatena-mode html-helper-mode "Simple Hatena"
  "ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒè‹¥ƒõ€Œ²‚ã‚ƒ‚å¸¥ƒè‹¥‚’ã€Emacsã‹ã‚‰åˆõ€Œ¶”õ€‹”™ã‚‹ãŸã‚ãõ€”ˆ‚ã‚ƒƒæ½Ÿ‚å¸¥ƒ•ã‚Ñ‚¤
ã‚é´»‚’æç®´›ã™ã‚‹ãƒâ‰ªƒè‹¥ƒ‰ã€‚

èõ€’¬®šæ–å·³•ã‚„ç¯å¸¥„æ–é´»õ€®ã‚ƒ„ãõ€ˆ˜õ€•¦€ç¯ãƒ¤¸‹ã‚’å‚ç…Ñõ€”ˆ“ãõ€‹”€‚
http://coderepos.org/share/wiki/SimpleHatenaMode"

  ;; çæ†œœõ€‹š–‹ã„ãõ€ˆ˜„ã‚‹ãƒãƒƒãƒ•ã‚ï¼œõ€”‹ƒ…å ±
  (make-local-variable 'simple-hatena-local-current-buffer-info)
  (make-local-variable 'simple-hatena-local-current-buffer-id)
  (make-local-variable 'simple-hatena-local-current-buffer-type)
  (make-local-variable 'simple-hatena-local-current-buffer-group)
  (make-local-variable 'simple-hatena-local-current-buffer-year)
  (make-local-variable 'simple-hatena-local-current-buffer-month)
  (make-local-variable 'simple-hatena-local-current-buffer-day)

  (if (string-match simple-hatena-filename-regex (buffer-file-name))
      (progn
        (setq simple-hatena-local-current-buffer-info
              (match-string 0 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-id
              (match-string 1 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-type
              (match-string 2 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-group
              (match-string 3 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-year
              (match-string 4 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-month
              (match-string 5 (buffer-file-name)))
        (setq simple-hatena-local-current-buffer-day
              (match-string 6 (buffer-file-name)))
        (simple-hatena-update-modeline))
    (error "Current buffer isn't related to Hatena::Diary Writer data file"))

  ;; ãƒ•ã‚õ€Œ²ƒæ½Ÿƒˆãƒõ€’ªƒƒã‚¯
  (font-lock-add-keywords 'simple-hatena-mode
    (list
     (list  "^\\(\\*[*a-zA-Z0-9_-]*\\)\\(.*\\)$"
            '(1 simple-hatena-slag-face t)
            '(2 simple-hatena-subtitle-face t))
     ;; ç¶½…ãš[]ãÑƒ›èšŠéšœ‚Œãõ€ˆ˜„ãõ€Ž‘ã‚Œãé•õ€Ž‚‰ãõ€Ž„ã‚‚ã®
     (list "\\[[*a-zA-Z0-9_-]+\\(:[^\n]+\\)+\\]"
           '(0 simple-hatena-inline-face t))
     ;; ç¶½…ãšã—ã‚‚[]ãÑƒ›èšŠéšœ‚Œãõ€ˆ˜„ãõ€Žãõ€ˆ˜‚‚ã‚ˆã„ã‚‚ã®
     (list "\\[?\\(id\\|a\\|b\\|d\\|f\\|g\\|graph\\|i\\|idea\\|map\\|question\\|r\\|isbn\\|asin\\)\\(:[a-zA-Z0-9_+:-]+\\)+\\]?"
           '(0 simple-hatena-inline-face t))
     (list  "^\\(:\\)[^:\n]+\\(:\\)"
            '(1 simple-hatena-markup-face t)
            '(2 simple-hatena-markup-face t))
     (list  "^\\([-+]+\\)"
            '(1 simple-hatena-markup-face t))
     (list  "\\(((\\).*\\())\\)"
            '(1 simple-hatena-markup-face t)
            '(2 simple-hatena-markup-face t))
     (list  "^\\(>>\\|<<\\|><!--\\|--><\\|>|?[^|]*|\\||?|<\\|=====?\\)"
            '(1 simple-hatena-markup-face t))
     (list  "\\(s?https?://\[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#\]+\\)"
            '(1 simple-hatena-link-face t))))
  (font-lock-mode 1)

  (use-local-map simple-hatena-mode-map)
  (run-hooks 'simple-hatena-mode-hook))

;; ãõ€•¦õ€ˆ˜ƒ€ãƒõ€Œ²ƒ‡ãƒè‹¥‚å¸¥«simple-hatena-modeã‚’éõ€Œ¶”õ€‹”™ã‚‹
;;
;; - ~/.hatena/hatena-id/diary/YYYY-MM-DD.txt
;; - ~/.hatena/hatena-id/group/group-name/YYYY-MM-DD.txt
;;
;; ãõ€‹”„ã†ãƒ•ã‚ï¼œ‚ã‚ƒƒõ€®‚’é–‹ã„ãŸã‚‰ã€simple-hatena-modeãõ€®™ã‚‹
(add-to-list 'auto-mode-alist
             (cons simple-hatena-filename-regex 'simple-hatena-mode))

;;;; * ã‚æ½Ÿƒžãƒæ½Ÿƒ‰

(defun simple-hatena-setup ()
  (interactive)
  "ãƒ‡ã‚ï½ƒƒõ€‘Œ‚õ€•¦ƒˆãƒõ€Ž–…è‡€õ€”ˆ‚’ã‚ç¥‰ƒƒãƒˆã‚â‰ªƒƒãƒ—ã™ã‚‹ã€‚"
  (and
   ;; simple-hatena-bin
   (simple-hatena-setup-check-hatena-bin-exists-p)

   ;; hatena id(s)
   (simple-hatena-setup-id)

   ;; hatena group
   (if (y-or-n-p
        "Set up about `Hatena::Group' next? ")
       (simple-hatena-group-setup)
     (message "Enjoy!"))))

(defun simple-hatena-setup-check-hatena-bin-exists-p ()
  (if (file-executable-p simple-hatena-bin)
      t
    (progn
      (if (y-or-n-p
           (format
            "`Hatena Diary Writer' not found in %s. Are you sure to continue setup? "
            simple-hatena-bin))
          t
        (progn
          (when (y-or-n-p
                 "Open the documentation of simple-hatnea-mode in your browser? ")
            (browse-url "http://coderepos.org/share/wiki/SimpleHatenaMode"))
          (message "You must download and install `Hatena Diary Writer' first")
          nil)))))

(defun simple-hatena-setup-id ()
  (let
      ((ids (list)))
    (when (file-directory-p simple-hatena-root)
      (dolist (id (simple-hatena-internal-list-directories simple-hatena-root))
        (add-to-list 'ids id)))

    (when simple-hatena-default-id
      (add-to-list 'ids simple-hatena-default-id))

    (while
        (or (not ids) ;;FIXME incomprehensible.
            (y-or-n-p
             (format
              "Existing id(s): `%s'\nSet up other id? "
              (mapconcat 'identity
                         ids "', `"))))
      (add-to-list
       'ids (simple-hatena-read-string-and-match-check
             "Please input your other Hatena id: "
             simple-hatena-id-regex
             "`%s' is invalid as a Hatena id.")))

    (dolist (id ids)
      (simple-hatena-setup-id-create-directory-and-file id))
    ids))

(defun simple-hatena-setup-id-create-directory-and-file (id)
  (simple-hatena-setup-create-directory-and-file
   (expand-file-name
    (format "%s/%s/diary/config.txt"
            simple-hatena-root id))))

(defun simple-hatena-group-setup ()
  (interactive)
  "ãƒ‡ã‚ï½ƒƒõ€‘Œ‚õ€•¦ƒˆãƒõ€Žõ€®õ€•¦õ€ˆ˜õ€Ž‚é•ƒõ€®ƒè‹¥ƒ—ã‚’è´éµŠ ã™ã‚‹ã€‚"
  ;; hatena group(s)
  (simple-hatena-setup-group))

(defun simple-hatena-setup-group ()
  (let*
      ((groups (list))
       (id (condition-case err
               simple-hatena-local-current-buffer-id
             (error (simple-hatena-internal-completing-read-id
                     simple-hatena-root))))
       (group-dir (expand-file-name (format "%s/%s/group"
                                            simple-hatena-root id))))

    (unless (file-directory-p group-dir)
      (make-directory group-dir 'parents))

    (dolist (group (simple-hatena-internal-list-directories group-dir))
      (add-to-list 'groups group))

    (while
        (or (not groups)
            (y-or-n-p
             (format
              "Existing group(s): `%s'\nSet up other group? "
              (mapconcat 'identity
                         groups "', `"))))
      (add-to-list
       'groups (simple-hatena-read-string-and-match-check
                (format
                 "Please input a group name for id:%s: " id)
                simple-hatena-group-regex
             "`%s' is invalid as a group name.")))

    (dolist (group groups)
      (if (string-match simple-hatena-group-regex group)
          (simple-hatena-setup-group-create-directory-and-file id group)
        (message (format "`%s' is invalid as a group name." group))))))

(defun simple-hatena-setup-group-create-directory-and-file (id group)
  (simple-hatena-setup-create-directory-and-file
   (expand-file-name
    (format "%s/%s/group/%s/config.txt"
            simple-hatena-root id group))))

(defun simple-hatena-setup-create-directory-and-file (filename)
  "Set up a directory and file.

NOTE: Create intermediate directories as required."
  (let
      ((dirname (file-name-directory filename)))
    (unless (file-exists-p filename)
      (unless (file-directory-p dirname)
        (make-directory dirname 'parents))
      (append-to-file 1 1 filename))))

(defun simple-hatena-read-string-and-match-check (prompt regex
                                                         &optional errmsg)
  "Read a string from the minibuffer, prompting with string prompt,
and Cheking input value.

If non-nil, third args, you can set error message.

NOTE: Please refer to `format' for the format of the error
message."
  (let
      ((input nil)
       (errmsg (or errmsg
                   "Your input is invalid...")))
    (while
        (and
         (setq input (read-string prompt))
         (not (string-match regex input)))
      (message (format errmsg input))
      (sleep-for 1))
    input))

(defun simple-hatena (id)
  "çµŽŸèŒµŒæ—ãƒ§æ†œœõ€‹”õ€”‹—ãƒ¤»˜ãõ€”ˆƒ•ã‚ï¼œ‚ã‚ƒƒõ€®‚’é–‹ãã€‚"
  (interactive
   (list
    (if simple-hatena-default-id
        simple-hatena-default-id
      (simple-hatena-internal-completing-read-id simple-hatena-root))))
  (simple-hatena-internal-safe-find-file (concat
               simple-hatena-root
               "/"
               id
               "/diary/"
               (simple-hatena-internal-make-diary-file-string 0))))

(defun simple-hatena-group (id group)
  "çµŽŸèŒµŒæ—ãƒ§æ†œœõ€‹”õ€”‹—ãƒ¤»˜ãõ€”ˆ€æŒ‡çµŽšã•ã‚ŒãŸã‚é•ƒõ€®ƒè‹¥ƒ—ãõ€±Š•è…®å¸¥™ã‚‹ãŸã‚ãõ€”ˆƒ•ã‚ï¼œ‚ã‚ƒƒ«
ã‚’é–‹ãã€‚"
  (interactive
   (if simple-hatena-default-id
       (list
        simple-hatena-default-id
        (if simple-hatena-default-group
            simple-hatena-default-group
          (simple-hatena-internal-completing-read-group simple-hatena-default-id)))
     (let ((id (simple-hatena-internal-completing-read-id simple-hatena-root)))
       (list
        id
        (if simple-hatena-default-group
            simple-hatena-default-group
          (simple-hatena-internal-completing-read-group id))))))
  (simple-hatena-internal-safe-find-file (concat
              simple-hatena-root
              "/"
              id
              "/group/"
              group
              "/"
              (simple-hatena-internal-make-diary-file-string 0))))

(defun simple-hatena-change-default-id ()
  "çæ†œœõ€‹”õ€”ˆƒ‡ãƒ•ã‚õ€Œ²ƒõ€®ƒˆidã‚’ç´Š‰æ›çœ¼™ã‚‹ã€‚"
  (interactive)
  (setq simple-hatena-default-id
        (simple-hatena-internal-completing-read-id simple-hatena-root))
  (message "Changed current default id to %s" simple-hatena-default-id))

(defun simple-hatena-change-default-group ()
  "çæ†œœõ€‹”õ€”ˆƒ‡ãƒ•ã‚õ€Œ²ƒõ€®ƒˆã‚é•ƒõ€®ƒè‹¥ƒ—ã‚’ç´Š‰æ›çœ¼™ã‚‹ã€‚"
  (interactive)
  (if simple-hatena-default-id
      (setq simple-hatena-default-group
            (simple-hatena-internal-completing-read-group simple-hatena-default-id))
    (list (simple-hatena-change-default-id)
          (setq simple-hatena-default-group
                (simple-hatena-internal-completing-read-group simple-hatena-default-id))))
  (message "Change current default group to %s" simple-hatena-default-group))

(defun simple-hatena-submit ()
  "ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒ¼/ã‚é•ƒõ€®ƒè‹¥ƒ—ãõ€±Š•è…®å¸¥™ã‚‹ã€‚"
  (interactive)
  (simple-hatena-internal-do-submit))

(defun simple-hatena-trivial-submit ()
  "ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒõ€Žƒ¼/ã‚é•ƒõ€®ƒè‹¥ƒ—ãõ€®€Œãï¼œ‚‡ãï½ƒõ€‹”—ãŸæ›è´‹–é•€ãÑ„Š•è…®å¸¥™ã‚‹ã€‚"
  (interactive)
  (simple-hatena-internal-do-submit "-t"))

(defun simple-hatena-timestamp ()
  "çµŽŸèŒµŒç¯è‡€õ€”ˆõ€®€ã€Œ*ã‚å¸¥‚ã‚ƒƒ ã‚é´»‚å¸¥ƒæ½Ÿƒ—*ã€ã‚’æŒæ°´…ãƒ£™ã‚‹ã€‚"
  (interactive)
  (insert (format-time-string "*%s*" (current-time))))

(defun simple-hatena-find-diary-for (date)
  "æŒ‡çµŽšã•ã‚ŒãŸæ—ãƒ¤»˜ãõ€”‹—ãƒ¨¨˜ãƒãƒƒãƒ•ã‚ï¼œ‚’èŒµõ€‹˜ãšã™ã‚‹ã€‚"
  (interactive "sDate(YYYY-MM-DD): ")
  (if (equal major-mode 'simple-hatena-mode)
      (if (string-match "^[0-9][0-9][0-9][0-9]-[01][0-9]-[0-3][0-9]$" date)
          (simple-hatena-internal-safe-find-file
           (concat (file-name-directory (buffer-file-name))
                   (concat date ".txt")))
        (error "Invalid date"))
    (error "Current major mode isn't simple-hatena-mode")))

(defun simple-hatena-go-forward (&optional i)
  "å‰ãõ€”‹—ãƒ¤»˜ãæ‚ŸÐ©å‹•ã™ã‚‹ã€‚å‰è‡€õ€”Š¼•æ•é•Œç¾ï¼œ•ã‚ŒãŸå ç¿«ˆãõ€•¦€ããõ€”‹•é• ã‘ç·‡Œãõ€”‹—ãƒ¤»˜ãõ€²Ð©å‹•ã™ã‚‹ã€‚"
  (interactive "p")
  (if (not i)
      (simple-hatena-internal-go-for 1)
    (simple-hatena-internal-go-for i)))

(defun simple-hatena-go-back (&optional i)
  "ç½¨ï¼œõ€”‹—ãƒ¤»˜ãæ‚ŸÐ©å‹•ã™ã‚‹ã€‚å‰è‡€õ€”Š¼•æ•é•Œç¾ï¼œ•ã‚ŒãŸå ç¿«ˆãõ€•¦€ããõ€”‹•é• ã‘å‰ãõ€”‹—ãƒ¤»˜ãõ€²Ð©å‹•ã™ã‚‹ã€‚"
  (interactive "p")
  (if (not i)
      (simple-hatena-internal-go-for -1)
    (simple-hatena-internal-go-for (- i))))

(defun simple-hatena-toggle-debug-mode ()
  "ãƒ‡ãƒãƒƒã‚é•ƒâ‰ªƒè‹¥ƒ‰ã‚’ã‚õ€Žƒ³/ã‚õ€Žƒ•ã™ã‚‹ã€‚"
  (interactive)
  (if simple-hatena-option-debug-flag
      (progn
        (setq simple-hatena-option-debug-flag nil)
        (message "Debug mode off"))
    (progn
      (setq simple-hatena-option-debug-flag t)
      (message "Debug mode on"))))

(defun simple-hatena-exit ()
  "simple-hatena-modeãõ€”Žõ€Œ¶”õ€‹”•ã‚Œãõ€ˆ˜„ã‚‹ãƒãƒƒãƒ•ã‚ï¼œ‚’å…õ€‹”õ€ˆš‰Šé™ã‚ƒ™ã‚‹ã€‚"
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and
           (buffer-file-name buffer)
           (string-match simple-hatena-filename-regex (buffer-file-name buffer)))
      (when (buffer-modified-p buffer)
        (progn
          (save-current-buffer
            (set-buffer buffer)
            (save-buffer))))
      (kill-buffer buffer)))
  (message "simple-hatena-mode has been exited"))

(defun simple-hatena-electric-asterisk (arg)
  "éšŠ(ã‚â‰ª‚é´»‚å¸¥ƒõ€Ž‚é´»‚¯)æŠå¯‚¸‹ãõ€®‚ˆã‚Šã€ã‚å¸¥‚ã‚ƒƒ ã‚é´»‚å¸¥ƒæ½Ÿƒ—ç¯˜ãçµ¨é ³‹å‡å†´—ã‚’æŒæ°´…ãƒ£™ã‚‹ã€‚

ãƒã‚ã‚ƒƒæ½ŸƒˆãŒèŒµŒé õ€’ªõ€®‚ã‚‹å ç¿«ˆãõ€”ˆå¸¥€ã‚å¸¥‚ã‚ƒƒ ã‚é´»‚å¸¥ƒæ½Ÿƒ—ã‚’æŒæ°´…ãƒ£—ã€ããõ€”‰»–ãõ€”Š ç¿«ˆ
ãõ€•¦€é€šçµ½æªŽ€šã‚Šã‚â‰ª‚é´»‚å¸¥ƒõ€Ž‚é´»‚õ€•¦‚’æŒæ°´…ãƒ£™ã‚‹ã€‚"
  (interactive "*p")
  (if (and simple-hatena-use-timestamp-permalink-flag
           (zerop (current-column)))
      (simple-hatena-timestamp)
    (self-insert-command arg)))

;;;; * å†…éƒõ€‹š–âˆ½•°

(defun simple-hatena-internal-safe-find-file (filename)
  "æ–é•—ã„ãƒçœ¼‚ï¼œƒè‹¥‚å¾ƒÑƒæ½Ÿ®html-helper-modeãõ€•¦€ãƒ‡ãƒ•ã‚õ€Œ²ƒõ€®ƒˆãÑ‚é´»‚å®´ƒõ€®ƒˆãƒ³
ã‚’ç¯œãï½ƒõ€ˆ˜‚õ€ˆ˜‚åŸ„ãõ€”ˆÑ€é˜ç´™õ€‘©ã™ã‚‹ã€‚"
  (let ((html-helper-build-new-buffer nil))
    (find-file filename)))

(defun simple-hatena-internal-make-diary-file-string (i &optional date)
  "dateãŒæŒ‡çµŽšã•ã‚Œãõ€ˆ˜„ãõ€Ž„å ç¿«ˆãõ€•¦€çµŽŸèŒµŒæ—ãƒ§æ†œœõ€‹”õ€”‹—ãƒ¤»˜ã‚’èŽŽæ¬ ‚é´»õ€®—ãŸæ—ãƒ¨¨˜ãƒ•ã‚ï¼œ‚ã‚ƒƒõ€°ã‚’ç”Ÿæˆã™ã‚‹ã€‚

   0: ç¯Šæ—¥
   1: æ˜Žæ—¥
  -1: æ˜õ€‹——¥

æŒ‡çµŽšã•ã‚Œãõ€ˆ˜„ã‚‹å ç¿«ˆãõ€•¦€ããõ€”‹—ãƒ¤»˜ã‚’èŽŽæ¬ ‚é´»õ€®—ãŸæ—ãƒ¨¨˜ãƒ•ã‚ï¼œ‚ã‚ƒƒõ€°ã‚’ç”Ÿæˆã™ã‚‹ã€‚"
  (apply (lambda (s min h d mon y &rest rest)
           (format-time-string "%Y-%m-%d.txt"
                               (encode-time s min h (+ d i) mon y)))
         (if date
             (append '(0 0 0) date)
           (apply (lambda (s min h d mon y &rest rest)
                    (list s min (- h (or simple-hatena-time-offset 0)) d mon y))
                  (decode-time)))))

(defun simple-hatena-internal-go-for (i)
  "ç¶£•æ•é•õ€”‹•é• ã‘å‰ç·‡Œãõ€”‹—ãƒ¤»˜ãõ€”ˆƒ•ã‚ï¼œ‚ã‚…ãƒãƒƒãƒ•ã‚ï¼œæ‚ŸÐ©å‹•ã™ã‚‹ã€‚"
  (simple-hatena-internal-safe-find-file
   (concat
    (file-name-directory (buffer-file-name))
    (simple-hatena-internal-make-diary-file-string
     i
       (list (string-to-number simple-hatena-local-current-buffer-day)
             (string-to-number simple-hatena-local-current-buffer-month)
             (string-to-number simple-hatena-local-current-buffer-year))))))

(defun simple-hatena-internal-list-directories (dir)
  "dirç­‹ãõ€®‚ã‚‹ãƒ‡ã‚ï½ƒƒõ€‘Œ‚õ€•¦ƒˆãƒõ€Ž‚’ãƒõ€Ž‚é´»ƒˆãõ€®—ãõ€ˆ¿”ã™ã€‚"
  (let ((dir-list nil))
    (dolist (file (directory-files dir t "^[^\.]") dir-list)
      (if (file-directory-p file)
          (progn
            (string-match "\\([^/]+\\)/?$" file)
            (setq dir-list (cons (match-string 1 file) dir-list)))))))

(defun simple-hatena-internal-completing-read-id (dir)
  "dirç¯ãƒ¤¸‹ã‹ã‚‰ãõ€•¦õ€ˆ˜ªidã‚’æŠéµ‡å†´—ã€èŒ–œçµŽŒå…ãƒ¥Š›ã•ã›ã‚‹ã€‚"
  (completing-read
   "Hatena id: " (simple-hatena-internal-list-directories simple-hatena-root) nil t))

(defun simple-hatena-internal-completing-read-group (id)
  "dirç¯ãƒ¤¸‹ã‹ã‚‰ã‚é•ƒõ€®ƒè‹¥ƒ—åã‚’æŠéµ‡å†´—ã€èŒ–œçµŽŒå…ãƒ¥Š›ã•ã›ã‚‹ã€‚"
  (completing-read
   "Group: " (simple-hatena-internal-list-directories
              (concat simple-hatena-root "/" id "/group")) nil t))

(defun simple-hatena-internal-do-submit (&optional flag)
  "ãõ€•¦õ€ˆ˜õ€Žƒ€ã‚ã‚ƒ‚â‰ªƒª/ã‚é•ƒõ€®ƒè‹¥ƒ—ãå¾¡—ãƒ¨¨˜ã‚’æŠ•è…®å¸¥™ã‚‹ã€‚"
  (let ((max-mini-window-height 10)  ; hw.plãŒèŒµõ€‹˜ãšã™ã‚‹ãƒï¼œƒƒã‚ç¥‰ƒè‹¥‚å¾‚’ã€
                                     ; echoã‚õ€‹”ƒõ€Ž‚â‰ªõ€³ï¼›è…“å†´•ã›ã‚‹ãŸã‚ã€‚
        (thisdir (file-name-directory (buffer-file-name))))
    (run-hooks 'simple-hatena-before-submit-hook)
    (when (buffer-modified-p)
      (save-buffer))
    (message "%s" "Now posting...")
    (let* ((buffer (get-buffer-create simple-hatena-process-buffer-name))
           (proc (get-buffer-process buffer)))
      (if (and
           proc
           (eq (process-status proc) 'run))
          (if (yes-or-no-p (format "A %s process is running; kill it?"
                                   (process-name proc)))
              (progn
                (interrupt-process proc)
                (sit-for 1)
                (delete-process proc))
            (error nil)))
      (with-current-buffer buffer
        (progn
          (erase-buffer)
          (buffer-disable-undo (current-buffer))
          (setq default-directory thisdir)))
      (make-comint-in-buffer
       "simple-hatena-submit" buffer shell-file-name nil
       shell-command-switch (simple-hatena-internal-build-command flag))
      (set-process-sentinel
       (get-buffer-process buffer)
       '(lambda (process signal)
          (if (string= signal "finished\n")
              (let ((max-mini-window-height 10))
                (display-message-or-buffer (process-buffer process))
                (run-hooks 'simple-hatena-after-submit-hook))))))))

(defun simple-hatena-internal-build-command (flag)
  "çµŽŸèŒµŒåõˆ•«ƒç´”õ€Ž‚æ½Ÿƒžãƒæ½Ÿƒ‰æ–‡çµ–—åˆ—ã‚’ç¯œæˆã™ã‚‹ã€‚"
  (let ((flag-list (list flag)))
    (if simple-hatena-option-debug-flag  (setq flag-list (cons "-d" flag-list)))
    (if simple-hatena-option-cookie-flag (setq flag-list (cons "-c" flag-list)))
    (simple-hatena-internal-join
     " "
     (cons simple-hatena-bin
           (append (simple-hatena-internal-build-option-list-from-alist) flag-list)))))

(defun simple-hatena-internal-build-option-list-from-alist ()
  "ç¶£•æ•é•‚’å–ã‚‹ã‚õ€Žƒ—ã‚æ¿€ƒÑƒæ½Ÿõ€”ˆƒõ€Ž‚é´»ƒˆã‚’ç¯œæˆã™ã‚‹ã€‚"
  (let ((opts nil))
    (dolist (pair
             `(("-u" . ,simple-hatena-local-current-buffer-id)
               ("-g" . ,simple-hatena-local-current-buffer-group)
               ("-a" . ,simple-hatena-option-useragent)
               ("-T" . ,(format "%s" simple-hatena-option-timeout)))
             opts)
      (if (cdr pair)
           (setq opts (append opts (list (car pair) (cdr pair))))))))

(defun simple-hatena-internal-join (sep list)
  "èµŠèŽ õ€Žõ€”Š†ç™å º˜Žãõ€Ž‚“ã ã‚ã†ã‘ãõ€Œ²€è€‹ãã‚ƒ‹ã‚‰ãõ€Ž‹ãï½ƒŸãõ€”ˆ§joinçµŽŸèŒ–…"
  (if (<= (length list) 1)
      (car list)
    (concat (car list) sep (simple-hatena-internal-join sep (cdr list)))))

(defun simple-hatena-update-modeline ()
  "ãƒâ‰ªƒè‹¥ƒ‰ãƒõ€Œ²‚ã‚ƒƒæ½Ÿõ€”ï¼›è…“å†´‚’æ›è´‹–é•™ã‚‹"
  (let ((id
         (concat
          (if simple-hatena-local-current-buffer-group
              (format "g:%s:" simple-hatena-local-current-buffer-group)
            "")
          (format "id:%s" simple-hatena-local-current-buffer-id))))
    (setq mode-name (format "Simple Hatena [%s]" id))
    (force-mode-line-update)))

(provide 'simple-hatena-mode)

;;; simple-hatena-mode.el ends here
