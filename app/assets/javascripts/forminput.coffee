@forminput = ($compile) ->
  setupDom = (element) ->
    topElement = element[0]
    input = topElement.querySelector("input, textarea, select")
    type = input.getAttribute("type")
    if type isnt "checkbox" and type isnt "radio"
      input.classList.add("form-control")

    label = topElement.querySelector("label")
    label.classList.add("control-label", "col-md-4")
    topElement.classList.add("form-group")
    name = input.name
    return name

  addMessages = (form, element, name, $compile, scope) ->
    elementAccessor = form.$name + '.' + name
    glypspan = '<span class="glyphicon glyphicon-ok-circle"></span>'
    errordiv = '<div class="help-block" ng-messages="' + elementAccessor + '.$error"
                ng-messages-include="messages.html" >
            </div>'
    message = glypspan + errordiv
    element.append($compile(message)(scope))

  watchFor = (form, name) ->
    () -> if form and form[name]
      {
      invalid: form[name].$invalid,
      touched: form[name].$touched
      value: form[name].$modelValue
      }

  updateFor = (form, name, element) ->
    (field) ->
      if field.invalid
        if field.touched
          element.removeClass("has-success").addClass("has-error")
        else
          element.removeClass("has-error").removeClass("has-success")
      else
        if field.value
          element.removeClass("has-error").addClass("has-success")
        else
          element.removeClass("has-error").removeClass("has-success")


  link = ($compile)->
    (scope, element, attributes, form) ->
      name = setupDom(element)
      addMessages(form, element, name, $compile, scope)
      scope.$watch(watchFor(form, name), updateFor(form, name, element), true)

  return {
  restrict: "A"
  require: "^form"
  link: link($compile)
  }