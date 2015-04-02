# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@SetupCtrl = ($scope, $resource, $http, memberService) ->
  Facility = $resource('/facilities/:id/', {id: "@id"},
    {
      update: {method: "PUT"}
    })
  Membership = $resource('/facilities/:facility_id/memberships/:id/', {facility_id: "@facility_id", id: "@id"})

  $http.get('/setupstatus')
  .success (data) ->
    $scope.facility = data
    if !$scope.facility.id?
      $scope.setupFacility()
    else if $scope.facility.memberships.length is 0
      $scope.setupMembership()
    else
      $scope.setupMember()
  .error (data, status, headers, config) ->
    console.log(status)

  $scope.steps = []
  $scope.durationTypes = ["days", "months", "years"]

  $scope.setupFacility = ->
    $scope.status = "facility"
    $scope.setProgress(1)
    $scope.newFacility = {}

  $scope.saveFacility = ->
    facilityToSave = new Facility($scope.newFacility)
    facilityToSave.$save (facilityToSave) ->
      $scope.setupMembership() if facilityToSave.id?
      $scope.facility = facilityToSave
      $scope.facility.memberships = []

  $scope.setupMembership = ->
    $scope.newMembership = {}
    $scope.newMembership.duration_type=$scope.durationTypes[1]
    $scope.status = "membership"
    $scope.setProgress(2)


  $scope.saveMembership = (membershipForm) ->
    membershipToSave = new Membership $scope.newMembership
    membershipToSave.facility_id = $scope.facility.id
    membershipToSave.$save (membershipToSave) ->
      if membershipToSave.id?
        $scope.facility.memberships.push(membershipToSave)
        $scope.newMembershipStatus = membershipToSave.name + " was successfully added"
        membershipForm.$setUntouched() if membershipForm
        $scope.setupMembership()

  $scope.setProgress = (currentStep)->
    for i in [1..currentStep]
      $scope.steps[i] = "progress-bar-success done"

    for i in [currentStep..3]
      $scope.steps[i] = ""

    $scope.steps[currentStep] = "ongoing"

  $scope.setupMember = (membershipForm) ->
    $scope.saveMembership() if membershipForm and membershipForm.$valid

    $scope.newMember = {}
    $scope.newMember.subscription = {}
    $scope.newMember.subscription.start_date = moment().format('DD/MM/YYYY')
    $scope.status = "member"
    $scope.setProgress(3)


  $scope.saveMember = (memberForm) ->
    $scope.newMember.facility_id = $scope.facility.id
    MemberToSave = new memberService $scope.newMember
    MemberToSave.$save (MemberToSave) ->
      if MemberToSave.id?
        $scope.newMemberStatus = MemberToSave.name + " was successfully added"
        $scope.newMember = {}
        $scope.facility.members.push(MemberToSave)
        memberForm.$setUntouched() if memberForm


