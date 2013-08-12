Gem::Specification.new do |spec|
  spec.name = 'peck'
  spec.version = '0.3.0'

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

  spec.files = Dir.glob("{lib}/**/*") + %w(COPYING README.md)

  spec.has_rdoc = true
  spec.extra_rdoc_files = ['COPYING']
  spec.rdoc_options << "--charset=utf-8"
end