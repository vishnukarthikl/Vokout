@EditMemberCtrl = ($scope, $resource, $http, memberService, membershipService, $modal) ->
  div = $('#data')[0]
  $scope.facility_id = div.getAttribute("data-facility-id")
  $scope.member_id = div.getAttribute("data-member-id")

  memberService.get({facility_id: $scope.facility_id, id: $scope.member_id}, (data) ->
    $scope.member = data
    $scope.member.is_male = "" + $scope.member.is_male if $scope.member
  )

  membershipService.query({facility_id: $scope.facility_id}, (data) ->
    $scope.memberships = data
  )

  $scope.updateMember = ->
    $scope.member.$update afterMemberSave, memberSaveFailureCallback

  afterMemberSave = (member) ->
    showModalWithStatus(memberStatus(member.name + ' was successfully updated.', 'success'), member)

  memberStatus = (status, type) ->
    $scope.memberStatus = {text: status, style: type}

  memberSaveFailureCallback = (err) ->
    console.log(err)
    reason = prettyError(err)
    status = "save failed"
    status += ": " + reason if reason
    showModalWithStatus(memberStatus(status, 'danger'), $scope.member)

  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value

  showModalWithStatus = (status, member) ->
    modalInstance = $modal.open({
      templateUrl: 'editMemberStatus.html',
      controller: editMemberStatusCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        status: -> status
        member: -> member
    })

editMemberStatusCtrl = ($scope, $modalInstance, status, member) ->
  $scope.status = status
  $scope.member = member

  $scope.retry = ->
    $modalInstance.dismiss('retry')

