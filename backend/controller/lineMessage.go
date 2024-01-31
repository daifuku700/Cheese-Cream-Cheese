package controller

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/line/line-bot-sdk-go/v8/linebot"
)

func Line(c *gin.Context) {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	LINE_CHANNEL_SECRET := os.Getenv("LINE_CHANNEL_SECRET")
	LINE_CHANNEL_TOKEN := os.Getenv("LINE_CHANNEL_TOKEN")

	bot, err := linebot.New(
		LINE_CHANNEL_SECRET,
		LINE_CHANNEL_TOKEN,
	)
	if err != nil {
		log.Fatal(err)
	}

	area, _, text, _, temp_max, temp_min_tomorrow, temp_max_tomorrow := formatWeather()

	var msg string
	if temp_max == "" {
		msg = "こんにちは！\nこの後の" + area + "の天気は" + text + "です。\n今夜の最低気温は" + temp_min_tomorrow + "℃です。\n明日の最高気温は" + temp_max_tomorrow + "℃です。"
	} else {
		msg = "おはようございます！\nこの後の" + area + "の天気は" + text + "です。\n今日の最高気温は" + temp_max + "℃です。"
	}

	message := linebot.NewTextMessage(msg)

	if _, err := bot.BroadcastMessage(message).Do(); err != nil {
		log.Fatal(err)
	}

	c.JSON(200, gin.H{
		"message": "finished",
	})
}
