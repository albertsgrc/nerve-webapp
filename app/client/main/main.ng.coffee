import '/client/app.ng.coffee'

MainCtrl = ($scope, $state, $window, $meteor) ->
  videoClient = null
  $meteor.call('twillioToken', { name: 'lol' }).then(
    (token) ->
      videoClient = new Twilio.Video.Client(token)
  )

  $scope.roomSelected = [];
  $scope.roomSelectedIndex = null
  $scope.roomInfo = []

  currentRoom = null

  previouslySelected = null

  $scope.filter = {
    show: false
  }

  $scope.roomsQuery = {
    filter: ''
    limit: 30
    order: '-status'
    page: 1
  }

  $scope.computePercentage = (room) ->
    if room?
      if room.nVotes > 0
        100*(room.vote + room.nVotes/2)/(room.nVotes)
      else
        50

  $scope.onRoomSelected = (room, i) ->
    for _room , i in $scope.rooms
      if room._id is _room._id
        $scope.roomSelectedIndex = i
        $scope.roomInfo[$scope.roomSelectedIndex] ?= {}
        break

    if previouslySelected?
      Rooms.update({ _id: previouslySelected._id }, { $inc: { viewers: -1 } })

    Rooms.update({ _id: room._id }, { $inc: { viewers: 1 } })

    if currentRoom?
      currentRoom.participants.forEach((participant) -> participant.media.detach())
      currentRoom.disconnect()

    previouslySelected = room

    roomJoined = (room) ->
      room.on('disconnected', ->
          room.localParticipant.media.detach();
          room.participants.forEach((participant) ->
            participant.media.detach()
          )
          currentRoom = null
          $scope.roomSelected = []
          $scope.roomSelectedIndex = null
      )

      currentRoom = room
      console.log "joined"
      i = 0


      console.log room.participants
      room.participants.forEach((participant) ->
        if i is 0
          console.log "0: #{participant}"
          participant.media.attach("#singer1")
        else
          console.log "1: #{participant}"
          participant.media.attach("#singer2")

        ++i
      )

    console.log Meteor.userId()

    videoClient.connect({ to: room._id }).then(roomJoined,
      (err) ->
        console.error 'Could not connect to Twilio'
        console.error err.toString()
        console.error err
        console.error err.message
    )


  $scope.onRoomDeselected = (room) ->
    if currentRoom?
      currentRoom.participants.forEach((participant) -> participant.media.detach())
      currentRoom.disconnect()

    Rooms.update({ _id: room._id }, { $inc: { viewers: -1 } })
    previouslySelected = null
    currentRoom = null
    $scope.roomSelectedIndex = null

  $scope.onExit = ->
    if $scope.roomSelected.length
      Rooms.update({ _id: $scope.roomSelected[0]._id }, { $inc: { viewers: -1 } })

  $scope.vote = (singer) ->
    $scope.roomInfo[$scope.roomSelectedIndex].voted = singer

    console.log singer
    if singer is 1
      Rooms.update({ _id: $scope.roomSelected[0]._id }, { $inc: { vote: 1 +  ($scope.roomInfo[$scope.roomSelectedIndex].hasVoted ? 0) } })
    else
      Rooms.update({ _id: $scope.roomSelected[0]._id }, { $inc: { vote: -(1 + ($scope.roomInfo[$scope.roomSelectedIndex].hasVoted ? 0)) } })

    unless $scope.roomInfo[$scope.roomSelectedIndex].hasVoted
      Rooms.update({ _id: $scope.roomSelected[0]._id }, { $inc: { nVotes: 1 } })

    $scope.roomInfo[$scope.roomSelectedIndex].hasVoted = yes

    console.log JSON.stringify($scope.roomInfo)

    console.log JSON.stringify($scope.roomInfo)


  $scope.streamCount = 5

  $scope.helpers({
    rooms: -> Rooms.find({ singer2: { $exists: yes }, accepted: true }).fetch()
  })

  $scope.someRoom = -> $scope.rooms?.length

  $scope.playRoom = (id) -> $state.go('play', { id })


  $window.onbeforeunload = $scope.onExit;


app.controller('MainCtrl', ['$scope', '$state', '$window', "$meteor", MainCtrl])