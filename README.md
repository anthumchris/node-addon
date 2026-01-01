This repo tests JavaScript/TypeScript [nodejs addons](https://nodejs.org/api/addons.html)/bindings to C/C++ libraries using:

1. [node-addon-api](https://github.com/nodejs/node-addon-api?tab=readme-ov-file#node-addon-api-module) ([Node-API](https://nodejs.org/api/n-api.html#node-api)) for Application Binary Interface (ABI) stability
1. make/Makefile instead of [node-gyp](https://github.com/nodejs/node-gyp) to be faster and lightweight with fewer dependencies installed
1. [`--experimental-addon-modules`](https://nodejs.org/docs/latest/api/cli.html#--experimental-addon-modules) to provide `import` syntax instead of `require()` syntax ([ECMAScript Modules (ESM) / JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) vs [CommonJS (CJS)](https://nodejs.org/api/modules.html#modules-commonjs-modules)

## Developers

1. Install `nodejs` (npm), `make`, `watchexec`, with your system's package manager, if needed
1. Run `npm install`

### Workflow tasks

Run tasks with either `make [task]` or `npm run [task]`; npm scripts mirror make targets

**Examples from the [Makefile](Makefile):**

```sh
make                # (make all)
make all            # builds project and runs tests
make dev            # developer mode, watches file changes and rebuilds/retests

make clean          # remove built files
make clean all      # clean and build/test
make build          # build without testing
make test           # test without building

# npm only
npm run npm-reset   # reset for "npm install" reinstallation tests
```
