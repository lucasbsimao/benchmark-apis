package main

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strconv"
)

const addr = ":8080"
const filepath = "/tmp/txt"

func benchmarkHandler(w http.ResponseWriter, r *http.Request) {
	nstr := r.URL.Query().Get("n")
	if nstr == "" {
		w.WriteHeader(http.StatusBadRequest)
		_ = json.NewEncoder(w).Encode(map[string]string{
			"error": `query 'n' is missing or empty`,
		})
		return
	}

	// Convert the string to an integer
	n, err := strconv.Atoi(nstr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		_ = json.NewEncoder(w).Encode(map[string]string{
			"error": `query 'n' must be an integer`,
		})
		return
	}

	data, err := os.ReadFile(filepath)
	if err != nil {
		slog.Error("unable to read file", "err", err)
		return
	}

	for i := 0; i < n; i++ {
		h := sha256.Sum256(data)
		hex.EncodeToString(h[:])
	}
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`OK`))
	// _ = json.NewEncoder(w).Encode(map[string]string{
	// 	"result": `OK`,
	// })
}

func main() {
	mx := http.NewServeMux()
	mx.HandleFunc("/benchmark", benchmarkHandler)

	srv := &http.Server{
		Handler: mx,
		Addr:    addr,
	}

	ch := setupShutdown(srv)
	slog.Info("starting up", "addr", addr)
	if err := srv.ListenAndServe(); err != http.ErrServerClosed {
		slog.Error("fail to listen and serve", "err", err)
	}
	<-ch
	slog.Info("shutting down")
}

func setupShutdown(srv *http.Server) chan struct{} {
	shutdownComplete := make(chan struct{})
	go func() {
		sigint := make(chan os.Signal, 1)
		signal.Notify(sigint, os.Interrupt)
		<-sigint // We wait...

		// BooYa!
		if err := srv.Shutdown(context.Background()); err != nil {
			slog.Error("fail to shutdown", "err", err)
		}

		close(shutdownComplete)
	}()

	return shutdownComplete
}
