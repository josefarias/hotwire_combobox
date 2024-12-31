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

export function debounce(fn, delay = 150) {
  let timeoutId = null

  return (...args) => {
    const callback = () => fn.apply(this, args)
    clearTimeout(timeoutId)
    timeoutId = setTimeout(callback, delay)
  }
}

export function isDeleteEvent(event) {
  return event.inputType === "deleteContentBackward" || event.inputType === "deleteWordBackward"
}

export function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

export function unselectedPortion(element) {
  if (element.selectionStart === element.selectionEnd) {
    return element.value
  } else {
    return element.value.substring(0, element.selectionStart)
  }
}

export function dispatch(eventName, { target, cancelable, detail } = {}) {
  const event = new CustomEvent(eventName, {
    cancelable,
    bubbles: true,
    composed: true,
    detail
  })

  if (target && target.isConnected) {
    target.dispatchEvent(event)
  } else {
    document.documentElement.dispatchEvent(event)
  }

  return event
}

export function nextRepaint() {
  if (document.visibilityState === "hidden") {
    return nextEventLoopTick()
  } else {
    return nextAnimationFrame()
  }
}

export function nextAnimationFrame() {
  return new Promise((resolve) => requestAnimationFrame(() => resolve()))
}

export function nextEventLoopTick() {
  return new Promise((resolve) => setTimeout(() => resolve(), 0))
}

export function randomUUID() {
  const uuidPattern = "10000000-1000-4000-8000-100000000000"

  return uuidPattern.replace(/[018]/g, (match) => {
    const randomByte = crypto.getRandomValues(new Uint8Array(1))[0]
    return (match ^ (randomByte & 15) >> (match / 4)).toString(16)
  })
}
