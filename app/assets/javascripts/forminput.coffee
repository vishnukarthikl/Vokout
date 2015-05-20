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
      touched: form[name].$touched,
      value: form[name].$viewValue
      }

  updateFor = (form, name, element) ->
    (field) ->
      if field.invalid
        if field.touched or field.value
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

@unique = () ->
  return {
  restrict: 'A',
  require: 'ngModel',
  scope: {
    items: '&'
  }
  link: (scope, elem, attr, ctrl) ->
    ctrl.$validators.unique = (modelValue, viewValue) ->
      items = scope.items()
      items.indexOf(viewValue) == -1 if items
  }

@datepicker = ($filter) ->
  return {
  restrict: "A",
  require: "ngModel",
  scope: {
    top: '&'
  }
  link: (scope, elem, attrs, ngModelCtrl) ->
    updateModel = (dateText) ->
      scope.$apply(() ->
        ngModelCtrl.$setViewValue(dateText)
      )
    if scope.top()
      zIndex = 99999
    else
      zIndex = 100
    options = {
      dateFormat: "dd/mm/yy",
      onSelect: (dateText) ->
        updateModel(dateText)
      changeYear: true
      changeMonth: true
      constrainInput: true
      beforeShow: (input) ->
        $(input).css({
          "position": "relative",
          "z-index": zIndex
        })
    }

    ngModelCtrl.$formatters.push((data) ->
      $filter('date')(data, "dd/MM/yyyy");
    )
    elem.datepicker(options)
  }

@confirmClick = () ->
  return {
  priority: -1,
  restrict: 'A',
  link: (scope, element, attrs) ->
    element.bind('click', (e) ->
      message = attrs.ngConfirmClick
      if(message && !confirm(message))
        e.stopImmediatePropagation();
        e.preventDefault();
    )
  }
