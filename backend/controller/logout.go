package controller

import (
	"github.com/gin-gonic/gin"
	"os"
)

func Logout(c *gin.Context) {
	os.Remove("token.json")
	c.JSON(200, gin.H{
		"message": "logout complete",
	})
}
