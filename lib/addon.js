// https://nodejs.org/api/addons.html#c-addons
// named imports are unsupported and are destructured on export
import nodeAddon from '../build/addon.node'

export const {
  hello
} = nodeAddon
