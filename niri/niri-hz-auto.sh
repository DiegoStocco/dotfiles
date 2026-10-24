#!/usr/bin/env bash
#
# niri-hz-auto — 120 Hz con l'alimentatore, 60 Hz a batteria (compositor niri).
#
# Installazione (come utente normale, non root):
#   1. verifica nome e modi dello schermo:   niri msg outputs
#   2. install -Dm755 niri-hz-auto.sh ~/.local/bin/niri-hz-auto
#   3. in ~/.config/niri/config.kdl aggiungi:
#        spawn-at-startup "/home/diego/.local/bin/niri-hz-auto"
#   4. provalo subito:   setsid ~/.local/bin/niri-hz-auto >/dev/null 2>&1 &
#
# Se i modi in 'niri msg outputs' hanno un valore diverso (es. 119.999), adatta
# MODE_AC / MODE_BAT qui sotto oppure passali come variabili d'ambiente.
set -u

MODE_AC="${MODE_AC:-2880x1620@120.002}"
MODE_BAT="${MODE_BAT:-2880x1620@60.001}"

# una sola istanza alla volta
lock="${XDG_RUNTIME_DIR:-/tmp}/niri-hz-auto.lock"
exec 9>"$lock"
flock -n 9 || exit 0

OUT="${OUT:-$(niri msg outputs 2>/dev/null | sed -n 's/^Output .*(\(eDP-[0-9]*\)).*/\1/p' | head -1)}"
OUT="${OUT:-eDP-1}"

ac_online() {
  local d
  for d in /sys/class/power_supply/*; do
    [[ -r $d/type && $(<"$d/type") == Mains ]] || continue
    [[ -r $d/online && $(<"$d/online") == 1 ]] && return 0
  done
  return 1
}

last=""
apply_if_changed() {
  local state mode
  if ac_online; then state=ac; mode=$MODE_AC; else state=bat; mode=$MODE_BAT; fi
  [[ $state == "$last" ]] && return
  last=$state
  niri msg output "$OUT" mode "$mode" >/dev/null 2>&1 \
    || echo "niri-hz-auto: impossibile impostare $mode su $OUT (controlla 'niri msg outputs')" >&2
}

apply_if_changed
while read -r _; do
  apply_if_changed
done < <(udevadm monitor --udev --subsystem-match=power_supply 2>/dev/null)
