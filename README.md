This repo tests integrating [nodejs addons](https://nodejs.org/api/addons.html) using [--experimental-addon-modules](https://nodejs.org/docs/latest/api/cli.html#--experimental-addon-modules) to support [ECMAScript Modules (ESM) / JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) `import` syntax instead of [CommonJS (CJS)](https://nodejs.org/api/modules.html#modules-commonjs-modules) `require()` syntax.

### Development

Install nodejs and any missing system dependencies with Homebrew, etc. Then use `dev` script to automatically rebuild/retest:

```sh
npm install
npm run dev
```
