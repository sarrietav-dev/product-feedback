import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["counter"];
  static values = { counter: Number };

  initialize() {
    this.counterValue = 250;
  }

  connect() {
    const textarea = this.element.querySelector("textarea");
    this.counterValue = this.counterValue - textarea.value.length;
    this.counterTarget.innerText = this.counterValue;
  }

  decrement(event) {
    console.log(this.counterTarget);
    this.counterValue = 250 - event.target.value.length;
  }

  counterValueChanged() {
    this.counterTarget.innerText = this.counterValue;
  }
}
