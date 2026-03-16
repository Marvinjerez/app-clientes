package models

import "gorm.io/gorm"

type Usuario struct {
	gorm.Model
	Usuario  string `gorm:"unique;not null"`
	Password string `gorm:"not null"`
}

func (Usuario) TableName() string {
	return "usuarios"
}
