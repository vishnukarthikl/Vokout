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

  $scope.updateMembership = (id, name, duration, durationType, cost, index) ->
    oldMembership = $scope.memberships[index]
    console.log(index)
    console.log(oldMembership)
    oldMembership.name = name
    oldMembership.duration = duration
    oldMembership.duration_type = durationType
    oldMembership.cost = cost

    oldMembership.$update afterMembershipSave(index),membershipSaveFailureCallback(oldMembership)

  afterMembershipSave = (index) ->
    (membership) ->
      $scope.memberships[index] = membership
      showModalWithStatus(membershipStatus(membership.name + ' was successfully updated.', 'success'), membership)
      $scope.editing[index] = false

  membershipSaveFailureCallback = (membership) ->
    (err) ->
      reason = prettyError(err)
      status = "save failed"
      status += ": " + reason if reason
      showModalWithStatus(membershipStatus(status, 'danger'), membership)

  membershipStatus = (status, type) ->
    $scope.membershipStatus = {text: status, style: type}

  showModalWithStatus = (status, membership) ->
    modalInstance = $modal.open({
      templateUrl: 'editMembershipStatus.html',
      controller: editMembershipStatusCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        status: -> status
        membership: -> membership
    })


  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value


editMembershipStatusCtrl = ($scope, $modalInstance, status, membership) ->
  $scope.status = status
  $scope.membership = membership

  $scope.retry = ->
    $modalInstance.dismiss('retry')

  $scope.close = ->
    $modalInstance.dismiss('close')

