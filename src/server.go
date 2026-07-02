//go:build !js

package main

import (
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"

	"github.com/maxence-charriere/go-app/v11/pkg/app"
)

const (
	siteDomain      = "dinoleung.com"
	siteDescription = "Dino Leung is a platform engineer focused on AWS, Kubernetes, GitOps, observability, and reproducible delivery systems."
	siteImage       = "/web/icons/site/dino-512.png"
)

func runServer() {
	if env("GENERATE_STATIC", "") == "1" {
		if err := app.GenerateStaticWebsite(env("STATIC_DIR", "dist"), siteHandler(), "/favicon.ico"); err != nil {
			log.Fatal(err)
		}
		return
	}

	http.HandleFunc("/wasm_exec.js", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "web/wasm_exec.js")
	})
	http.Handle("/web/", http.StripPrefix("/web/", http.FileServer(http.Dir("web"))))
	http.Handle("/", siteHandler())

	addr := env("ADDR", ":8080")
	log.Printf("serving on http://localhost%s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}

func siteHandler() *app.Handler {
	return &app.Handler{
		Name:        "dinoleung.com",
		Title:       "Dino Leung",
		Description: siteDescription,
		Domain:      siteDomain,
		Author:      "Dino Leung",
		Image:       siteImage,
		ShortName:   "Dino",
		Icon: app.Icon{
			Default:  "/web/icons/site/dino-192.png",
			Large:    "/web/icons/site/dino-512.png",
			SVG:      "/web/icons/site/dino.svg",
			Maskable: "/web/icons/site/dino-512.png",
		},
		BackgroundColor:   "#eff1f5",
		ThemeColor:        "#4c4f69",
		LoadingLabel:      "Loading {progress}%",
		WasmContentLength: wasmContentLength(),
		ProxyResources: []app.ProxyResource{
			{Path: "/favicon.ico", ResourcePath: "/web/favicon.ico"},
		},
		CacheableResources: []string{
			"/web/icons/site/dino.svg",
			"/web/favicon.ico",
		},
		Styles: []string{
			"/web/styles.css",
		},
	}
}

func wasmContentLength() string {
	path := filepath.Join("web", "app.wasm")
	if staticDir := env("STATIC_DIR", ""); staticDir != "" {
		path = filepath.Join(staticDir, "web", "app.wasm")
	}

	info, err := os.Stat(path)
	if err != nil {
		return ""
	}
	return strconv.FormatInt(info.Size(), 10)
}

func env(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
