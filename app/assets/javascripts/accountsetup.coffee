# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@SetupCtrl = ($scope, $resource) ->
  Facility = $resource('/facilities/:id/', {id: "@id"},
    {
      update: {method: "PUT"}
    })

  $scope.showFacility = true
  $scope.showMembership = false
  $scope.progressStyle= {width: "30%"}

  $scope.saveFacility = ->
    createdFacility = new Facility $scope.newFacility
    createdFacility.$save (createdFacility) ->
      $scope.setupMembership() if createdFacility.id?
      $scope.progressStyle= {width: "60%"}


  $scope.clearFacility = ->
    $scope.newFacility.name = ""
    $scope.newFacility.address = ""
    $scope.newFacility.phone = ""

  $scope.setupMembership = ->
    $scope.showFacility = false
    $scope.showMembership = true