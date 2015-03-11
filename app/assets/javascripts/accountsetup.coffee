# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@SetupCtrl = ($scope, $resource, $http) ->
  Facility = $resource('/facilities/:id/', {id: "@id"},
    {
      update: {method: "PUT"}
    })
  Membership = $resource('/facilities/:facility_id/memberships/:id/', {facility_id: "@facility_id", id: "@id"})
  Customer = $resource('/facilities/:facility_id/customers/:id', {facility_id: "@facility_id", id: "@id"},
    isArray: true)

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


  $scope.setupFacility = ->
    $scope.status = "facility"
    $scope.setProgress(30)
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
    $scope.setProgress(60)


  $scope.saveMembership = ->
    membershipToSave = new Membership $scope.newMembership
    membershipToSave.facility_id = $scope.facility.id
    membershipToSave.$save (membershipToSave) ->
      if membershipToSave.id?
        $scope.facility.memberships.push(membershipToSave)
        $scope.newMembership = {}
        $scope.newMembershipStatus = membershipToSave.name + " was successfully added"

  $scope.setProgress = (percentage)->
    $scope.progressStyle = {width: percentage + "%"}

  $scope.setupCustomer = ->
    $scope.facility.customers = []
    $scope.facility.customers = Customer.query({facility_id: $scope.facility.id},
      ->,
      (err) -> console.log(err)
    )
    $scope.newCustomer = {}
    $scope.status = "customer"
    $scope.setProgress(80)


  $scope.saveCustomer = ->
    $scope.newCustomer.facility_id = $scope.facility.id
    customerToSave = new Customer $scope.newCustomer
    customerToSave.$save (customerToSave) ->
      if customerToSave.id?
        $scope.newCustomerStatus = customerToSave.name + " was successfully added"
        $scope.newCustomer = {}
        $scope.facility.customers.push(customerToSave)
