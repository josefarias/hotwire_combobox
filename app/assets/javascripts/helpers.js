export function Concerns(Base, ...mixins) {
  return mixins.reduce((accumulator, current) => current(accumulator), Base)
}

export function visible(target) {
  return !(target.hidden || target.closest("[hidden]"))
}

export function wrapAroundAccess(array, index) {
  const first = 0
  const last = array.length - 1

  if (index < first) return array[last]
  if (index > last) return array[first]
  return array[index]
}

export function applyFilter(query, { matching }) {
  return (target) => {
    if (query) {
      const value = target.getAttribute(matching) || ""
      const match = value.toLowerCase().includes(query.toLowerCase())

      target.hidden = !match
    } else {
      target.hidden = false
    }
  }
}

export function cancel(event) {
  event.stopPropagation()
  event.preventDefault()
}

export function startsWith(string, substring) {
  return string.toLowerCase().startsWith(substring.toLowerCase())
}

export function nextFrame() {
  return new Promise(requestAnimationFrame)
}

export function debounce(fn, delay = 150) {
  let timeoutId = null

  return (...args) => {
    const callback = () => fn.apply(this, args)
    clearTimeout(timeoutId)
    timeoutId = setTimeout(callback, delay)
  }
}
