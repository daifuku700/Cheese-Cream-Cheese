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

	cmd := "SELECT id, category, name, weight FROM Items Where id = $1"
	row := db.QueryRow(cmd, item.ID)
	var id int
	var category string
	var name string
	var weight int
	err = row.Scan(&id, &category, &name, &weight)
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
	}

	cmd = "UPDATE Items SET category = $1, name = $2, weight = $3 WHERE id = $4"
	_, err = db.Exec(cmd, category, name, weight, id)
	if err != nil {
		log.Fatal(err)
	}
	c.JSON(200, gin.H{
		"message": "updated item",
	})
}
