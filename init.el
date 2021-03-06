; -*- lexical-binding: t -*-

(setq lexical-binding t)

(eval-when-compile
  (require 'cl)
  )

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq comp-deferred-compilation nil)

(require 'package)

(progn
  (setq package-archives
  '(("melpa" . "https://melpa.org/packages/")
    ("gnu" . "https://elpa.gnu.org/packages/")
    ("org" . "https://orgmode.org/elpa/"))))
(when (or (not (package-installed-p 'use-package)))
  (package-refresh-contents)
  (package-install 'el-get)
  (package-install 'use-package)
  (package-install 'f))

;; (require 'req-package)

(cl-loop
 for file in (split-string
	(shell-command-to-string "find ~/.emacs.d/config -type f -iname '*.el'") "\n" t)
 do (condition-case nil
  (progn
    (message "Loading file: %s" file)
    (load-file file))
  (error (message "Could not load file: %s" file))))

;(req-package-finish)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2D2A2E" "#CC6666" "#A9DC76" "#FFD866" "#78DCE8" "#FF6188" "#78DCE8" "#FCFCFA"])
 '(custom-safe-themes
   '("95d0ed21bb0e919be7687a25ad59a1c2c8df78cbe98c9e369d44e65bfd65b167" "6b80b5b0762a814c62ce858e9d72745a05dd5fc66f821a1c5023b4f2a76bc910" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "7546a14373f1f2da6896830e7a73674ef274b3da313f8a2c4a79842e8a93953e" "0e2a7e1e632dd38a8e0227d2227cb8849f877dd878afb8219cb6bcdd02068a52" "8f5a7a9a3c510ef9cbb88e600c0b4c53cdcdb502cfe3eb50040b7e13c6f4e78e" "f4876796ef5ee9c82b125a096a590c9891cec31320569fc6ff602ff99ed73dca" "4f01c1df1d203787560a67c1b295423174fd49934deb5e6789abd1e61dba9552" "fce3524887a0994f8b9b047aef9cc4cc017c5a93a5fb1f84d300391fba313743" "c086fe46209696a2d01752c0216ed72fd6faeabaaaa40db9fc1518abebaf700d" "0fe24de6d37ea5a7724c56f0bb01efcbb3fe999a6e461ec1392f3c3b105cc5ac" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "2c49d6ac8c0bf19648c9d2eabec9b246d46cb94d83713eaae4f26b49a8183fc4" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "0685ffa6c9f1324721659a9cd5a8931f4bb64efae9ce43a3dba3801e9412b4d8" "ff3c57a5049010a76de8949ddb629d29e2ced42b06098e046def291989a4104a" "56d10d2b60685d112dd54f4ba68a173c102eacc2a6048d417998249085383da1" "fd22c8c803f2dac71db953b93df6560b6b058cb931ac12f688def67f08c10640" "75b8719c741c6d7afa290e0bb394d809f0cc62045b93e1d66cd646907f8e6d43" "4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" "e27556a94bd02099248b888555a6458d897e8a7919fd64278d1f1e8784448941" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "f94110b35f558e4c015b2c680f150bf8a19799d775f8352c957d9d1054b0a210" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "0a41da554c41c9169bdaba5745468608706c9046231bbbc0d155af1a12f32271" "ca70827910547eb99368db50ac94556bbd194b7e8311cfbdbdcad8da65e803be" "e3c64e88fec56f86b49dcdc5a831e96782baf14b09397d4057156b17062a8848" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "c5692610c00c749e3cbcea09d61f3ed5dac7a01e0a340f0ec07f35061a716436" "2422e84e81ce5ff243b9b8dd4076b8bab9b5c630c9b8a7533ec3c5b3fed23329" "1fbd63256477789327fe429bd318fb90a8a42e5f2756dd1a94805fc810ae1b62" "912cac216b96560654f4f15a3a4d8ba47d9c604cbc3b04801e465fb67a0234f0" "79bc32a7c8da2ca2dd33591df9485258293e0e6e03d0ff4a2403a6882dcfdb2b" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "82360e5f96244ce8cc6e765eeebe7788c2c5f3aeb96c1a765629c5c7937c0b5b" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "0cb1b0ea66b145ad9b9e34c850ea8e842c4c4c83abe04e37455a1ef4cc5b8791" "5d09b4ad5649fea40249dd937eaaa8f8a229db1cec9a1a0ef0de3ccf63523014" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "bf387180109d222aee6bb089db48ed38403a1e330c9ec69fe1f52460a8936b66" "b66970f42d765a40fdb2b6b86dd2ab6289bed518cf4d8973919e5f24f0ca537b" "fe94e2e42ccaa9714dd0f83a5aa1efeef819e22c5774115a9984293af609fce7" "9b01a258b57067426cc3c8155330b0381ae0d8dd41d5345b5eddac69f40d409b" "3577ee091e1d318c49889574a31175970472f6f182a9789f1a3e9e4513641d86" "d71aabbbd692b54b6263bfe016607f93553ea214bc1435d17de98894a5c3a086" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "3d3807f1070bb91a68d6638a708ee09e63c0825ad21809c87138e676a60bda5d" "a92e9da0fab90cbec4af4a2035602208cebf3d071ea547157b2bfc5d9bd4d48d" "e2acbf379aa541e07373395b977a99c878c30f20c3761aac23e9223345526bcc" "632694fd8a835e85bcc8b7bb5c1df1a0164689bc6009864faed38a9142b97057" "9b272154fb77a926f52f2756ed5872877ad8d73d018a426d44c6083d1ed972b1" "34b3219ae11acd81b2bb7f3f360505019f17d7a486deb8bb9c1b6d13c6616d2e" "6177ecbffb8f37756012c9ee9fd73fc043520836d254397566e37c6204118852" "2a749c20af891c16571527d07976bbcf2bf31819fa7d322942b73386019f4d58" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" "d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee" "361f5a2bc2a7d7387b442b2570b0ef35198442b38c2812bf3c70e1e091771d1a" "f2b56244ecc6f4b952b2bcb1d7e517f1f4272876a8c873b378f5cf68e904bd59" "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94" "d5f8099d98174116cba9912fe2a0c3196a7cd405d12fa6b9375c55fc510988b5" "7c4cfa4eb784539d6e09ecc118428cd8125d6aa3053d8e8413f31a7293d43169" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "e1ecb0536abec692b5a5e845067d75273fe36f24d01210bf0aa5842f2a7e029f" "93ed23c504b202cf96ee591138b0012c295338f38046a1f3c14522d4a64d7308" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "7d708f0168f54b90fc91692811263c995bebb9f68b8b7525d0e2200da9bc903c" "58c3313b4811ed8b30239b1d04816f74d438bcb72626d68181f294b115b7220d" "51956e440cec75ba7e4cff6c79f4f8c884a50b220e78e5e05145386f5b381f7b" "229c5cf9c9bd4012be621d271320036c69a14758f70e60385e87880b46d60780" "285efd6352377e0e3b68c71ab12c43d2b72072f64d436584f9159a58c4ff545a" "f9cae16fd084c64bf0a9de797ef9caedc9ff4d463dd0288c30a3f89ecf36ca7e" "615123f602c56139c8170c153208406bf467804785007cdc11ba73d18c3a248b" "1d50bd38eed63d8de5fcfce37c4bb2f660a02d3dff9cbfd807a309db671ff1af" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "fa3bdd59ea708164e7821574822ab82a3c51e262d419df941f26d64d015c90ee" "cb96a06ed8f47b07c014e8637bd0fd0e6c555364171504680ac41930cfe5e11e" "cbd014af7a08121d1d30388c519b7374496351743bbd59371c44786640056623" "bc836bf29eab22d7e5b4c142d201bcce351806b7c1f94955ccafab8ce5b20208" default))
 '(evil-undo-system 'undo-redo)
 '(fci-rule-color "#4C4A4D" t)
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#3a81c3")
     ("OKAY" . "#3a81c3")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#42ae2c")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(jdee-db-active-breakpoint-face-colors (cons "#19181A" "#FCFCFA"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#19181A" "#A9DC76"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#19181A" "#727072"))
 '(objed-cursor-color "#CC6666")
 '(package-selected-packages
   '(jinja2-mode tron-legacy-theme melancholy-theme melacholy-theme vs-dark-theme emacs-async emacs-asyn company-ctags cyberpunk minsk-theme leuven-theme yasnippet pipenv company-prescient ivy-prescient prescient mood-line minimal-theme ccls wakatime-mode no-littering org-journal arc-dark-theme company-box treemacs-evil treemacs-projectile treemacs spacemacs spacemacs-them spacemacs-theme vscode-dark-plus-theme dracula-theme badger-theme moe-theme tao-theme doom-theme feebleline cyberpunk-theme doom-themes exec-path-from-shell slime haskell-mode platformio-mode company-irony flycheck-irony irony-eldoc irony elixir-mode typescript-mode smart-jump doom-modeline ox-twbs yaml-mode ggtags counsel-projectile counsel-etags cider color-theme-approximate rust-mode js2-mode web-mode evil-lisp-state evil-leader evil-god-state evil-commentary evil-smartparens evil smartparens company iedit flycheck-package flycheck pyvenv magit req-package use-package el-get))
 '(pdf-view-midnight-colors (cons "#FCFCFA" "#2D2A2E"))
 '(rustic-ansi-faces
   ["#2D2A2E" "#CC6666" "#A9DC76" "#FFD866" "#78DCE8" "#FF6188" "#78DCE8" "#FCFCFA"])
 '(safe-local-variable-values
   '((venv-directory . "/home/hector/trabajo/proyectos/octopull-alas-integration")
     (venv-directory . "/home/hector/.local/share/virtualenvs/octopull-alas-integration-yCvdeJyf/bin/activate")))
 '(vc-annotate-background "#2D2A2E")
 '(vc-annotate-color-map
   (list
    (cons 20 "#A9DC76")
    (cons 40 "#c5da70")
    (cons 60 "#e2d96b")
    (cons 80 "#FFD866")
    (cons 100 "#fec266")
    (cons 120 "#fdad66")
    (cons 140 "#FC9867")
    (cons 160 "#fd8572")
    (cons 180 "#fe737d")
    (cons 200 "#FF6188")
    (cons 220 "#ee627c")
    (cons 240 "#dd6471")
    (cons 260 "#CC6666")
    (cons 280 "#b56869")
    (cons 300 "#9f6b6c")
    (cons 320 "#886d6f")
    (cons 340 "#4C4A4D")
    (cons 360 "#4C4A4D")))
 '(vc-annotate-very-old-color nil)
 '(wakatime-cli-path "/usr/bin/wakatime")
 '(wakatime-python-bin nil)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-error ((t (:underline "Red1"))))
 '(flycheck-info ((t (:underline "ForestGreen"))))
 '(flycheck-warning ((t (:underline "DarkOrange")))))

(message "Done loading init.el")
