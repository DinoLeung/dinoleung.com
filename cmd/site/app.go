package main

import "github.com/maxence-charriere/go-app/v10/pkg/app"

type home struct {
	app.Compo
}

func registerRoutes() {
	app.Route("/", func() app.Composer {
		return &home{}
	})
}

func (h *home) Render() app.UI {
	return app.Div().Class("page").Body(
		app.Main().Class("shell").Body(
			app.Section().Class("hero").Body(
				app.A().Class("github-button").Href("https://github.com/DinoLeung/dinoleung.com").Target("_blank").Rel("noreferrer").Aria("label", "GitHub").Title("GitHub"),
				app.P().Class("eyebrow").Text("Home"),
				app.H1().Text("[headline]"),
				app.P().Class("lede").Text("[two sentence intro here]"),
			),
			app.Section().Class("content-grid").Body(
				placeholderCard("About", "[something about me and what i care]"),
				placeholderCard("Projects", "[links to projects maybe]"),
				placeholderCard("Contact", "[email, github, linkedin]"),
				placeholderCard("Links", "[downlaod link for my resume?]"),
			),
		),
	)
}

func placeholderCard(title, body string) app.UI {
	return app.Article().Class("card").Body(
		app.H2().Text(title),
		app.P().Text(body),
	)
}
