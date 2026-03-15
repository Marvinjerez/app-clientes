package models

import (
	"gorm.io/gorm"
)

type Cliente struct {
	gorm.Model /*esto se utiliza como id que toma el de la BD*/
	Dpi        string
	Nombre     string
	Email      string
	Telefono   string
}

func (Cliente) Tablename() string {
	return "clientes"
}
