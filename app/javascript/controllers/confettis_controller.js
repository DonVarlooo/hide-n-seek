import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti";

// Connects to data-controller="confettis"
export default class extends Controller {
  static targets = ["items"]
  connect() {
    console.log("Bonjour");
    this.showerConfetti();
  }

   // Fonction pour faire apparaître des confettis
  showerConfetti() {
    const canvas = this.itemsTarget; // Élément HTML lié au contrôleur
    const myConfetti = confetti.create(canvas, {
      resize: true,
      useWorker: true
    });
    myConfetti({
      particleCount: 1000,
      spread: 160,
      origin: { y: 0 },
      shape : "star",
    });
  }

}
