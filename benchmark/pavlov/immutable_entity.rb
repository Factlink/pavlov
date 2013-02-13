require_relative '../../lib/pavlov/immutable_entity'

require 'benchmark/ips'
require 'benchmark'

class User < Pavlov::ImmutableEntity
  attributes :username, :bla, :bla2, :bla3
end

class User2
  attr_accessor :username, :bla, :bla2, :bla3
end

Benchmark.ips do |r|
  r.report("immutable create") do |times|
    user = User.new do
      self.username = times.to_s
      self.bla = 'eouaou'
      self.bla2 = 'ouaoue'
      self.bla3 = 'ouaeuao'
    end

    user = user.update do
      self.username = user.bla + user.bla2+user.bla3+user.username+times.to_s
    end
  end

  r.report("normal create") do |times|
    user2 = User2.new
    user2.username = times.to_s
    user2.bla = 'eouaou'
    user2.bla2 = 'ouaoue'
    user2.bla3 = 'ouaeuao'

    user3 = user2.dup

    user3.username = user2.bla + user2.bla2+user2.bla3+user2.username+times.to_s
  end
end
