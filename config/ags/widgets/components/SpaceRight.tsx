import { App } from "astal/gtk3"
import Mpris from "gi://AstalMpris"

const mpris = Mpris.get_default()

function SpaceRightDefaultClicks(Child) {
    return <eventbox
        // onHover={() => /* barStatusIcons.toggleClassName('bar-statusicons-hover', true) */}
        // onHoverLost={() => /* barStatusIcons.toggleClassName('bar-statusicons-hover', false) */}
        onPrimaryClick={() => App.toggleWindow('sideright')}
        // onSecondaryClick={() => }
        // onMiddleClick={() => }
        // setup={(self) => self.on('button-press-event', (self, event) => {
        //     if (event.get_button()[1] === 8) 
        //         execAsync('playerctl previous').catch(print)
        // })}
        >
        <Child />
    </eventbox>
}

function ActualContent() {
    return <box className="" hexpand>

    </box>
}

export function Indicators() {
    return <eventbox
        onScrollUp={() => {

        }}
        onScrollDown={() => {

        }}
        >
            <box>
                <ActualContent />
            </box>
    </eventbox>
}