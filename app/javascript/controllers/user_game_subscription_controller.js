import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="user-game-subscription"
export default class extends Controller {
  static values = {userGameId: Number}
  static targets = ["game"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "UserGameChannel", id: this.userGameIdValue },
      { received: data => this.#updatePage(data) }
    )
  }

  #updatePage(data) {
    if (data.url) {
        window.location.href = data.url
      // window.alert('Challenged again by the other boloss, 10s to redirectiooin')
      // setTimeout(() => {
      // }, 10000);
    } else if (data.html) {
      this.gameTarget.innerHTML = data.html
    } else {
      console.warn('cable UserGameChannel didnt receive any data')
    }
  }
}

// data
// { "event": "opponent_joined", "html": "<div..." }
// { "event": "game_started", "html": "<div..." }
// { "event": "game_finished", "html": "<div..." }
// { "event": "rematch", "url": "/games/XXX" }
