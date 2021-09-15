# cellar
scRNA-Seq analysis vignettes

# website
https://rnabioco.github.io/cellar/ 


# adding content

We will use pull requests to add content to avoid clobbering the master branch. When generating new content, make branch (e.g. class4) synced with master. Then change to this branch for developing new content. 

Place new Rmarkdown file into root directory. To add a link in the navbar to the new content edit the `_site.yml` file. 

Run `rmarkdown::render_site("new_rmarkdown.Rmd")` to render the new .Rmd into `.html` which will be placed in the `docs` directory.  If you run `rmarkdown::render_site()` it will render all of the .Rmds which might not be desirable. View the resulting `.html` in the `docs/` directory.

Note that `render_site()` will copy all files in the project into `docs/` unless you follow specific naming conventions or list the files/directories to ignore in the `_site.yml`.

E.g. exclude: ["data"] 

Once satisfied with the content, commit and push the `.Rmd` and the changes in the `docs` directory to your branch. A pull request can then be used to merge in the content to master. 

