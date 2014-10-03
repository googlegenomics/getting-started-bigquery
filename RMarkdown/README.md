# Getting started in RMarkdown

1. Read the rendered version of the RMarkdown [literate-programming-demo.md](./literate-programming-demo.md)

2. Execute the code 
chunk by chunk in RStudio [literate-programming-demo.Rmd](./literate-programming-demo.Rmd)
or 
line by line in R [literate-programming-demo.R](./literate-programming-demo.R)

### Notes

[literate-programming-demo.md](./literate-programming-demo.md) was created from [literate-programming-demo.Rmd](./literate-programming-demo.Rmd) via
```
require(knitr)
knit("./literate-programming-demo.Rmd")
```

[literate-programming-demo.R](./literate-programming-demo.R) was created from [literate-programming-demo.Rmd](./literate-programming-demo.Rmd) via
```
require(knitr)
purl("./literate-programming-demo.Rmd", documentation=1)
```
