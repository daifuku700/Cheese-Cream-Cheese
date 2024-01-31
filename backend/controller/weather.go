package controller

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"

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
	area, weather_code, text, temp_min, temp_max, temp_min_tomorrow, temp_max_tomorrow := formatWeather()

	c.JSON(200, gin.H{
		"area": area,
		"weather_code": weather_code,
		"text": text,
		"temp_min": temp_min,
		"temp_max": temp_max,
		"temp_min_tomorrow": temp_min_tomorrow,
		"temp_max_tomorrow": temp_max_tomorrow,
	})
}

func httpGetBody(url string) ([]byte, error) {
	res, err := http.Get(url)
	if err != nil {
		err = fmt.Errorf("get http error: %s", err)
		return nil, err
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		err := fmt.Errorf("io read error: %s", err)
		return nil, err
	}

	defer res.Body.Close()

	return body, nil
}

func formatWeather() (string, string, string, string, string, string, string) {
	body, err := httpGetBody("https://www.jma.go.jp/bosai/forecast/data/forecast/130000.json")
	if err != nil {
		log.Fatal(err)
	}

	weather := new(Weather)
	if err := json.Unmarshal(body, weather); err != nil {
		log.Fatal(err)
	}

	area := (*weather)[1].TimeSeries[1].Areas[0].Area.Name
	weather_code := (*weather)[0].TimeSeries[0].Areas[0].WeatherCodes[0]
	text := (*weather)[0].TimeSeries[0].Areas[0].Weathers[0]
	text = strings.ReplaceAll(text, "　", "")
	temp_min := (*weather)[1].TimeSeries[1].Areas[0].TempsMin[0]
	temp_min_tomorrow := (*weather)[1].TimeSeries[1].Areas[0].TempsMin[1]
	temp_max := (*weather)[1].TimeSeries[1].Areas[0].TempsMax[0]
	temp_max_tomorrow := (*weather)[1].TimeSeries[1].Areas[0].TempsMax[1]

	return area, weather_code, text, temp_min, temp_max, temp_min_tomorrow, temp_max_tomorrow
}
