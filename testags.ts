import Battery from "gi://AstalBattery"

const battery = Battery.get_default()

print(battery.time_to_empty)
print(battery.percentage)
print(battery.vendor)
print(battery.charging)
