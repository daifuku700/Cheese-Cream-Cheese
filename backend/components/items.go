package components

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func GetItemList(categories map[string]bool) []Item {
	CheckItems()

	db, err := sql.Open("sqlite3", "db/ccc.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	items := []Item{}
	cmd := "UPDATE Items SET weight = weight + 2 WHERE category = $1"
	for key, value := range categories {
		if value {
			_, err = db.Exec(cmd, key)
			if err != nil {
				log.Fatal(err)
			}
		}
	}

	rows, err := db.Query("SELECT id, category, name , weight FROM Items ORDER BY weight DESC")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	cnt := 0
	for rows.Next() {
		var item Item
		err := rows.Scan(&item.ID, &item.Category, &item.Name, &item.Weight)
		if err != nil {
			log.Fatal(err)
		}
		items = append(items, item)
		cnt++
		if cnt > 5 {
			break
		}
	}
	rows.Close()

	cmd = "UPDATE Items SET weight = weight - 2 WHERE category = $1"
	for key, value := range categories {
		if value {
			_, err = db.Exec(cmd, key)
			if err != nil {
				log.Fatal(err)
			}
		}
	}

	return items
}
