package controller

import (
	"ccc/components"
	"database/sql"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/mattn/go-sqlite3"
)

func DeleteDB(c *gin.Context) {
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

	cmd := "DELETE FROM Items WHERE id = $1"
	_, err = db.Exec(cmd, item.ID)
	if err != nil {
		log.Fatal(err)
	}

	c.JSON(200, gin.H{
		"message": "deleted item",
	})
}
