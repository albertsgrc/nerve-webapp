import '/client/app.ng.coffee'

PlayCtrl = ($scope, $stateParams, $meteor) ->
    $scope.roomId = $stateParams.id



    $scope.albert = "Albert"
    console.log "lol"

    $scope.helpers({
        rooms: -> Rooms.find({ singer2: { $exists: yes } }).fetch()
    })

    $scope.someRoom = -> $scope.rooms?.length

    roomJoined = (room) ->
        room.participants.forEach((participant, i) ->
            if i is 0
                participant.media.attach("#remote-singer1")
            else
                participant.media.attach("#remote-singer2")
        )

    $meteor.call('twillioToken', { name: 'lol' }).then(
        (token) ->
            videoClient = new Twilio.Video.Client(token)

            videoClient.connect({ to: $scope.roomId }).then(roomJoined,
                (err) ->
                    console.error 'Could not connect to Twilio'
            )
    )



app.controller('PlayCtrl', ['$scope', '$stateParams', '$meteor', PlayCtrl])