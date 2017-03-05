import '/server/main.coffee'

Meteor.methods(
    createRoom: (roomData) ->
        result = Rooms.insert(roomData)
        { id: result }

    requestPartner: ({ roomId, partnerId }) ->
        user = Meteor.users.findOne({ _id: partnerId })
        console.log {user}

        userMakingRequest = Meteor.users.findOne({ _id: this.userId })

        console.log { userMakingRequest }
        nUpdated = Rooms.update({ _id: roomId, singer1: userMakingRequest.username }, { $set: { singer2: user.username } })

        {
            ok: nUpdated > 0,
        }


    acceptRequest: ({ roomId }) ->
        user = Meteor.users.findOne({ _id: this.userId })
        console.log {user}
        result = Rooms.update({ _id: roomId, singer2: user.username }, { $set: { accepted: yes } })

        if result is 0
            { ok: no, status: 'Request not found or not for singer2' }
        else
            { ok: yes }


    getUsers: -> Meteor.users.find({}).fetch()

    getRooms: -> Rooms.find().fetch()

    twillioToken: ({ name }) ->
        AccessToken = Twilio.AccessToken

        # Helper function to generate an access token to enable a client to use Twilio
        # Video in the browser. Grants limited permissions to use
        # Twilio back end services for NAT traversal and general "endpoint" services
        # like listening for inbound calls and initiating outbound calls.

        accessToken = new AccessToken(TWILIO_CONF.accountSid, TWILIO_CONF.apiKey, TWILIO_CONF.apiSecret)
        # Add the capabilities for conversation endpoints to this token, including
        # it's unique name. We'll use the default permission set of "listen" and
        # "invite"
        # Grant access to Conversations
        grant = new (AccessToken.ConversationsGrant)(configurationProfileSid: TWILIO_CONF.configurationProfileSid)
        accessToken.addGrant grant
        #Video capabilities
        videoGrant = new (AccessToken.VideoGrant)(configurationProfileSid: TWILIO_CONF.configurationProfileSid)
        accessToken.identity = name
        accessToken.addGrant videoGrant
        # Generate a JWT token string that will be sent to the browser and used
        # by the Conversations SDK
        token = accessToken.toJwt()

        console.log token

        token

    deleteRooms: -> Rooms.remove({})
)