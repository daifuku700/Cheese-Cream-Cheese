package controller

import (
	"ccc/components"
	"database/sql"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/mattn/go-sqlite3"
)

func ChangeWeight(c *gin.Context) {
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

	// Check if a row with the same id as item.ID exists in the database
	var count int
	err = db.QueryRow("SELECT COUNT(*) FROM Items WHERE id = $1", item.ID).Scan(&count)
	if err != nil {
		log.Fatal(err)
	}

	// Use the count variable to determine if the row exists or not
	if count == 0 {
		c.JSON(400, gin.H{
			"message": "No such item",
		})
		return
	}

	if item.Weight >= 0 {
		cmd := "UPDATE Items SET weight = $1 WHERE id = $2"
		_, err = db.Exec(cmd, item.Weight, item.ID)
		if err != nil {
			log.Fatal(err)
		}
	}
	c.JSON(200, gin.H{
		"message": "update DB",
	})
}
