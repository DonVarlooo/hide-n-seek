export class Timer {
  constructor(attributes) {
    this.target     = attributes.target
    this.duration   = attributes.duration * 1_000 + 450
    this.onStart    = attributes.onStart
    this.onPause    = attributes.onPause
    this.onContinue = attributes.onContinue
    this.onEnd      = attributes.onEnd
    this.precision  = attributes.precision || 50 // milliseconds | cannot be extremely precise because of drift of setInterval()
    this.metaTitle  = attributes.metaTitle || 'Komin.io'
    this.displayDuration()
  }

  start(duration = this.duration) {
    if (this.onStart) { this.onStart() }
    this.timeLeft = duration
    this.counter = setInterval(() => {
      this.timeLeft = this.timeLeft - this.precision
      this.target.innerText = this.#humanTimeString(this.timeLeft)
      /* document.title = this.#humanTimeString(this.timeLeft, false) */
      if (this.timeLeft <= 0) {
        if (this.onEnd) { this.onEnd() }
        clearInterval(this.counter)
        this.target.innerText = 'Time is over'
        /* document.title = 'Time is over' */
        setTimeout(() => {
          this.reset()
        }, 2000)
      }
    }, this.precision)
  }

  pause() {
    if (this.onPause) { this.onPause() }
    clearInterval(this.counter)
    return this.timeLeft
  }

  continue() {
    if (this.onContinue) { this.onContinue() }
    this.start(this.timeLeft)
    return this.timeLeft
  }

  lenghten(seconds) {
    this.timeLeft += seconds * 1_000
    return this.timeLeft
  }

  shorten(seconds) {
    this.timeLeft -= seconds * 1_000
    return this.timeLeft
  }

  reset() {
    this.pause()
    this.displayDuration()
  }

  displayDuration() {
    this.target.innerText = this.#humanTimeString(this.duration)
    /* document.title = this.metaTitle + ' | ' + this.#humanTimeString(this.duration, false) */
  }

  #humanTimeObject(milliseconds) {
    return {  hours:   Math.floor( milliseconds / (1000 * 60 * 60), 1),
              minutes: Math.floor((milliseconds % (1000 * 60 * 60)) / (1000 * 60)),
              seconds: Math.floor((milliseconds % (1000 * 60)) / 1000) }
  }

  #humanTimeString(milliseconds, hours = true) {
    const timeObject = this.#humanTimeObject(milliseconds)
    if (hours) {
      return `${("0" + timeObject.hours).slice (-2)}:${("0" + timeObject.minutes).slice (-2)}:${("0" + timeObject.seconds).slice (-2)}`
    } else {
      return `${("0" + timeObject.minutes).slice (-2)}:${("0" + timeObject.seconds).slice (-2)}`
    }
  }
}

// global.Timer = Timer
