import evdev, subprocess

LED_PATH = '/sys/class/leds/platform::mute/brightness'
EVENT_DEV = '/dev/input/event0' # check with evtest
KEY_CODE = evdev.ecodes.KEY_MUTE

# the DEFAULT_SINK may behave weird with multiple audio outputs
def is_muted() -> bool:
    out = subprocess.run(
        ['wpctl', 'get-volume', '@DEFAULT_AUDIO_SINK@'],
        capture_output=True, text=True
    ).stdout
    return 'MUTED' in out

def set_led(on: bool):
    with open(LED_PATH, 'w') as f:
        f.write('1' if on else '0')

def main():
    # to proof dualboot
    set_led(is_muted())

    dev = evdev.InputDevice(EVENT_DEV)
    for ev in dev.read_loop():
        if ev.type == evdev.ecodes.EV_KEY and ev.code == KEY_CODE:
            set_led(is_muted())

main()