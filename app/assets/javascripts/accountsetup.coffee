# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@SetupCtrl = ($scope, $resource, $http, memberService) ->
  Facility = $resource('/facilities/:id/', {id: "@id"},
    {
      update: {method: "PUT"}
    })
  Membership = $resource('/facilities/:facility_id/memberships/:id/', {facility_id: "@facility_id", id: "@id"})

  $http.get('/facilities/show')
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

  resetMembership = (membershipForm)->
    resetForm(membershipForm)
    $scope.newMembership = {}
    $scope.newMembership.duration_type = $scope.durationTypes[1]

  $scope.setupMembership = ->
    resetMembership()
    $scope.status = "membership"
    $scope.setProgress(2)

  $scope.getMembershipNames = ->
    $scope.facility.memberships.map((x)-> x.name)

  afterMembershipSave = (membershipToSave, membershipForm) ->
    () ->
      if membershipToSave.id?
        $scope.facility.memberships.push(membershipToSave)
        $scope.newMembershipStatus = {text: membershipToSave.name + " added successfully, Add another or continue with setup", style: "success"}
        resetMembership(membershipForm)

  membershipSaveFailureCallback = (err) ->
    reason = err.data
    status = "save failed"
    status += " " + reason if reason
    $scope.newMembershipStatus = {text: status, style: "danger"}


  $scope.saveMembership = (membershipForm) ->
    membershipToSave = new Membership $scope.newMembership
    membershipToSave.facility_id = $scope.facility.id
    membershipToSave.$save afterMembershipSave(membershipToSave, membershipForm), membershipSaveFailureCallback

  $scope.setProgress = (currentStep)->
    for i in [1..currentStep]
      $scope.steps[i] = "progress-bar-success done"

    for i in [currentStep..3]
      $scope.steps[i] = ""

    $scope.steps[currentStep] = "ongoing"

  $scope.getMembersPhone = ->
    if $scope.facility.members
      $scope.facility.members.map((x)-> x.phone_number)
    else
      []

  $scope.setupMember = (membershipForm) ->
    $scope.saveMembership() if membershipForm and membershipForm.$valid
    resetNewMember()
    $scope.status = "member"
    $scope.setProgress(3)

  $scope.open = ($event, opened) ->
    $event.preventDefault();
    $event.stopPropagation();
    $scope[opened] = true;

  $scope.clear = () ->
    $scope.newMember.subscription.start_date = null;


  $scope.saveMember = (memberForm) ->
    $scope.newMember.facility_id = $scope.facility.id
    memberToSave = new memberService $scope.newMember
    memberToSave.$save afterMemberSave(memberToSave, memberForm), memberSaveFailureCallback

  afterMemberSave = (memberToSave, memberForm) ->
    () ->
      if memberToSave.id?
        showMemberStatus(memberToSave.name + " was successfully added. Add another or continue to dashboard", "success")
        addNewMember(memberToSave)
        resetNewMember()
        resetForm(memberForm)

  resetForm = (form) ->
    form.$setUntouched() if form

  addNewMember = (memberToSave) ->
    $scope.facility.members = [] if !$scope.facility.members
    $scope.facility.members.push(memberToSave)

  resetNewMember = ->
    $scope.newMember = {}
    $scope.newMember.subscription = {}
    $scope.newMember.subscription.start_date = moment().format('DD/MM/YYYY')

  showMemberStatus = (status, type) ->
    $scope.newMemberStatus = {text: status, style: type}

  memberSaveFailureCallback = (err) ->
    console.log(err)
    reason = prettyError(err)
    status = "save failed"
    status += ": " + reason if reason
    showMemberStatus(status, 'danger')

  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value



