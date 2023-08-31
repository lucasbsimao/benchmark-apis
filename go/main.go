package main

import (
    "net/http"

	"os"
	"strconv"
	"fmt"

	"crypto/sha256"
    "encoding/hex"

    "github.com/go-chi/chi"
)

func get(w http.ResponseWriter, r *http.Request) {

	nStr := chi.URLParam(r, "n")

    n, err := strconv.Atoi(nStr)

	data, err := os.ReadFile("txt")
    if err != nil {
        fmt.Println(err)
        return
    }

	
    content := string(data)

	for i := 0; i < n; i++ {
		sha256Hash := sha256.Sum256([]byte(content))

    	hex.EncodeToString(sha256Hash[:])
	}

	
    w.Write([]byte("OK"))
}

func main() {
    r := chi.NewRouter()
    r.Get("/benchmark", get)

    http.ListenAndServe(":8080", r)
}