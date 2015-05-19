@NewMemberCtrl = ($scope, $resource, $http, memberService, membershipService, $modal, $timeout) ->
  $scope.form = {}

  $scope.refreshData = () ->
    div = $('#data')[0]
    $scope.facility_id = div.getAttribute("data-facility-id")
    membershipService.query({facility_id: $scope.facility_id}, (data) ->
      $scope.memberships = data
      $scope.setupMember()
    )

  $scope.setupMember = () ->
    $scope.newMember = {}
    $scope.form.member.$setUntouched()
    $scope.showCustom = false
    $scope.newMember.subscription = {}
    $scope.newMember.subscription.start_date = moment().format('DD/MM/YYYY')
    $scope.newMember.is_male = "true"
    $scope.newMember.subscription.membership_id = $scope.memberships[0].id

  $scope.refreshData()

  $scope.saveMember = (memberForm) ->
    $scope.newMember.facility_id = $scope.facility_id
    memberToSave = new memberService $scope.newMember
    memberToSave.$save afterMemberSave(memberToSave), memberSaveFailureCallback

  afterMemberSave = (memberToSave) ->
    () ->
      showModalWithStatus(memberStatus(memberToSave.name + ' was successfully added.', 'success'))

  memberStatus = (status, type) ->
    $scope.newMemberStatus = {text: status, style: type}

  memberSaveFailureCallback = (err) ->
    console.log(err)
    reason = prettyError(err)
    status = "save failed"
    status += ": " + reason if reason
    showModalWithStatus(memberStatus(status, 'danger'))

  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value

  showModalWithStatus = (status) ->
    modalInstance = $modal.open({
      templateUrl: 'saveMemberStatus.html',
      controller: saveMemberStatusCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        status: -> status
    })

    modalInstance.result.then((action) ->
      if action == 'add'
        $scope.setupMember()
    )

  $scope.addCustomSubscription = () ->
    modalInstance = $modal.open({
      templateUrl: 'newCustomMembership.html',
      controller: newCustomMembershipCtrl,
      scope: $scope,
      size: 'md',
      resolve: {
        memberships: -> $scope.memberships
        facilityId: -> $scope.facility_id
      }
    })

    modalInstance.result.then((membership) ->
      $scope.customSubscription = {name: membership.name, cost: membership.cost, duration: membership.duration + " " + membership.duration_type}
      $scope.showCustom = true
      $scope.newMember.subscription.membership_id = membership.id
    )

  $scope.cancelCustom = () ->
    $scope.showCustom = false
    $scope.newMember.subscription.membership_id = $scope.memberships[0].id

saveMemberStatusCtrl = ($scope, $modalInstance, status) ->
  $scope.status = status

  $scope.retry = ->
    $modalInstance.dismiss('retry')

  $scope.addAnother = ->
    $modalInstance.close('add')

newCustomMembershipCtrl = ($scope, $modalInstance, memberships, facilityId, membershipService) ->
  $scope.form = {};
  $scope.memberships = memberships
  $scope.facilityId = facilityId
  $scope.durationTypes = ["days", "months", "years"]
  $scope.newMembership = {duration_type: $scope.durationTypes[0], temporary: true}

  $scope.getMembershipNames = ->
    $scope.memberships.map((x)-> x.name) if $scope.memberships

  $scope.cancelAdd = ->
    $modalInstance.dismiss('cancel')

  $scope.isFormValid = (form) ->
    !$.isEmptyObject(form.$error)

  $scope.saveMembership = ->
    membershipToSave = new membershipService $scope.newMembership
    membershipToSave.facility_id = $scope.facilityId
    membershipToSave.$save afterMembershipSave, membershipFailureCallback(membershipToSave)

  afterMembershipSave = (membership) ->
    $modalInstance.close(membership)

  membershipFailureCallback = (membership) ->
    (err) ->
      if err.status != 500
        reason = prettyError(err)

      saveStatus = {}
      saveStatus.text = "save failed"
      saveStatus.text += ": " + reason if reason
      saveStatus.style = "danger"
      $scope.saveStatus = saveStatus


  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value
