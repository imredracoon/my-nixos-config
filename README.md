# nix-config

NixOS + Hyprland + tema Solitude per un Surface Pro 7. Sistema in `hosts/`,
utente con home-manager standalone, palette unica in `theme/palette.nix`.

```
flake.nix                     entry point (nixosConfigurations + homeConfigurations)
hosts/surface/configuration.nix   sistema: boot, rete, audio, Hyprland, greetd, PAM
home.nix                      pacchetti utente e import dei moduli
modules/hyprland.nix          compositor e keybind
modules/session.nix           hyprlock, hypridle, mako
modules/waybar.nix            barra
modules/launcher.nix          fuzzel
modules/terminal.nix          ghostty
modules/neovim.nix            neovim + tema generato dalla palette
nvim/init.lua                 config neovim
theme/palette.nix             colori
wallpapers/solitude.jpg       (opzionale) se presente viene usato come sfondo
```

## Prima del build

1. In `flake.nix` imposta `username` e `hostname`.
2. Sulla macchina installata, genera l'hardware:

   ```bash
   nixos-generate-config --show-hardware-config > hosts/surface/hardware-configuration.nix
   ```

3. I flake vedono solo i file tracciati da git:

   ```bash
   git init && git add -A
   ```

## Applicare

Sistema (richiede root):

```bash
sudo nixos-rebuild switch --flake .#surface
```

Utente, la prima volta (home-manager non e' ancora installato):

```bash
nix run home-manager/master -- switch --flake .#utente
```

Poi basta `home-manager switch --flake .#utente`.

Dopo il primo rebuild di sistema riavvia: greetd mostra il login e avvia Hyprland via uwsm.

## Scorciatoie

| Tasto | Azione |
|---|---|
| Super+Invio | terminale |
| Super+Spazio | launcher |
| Super+W | chiudi finestra |
| Super+F / T | fullscreen / flottante |
| Super+1..9 | workspace (Shift per spostarci la finestra) |
| Super+frecce | focus (Shift per spostare) |
| Super+L | blocca schermo |
| Super+V | cronologia clipboard |
| Stamp | screenshot di un'area (Shift: schermo intero) |
| Super+Shift+E | esci dalla sessione |
