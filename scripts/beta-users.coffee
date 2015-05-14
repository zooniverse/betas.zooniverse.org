#!/usr/bin/env coffee
colors = require 'colors'
fs = require 'fs'
{ MongoClient, ObjectID } = require 'mongodb'
yaml = require 'js-yaml'

OUTPUT_FILE = '/out/beta_users.txt'

CONFIG = yaml.safeLoad fs.readFileSync '/app/config.yml'

fs.openSync OUTPUT_FILE, 'w'

MongoClient.connect "mongodb://#{ CONFIG['DB_USERNAME'] }:#{ CONFIG['DB_PASSWORD'] }@#{ CONFIG['DB_HOST'] }:#{ CONFIG['DB_PORT'] }/#{ CONFIG['DB_NAME'] }", (err, db) ->
  if err then throw err

  cursor = db.collection('users').find {"preferences.beta_opt_in": "true"}

  userCount = 0

  cursor.each (err, doc) ->
    if err
      console.error "Error: #{ err }".red
      process.exit 1
      return

    unless doc?
      console.log "Found and exported #{ userCount } users.".green
      process.exit 0
      return

    userCount += 1
    { email } = doc
    fs.appendFileSync OUTPUT_FILE, email + '\n'
