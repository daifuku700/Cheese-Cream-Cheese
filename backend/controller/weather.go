package controller

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Weather []struct {
	PrecipAverage struct {
		Areas []struct {
			Area struct {
				Code string `json:"code"`
				Name string `json:"name"`
			} `json:"area"`
			Max string `json:"max"`
			Min string `json:"min"`
		} `json:"areas"`
	} `json:"precipAverage"`
	PublishingOffice string `json:"publishingOffice"`
	ReportDatetime   string `json:"reportDatetime"`
	TempAverage      struct {
		Areas []struct {
			Area struct {
				Code string `json:"code"`
				Name string `json:"name"`
			} `json:"area"`
			Max string `json:"max"`
			Min string `json:"min"`
		} `json:"areas"`
	} `json:"tempAverage"`
	TimeSeries []struct {
		Areas []struct {
			Area struct {
				Code string `json:"code"`
				Name string `json:"name"`
			} `json:"area"`
			Pops          []string `json:"pops"`
			Reliabilities []string `json:"reliabilities"`
			Temps         []string `json:"temps"`
			TempsMax      []string `json:"tempsMax"`
			TempsMaxLower []string `json:"tempsMaxLower"`
			TempsMaxUpper []string `json:"tempsMaxUpper"`
			TempsMin      []string `json:"tempsMin"`
			TempsMinLower []string `json:"tempsMinLower"`
			TempsMinUpper []string `json:"tempsMinUpper"`
			Waves         []string `json:"waves"`
			WeatherCodes  []string `json:"weatherCodes"`
			Weathers      []string `json:"weathers"`
			Winds         []string `json:"winds"`
		} `json:"areas"`
		TimeDefines []string `json:"timeDefines"`
	} `json:"timeSeries"`
}

func WeatherPost(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "error",
	})
}

func WeatherGet(c *gin.Context) {
	body, err := httpGetBody("https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json")
	if err != nil {
		fmt.Println(err)
		return
	}

	weather, err := formatWeather(body)
	if err != nil {
		return
	}

	area := (*weather)[0].TimeSeries[0].Areas[0].Area.Name
	weather_code := (*weather)[0].TimeSeries[0].Areas[0].WeatherCodes[0]
	text := (*weather)[0].TimeSeries[0].Areas[0].Weathers[0]
	temperature_min := (*weather)[0].TimeSeries[2].Areas[0].Temps[0]
	temperature_max := (*weather)[0].TimeSeries[2].Areas[0].Temps[1]

	c.JSON(200, gin.H{
		"area": area,
		"weather_code": weather_code,
		"text": text,
		"temperature_min": temperature_min,
		"temperature_max": temperature_max,
	})
}

func httpGetBody(url string) ([]byte, error) {
	res, err := http.Get(url)
	if err != nil {
		err = fmt.Errorf("Get Http Error: %s", err)
		return nil, err
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		err := fmt.Errorf("IO Read Error: %s", err)
		return nil, err
	}

	defer res.Body.Close()

	return body, nil
}

func formatWeather(body []byte) (*Weather, error) {
	weather := new(Weather)
	if err := json.Unmarshal(body, weather); err != nil {
		err := fmt.Errorf("json unmarshal error: %s", err)
		return nil, err
	}
	return weather, nil
}
