@forminput = () ->
  setupDom = (element) ->
    topElement = element[0]
    input = topElement.querySelector("input, textarea, select")
    type = input.getAttribute("type")
    if type isnt "checkbox" and type isnt "radio"
      input.classList.add("form-control")

    label = topElement.querySelector("label")
    label.classList.add("control-label", "col-md-4")
    topElement.classList.add("form-group")

  link = (scope, element) ->
    setupDom(element)

  return {
  restrict: "A"
  link: link
  }