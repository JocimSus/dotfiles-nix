import { bind } from "astal"
import { App } from "astal/gtk3"
import Tray from "gi://AstalTray"

const tray = Tray.get_default()

export function SysTray() {
    return <box spacing="5">
        {bind(tray, "items").as(items => items.map(item => (
            <menubutton
                tooltipMarkup={bind(item, "tooltipMarkup")}
                usePopover={false}
                actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
                menuModel={bind(item, "menuModel")}
            >
                <icon 
                    gicon={bind(item, "gicon")} 
                />
            </menubutton>
        )))}
    </box>
}
