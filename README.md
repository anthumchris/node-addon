This repo tests integrating a [nodejs addon](https://nodejs.org/api/addons.html) using [--experimental-addon-modules](https://nodejs.org/docs/latest/api/cli.html#--experimental-addon-modules) to support ESM `import` syntax instead of CommonJS (CJS) `require()` syntax.

### Development

Install nodejs and any missing system dependencies with Homebrew, etc. Then use `dev` script to automatically rebuild/retest:

```sh
npm install
npm run dev
```
