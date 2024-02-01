package controller

import (
	"github.com/gin-gonic/gin"

	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"

	"ccc/components"
)

func InsertDB(c *gin.Context) {
	components.CheckItems()

	db, err := sql.Open("sqlite3", "db/ccc.db")
	if err != nil {
		log.Fatal(err)
		return
	}
	defer db.Close()

	var item components.Item

	if err := c.ShouldBindJSON(&item); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	var exist bool
	cmd := "SELECT EXISTS(SELECT * FROM Items WHERE category = $1 AND name = $2)"
	err = db.QueryRow(cmd, item.Category, item.Name).Scan(&exist)
	if err != nil {
		log.Fatal(err)
		return
	}

	if exist {
		cmd = "UPDATE Items SET weight = weight + 1 WHERE category = $1 AND name = $2"
		_, err = db.Exec(cmd, item.Category, item.Name)
		if err != nil {
			log.Fatal(err)
			return
		}
		c.JSON(200, gin.H{
			"message": "inserted item",
		})
		return
	}

	weight := item.Weight
	if weight < 0 {
		weight = 3
	}

	if item.Category == "" || item.Name == "" {
		c.JSON(400, gin.H{
			"message": "category and name must not be empty",
		})
		return
	}

	if !components.IncludeCategory(item.Category) {
		c.JSON(400, gin.H{
			"message": "category must be class, exam, party, trip, job, mtg or other",
		})
		return
	}

	cmd = "INSERT INTO Items (category, name, weight) VALUES($1, $2, $3)"
	_, err = db.Exec(cmd, item.Category, item.Name, weight)
	if err != nil {
		log.Fatal(err)
		return
	}

	c.JSON(200, gin.H{
		"message": "inserted item",
	})
}
