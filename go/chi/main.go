package main

import (
    "net/http"

	"os"
	"strconv"
	"fmt"

	"crypto/sha256"

    "github.com/go-chi/chi"
)

func get(w http.ResponseWriter, r *http.Request) {

	nStr := chi.URLParam(r, "n")

    n, err := strconv.Atoi(nStr)

	data, err := os.ReadFile("/tmp/txt")
    if err != nil {
        fmt.Println(err)
        return
    }

	
    content := string(data)
    bytes := []byte(content)

	for i := 0; i < n; i++ {
		sha256.Sum256(bytes)
	}

	
    w.Write([]byte("OK"))
}

func main() {
    r := chi.NewRouter()
    r.Get("/benchmark", get)

    http.ListenAndServe(":8080", r)
}