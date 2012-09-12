# encoding: utf-8

require 'peck'
require 'peck/delegates'
require 'peck/counter'
require 'peck/context'
require 'peck/specification'
require 'peck/expectations'
require 'peck/notifiers/default'

Peck::Notifiers::Default.use
Peck.run_at_exit