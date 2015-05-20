# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@SetupCtrl = ($scope, $resource, $http, memberService, $modal) ->
  $scope.form = {}

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

  resetMembership = ()->
    resetForm($scope.form.membership)
    $scope.newMembership = {}
    $scope.newMembership.duration_type = $scope.durationTypes[1]

  $scope.setupMembership = () ->
    resetMembership()
    $scope.status = "membership"
    $scope.setProgress(2)

  $scope.getMembershipNames = ->
    $scope.facility.memberships.map((x)-> x.name)

  afterMembershipSave = (membership) ->
    $scope.facility.memberships.push(membership)
    showModalWithStatus('saveMembershipStatus_setup.html',
      saveMembershipStatusSetupCtrl,
      saveStatus(membership.name + ' was successfully added.', 'success'))

  saveStatus = (status, type) ->
    $scope.statusMessage = {text: status, style: type}

  showModalWithStatus = (modalview, modalCtrl, statusMessage) ->
    modalInstance = $modal.open({
      templateUrl: modalview,
      controller: modalCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        statusMessage: -> statusMessage
    })

    onSuccess = (action) ->
      if action == 'member'
        $scope.setupMember()
      else if action == 'add'
        $scope.setupMembership()
    onFailure = ->
      resetForm($scope.form.membership)
      resetForm($scope.form.member)
    modalInstance.result.then(onSuccess, onFailure)


  membershipSaveFailureCallback = (err) ->
    if err.status != 500
      reasons = prettyError(err)

    status = ""
    if reasons
      for reason,i in reasons
        status += (reason + "</br>")

    showModalWithStatus('saveMembershipStatus_setup.html',
      saveMembershipStatusSetupCtrl,
      saveStatus(status, 'danger'),
    )


  $scope.saveMembership = (membershipForm) ->
    membershipToSave = new Membership $scope.newMembership
    membershipToSave.facility_id = $scope.facility.id
    membershipToSave.$save afterMembershipSave, membershipSaveFailureCallback

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

  $scope.setupMember = () ->
    resetNewMember()
    resetForm($scope.form.member)
    $scope.status = "member"
    $scope.setProgress(3)

  $scope.saveMember = (memberForm) ->
    $scope.newMember.facility_id = $scope.facility.id
    memberToSave = new memberService $scope.newMember
    memberToSave.$save afterMemberSave(memberToSave), memberSaveFailureCallback

  afterMemberSave = (member) ->
    () ->
      showModalWithStatus('saveMemberStatus.html',
        saveMemberStatusSetupCtrl,
        saveStatus(member.name + ' was successfully added.', 'success'))


  resetForm = (form) ->
    form.$setUntouched() if form

  addNewMember = (memberToSave) ->
    $scope.facility.members = [] if !$scope.facility.members
    $scope.facility.members.push(memberToSave)

  resetNewMember = ->
    $scope.newMember = {}
    $scope.newMember.subscription = {}
    $scope.newMember.subscription.start_date = moment().format('DD/MM/YYYY')
    $scope.newMember.is_male = "true"
    $scope.newMember.subscription.membership_id = $scope.facility.memberships[0].id

  showMemberStatus = (status, type) ->
    $scope.newMemberStatus = {text: status, style: type}

  memberSaveFailureCallback = (err) ->
    if err.status != 500
      reasons = prettyError(err)

    status = ""
    if reasons
      for reason,i in reasons
        status += (reason + "</br>")

    showModalWithStatus('saveMemberStatus.html',
      saveMemberStatusSetupCtrl,
      saveStatus(status, 'danger'),
    )

  prettyError = (err) ->
    for own key, value of err.data
      "(" + key + ")  " + value



saveMembershipStatusSetupCtrl = ($scope, $modalInstance, statusMessage, $sce) ->
  $scope.status = statusMessage
  $scope.status.text = $sce.trustAsHtml($scope.statusMessage.text)

  $scope.retry = ->
    $modalInstance.close('retry')

  $scope.setupMember = ->
    $modalInstance.close('member')

  $scope.addAnother = ->
    $modalInstance.close('add')


saveMemberStatusSetupCtrl = ($scope, $modalInstance, statusMessage, $sce) ->
  $scope.status = statusMessage
  $scope.status.text = $sce.trustAsHtml($scope.statusMessage.text)

  $scope.retry = ->
    $modalInstance.close('retry')

  $scope.addAnother = ->
    $modalInstance.close('member')