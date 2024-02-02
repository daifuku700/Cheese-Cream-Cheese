package controller

import (
	"ccc/components"
	"database/sql"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/mattn/go-sqlite3"
)

func UpdateDB(c *gin.Context) {
	components.CheckItems()

	db, err := sql.Open("sqlite3", "db/ccc.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	var item components.Item

	if err := c.ShouldBindJSON(&item); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	var exist bool
	err = db.QueryRow("SELECT EXISTS(SELECT * FROM Items WHERE id = $1)", item.ID).Scan(&exist)
	if err != nil {
		log.Fatal(err)
	}

	if !exist {
		c.JSON(400, gin.H{
			"message": "No such item",
		})
		return
	}

	cmd := "SELECT id, category, name, weight, event_date FROM Items Where id = $1"
	row := db.QueryRow(cmd, item.ID)
	var id int
	var category string
	var name string
	var weight int
	var eventDate string
	err = row.Scan(&id, &category, &name, &weight, &eventDate)
	if err != nil {
		log.Fatal(err)
	}

	if item.Category != "" {
		if !components.IncludeCategory(item.Category) {
			c.JSON(400, gin.H{
				"message": "category must be class, exam, party, trip, job, mtg or other",
			})
			return
		}
		category = item.Category
	}
	if item.Name != "" {
		name = item.Name
	}
	if item.Weight >= 0 {
		weight = item.Weight
	} else {
		if weight > 0 {
			weight = weight - 1
		} else {
			weight = 0
		}
	}
	if item.EventDate != "" {
		eventDate = item.EventDate
	}

	cmd = "SELECT EXISTS(SELECT * FROM Items WHERE category = $1 AND name = $2 AND event_date = $3 AND id != $4)"
	err = db.QueryRow(cmd, category, name, eventDate, id).Scan(&exist)
	if err != nil {
		log.Fatal(err)
	}
	if exist {
		c.JSON(400, gin.H{
			"message": "item already exists",
		})
		return
	}

	cmd = "UPDATE Items SET category = $1, name = $2, weight = $3, event_date = $4 WHERE id = $5"
	_, err = db.Exec(cmd, category, name, weight, eventDate, id)
	if err != nil {
		log.Fatal(err)
	}
	c.JSON(200, gin.H{
		"message": "updated item",
	})
}
