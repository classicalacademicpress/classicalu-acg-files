# ClassicalU ACG Files

A plugin to embed Ambrose curriculum files.

## Usage

### Shortcodes

#### acg_file

##### Description

Embeds a zoomable ACG file within a page.

`[acg_file src="..." title="..." height="..." width="..."]`

##### Params

**src**

(*Required*) The link to the embedable ACG file; the link is generated from Google Docs using [Publish to the web](https://support.google.com/a/users/answer/9308870?hl=en)

**title**

(*Required*) The title of the embedable ACG file

**height**

(*Optional*) The height of the embed in pixels

*Default value: 600*

**width**

(*Optional*) The height of the embed in pixels

*Default value: 600*

## Development

1. `git clone git@github.com:classicalacademicpress/classicalu-acg-files.git`
2. `cd classicalu-acg-files`
3. `yarn install`
4. `yarn start`

## Deployment

1. `yarn run build`
2. Upload `classicalu-acg-files.zip` to Wordpress as a Plugin