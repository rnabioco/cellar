# cellar
scRNA-Seq analysis vignettes

# website  

https://rnabioco.github.io/cellar/ 


# adding content

We will use pull requests to add content to avoid clobbering the master branch. When generating new content, make branch (e.g. class4) synced with master. Then change to this branch for developing new content. 

The site is now being built as a [`distill blog`](https://rstudio.github.io/distill/). This makes it easy to add new class content as blog posts, which don't require rerendering previous Rmarkdowns. 

To make a new post, follow the [distill blog tutorial]( https://rstudio.github.io/distill/blog.html)

Essentially, run `create_post` which will create a subdirectory and template Rmarkdown in `_posts`. 

```r
library(distill)
create_post("class-1", draft = TRUE)
```

Navigate to the Rmarkdown in the `_posts` subdirectory, add content, then knit and check output html file. If the content looks ready to publish, remove `draft: True`from the header, reknit, then rebuild the site using the `Build website` button under the `Build` tab in Rstudio. `Build website` will update the classes listed in the `Classes` tab, unless `draft: True` is set. Also note that `Build website` will copy all files in the project into `_site` unless you list the files/directories to ignore in the `_site.yml`.

E.g. exclude: ["data"] 

You can preview the website by viewing the index.html in the `_site` directory. 

Once satisfied with the content, commit the content in the `_posts` directory and the changes in the `_site` directory to your branch. A pull request can then be used to merge in the content to master. 

