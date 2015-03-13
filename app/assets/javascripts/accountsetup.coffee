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

  $scope.setupMember = ->
    $scope.facility.members = []
    $scope.facility.members = memberService.query({facility_id: $scope.facility.id},
      (data)-> console.log(data),
      (err) -> console.log(err)
    )
    $scope.newMember = {}
    $scope.status = "member"
    $scope.setProgress(80)


  $scope.saveMember = ->
    $scope.newMember.facility_id = $scope.facility.id
    MemberToSave = new memberService $scope.newMember
    MemberToSave.$save (MemberToSave) ->
      if MemberToSave.id?
        $scope.newMemberStatus = MemberToSave.name + " was successfully added"
        $scope.newMember = {}
        $scope.facility.members.push(MemberToSave)
