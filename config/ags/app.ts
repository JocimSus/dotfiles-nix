import { App } from "astal/gtk3"
import styles from "./styles.scss"
// import icons from "./assets/icons"
import Bar from "./widgets/Bar.tsx"

App.start({
    // icons: icons,
    css: styles,
    instanceName: "astal",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(Bar),
})
