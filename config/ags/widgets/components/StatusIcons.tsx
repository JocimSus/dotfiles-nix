import { Gtk } from "astal/gtk3"
import Network from "gi://AstalNetwork"
import { Variable, bind } from "astal"

const network = Network

function SimpleNetworkIndicator({ name }: { name: string }) {
    const wifi = Network.get_default().wifi

    return <icon
        name={name}
        className="icon"
        tooltipText={bind(wifi, "ssid").as(String)}
        icon={bind(wifi, "iconName")
    }/>
}

function NetworkIndicator() {
    const visibleChild = Variable("0")
    const primaryNetwork = network.get_default().get_primary()
    visibleChild.set(`${primaryNetwork}`)

    return <stack
        transitionType={Gtk.RevealerTransitionType.SLIDE_UP_DOWN}
        transitionDuration="110"
        // TODO: COME HERE AND COMPLETE THIS
        // PROBLEM: THE FUJNCTION INSIDE SETUP IS NOT CALLED AT ALL
        // visibleChild IS NOT SET INSIDE IT
        // setup={(self) => self.hook(network, visibleChild => {
        //     const primaryNetwork = network.get_default().get_primary()
        //     visibleChild.set(`${primaryNetwork}`)
        // })}
        visibleChildName={visibleChild.get()}
        >
            <label name="1" label="1" />
            <SimpleNetworkIndicator name="2" />
    </stack>
}

export function StatusIcons() {
    return <box>
        <NetworkIndicator />
    </box>
}