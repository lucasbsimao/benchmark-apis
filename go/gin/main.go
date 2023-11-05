package main

import (
    "net/http"

	"os"
	"strconv"
	"fmt"

	"crypto/sha256"

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
    bytes := []byte(content)

	for i := 0; i < n; i++ {
		sha256.Sum256(bytes)
	}
	
    c.Data(http.StatusOK, "text/plain", []byte("OK"))
}

func main() {
    router := gin.Default()
    router.GET("/benchmark", get)

    router.Run("0.0.0.0:8080")
}