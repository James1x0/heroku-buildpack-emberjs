MRuby::Gem::Specification.new('buildpack') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Terence Lee'
  spec.summary = 'buildpack'
  spec.bins    = ['buildpack']

  spec.add_dependency 'mruby-docopt',            github:  'hone/mruby-docopt'
  spec.add_dependency 'mruby-env',               mgem:    'mruby-env'
  spec.add_dependency 'mruby-exit',              core:    'mruby-exit'
  spec.add_dependency 'mruby-print',             core:    'mruby-print'
  spec.add_dependency 'mruby-fileutils-simple',  github:  'hone/mruby-fileutils-simple'
  spec.add_dependency 'mruby-httprequest',       mgem:    'mruby-httprequest'
  spec.add_dependency 'mruby-io',                github:  'hone/mruby-io',               branch:  'popen_status'
  spec.add_dependency 'mruby-json',              github:  'James1x0/mruby-json'
  spec.add_dependency 'mruby-polarssl',          mgem:    'mruby-polarssl'
  spec.add_dependency 'mruby-tempfile',          mgem:    'mruby-tempfile'
  spec.add_dependency 'mruby-yaml',              github:  'jit-y/mruby-yaml'
  spec.add_test_dependency 'mruby-mtest',        mgem:    'mruby-mtest'
  spec.add_test_dependency 'mruby-stringio',     mgem:    'mruby-stringio'
end
