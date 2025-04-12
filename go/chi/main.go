package main

import (
    "net/http"

	"strconv"

    "math"

    "github.com/go-chi/chi"
)

func compute(n int) int {
	result := 0

    temp := make([]int, n)
	for i := 0; i < n; i++ {
		temp[i] = int(math.Sqrt(float64(i*i + i)))
		result += temp[i]
	}
	
    return result
}

func get(w http.ResponseWriter, r *http.Request) {

	nStr := r.URL.Query().Get("n")

    n, _ := strconv.Atoi(nStr)

	result := compute(n)

    w.Header().Set("X-Benchmark-Result", strconv.Itoa(result))
	
    w.Write([]byte("OK"))
}

func main() {
    r := chi.NewRouter()
    r.Get("/benchmark", get)

    http.ListenAndServe(":8080", r)
}