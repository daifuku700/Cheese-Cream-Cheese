package main

import (
	"ccc/controller"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	ccc := router.Group("/ccc")
	{
		ccc.GET("/weather", controller.WeatherGet)
		ccc.POST("/weather", controller.WeatherPost)
		ccc.GET("/calendar", controller.Calender)
		ccc.GET("/logout", controller.Logout)
	}

	router.Run(":8080")
}
