import Network from "gi://AstalNetwork"
import { Variable, bind } from "astal"

const network = Network
const varThing = Variable("1")

print(network.get_default().get_primary())