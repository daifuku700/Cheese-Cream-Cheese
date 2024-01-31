package controller

import (
	"github.com/gin-gonic/gin"
)

func Line(c *gin.Context) {
	// err := godotenv.Load()
	// if err != nil {
	// 	log.Fatal("Error loading .env file")
	// }

	// LINE_CHANNEL_SECRET := os.Getenv("LINE_CHANNEL_SECRET")
	// LINE_CHANNEL_TOKEN := os.Getenv("LINE_CHANNEL_TOKEN")

	// bot, err := linebot.New(
	// 	LINE_CHANNEL_SECRET,
	// 	LINE_CHANNEL_TOKEN,
	// )

	c.JSON(200, gin.H{
		"message": "finished",
	})
}
