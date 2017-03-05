import { Meteor } from 'meteor/meteor'

@Twilio = require 'twilio'

@twilio = twilio = null

@TWILIO_CONF =
    accountSid: 'AC4b410ad7e5f27a4e08be06b891a18976'
    apiKey: 'SK22e997cd4322007232b3d8929875ba39'
    apiSecret: 'osHq23iiFZOSKjnmkduADMM1o6xmU0v3'
    configurationProfileSid: 'VS3de1c02a07b9ee2259f36d85300e7055'
    authToken: "ae184eea197ae4e7ed21b22363b52994"

setupTwilio = ->
    twilio = Twilio(TWILIO_CONF.accountSid, TWILIO_CONF.authToken)

Meteor.startup(->
    setupTwilio()

    WebApp.connectHandlers.use((req, res, next) ->
        res.setHeader('Strict-Transport-Security', 'max-age=2592000; includeSubDomains')
        return next()
    )
)
