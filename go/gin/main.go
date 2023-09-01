package main

import (
    "net/http"

	"os"
	"strconv"
	"fmt"

	"crypto/sha256"
    "encoding/hex"

    "github.com/gin-gonic/gin"
)

func get(c *gin.Context) {

	nStr := c.Query("n")

    n, err := strconv.Atoi(nStr)

	data, err := os.ReadFile("/tmp/txt")
    if err != nil {
        fmt.Println(err)
        return
    }

	
    content := string(data)

	for i := 0; i < n; i++ {
		sha256Hash := sha256.Sum256([]byte(content))

    	hex.EncodeToString(sha256Hash[:])
	}

	
    c.Data(http.StatusOK, "text/plain", []byte("OK"))
}

func main() {
    router := gin.Default()
    router.GET("/benchmark", get)

    router.Run("localhost:8080")
}