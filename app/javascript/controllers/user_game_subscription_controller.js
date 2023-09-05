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
    console.log(`Subscribed to the chatroom with the id ${this.userGameIdValue}.`);
  }

  #updatePage(data) {
    console.log(data)
    this.gameTarget.innerHTML = data
  }
}

// data
// { "event": "opponent_joined", "html": "<div..." }
// { "event": "game_started", "html": "<div..." }
// { "event": "game_finished", "html": "<div..." }
// { "event": "rematch", "url": "/games/XXX" }

// if (data.event == "rematch") {
//   window.location = data.url
// } else {
//   this.gameTarget.innerHTML = data.html
// }
