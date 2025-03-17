import { Gtk } from "astal/gtk3"
import Network from "gi://AstalNetwork"
import { Variable, bind } from "astal"

const network = Network

function SimpleNetworkIndicator() {
    const wifi = Network.get_default().wifi

    return <icon
        className="icon"
        tooltipText={bind(wifi, "ssid").as(String)}
        icon={bind(wifi, "iconName")
    }/>
}

function NetworkIndicator() {
    const visibleChild = Variable("2")

    return <stack
        transitionType={Gtk.RevealerTransitionType.SLIDE_UP_DOWN}
        transitionDuration="110"
        // TODO: COME HERE AND COMPLETE THIS
        // PROBLEM: THE FUJNCTION INSIDE SETUP IS NOT CALLED AT ALL
        // visibleChild IS NOT SET INSIDE IT
        setup={(self) => self.hook(network, visibleChild => {
            const primaryNetwork = network.get_default().get_primary()
            if ([1, 2].includes(primaryNetwork))
                visibleChild.set("2")
            else
                visibleChild.set("2")
        })}
        visibleChildName={visibleChild.get()}
        >
            <label name="1" label="1" />
            <label name="2" label="2" />
    </stack>
}

export function StatusIcons() {
    return <box>
        <NetworkIndicator />
    </box>
}