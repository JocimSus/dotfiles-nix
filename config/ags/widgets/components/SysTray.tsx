import { bind } from "astal"
import { App } from "astal/gtk3"
import Tray from "gi://AstalTray"

// const map = function map<T, U>(tbl: T[], fn: (value: T, index: number) => U): U[] {
//     const new_tbl: U[] = [];
//     for (let i = 0; i < tbl.length; i++) {
//         new_tbl[i] = fn(tbl[i], i);
//     }
//     return new_tbl;
// }

const tray = Tray.get_default()
// Translated from lua, need to be fixed
export default function SysTray() {
    return <box spacing="5">
    {/* {bind(tray, "items").as((items) => {
            return map(items, (item) => {
                if (item.icon_theme_path != null) {
                    App.add_icons(item.icon_theme_path);
                }

                const menu = item.create_menu();
                return <button tooltipMarkup={bind(item, "tooltipMarkup")} className="flat" valign="CENTER" halign="Center" onClickRelease={(self, event) => {
                    switch (event.button) {
                        case "PRIMARY":
                            menu.activate()
                            break
                        case "SECONDARY":
                            if (menu != null) {
                                menu.popup_at_widget(self, "SOUTH", "NORTH", null)
                            }
                            break
                    }
                }} >
                <icon gicon={bind(item, "gicon")} />
                </button>

            })
        })} */}
        {bind(tray, "items").as(items => items.map(item => (
            <menubutton
            tooltipMarkup={bind(item, "tooltipMarkup")}
            usePopover={false}
            actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
            menuModel={bind(item, "menuModel")}>
            <icon gicon={bind(item, "gicon")} />
            </menubutton>
        )))}
    </box>
}
