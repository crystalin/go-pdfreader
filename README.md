go-pdfreader
============

Quick & Dirty copy of https://code.google.com/p/pdfreader/ to run under Go1.4

Example how to use it

```go
package main

import (
	"code.google.com/p/pdfreader"
	"flag"
	"fmt"
	"path"
)

func main() {

	fileFlag := flag.String("file", "", "File to use")
	flag.Parse()

	if *fileFlag == "" {
		return
	}

	pd := pdfread.Load(*fileFlag)
	if pd != nil {
		pg := pd.Pages()
		fmt.Printf("        %s PagesCount=%d\n\n", path.Base(*fileFlag), len(pg))
		for k := range pg {
			fmt.Printf("Page %d - MediaBox: %s\n",
				k+1, pd.Att("/MediaBox", pg[k]))
			fonts := pd.PageFonts(pg[k])
			for l := range fonts {
				fontname := pd.Dic(fonts[l])["/BaseFont"]
				fmt.Printf("  %s = \"%s\"\n",
					l, fontname[1:])
			}

		}

	}
}

```
