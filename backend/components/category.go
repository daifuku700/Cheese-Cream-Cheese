package components

import (
	"strings"
)

func GetCategory(summary string) string {
	if (strings.Contains(summary, "講義") || strings.Contains(summary, "授業") || strings.Contains(summary, "ゼミ")) && strings.Contains(summary, "class") {
		return "class"
	} else if strings.Contains(summary, "試験") || strings.Contains(summary, "テスト") || strings.Contains(summary, "exam") {
		return "exam"
	} else if strings.Contains(summary, "飲み") || strings.Contains(summary, "打ち上げ") || strings.Contains(summary, "忘年会") || strings.Contains(summary, "新年会") || strings.Contains(summary, "party") {
		return "party"
	} else if strings.Contains(summary, "旅行") || strings.Contains(summary, "travel") || strings.Contains(summary, "trip") {
		return "trip"
	} else if strings.Contains(summary, "バイト") || strings.Contains(summary, "インターン") || strings.Contains(summary, "job") {
		return "job"
	} else if strings.Contains(summary, "ミーティング") || strings.Contains(summary, "mtg") || strings.Contains(summary, "meeting") || strings.Contains(summary, "mtg") {
		return "mtg"
	} else {
		return "other"
	}
}
