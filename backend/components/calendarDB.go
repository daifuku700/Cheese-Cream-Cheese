package components

import (
	"database/sql"
	"log"
	"strconv"

	_ "github.com/mattn/go-sqlite3"
)

func InsertCalendarDB(date string, ids []int) {
	CheckCalendars()

	db, err := sql.Open("sqlite3", "db/calendar.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	cmd := "INSERT OR REPLACE INTO Calendars (date, id1, id2, id3, id4, id5, id6) VALUES ($1, $2, $3, $4, $5, $6, $7)"

	_, err = db.Exec(cmd, date, ids[0], ids[1], ids[2], ids[3], ids[4], ids[5])
	if err != nil {
		log.Fatal(err)
	}
}

func GetCalendarDB(date string) []string {
	var items []string
	CheckItems()
	CheckCalendars()

	db_calendar, err := sql.Open("sqlite3", "db/calendar.db")
	if err != nil {
		log.Fatal(err)
	}
	db_items, err := sql.Open("sqlite3", "db/ccc.db")
	if err != nil {
		log.Fatal(err)
	}

	defer db_calendar.Close()
	defer db_items.Close()

	for i := 1; i <= 6; i++ {
		var id int
		cmd := "SELECT id" + strconv.Itoa(i) + " FROM Calendars WHERE date = $1"
		err = db_calendar.QueryRow(cmd, date).Scan(&id)
		if err != nil {
			log.Fatal(err)
		}
		if (id == 0) {
			break;
		}
		var item string
		cmd = "SELECT name FROM Items WHERE id = $1"
		err = db_items.QueryRow(cmd, id).Scan(&item)
		if err != nil {
			log.Fatal(err)
		}
		items = append(items, item)
	}
	return items
}
