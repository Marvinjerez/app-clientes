package routes

import (
	"github.com/app-clientes/controllers"
	"github.com/gin-gonic/gin"
)

func ClienteRouter(router *gin.Engine) {

	routes := router.Group("api/v1/clientes")
	routes.POST("", controllers.ClienteCreate)
	routes.GET("", controllers.ClienteGet)
	routes.GET("/:id", controllers.ClienteGetByID)
	routes.PUT("/:id", controllers.ClienteUpdate)
	routes.DELETE("/:id", controllers.ClienteDelete)
}
