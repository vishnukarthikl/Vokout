@MembershipCtrl = ($scope, membershipService, $modal) ->
  $scope.refreshData = () ->
    div = $('#data')[0]
    $scope.facility_id = div.getAttribute("data-facility-id")
    membershipService.query({facility_id: $scope.facility_id}, (data) ->
      $scope.memberships = data
    )
  $scope.durationTypes = ["days", "months", "years"]
  $scope.editing = []

  $scope.refreshData()

  $scope.addNew = () ->
    $scope.showAddNew = true
    $scope.membershipForm.$setUntouched()
    $scope.newMembership = {}
    $scope.newMembership.duration_type = $scope.durationTypes[1]

  $scope.cancelAdd = () ->
    $scope.addNew()
    $scope.showAddNew = false

  $scope.updateMembership = (id, name, duration, durationType, cost, index) ->
    oldMembership = $scope.memberships[index]
    oldMembership.name = name
    oldMembership.duration = duration
    oldMembership.duration_type = durationType
    oldMembership.cost = cost

    oldMembership.$update afterMembershipUpdate(index), membershipFailureCallback(oldMembership)

  afterMembershipUpdate = (index) ->
    (membership) ->
      $scope.memberships[index] = membership
      showModalWithStatus('editMembershipStatus.html', editMembershipStatusCtrl,
        membershipStatus(membership.name + ' was successfully updated.', 'success'),
        membership
      )
      $scope.editing[index] = false

  membershipFailureCallback = (membership) ->
    (err) ->
      if err.status != 500
        reason = prettyError(err)

      status = "save failed"
      status += ": " + reason if reason
      showModalWithStatus('editMembershipStatus.html',
        editMembershipStatusCtrl,
        membershipStatus(status, 'danger'),
        membership
      )

  membershipStatus = (status, type) ->
    $scope.membershipStatus = {text: status, style: type}

  showModalWithStatus = (modalview, modalCtrl, status, membership) ->
    modalInstance = $modal.open({
      templateUrl: modalview,
      controller: modalCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        status: -> status
        membership: -> membership
    })

    modalInstance.result.then((action) ->
      if action == 'add'
        $scope.addNew()
      else if action == 'close'
        $scope.showAddNew = false
    )

  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value

  $scope.getMembershipNames = ->
    $scope.memberships.map((x)-> x.name) if $scope.memberships

  $scope.saveMembership = () ->
    membershipToSave = new membershipService $scope.newMembership
    membershipToSave.facility_id = $scope.facility_id
    membershipToSave.$save afterMembershipSave, membershipFailureCallback(membershipToSave)


  afterMembershipSave = (membership) ->
    $scope.memberships.push(membership)
    showModalWithStatus('saveMembershipStatus.html', saveMembershipStatusCtrl,
      membershipStatus(membership.name + ' was successfully added.', 'success'),
      membership
    )


editMembershipStatusCtrl = ($scope, $modalInstance, status, membership) ->
  $scope.status = status
  $scope.membership = membership

  $scope.retry = ->
    $modalInstance.dismiss('retry')

  $scope.close = ->
    $modalInstance.close('close')

saveMembershipStatusCtrl = ($scope, $modalInstance, status, membership) ->
  $scope.status = status
  $scope.membership = membership

  $scope.retry = ->
    $modalInstance.dismiss('retry')

  $scope.close = ->
    $modalInstance.close('close')

  $scope.addAnother = ->
    $modalInstance.close('add')



