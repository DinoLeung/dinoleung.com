//go:build js

package app

import "strings"

func clientResourceResolver(resourcesLocation string) func(string) string {
	return func(location string) string {
		if remoteLocation(location) || !webLocation(location) {
			return location
		}
		location = strings.Trim(location, "/")
		return resourcesLocation + "/" + strings.TrimPrefix(location, "web/")
	}
}

func remoteLocation(location string) bool {
	return strings.HasPrefix(location, "https://") ||
		strings.HasPrefix(location, "http://")
}

func webLocation(location string) bool {
	return strings.HasPrefix(location, "/web/") ||
		location == "/web" ||
		strings.HasPrefix(location, "web/") ||
		location == "web"
}
