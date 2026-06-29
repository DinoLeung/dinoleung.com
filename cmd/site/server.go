//go:build !js

package main

import (
	"log"
	"net/http"
	"os"

	"github.com/maxence-charriere/go-app/v11/pkg/app"
)

func runServer() {
	http.HandleFunc("/wasm_exec.js", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "web/wasm_exec.js")
	})
	http.Handle("/web/", http.StripPrefix("/web/", http.FileServer(http.Dir("web"))))
	http.Handle("/", &app.Handler{
		Name:        "dinoleung.com",
		Description: "Personal site built with go-app and TinyGo.",
		Styles: []string{
			"/web/styles.css",
		},
	})

	addr := env("ADDR", ":8080")
	log.Printf("serving on http://localhost%s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}

func env(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
