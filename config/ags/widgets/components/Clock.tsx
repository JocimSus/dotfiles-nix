import { Variable, GLib } from "astal"

export function Clock() {
    const time = Variable<string>("00:00").poll(6000, () => GLib.DateTime.new_now_local().format("%H:%M"))

    const date = Variable<string>("00:00").poll(3600000, () => GLib.DateTime.new_now_local().format("%a, %d/%m/%g"))

    return <box className="bar-box clock-box" halign="CENTER" valign="CENTER" spacing="5" onDestroy={() => {
        time.drop()
        date.drop()
    }}>
        <label label={time()} className="bar-label" halign="CENTER" hexpand />
        <icon icon="dot-symbolic" className="symbolic" valign="CENTER" />
        <label label={date()} className="bar-label" halign="CENTER" hexpand />
    </box>
}
