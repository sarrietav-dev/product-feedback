import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "button", "backdrop"];

  toggle() {
    this.buttonTarget.src = !this.menuTarget.classList.contains("hidden")
      ? this.buttonTarget.dataset.hamburgerSrc
      : this.buttonTarget.dataset.closeSrc;
    this.menuTarget.classList.toggle("hidden");
    this.backdropTarget.classList.toggle("hidden");
  }
}
