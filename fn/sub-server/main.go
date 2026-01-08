package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"text/template"
)

var t *template.Template

func handler(w http.ResponseWriter, r *http.Request) {
	token := r.URL.Query().Get("token")
	if token == "" {
		http.Error(w, "Missing 'token' query parameter", http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "text/plain; charset=utf-8")

	err := t.Execute(w, token)
	if err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}
}

func main() {
	listen := os.Getenv("SUB_SERVER_LISTEN")
	if listen == "" {
		listen = ":8080"
	}

	tmplPath := os.Getenv("SUB_SERVER_TEMPLATE_PATH")
	if tmplPath == "" {
		log.Fatal("Environment variable SUB_TEMPLATE_PATH is not set")
	}

	var err error
	t, err = template.ParseFiles(tmplPath)
	if err != nil {
		log.Fatalf("Failed to parse template file at %s: %v", tmplPath, err)
	}

	http.HandleFunc("/", handler)
	fmt.Printf("Starting server on %s\n", listen)
	http.ListenAndServe(listen, nil)
}
