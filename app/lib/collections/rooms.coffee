@Rooms = new Mongo.Collection("rooms")

Rooms.schema = new SimpleSchema(
    songTitle:
        type: String

    songArtist:
        type: String

    songId:
        type: String

    songImage:
        type: String

    viewers:
        type: Number
        defaultValue: 0

    singer1:
        type: [String]
        regEx: SimpleSchema.RegEx.Id

    singer2:
        type: [String]
        regEx: SimpleSchema.RegEx.Id
        optional: true

    accepted:
        type: Boolean
        defaultValue: false

    started:
        type: Boolean
        defaultValue: false

    vote:
        type: Number
        defaultValue: 0

    nVotes:
        type: Number
        defaultValue: 0
)