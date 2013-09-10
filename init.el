;; 大竹智也『Emacs実践入門』 p.60 chapter 4での設定
;; ~/.emacs.d/elisp ディレクトリをロードパスに追加する。
;; ただし、add-to-load-path関数を作成した場合は不要
;;(add-to-list 'load-path "~/.emacs.d/elisp")
;; auto-install.elはElispのインストールを自動化してくれるツール
;; rubikitchさんがメンテナンスをしている
;; http://www.emacs.wiki.org/emacs/download/auto-install.el
;; を~/.emacs.d/elispにおく

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
           (expand-file-name (concat user-emacs-directory path))))
           (add-to-list 'load-path default-directory)
           (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
             (normal-top-level-add-subdirs-to-load-path))))))


;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  ;; set install directory
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; fetch names of elisp registered in EmacsWiki
  (auto-install-update-emacswiki-package-name t)
  ;; set proxy if necessary
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; enable install-elisp
  (auto-install-compatibility-setup))
;; Japanese environment
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)



;; ======================================== ;;
;; 以下大竹智也『Emacs実践入門』での設定
;; ======================================== ;;

;; C-mにnewline-and-indentを割り当てる
;; 
(global-set-key (kbd "C-m") 'newline-and-indent)
;; C-tでウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)
;; C-hをバックスペースにする
;; 入力されるシーケンスを置き換える
;; ?\C-?はDELのキーシーケンス
(keyboard-translate ?\C-h ?\C-?)
;; 別のキーバインドにヘルプを割り当てる
;; (define-key global-map (kbd "C-x /") 'help-command)

;;カラム番号も表示
(column-number-mode t)
;; ファイルサイズを表示
(size-indication-mode t)
;; 時計を表示
(setq display-time-day-and-date t) ; 曜日／月／日を表示
(setq display-time-24hr-format t)  ; 24時表示
(display-time-mode t)

;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; P101 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;; http://sakito.jp/emacs/emacs24.html#emacs-d-init-el
;; マウスで選択するとコピーする Emacs 24 ではデフォルトが nil
(setq mouse-drag-copy-region t)

;; パッケージ管理
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; undohist
;; elpaにインストールされている。パッケージ管理でインストール
(when (require 'undohist nil t)
  (undohist-initialize))

;; grep-edit : auto-installでインストール
;; M-x install-elisp RET http://www.emacswiki.org/emacs/download/grep-edit.el
(require 'grep-edit)

;; color-moccur/moccur-edit
;; M-x install-elisp RET http://www.emacswiki.org/emacs/download/color-moccur.el
;; M-x install-elisp RET http://www.emacswiki.org/emacs/download/moccur-edit.el
;; M-x moccur RETで実行
(when (require 'color-moccur nil t)
  ;; グローバルマップにoccur-by-moccurを割当
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  (require 'moccur-edit nil t)
  ;; Migemoを利用できる環境であれば使用する
  (when (and (executable-find "cmigemo")
	     (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; auto-complete mode : 入力補完
;; wget http://cx4a.org/pub/auto-complete/auto-complete-1.3.1.tar.bz2
;; tar xfj auto-complete-1.3.1.tar.bz2
;; cd auto-complete-1.3.1
;; M-x load-file ~/path/auto-complete-1.3.1/etc/install.el RET
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp//ac-dict")
(ac-config-default)

;; smartchar
;; (install-elisp "http://raw.github.com/imakado/emacs-smartchr/master/smartchr.el")
;; "="を入力すると" = "などにしてくれる
(when (require 'smartchar nil t)
  (define-key global-map
    (kbd "=") (smartchar '("=" " = " " == " " === "))))
;; window maintenance like screen
;; http://www.morishima.net/naoto/elscreen-ja
;; curl -O ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-1.4.6.tar.gz
;; tar xvf elscreen-1.4.6.tar.gz
;; cd ./elscreen-1.4.6
;; cp ./elscreen.el ~/.emacs.d/elisp/
;; M-x byte-compile-file RET ~/.emacs.d/elisp/elscreen.el RET
;;(when (require 'elscreen nil t)
;;  (if window-system
;;      (define-key elscreen-map (kbd "C-z")
;;	'iconify-or-deiconify-frame)
;;    (define-key elscreen-map (kbd "C-z")
;;      'suspend-emacs)))

;; shell from Emacs : multi-term
;; M-x multi-term
(when (require 'multi-term nil t)
  (setq multi-term-program "/bin/zsh"))

;; wdired : 標準パッケージなのでそのまま使える。ただし
;; M-x wdired-change-to-wdired-mode と実行しなければならず長いので、キーバインド設定
(require 'wdired)
(define-key dired-mode-map "r"
  'wdired-change-to-wdired-mode)

;; ESS
;; http://ess.r-project.org/Manual/ess.html#Installation
;; (require 'ess-site)
;; だと動作しないので、下記のようにフォルダに解答したフォルダを丸ごとコピーして
;; ess-site.elをloadさせる
(load "~/.emacs.d/ess/ess-13.05/lisp/ess-site")
