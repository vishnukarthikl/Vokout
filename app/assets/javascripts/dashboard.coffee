# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@DashboardCtrl = ($scope, $resource, $http, memberService) ->
  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.facility = data
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.renew = (member)->
    $scope.$parent.renewModalResult(member, $scope.facility.memberships).then((renewedMember)->
      $scope.result = renewedMember.name + " was renewed successfully"
      $scope.refreshData()
    )

  $scope.extendSubscription = (member) ->
    memberService.get({facility_id: $scope.facility.id, id: member.id},
      (memberResource) ->
        $scope.$parent.extendSubscriptionWithResult(memberResource).then((extendedMember) ->
          memberIndex = $scope.facility.members.map((x) ->
            x.id
          ).indexOf(extendedMember.id)
          $scope.facility.members[memberIndex] = extendedMember

          extensionDate = extendedMember.latest_subscription.extended_till
          $scope.result = extendedMember.name + "'s subscription was extended to " + moment(extensionDate).format('D/M/YYYY')
          $scope.refreshData()
        )
    )

  $scope.getTotalActiveCustomers = (members) ->
    members.reduce((prev, curr) ->
      if !curr.inactive
        return prev + 1
      return prev
    , 0) if members

  $scope.activate = (member) ->
    memberService.get({facility_id: $scope.facility.id, id: member.id},
      (member) ->
        $scope.$parent.changeInactiveStateTo(member, false).then((member)->
          $scope.result = member.name + " was activated"
          $scope.refreshData()
        )
    )

  $scope.deactivate = (member) ->
    memberService.get({facility_id: $scope.facility.id, id: member.id},
      (member) ->
        $scope.$parent.changeInactiveStateTo(member, true).then((member)->
          $scope.result = member.name + " was deactivated"
          $scope.refreshData()
        )
    )


