import Vue from "vue/dist/vue.esm"
import system from "lux-design-system"
import "lux-design-system/dist/system/system.css"
import "lux-design-system/dist/system/tokens/tokens.scss"

Vue.use(system)

// create the LUX app and mount it to wrappers with class="lux"
document.addEventListener("DOMContentLoaded", () => {
  var elements = document.getElementsByClassName("lux")
  for (var i = 0; i < elements.length; i++) {
    new Vue({
      el: elements[i],
    })
  }
})