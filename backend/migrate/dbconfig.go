package main

import (
	configs "github.com/app-clientes/config"
)

func init() {
	configs.ConnectToDB()
}
