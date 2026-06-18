;; mirante — Rust-native terminal UI for observing and navigating
;; Kubernetes clusters. caixa Binario kind.
;;
;; Forked from fioletoven/b4n (MIT) at v0.4.9 / e7305e9; rebuilt to
;; pleme-io standards. Author edits HERE; substrate-side renderers
;; re-derive downstream (auto-release → crates.io per-member in dep order
;; + git tag; caixa-validate → CSE invariant check).
;;
;; Build:
;;   nix build .#mirante
;;   nix run  .#mirante -- --help
;;
;; Consume via home-manager:
;;   imports = [ mirante.homeManagerModules.default ];
;;   programs.mirante.enable = true;

(defcaixa
  :nome        "mirante"
  :versao      "0.1.0"
  :kind        Binario
  :edicao      "2026"
  :descricao   "Rust-native terminal UI for observing and navigating Kubernetes clusters"
  :repositorio "github:pleme-io/mirante"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("mirante" "rust" "kubernetes" "tui" "terminal" "k8s" "caixa-binario")

  ;; Workspace deps that need to vendor at build time.
  :deps        ()
  :deps-dev    ()

  ;; The wired-up binary `feira publish` releases (root package dir).
  :binarios    ("mirante")

  ;; The six library members are published to crates.io as mirante-* by the
  ;; workspace auto-release pipeline (multi-pass dep-order). They are the
  ;; reusable typed surface (mirante-kube is the UI-decoupled k8s engine).
  :bibliotecas ("mirante-kube" "mirante-list" "mirante-common"
                "mirante-config" "mirante-tasks" "mirante-tui"))
