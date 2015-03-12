# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@MembersCtrl = ($scope, $resource, $http) ->

  $http.get('/setupstatus')
  .success (data) ->
    $scope.facility = data
  .error (data, status, headers, config) ->
    console.log(status)
