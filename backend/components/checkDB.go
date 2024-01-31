package components

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func CheckItems() {
	db, err := sql.Open("sqlite3", "db/ccc.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	cmd := "CREATE TABLE IF NOT EXISTS Items (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, category TEXT NOT NULL, name TEXT NOT NULL, weight INTEGER NOT NULL)"
	_, err = db.Exec(cmd)
	if err != nil {
		log.Fatal(err)
	}
}

func CheckCalendars() {
	db, err := sql.Open("sqlite3", "db/calendar.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	cmd := "CREATE TABLE IF NOT EXISTS Calendars (date TEXT PRIMARY KEY NOT NULL, id1 INTEGER, id2 INTEGER, id3 INTEGER, id4 INTEGER, id5 INTEGER, id6 INTEGER)"
	_, err = db.Exec(cmd)
	if err != nil {
		log.Fatal(err)
	}
}
