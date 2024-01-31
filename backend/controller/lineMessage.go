package controller

import (
	"ccc/components"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/line/line-bot-sdk-go/v8/linebot"

	"time"
)

func Line(c *gin.Context) {
	t := time.Now()

	date := t.Format("2006-01-02")

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
		msg = "こんにちは😊\nチーズクリームチーズ🧀です。\n\nこの後の" + area + "の天気：" + text + "\n今夜の最低気温：" + temp_min_tomorrow + "℃⭐\n明日の最高気温：" + temp_max_tomorrow + "℃☀️\n\n今日持っていくべき持ち物は"
	} else {
		msg = "おはようございます😊\nチーズクリームチーズ🧀です。\n\nこの後の" + area + "の天気：" + text + "\n今日の最高気温：" + temp_max + "℃☀️\n\n今日持っていくべき持ち物💼は"
	}

	items := components.GetCalendarDB(date)

	for i := 0; i < len(items); i++ {
		msg +=  "\n・ " + items[i]
	}

	msg += "\nです。\n\n今日も一日頑張りましょう！😊"

	message := linebot.NewTextMessage(msg)

	if _, err := bot.BroadcastMessage(message).Do(); err != nil {
		log.Fatal(err)
	}

	c.JSON(200, gin.H{
		"message": "finished",
	})
}
