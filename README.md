# Sentry Documentation

The Sentry documentation is a static site, generated by [Jekyll][jekyll].

## Getting started

You will need [Ruby][ruby], [Bundler][bundler], [Node.js][nodejs], and [Yarn] installed.

```
$ bin/server
```

This will run Bundler to install all the necessary dependencies and then run a webserver at http://localhost:4000/.

[ruby]: https://www.ruby-lang.org/
[bundler]: http://bundler.io/
[nodejs]: https://nodejs.org/
[yarn]: https://yarnpkg.com

## Layout components

While in dev mode, visit [localhost:4000/dev/components/](http://localhost:4000/dev/components/) to see the components available.

## Adding content

The Sentry documentation contains three levels of navigation hierarchy: Category, Section, and Document.

### Add a category

Add a new entry to _src/data/categories.yml_.

### Add a section

Add a new file to _src/collections/_documentation_.

### Add a document

Add the file to a folder within _src/collections/_documentation_. If creating a new section, you must also create a new section file mentioned above.
