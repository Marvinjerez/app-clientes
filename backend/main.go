package main

import (
	"net/http"

	configs "github.com/app-clientes/config"
	"github.com/app-clientes/routes"
	"github.com/gin-gonic/gin"
)

func init() {
	configs.ConnectToDB()
}

func main() {

	r := gin.Default()

	routes.ClienteRouter(r)

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Hello world from server Go.",
		})
	})
	r.Run()
}
