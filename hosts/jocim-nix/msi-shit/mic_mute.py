#!/usr/bin/env python3
import subprocess
from subprocess import PIPE

LED_PATH = '/sys/class/leds/platform::micmute/brightness'
PACTL    = '/run/current-system/sw/bin/pactl'

def is_muted() -> bool:
    out = subprocess.run(
        [PACTL, 'get-source-mute', '@DEFAULT_SOURCE@'],
        capture_output=True, text=True
    ).stdout.lower()
    return 'yes' in out

def set_led(on: bool):
    with open(LED_PATH, 'w') as f:
        f.write('1' if on else '0')

def main():
    set_led(is_muted())

    proc = subprocess.Popen(
        [PACTL, 'subscribe'],
        stdout=PIPE, text=True, bufsize=1
    )

    for line in proc.stdout:
        if 'source' in line:
            set_led(is_muted())

main()
