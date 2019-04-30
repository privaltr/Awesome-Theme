-- Fix unpack compatibility between lua versions
unpack = unpack or table.unpack

-- Set lock 'true' to disable autostart applications
local timestamp = require("redflat.timestamp")
timestamp.lock = false

-- Select configuration file
local rc = "rc-colorless"
require(rc)
