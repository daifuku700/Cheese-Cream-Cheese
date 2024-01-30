package components

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func GetItemList(category string) []Item {
	db, err := sql.Open("sqlite3", "db/ccc.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	items := []Item{}
	cmd := "UPDATE Items SET weight = weight + 1 WHERE category = $1"
	_, err = db.Exec(cmd, category)
	if err != nil {
		log.Fatal(err)
	}

	rows, err := db.Query("SELECT id, category, name , weight FROM Items")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var item Item
		err := rows.Scan(&item.ID, &item.Category, &item.Name, &item.Weight)
		if err != nil {
			log.Fatal(err)
		}
		items = append(items, item)
	}

	cmd = "UPDATE Items SET weight = weight - 1 WHERE category = $1"
	_, err = db.Exec(cmd, category)
	if err != nil {
		log.Fatal(err)
	}
	return items
}
