#!/usr/bin/env coffee
colors = require 'colors'
fs = require 'fs'
{ MongoClient, ObjectID } = require 'mongodb'

# Note the script is destructive.
# Be sure you save OUTPUT_FILE elsewhere if you wish to keep it's contents.

OUTPUT_FILE = 'beta_users.txt'
{ DB_NAME, DB_USERNAME, DB_PASSWORD, DB_HOST, DB_PORT } = process.env

fs.openSync OUTPUT_FILE, 'w'

MongoClient.connect "mongodb://#{ DB_USERNAME }:#{ DB_PASSWORD }@#{ DB_HOST }:#{ DB_PORT }/#{ DB_NAME }", (err, db) ->
  if err then throw err

  cursor = db.collection('users').find {"preferences.beta_opt_in": "true"}

  userCount = 0

  cursor.each (err, doc) ->
    if err
      console.log "Error: #{ err }".red
      process.exit 1
      return

    unless doc?
      console.log "Found and exported #{ userCount } users.".green
      process.exit 0
      return

    userCount += 1
    { email } = doc
    fs.appendFileSync OUTPUT_FILE, email + '\n'
