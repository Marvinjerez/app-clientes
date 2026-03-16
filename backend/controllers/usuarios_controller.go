package controllers

import (
	"time"

	configs "github.com/app-clientes/config"
	models "github.com/app-clientes/models"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

var jwtKey = []byte("mi_clave_secreta")

type UsuarioRequestBody struct {
	Usuario  string `json:"usuario"`
	Password string `json:"password"`
}

type LoginRequest struct {
	Usuario  string `json:"usuario"`
	Password string `json:"password"`
}

type Claims struct {
	Usuario string `json:"usuario"`
	jwt.RegisteredClaims
}

func UsuarioCreate(c *gin.Context) {

	body := UsuarioRequestBody{}

	if err := c.BindJSON(&body); err != nil {
		c.JSON(400, gin.H{"error": "Body inválido"})
		return
	}

	// verificar si el usuario existe
	var existing models.Usuario

	configs.DB.Where("usuario = ?", body.Usuario).First(&existing)

	if existing.ID != 0 {
		c.JSON(400, gin.H{
			"error": "El usuario ya existe",
		})
		return
	}

	// HASH PASSWORD
	hashedPassword, err := bcrypt.GenerateFromPassword(
		[]byte(body.Password),
		bcrypt.DefaultCost,
	)

	if err != nil {
		c.JSON(500, gin.H{"error": "Error al generar hash"})
		return
	}

	usuario := models.Usuario{
		Usuario:  body.Usuario,
		Password: string(hashedPassword),
	}

	result := configs.DB.Create(&usuario)

	if result.Error != nil {
		c.JSON(500, gin.H{"error": result.Error.Error()})
		return
	}

	c.JSON(200, gin.H{
		"id":      usuario.ID,
		"usuario": usuario.Usuario,
	})
}

func Login(c *gin.Context) {

	body := LoginRequest{}

	if err := c.BindJSON(&body); err != nil {
		c.JSON(400, gin.H{"error": "Body inválido"})
		return
	}

	var usuario models.Usuario

	result := configs.DB.Where("usuario = ?", body.Usuario).First(&usuario)

	if result.Error != nil {
		c.JSON(401, gin.H{"error": "Usuario no encontrado"})
		return
	}

	err := bcrypt.CompareHashAndPassword(
		[]byte(usuario.Password),
		[]byte(body.Password),
	)

	if err != nil {
		c.JSON(401, gin.H{"error": "Contraseña incorrecta"})
		return
	}

	expirationTime := time.Now().Add(24 * time.Hour)

	claims := &Claims{
		Usuario: usuario.Usuario,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString(jwtKey)

	if err != nil {
		c.JSON(500, gin.H{"error": "Error generando token"})
		return
	}

	c.JSON(200, gin.H{
		"token": tokenString,
	})
}

func UsuarioGet(c *gin.Context) {

	var usuarios []models.Usuario

	configs.DB.Select("id", "usuario").Find(&usuarios)

	c.JSON(200, usuarios)
}

func UsuarioGetByID(c *gin.Context) {

	id := c.Param("id")

	var usuario models.Usuario

	configs.DB.Select("id", "usuario").First(&usuario, id)

	c.JSON(200, usuario)
}

func UsuarioDelete(c *gin.Context) {

	id := c.Param("id")

	var usuario models.Usuario

	configs.DB.Delete(&usuario, id)

	c.JSON(200, gin.H{"deleted": true})
}
