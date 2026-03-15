package controllers

import (
	configs "github.com/app-clientes/config"
	models "github.com/app-clientes/models"
	"github.com/gin-gonic/gin"
)

type ClienteRequestBody struct {
	Dpi      string `json:"dpi"`
	Nombre   string `json:"nombre"`
	Email    string `json:"email"`
	Telefono string `json:"telefono"`
}

func ClienteCreate(c *gin.Context) {
	body := ClienteRequestBody{}

	c.BindJSON(&body)

	cliente := &models.Cliente{Dpi: body.Dpi, Nombre: body.Nombre, Email: body.Email, Telefono: body.Telefono}

	result := configs.DB.Create(&cliente)

	if result.Error != nil {
		c.JSON(500, gin.H{"Error": "Failed to insert"})
		return
	}

	c.JSON(200, &cliente)
}

func ClienteGet(c *gin.Context) {
	var clientes []models.Cliente
	configs.DB.Find(&clientes)
	c.JSON(200, &clientes)
	return
}

func ClienteGetByID(c *gin.Context) {
	id := c.Param("id")
	var cliente models.Cliente
	configs.DB.First(&cliente, id)
	c.JSON(200, &cliente)
	return
}

func ClienteUpdate(c *gin.Context) {
	id := c.Param("id")
	var cliente models.Cliente
	configs.DB.First(&cliente, id)

	body := ClienteRequestBody{}
	c.BindJSON(&body)
	data := &models.Cliente{Dpi: body.Dpi, Nombre: body.Nombre, Email: body.Email, Telefono: body.Telefono}

	result := configs.DB.Model(&cliente).Updates(data)

	if result.Error != nil {
		c.JSON(500, gin.H{"Error": true, "message": "Failed to update"})
		return
	}
	c.JSON(200, &cliente)
}

func ClienteDelete(c *gin.Context) {
	id := c.Param("id")
	var cliente models.Cliente
	configs.DB.Delete(&cliente, id)
	c.JSON(200, gin.H{"deleted": true})
	return

}
