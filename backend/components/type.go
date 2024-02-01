package components

type Item struct {
	ID        int    `json:"id"`
	Category  string `json:"category"`
	Name      string `json:"name"`
	Weight    int    `json:"weight"`
	EventDate string `json:"event_date"`
}
