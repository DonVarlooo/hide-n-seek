import { Controller } from "@hotwired/stimulus"
import { Timer } from "../timer"

// Connects to data-controller="timer"
export default class extends Controller {
  static targets = ["counter"]
  static values = {
    durationInSeconds: Number
  }

  connect() {
    console.log("timer connected")
    this.timer = new Timer({
      target: this.counterTarget,
      duration: this.durationInSecondsValue
    })
    this.timer.start()
  }
}
