import Network from "gi://AstalNetwork"
import { Variable, bind } from "astal"

const network = Network.get_default().get_primary()
const varThing = Variable("1")

print(varThing.get())