@DashboardOverviewCtrl = ($scope, $resource, $http) ->
  colors = ["#337ab7", "#FAA43A", "#60BD68", "#607B8B", "#DECF3F", "#E05854", "#9E9AC8", "#C0FF3E", "#FF0000",
            "#8B5A00", "#808000"]
  $scope.options = {
    segmentShowStroke: false,
    animateRotate: true,
    animateScale: false,
    percentageInnerCutout: 50,
  }

  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.showRevenueForType = 'All'
      $scope.facility = data
      $scope.revenueData = $scope.getRevenueByMonth()
      $scope.revenueSplitData = $scope.getRevenueSplit()
      $scope.splitMonths = $scope.getSplitMonths()
      $scope.revenueTypes = $scope.getAvailableRevenueTypes()
      $scope.splitMonth = $scope.splitMonths[0]
      $scope.membersAddedLost = $scope.getMembersAddedLost()
      $scope.revenueLostData = $scope.getRevenueLost()
      $scope.activeCustomerData = $scope.getActiveCustomerData()
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.refreshData()
  $scope.currentMonthRevenue = () ->
    if $scope.facility
      this_month = moment().format("MMMM YYYY")
      $scope.facility.revenues.monthly_revenue[this_month]

  generateMonths = ->
    generateAllMonths($scope.showRevenueForMonths)

  generateAllMonths = (n) ->
    [0..n].map ((i)->
      moment().subtract(i, 'month').format("MMMM YYYY")
    )

  $scope.$watch('showRevenueForMonths', () ->
    $scope.revenueData = $scope.getRevenueByMonth()
  )

  $scope.$watch('splitMonth', () ->
    $scope.revenueSplitData = $scope.getRevenueSplit()
  )

  $scope.$watch('showRevenueForType', () ->
    $scope.revenueData = $scope.getRevenueByMonth()
  )

  $scope.$watch('showAddedLostForMonths', () ->
    $scope.membersAddedLost = $scope.getMembersAddedLost()
  )

  $scope.$watch('showRevenueLostForMonths', () ->
    $scope.revenueLostData = $scope.getRevenueLost()
  )

  $scope.$watch('showActiveCustomerForMonths', () ->
    $scope.activeCustomerData = $scope.getActiveCustomerData()
  )

  $scope.getSplitMonths = () ->
    if $scope.facility
      months_with_revenue = []
      months = generateAllMonths(32)
      for month in months
        if $scope.facility.revenues.categorized_monthly[month]
          months_with_revenue.push(month)
      months_with_revenue.push("All")
      months_with_revenue

  $scope.getRevenueSplit = () ->
    if $scope.facility
      if $scope.splitMonth == "All"
        revenue_split = $scope.facility.revenues.categorized_all
      else
        revenue_split = $scope.facility.revenues.categorized_monthly[$scope.splitMonth]

      i = -1
      for own key, value of revenue_split
        i = i + 1
        {
        value: value
        label: key
        color: colors[i]
        }

  $scope.getAvailableRevenueTypes = ->
    if $scope.facility
      months = generateMonths()
      revenueTypes = new Set();
      revenueTypes.add("All")
      for month in months
        revenueThatMonth = $scope.facility.revenues.categorized_monthly[month]
        if revenueThatMonth
          for own key,value of revenueThatMonth
            revenueTypes.add(key)

      typesArray = []
      revenueTypes.forEach (x) ->
        typesArray.push(x)
      return typesArray


  monthlyRevenue = (month) ->
    $scope.facility.revenues.monthly_revenue[month]

  monthlyRevenueForType = (month, type) ->
    revenue = $scope.facility.revenues.categorized_monthly[month]
    revenue[type] if revenue

  colorCategory = d3.scale.category20()
  $scope.colorFunction = ->
    (d, i)->
      colorCategory(d);

  $scope.getRevenueByMonth = ->
    if $scope.facility
      revenueByMonth = (generateMonths().map ((month) ->
        revenueType = $scope.showRevenueForType
        if revenueType == 'All'
          revenueThatMonth = monthlyRevenue(month)
        else
          revenueThatMonth = monthlyRevenueForType(month, revenueType)
        if !revenueThatMonth
          revenueThatMonth = 0
        return {
        month: month
        value: revenueThatMonth
        }
      )).reverse()
      labels = revenueByMonth.map((r) ->
        r.month
      )
      data = revenueByMonth.map((r)->
        r.value
      )

      return [
        {
          "key": "Revenue"
          "values": d3.zip(labels, data)
        }
      ]


  membersAdded = (month) ->
    added = $scope.facility.members_stats.members_added_monthly[month]
    if added
      return added
    else
      return 0

  membersLost = (month) ->
    lost = $scope.facility.members_stats.members_lost_monthly[month]
    if lost
      return lost
    else
      return 0

  addedLostColorArray = ["#43AC6A", "#f04124"]

  $scope.addedLostColor = () ->
    (d, i) ->
      addedLostColorArray[i]

  $scope.getMembersAddedLost = ->
    if $scope.facility
      addedLostMonthly = (generateAllMonths($scope.showAddedLostForMonths).map ((month) ->
        {
        month: month
        added: membersAdded(month)
        lost: membersLost(month)
        }
      )).reverse()

      labels = addedLostMonthly.map((al) ->
        al.month
      )
      lost = addedLostMonthly.map((al)->
        al.lost
      )
      added = addedLostMonthly.map((al) ->
        al.added
      )

      return [
        {
          "key": "Added"
          "values": d3.zip(labels, added)
        },
        {
          "key": "Lost"
          "values": d3.zip(labels, lost)
        }
      ]


  lostRevenue = (month) ->
    revenueLost = $scope.facility.revenues.revenue_lost[month]
    if revenueLost
      return revenueLost
    else
      0

  $scope.getRevenueLost = () ->
    if $scope.facility
      revenueLostMonthly = (generateAllMonths($scope.showRevenueLostForMonths).map ((month) ->
        {
        month: month
        lostRevenue: lostRevenue(month)
        }
      )).reverse()

      labels = revenueLostMonthly.map((lr) ->
        lr.month
      )
      data = revenueLostMonthly.map((lr) ->
        lr.lostRevenue
      )

      datasets = [{
        label: "Lost Revenue",
        fillColor: "#f04124",
        data: data
      }]

      return {
      labels: labels
      datasets: datasets
      }

  averageMonthlyActive = (month) ->
    activeMembersCount = $scope.facility.members_stats.active_members_history[month]
    if activeMembersCount
      return activeMembersCount
    else
      0


  $scope.getActiveCustomerData = () ->
    if $scope.facility
      monthlyActive = (generateAllMonths($scope.showActiveCustomerForMonths).map ((month) ->
        {
        month: month
        count: averageMonthlyActive(month)
        }
      )).reverse()

      labels = monthlyActive.map((ma) ->
        ma.month
      )

      data = monthlyActive.map((ma) ->
        ma.count
      )

      datasets = [{
        label: "Active Customers",
        fillColor: "#43AC6A",
        strokeColor: "rgba(151,187,205,1)",
        pointColor: "rgba(151,187,205,1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(255,255,205,1)",
        data: data
      }]

      return {
      labels: labels
      datasets: datasets
      }


@DashboardMembersCtrl = ($scope, $resource, $http, $modal, $window) ->
  $scope.refreshData()