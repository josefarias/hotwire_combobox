<p align="center">
  <img src="docs/assets/images/logo.png" height=150>
</p>

# Easy and Accessible Autocomplete for Ruby on Rails

[![CI Tests](https://github.com/josefarias/hotwire_combobox/actions/workflows/ci_tests.yml/badge.svg)](https://github.com/josefarias/hotwire_combobox/actions/workflows/ci_tests.yml) [![Gem Version](https://badge.fury.io/rb/hotwire_combobox.svg)](https://badge.fury.io/rb/hotwire_combobox)


> [!IMPORTANT]
> HotwireCombobox is at an early stage of development. It's nearing a beta release, but the API might change and bugs are expected. Please continue to use the library and report any issues in the GitHub repo.

## Installation

First, make sure [Turbo](https://github.com/hotwired/turbo-rails) and [Stimulus](https://github.com/hotwired/stimulus-rails) are configured and running properly on your app.

Then, add this line to your application's Gemfile and run `bundle install`:

```ruby
gem "hotwire_combobox"
```

Finally, configure your assets:

### Configuring JS

Before continuing, you should know whether your app is using importmaps or JS bundling in your asset pipeline.

#### Importmaps

Most apps using importmaps won't need any configuration. If things aren't working for you, read on.

In `app/javascript/controllers/index.js` you should have one of the following:

Either,

```js
import { application } from "controllers/application" // or equivalent
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)
```

Or,

```js
import { application } from "controllers/application" // or equivalent
import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"

lazyLoadControllersFrom("controllers", application)
```

Or,

```js
import { application } from "controllers/application" // or equivalent

import HwComboboxController from "controllers/hw_combobox_controller"
application.register("hw-combobox", HwComboboxController)
```

#### JS bundling (esbuild, rollup, etc)

First, install the JS portion of HotwireCombobox from npm with one of the following:

```bash
yarn add @josefarias/hotwire_combobox
```

```bash
npm install @josefarias/hotwire_combobox
```

Then, register the library's stimulus controller in `app/javascript/controllers/index.js` as follows:

```js
import { application } from "./application" // or equivalent

import HwComboboxController from "@josefarias/hotwire_combobox"
application.register("hw-combobox", HwComboboxController)
```

### Configuring CSS

This library comes with optional default styles. Follow the instructions below to include them in your app.

Read the [docs section](#Docs) for instructions on styling the combobox yourself.

#### Default

This approach works for all setups. Simply add the stylesheet to your layout (this would go in your document's `<head>`):

```erb
<%= combobox_style_tag %>
```

This helper accepts any of the options you can pass to `stylesheet_link_tag`.

#### Sprockets

Require the styles in `app/assets/stylesheets/application.css`:

```erb
*= require hotwire_combobox
```

## Docs

Visit [the docs site](https://hotwirecombobox.com/) for a demo and detailed documentation.
If the site is down, you can run the docs locally by cloning [the docs repo](https://github.com/josefarias/hotwire_combobox_docs).

## Contributing

Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
