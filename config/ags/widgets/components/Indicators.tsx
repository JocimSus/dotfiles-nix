// the below import from astal is used multiple time, need to fix
import { Variable, bind } from "astal"
import Wp from "gi://AstalWp"
import Battery from "gi://AstalBattery"
import Network from "gi://AstalNetwork"

function WifiIcon() {
    const wifi = Network.get_default().wifi

    return <icon
        className="icon"
        tooltipText={bind(wifi, "ssid").as(String)}
        icon={bind(wifi, "iconName")
    }/>
}

function VolumeIcon() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!
    const scrollToggle = Variable()

    return <eventbox
        onHover={() => scrollToggle.set(true)}
        onHoverLost={() => scrollToggle.set(false)}
        // questionable string.format, check indicators.lua
        tooltipText={bind(speaker, "volume").as(v => `${Math.floor(v * 100)}%`)}
    >
        <box>
            <button onClickRelease={speaker.mute = !speaker.mute}>
                <icon className="icon" icon={bind(speaker, "volumeIcon")}/>
            </button>
        </box>
        /* maybe gtkrevealer idk */
        <revealer
            revealChild={scrollToggle()}
            transitionType="SLIDE_LEFT"
            valign="CENTER"
            >
            <slider
                className="volume-slider"
                onDragged={(self) => speaker.volume = self.value}
                hexpand
                value={bind(speaker, "volume")}
            />
        </revealer>
    </eventbox>
}

function BatteryIcon() {
    const bat = Battery.get_default()

    return <icon
        className="icon"
        icon={bind(bat, "batteryIconName")}
        tooltipText={bind(bat, "percentage").as(p => `${Math.floor(p * 100)}%`)}
    />
}

export default function Indicators() {
    return <box className="bar-box" valign="CENTER">
        <box className="indicator-cter" valign="CENTER" halign="CENTER" hexpand spacing="10">
            <WifiIcon />
            <VolumeIcon />
            <BatteryIcon />
        </box>
    </box>
}
