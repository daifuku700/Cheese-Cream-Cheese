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
		ccc.POST("/updateDB", controller.InsertDB)
	}

	router.Run(":8080")
}
