# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@SetupCtrl = ($scope, $resource, $http) ->
  Facility = $resource('/facilities/:id/', {id: "@id"},
    {
      update: {method: "PUT"}
    })
  Membership = $resource('/facilities/:facility_id/memberships/:id/', {facility_id: "@facility_id", id: "@id"})

  $http.get('/setupstatus')
  .success (data, status, headers, config) ->
    $scope.facility = data
    if !$scope.facility.id?
      $scope.setupFacility()
    else if $scope.facility.memberships.length is 0
      $scope.setupMembership()
    else
      $scope.setupCustomer()
  .error (data, status, headers, config) ->
    console.log(status)

  $scope.setupFacility = ->
    $scope.status = "facility"
    $scope.progressStyle = {width: "30%"}
    $scope.newFacility = {}

  $scope.saveFacility = ->
    facilityToSave = new Facility($scope.newFacility)
    facilityToSave.$save (facilityToSave) ->
      $scope.setupMembership() if facilityToSave.id?
      $scope.facility = facilityToSave
      $scope.facility.memberships = []

  $scope.setupMembership = ->
    $scope.newMembership = {}
    $scope.status = "membership"
    $scope.progressStyle = {width: "60%"}


  $scope.saveMembership = ->
    membershipToSave = new Membership $scope.newMembership
    membershipToSave.facility_id = $scope.facility.id
    membershipToSave.$save (membershipToSave) ->
      if membershipToSave.id?
        $scope.facility.memberships.push(membershipToSave)
        $scope.newMembership = {}

  $scope.setupCustomer = ->
    $scope.newCustomer = {}
    $scope.status = "customer"
    $scope.progressStyle = {width: "80%"}


