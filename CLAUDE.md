# mirante

Rust-native terminal UI for **observing and navigating Kubernetes clusters**
— a k9s-class TUI, rebuilt to pleme-io standards.

> Theory is canonical in [pleme-io/theory/THEORY.md](https://github.com/pleme-io/theory).
> This repo follows the twelve pillars, typed-emission, and the caixa SDLC.
> See also: `theory/TYPED-EMISSION.md` (format!() ban), `theory/URDUME.md` /
> `theory/TELA.md` (sibling service/frontend doctrines).

pending-format-ban: 227   # inherited from b4n; burn down then flip deny (see Standards)

## What this is

A **hard fork of [fioletoven/b4n](https://github.com/fioletoven/b4n)** (MIT) pinned
at **v0.4.9 / `e7305e9`**, taken over and standardized by pleme-io. Attribution in
`NOTICE` + git history; upstream `mirante-kube` bugfixes may be cherry-picked.

Name: *mirante* (Portuguese — lookout / vantage point), in the mado/tear/frost
tool register (NOT the urdume→tela loom spine). Observe-first; gated mutate later.

## Architecture (workspace)

| crate | role | reuse posture |
|-------|------|---------------|
| `mirante` (root) | binary: `b4n/`→`mirante/` `{cli,core,kube,ui}` event loop | rebuild to standard |
| `mirante-kube` | UI-decoupled k8s engine (kube-rs 3.0 + DynamicObject, k9s breadth) | reuse ≈as-is; converge on engenho `ClusterReader` trait |
| `mirante-config` | typed config (`Persistable`, keys, themes) | **Tier-A target**: swap loader → shikumi `.lisp` |
| `mirante-list` `mirante-common` `mirante-tasks` `mirante-tui` | list model / utils / async work / widgets | reuse ≈as-is |

Stack: ratatui 0.30, crossterm 0.29, kube 3.0, k8s-openapi 0.27, tokio. edition 2024.

## Decisions (locked 2026-06-17)

- **Scope**: Tier-A MVP first (standards + shikumi/lisp *data* config); the
  programmable Tier-B (embedded tatara-lisp-eval: lisp-defined keybindings/
  views/commands) is a separately-budgeted follow-on.
- **Posture**: observe-first; mutate verbs (scale/delete/edit) come later behind
  a capability flag — no SSA/status-write ceremony in v1.

## Config — shikumi + tatara-lisp (the programmability layer)

Two tiers (be tier-honest):

- **Tier A (this MVP)** — `mirante.lisp` parsed by `shikumi::LispProvider` into
  typed `MiranteConfig` (serde). Wire via `shikumi::ConfigStore::load_and_watch`
  (ArcSwap hot-reload) + `mirante config-show`. PRECEDENCE: defaults < env < FILE
  for the single-file path. Note: b4n's `KeyBindings`/`TextColors` have bespoke
  serde (inverted comma-string map; `fg:dim:bg`) — author the lisp to that shape
  OR adapt the serde (planned: adapt the serde). `~/.config/mirante/mirante.lisp`.
- **Tier B (later)** — embed `tatara-lisp-eval` (`Interpreter<H>` + host-fn
  stdlib) for `(defcommand)`/`(defview)`/`(bind-key)`. Requires opening the
  closed `KeyCommand`/`ResponseEvent` enums + decomposing `BgWorker`. Separate file
  `mirante.tlisp`. mirante would be the FIRST pleme-io consumer of the eval FFI.

## Standards adoption status

- [x] crate rename `b4n*`→`mirante*`; `APP_NAME`/config dir → `mirante`
- [x] `clippy.toml` format-ban declared (NOT yet enforced — see pending-format-ban)
- [x] `deny.toml` license gate (permissive allowlist; MIT fork, 0 copyleft)
- [x] `flake.nix` via substrate `rust-workspace-release-flake.nix` (module trio auto-emitted)
- [x] `caixa.lisp` :kind Binario; CI shims: auto-release / gen-spec / caixa-validate
- [x] `NOTICE` upstream attribution
- [ ] `gen build .` → commit Cargo.gen.lock (needed for `nix build`)
- [ ] shikumi `.lisp` config loader swap (Tier A)
- [ ] ishou `tui`-target theming (blocked on upstream ishou: selection role + Style surface)
- [ ] engenho `ClusterReader` trait + `SecretView` redaction + `FailureKind` convergence
- [ ] format!() burndown (227) → flip `disallowed_macros = "deny"`

## Build

```sh
cargo check --workspace          # dev
nix build .#mirante              # after `gen build .` lands Cargo.gen.lock
nix run  .#mirante -- --help
```

Memory: see `project_mirante_k8s_tui_fork` for the full recon + roadmap.
