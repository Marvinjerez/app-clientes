package main

import (
	configs "github.com/app-clientes/config"
	models "github.com/app-clientes/models"
)

func init() {
	configs.ConnectToDB()
}

func main() {
	configs.DB.AutoMigrate(&models.Cliente{})
}
