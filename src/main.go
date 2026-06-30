package main

import "github.com/maxence-charriere/go-app/v11/pkg/app"

func main() {
	registerRoutes()
	app.RunWhenOnBrowser()
	runServer()
}
