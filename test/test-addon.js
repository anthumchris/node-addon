import assert from 'assert'
import { hello } from '../lib/addon.js'

assert(hello, "undefined named import")
testName('world', 'hello world')
testName('everyone', 'hello everyone')
testName(1, 'hello 1')
testName(-1, 'hello -1')
testName('1', 'hello 1')
testName(null, 'hello')
testName(undefined, 'hello')

function testName(name, expected) {
  assert.strictEqual(name ? hello(name) : hello(), expected, "Unexpected value returned")
}

console.log("testing ✅")
