# Guide

## Building a site with Stitcher

Stitcher sites utilize a simple concept that allows PHP developers to quickly publish a structured website or blog.
**Data entries** are mapped onto **templates** and “stitched” together via a **config file**.

The goal is simple: create blazing fast websites. Stitcher will parse all your templates into static HTML pages, 
will parse and minify CSS and JavaScript, will optimize images using ``srcset`` and provides useful developer tools
to aid you in setting things up smoothly.

## Installation

When you read this guide you probably have set up the project already. If not, run

```bash
composer create-project pageon/stitcher
```

For development purposes you may run the internal PHP server and point it to the `/dev` directory.

```bash
php -S localhost:80 -t dev/
```

See »Host setup« to find out how to set up different hosts for development and production.

## File setup

### site.yml

The ``site.yml`` file, located in the ``src/site`` directory is used to stitch together data and templates. The file takes a collection of URLs and some configuration parameters.

```yaml
/:
    template: home

/guide:
    template: guide
    data:
        guide: guide.md

/examples:
    template: examples/overview
    data:
        collection: collection.yml
    adapters:
        # Enable pagination for the field `collection`, paginate per 10 entries.
        pagination:
            variable: collection
            amount: 10

/examples/{id}:
    template: examples/detail
    data:
        example: collection.yml
    adapters:
        # Enable detail pages for the variable `example`, map by the field `id`.
        collection:
            variable: example
            field: id
```

The ``template`` key is required and provides a path to the required template for this page.
The ``data`` key isn't required. It takes a collection of variable names (these will be accessible in the template as variables).
Each variable will need to be loaded. You can either provide a path to a data file (loaded from ``src/data`` by default),
or you can provide a collection with a `src` and `id` key. This approach will generate detail pages from a collection of data entries.

### Data entries

Data entries can be provided in many formats: JSON, YAML, MarkDown, image, folder, ... Examples can be found after running the `site:install` command.
A data file can either contain data of a single entry, or contain a collection of multiple entries. In the second case, when using JSON or YAML files,
An extra root key `entries` is required.

```yaml
entries:
    entry-a:
        title: Example Entry A
        intro: Lorem ipsum dolor sit amet
        body: entry-a.md
        image:
            src: img/blue.jpg
            alt: A Blue image
    entry-b:
        title: Example Entry B
        intro: This is the second entry
        body: entry-a.md
        image: img/orange.jpg

```

See the `src/data` folder files for a more thorough reference.

### Templates

In a template, all functionality of the engine is available, and all variables provided in `site.yml` are available.

```html
{extends 'index.tpl'}

{block 'content'}
    <h2>{$example.title}</h2>

    {if isset($example.image)}
        <img src="{$example.image.src}" srcset="{$example.image.srcset}" {if isset($example.image.alt)}alt="{$example.image.alt}"{/if}>
    {/if}

    {$example.body}

    <a href="/examples">Back</a>
{/block}
```

### Config

The `config.yml` file provides some configuration options, to set directory paths, image rendering config, meta config and minification options.
See the config file for more information.

## Helpers

Stitcher provides some helper functions in aid of creating fast websites.

```html
<html>
    <head>
        <title>Stitcher</title>

        {* The meta function will render config defined meta tags. *}
        {meta}

        {* Rendering a SCSS file, inline *}
        {css src='main.scss' inline=true}

        {* Loading a CSS file *}
        {css src='extra.css'}
    </head>
    <body>
        {block 'scripts'}
            {* Add inline JS *}
            {js src='main.js' inline=true}

            {* Load a JS file *}
            {js src='extra.js' inline=true}
        {/block}
    </body>
</html>
```

## Commands

Stitcher offers a command line script to run some static site actions.

Run `./stitcher` to see the list of available commands and options. Some of them are:

- `site:install`: Copy a base install example.
- `site:generate [url]`: Generate the whole site, or a specific URL from `sites.yml`.
- `site:clean [--force]`: Remove all the generated files.
- `router:list`: List all available URLs from `sites.yml`.
- `router:dispatch url`: Debug a specified URL.

## Host setup

Stitcher requires at least one virtual host, two if you'd want to use the development mode.

**Production**

```xml
<VirtualHost *:80>
    DocumentRoot "<path_to_project>/public"
    ServerName stitcher.local
    ErrorLog "<log_path>/error.log"
    CustomLog "<log_path>/access.log" common

    <Directory "<path_to_project>/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**Development**

```xml
<VirtualHost *:80>
    DocumentRoot "<path_to_project>/dev"
    ServerName dev.stitcher.local
    ErrorLog "<log_path>/error.log"
    CustomLog "<log_path>/access.log" common

    <Directory "<path_to_project>/dev">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

The development mode can be used to generate a single URL on-the-fly.

Thus enabling developers to make changes to data entries, configs or templates
and see these changes in real-time, without the need of manually generating the website again.
It's obvious that this approach takes a bit more rendering time, so web pages will be slower.
