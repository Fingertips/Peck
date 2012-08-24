Gem::Specification.new do |spec|
  spec.name = 'peck'
  spec.version = '0.1.0'

  spec.author = "Manfred Stienstra"
  spec.email = "manfred@fngtps.com"

  spec.description = <<-EOF
    Concurrent spec framework.
  EOF
  spec.summary = <<-EOF
    Peck is a concurrent spec framework which inherits a lot from the fabulous
    Bacon and MacBacon. We call it a framework because it was designed to be
    used in parts and is easily extended.
  EOF

  spec.files = [
    'COPYING',
    'lib/peck/context.rb',
    'lib/peck/counter.rb',
    'lib/peck/debug.rb',
    'lib/peck/delegates.rb',
    'lib/peck/error.rb',
    'lib/peck/expectations.rb',
    'lib/peck/notifiers/base.rb',
    'lib/peck/notifiers/default.rb',
    'lib/peck/specification.rb',
    'lib/peck.rb'
  ]

  spec.has_rdoc = true
  spec.extra_rdoc_files = ['COPYING']
  spec.rdoc_options << "--charset=utf-8"
end