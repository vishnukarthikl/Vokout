@MemberCtrl = ($scope, memberService) ->
  div = $('#data')[0]
  $scope.facility_id = div.getAttribute("data-facility-id")
  $scope.member_id = div.getAttribute("data-member-id")
  memberService.get({facility_id: $scope.facility_id, id: $scope.member_id}, (data) ->
    $scope.member = data
  )


