import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="user-game-subscription"
export default class extends Controller {
  static values = {userGameId: number}
  static targets = ["game"]
  connect() {
    console.log(`Subscribe to the userGame with the id ${this.userGameIdValue}.`);
  }
}
