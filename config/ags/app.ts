import { App } from "astal/gtk3"
import styles from "./styles.scss"
import Bar from "./widgets/Bar.tsx"

const iconsPath = "./assets/icons";

App.start({
    icons: iconsPath,
    css: styles,
    instanceName: "ags",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(Bar),
})
