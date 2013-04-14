$:.unshift File.dirname(__FILE__) + '/lib'
require 'mater/web'

run Mater::Web
