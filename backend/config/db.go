package configs

import (
	"log"

	"github.com/app-clientes/models"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectToDB() {

	var err error

	dsn := "root:12481248MjjC*@tcp(localhost:3306)/app_clientes?charset=utf8mb4&parseTime=True&loc=Local"

	DB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatal("No se pudo conectar a la base:", err)
	}

	// AutoMigrate
	DB.AutoMigrate(
		&models.Cliente{},
		&models.Usuario{},
	)

	log.Println("Base de datos conectada correctamente")
}
