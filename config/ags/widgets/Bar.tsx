import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import { Clock, SysTray, Indicators, BatteryThing, TheRightThings } from "./components"

// function Wifi() {
//     const network = Network.get_default()
//     const wifi = bind(network, "wifi")
//
//     return <box visible={wifi.as(Boolean)}>
//         {wifi.as(wifi => wifi && (
//             <icon
//                 tooltipText={bind(wifi, "ssid").as(String)}
//                 className="Wifi"
//                 icon={bind(wifi, "iconName")}
//             />
//         ))}
//     </box>
//
// }
//
// function AudioSlider() {
//     const speaker = Wp.get_default()?.audio.defaultSpeaker!
//
//     return <box className="AudioSlider" css="min-width: 140px">
//         <icon icon={bind(speaker, "volumeIcon")} />
//         <slider
//             hexpand
//             onDragged={({ value }) => speaker.volume = value}
//             value={bind(speaker, "volume")}
//         />
//     </box>
// }
//
// function BatteryLevel() {
//     const bat = Battery.get_default()
//
//     return <box className="Battery"
//         visible={bind(bat, "isPresent")}>
//         <icon icon={bind(bat, "batteryIconName")} />
//         <label label={bind(bat, "percentage").as(p =>
//             `${Math.floor(p * 100)} %`
//         )} />
//     </box>
// }

function Media() {
    const mpris = Mpris.get_default()

    return <box className="Media">
        {bind(mpris, "players").as(ps => ps[0] ? (
            <box>
                <box
                    className="Cover"
                    valign={Gtk.Align.CENTER}
                    css={bind(ps[0], "coverArt").as(cover =>
                        `background-image: url('${cover}');`
                    )}
                />
                <label
                    label={bind(ps[0], "metadata").as(() =>
                        `${ps[0].title} - ${ps[0].artist}`
                    )}
                />
            </box>
        ) : (
            <label label="Nothing Playing" />
        ))}
    </box>
}

export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}>
        <centerbox className="bar-centerbox">
            <box hexpand halign={Gtk.Align.START}>
                <Media />
            </box>
            <box spacing="5">
                <Clock />
                <BatteryThing />
            </box>
            <box hexpand halign={Gtk.Align.END} >
                <TheRightThings />
            </box>
        </centerbox>
    </window>
}
