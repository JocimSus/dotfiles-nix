import { Variable, bind } from "astal"
import Battery from "gi://AstalBattery"

function BatteryIcon() {
    const bat = Battery.get_default()
    const batIconName = bind(bat, "batteryIconName")
    const batDecimal = bind(bat, "percentage")
    const batPercentage = batDecimal.as(p => `${Math.floor(p * 100)}%`)

    return <box spacing="2">
        <label label={batPercentage} />
            <circularprogress value={batDecimal} startAt={0.00} endAt={1.00}>
                <icon
                    icon={batIconName}
                    tooltipText={batPercentage}
            />
        </circularprogress>
    </box>
}

export function Battery() {
    return <box className="bar-box" valign="CENTER">
        <box className="indicator-cter" valign="CENTER" halign="CENTER" hexpand spacing="10">
            <BatteryIcon />
        </box>
    </box>
}