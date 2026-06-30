package main

import "github.com/maxence-charriere/go-app/v11/pkg/app"

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
			heroCard(),
			app.Section().Class("content-grid").Body(
				contactCard(),
				aboutCard(),
				projectsCard(),
			),
		),
	)
}

func heroCard() app.UI {
	return app.Section().Class("hero").Body(
		app.A().Class("source-code-button").
			Href("https://github.com/DinoLeung/dinoleung.com").
			Target("_blank").
			Rel("noreferrer").
			Aria("label", "View source code for dinoleung.com on GitHub"),
		app.P().Class("eyebrow").Text("Dino Leung"),
		app.H1().Text("Platform Engineer"),
		app.P().Class("lede").
			Text(
				"Owned production infrastructure and developer enablement through practical, " +
				"repeatable systems."),
	)
}

func contactCard() app.UI {
	return app.Article().Class("card contact-card").Body(
		app.H2().Text("Contact"),
		app.Div().Class("contact-list").Body(
			app.A().Class("contact-link").
				Href("mailto:hi@DinoLeung.com").
				Aria("label", "Email Dino Leung").
				Body(
					app.Span().Class("contact-glyph contact-glyph-email"),
					app.Span().Text("hi@DinoLeung.com"),
				),
			app.A().Class("contact-link").
				Href("https://github.com/DinoLeung").
				Target("_blank").
				Rel("noreferrer").
				Aria("label", "GitHub profile for Dino Leung").
				Body(
					app.Span().Class("contact-glyph contact-glyph-github"),
					app.Span().Text("@DinoLeung"),
				),
			app.A().Class("contact-link").
				Href("https://www.linkedin.com/in/DinoPHLeung").
				Target("_blank").
				Rel("noreferrer").
				Aria("label", "LinkedIn profile for Dino Leung").
				Body(
					app.Span().Class("contact-glyph contact-glyph-linkedin"),
					app.Span().Text("DinoPHLeung"),
				),
		),
	)
}

func aboutCard() app.UI {
	return app.Article().Class("card").Body(
		app.H2().Text("About"),
		app.P().Text(
			"I work across AWS, Kubernetes, GitOps, CI/CD, observability, and secure " +
			"cloud operations, turning platform requirements into systems developers " +
			"can use without fighting them. I care about reliability, clear deployment " +
			"paths, and repeatable environments, which is also why NixOS and reproducible " +
			"local setup interest me."),
	)
}

func projectsCard() app.UI {
	return app.Article().Class("card projects-card").Body(
		app.H2().Text("Projects"),
		app.Div().Class("project-list").Body(
			app.Div().Class("project-item").Body(
				app.A().Class("project-link").
					Href("https://github.com/DinoLeung/can-pulse").
					Target("_blank").
					Rel("noreferrer").
					Aria("label", "can-pulse project on GitHub").
					Body(
						app.Span().Class("project-glyph"),
						app.Span().Class("project-title").Text("can-pulse"),
					),
				app.Span().Class("project-description").
					Text("An ESP32-based CAN bus bridge for RaceChrono."),
			),
			app.Div().Class("project-item").Body(
				app.A().Class("project-link").
					Href("https://github.com/DinoLeung/skuare").
					Target("_blank").
					Rel("noreferrer").
					Aria("label", "skuare project on GitHub").
					Body(
						app.Span().Class("project-glyph"),
						app.Span().Class("project-title").Text("skuare"),
					),
				app.Span().Class("project-description").
					Text("A work-in-progress Compose Multiplatform take on a G-Shock companion app."),
			),
			app.Div().Class("project-item").Body(
				app.A().Class("project-link").
					Href("https://github.com/DinoLeung/TeleDart").
					Target("_blank").
					Rel("noreferrer").
					Aria("label", "TeleDart project on GitHub, unmaintained").
					Body(
						app.Span().Class("project-glyph"),
						app.Span().Class("project-title").Body(
							app.Span().Text("TeleDart"),
							app.Span().Class("project-status").Text("unmaintained"),
						),
					),
				app.Span().Class("project-description").
					Text("A Dart library for building against the Telegram Bot API."),
			),
		),
	)
}
