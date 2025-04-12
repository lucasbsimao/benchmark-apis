package main

import (
    "net/http"

    "math"

	"strconv"

    "github.com/gin-gonic/gin"
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

func get(c *gin.Context) {

	nStr := c.Query("n")

    n, _ := strconv.Atoi(nStr)

	result := compute(n)

	c.Header("X-Benchmark-Result", strconv.Itoa(result))
	
    c.Data(http.StatusOK, "text/plain", []byte("OK"))
}

func main() {
    gin.SetMode(gin.ReleaseMode)
    router := gin.New()
    router.GET("/benchmark", get)

    router.Run("0.0.0.0:8080")
}