package controller

import (
	"github.com/gin-gonic/gin"

	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"

	"ccc/components"
)

func InsertDB(c *gin.Context) {
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

	cmd := "INSERT INTO Items (category, name, weight) VALUES($1, $2, $3)"
	_, err = db.Exec(cmd, item.Category, item.Name, item.Weight)
	if err != nil {
		log.Fatal(err)
	}

	c.JSON(200, gin.H{
		"message": "update DB",
	})
}
