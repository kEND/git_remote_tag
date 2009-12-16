module GitRemoteTag  
  module VERSION #:nodoc:
    MAJOR    = 0
    MINOR    = 0
    TINY     = 1
    
    STRING   = [MAJOR, MINOR, TINY].join('.').freeze
  end
  
  NAME          = 'git_remote_tag'.freeze
  COMPLETE_NAME = "#{NAME} #{VERSION::STRING}".freeze  
  COMMAND_NAME  = 'grt'.freeze
  SHORT_NAME    = COMMAND_NAME
end
