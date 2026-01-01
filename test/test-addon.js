import assert from 'assert'
import { hello } from '../lib/addon.js'

assert(hello, "undefined named import")
testName('world', 'hello world')
testName('everyone', 'hello everyone')
testName(0, 'hello 0')
testName(1, 'hello 1')
testName(-1, 'hello -1')
testName('1', 'hello 1')
testName(false, 'hello false')
testName(true, 'hello true')
testName(null, 'hello')
testName(undefined, 'hello')

function testName(name, expected) {
  const returnVal = (name == null || name == undefined) ? hello() : hello(name)
  assert.strictEqual(returnVal, expected, "Unexpected value returned")
}
