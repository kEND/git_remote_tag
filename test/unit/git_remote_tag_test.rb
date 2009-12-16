require File.join( File.dirname(__FILE__), '..', 'test_helper')

class GitRemoteTagTest < Test::Unit::TestCase
  context 'help' do
    should 'contain examples for all basic commands' do
      GitRemoteTag::COMMANDS.keys.each do |k|
        assert_match "grt #{k} tag_name", grt.get_usage
      end
    end
    
    should 'contain an example for explain' do
      assert_match 'grt explain', grt.get_usage
    end
    
    should 'contain an enumeration of all aliases' do
      GitRemoteTag::COMMANDS.each_pair do |k,v|
        assert_match "#{k}: #{v[:aliases].join(', ')}", grt.get_usage
      end
    end
  end
  
  context "the reverse mapping for aliases" do
    GitRemoteTag::COMMANDS.each_pair do |cmd, params|
      params[:aliases].each do |alias_|
        should "contain the alias #{alias_}" do
          assert GitRemoteTag::ALIAS_REVERSE_MAP[alias_]
        end
      end
    end
    
    context "upon creation" do
      should "raise an exception when there are duplicates" do
        assert_raise(RuntimeError) do
          GitRemoteTag.get_reverse_map( GitRemoteTag::COMMANDS.merge(:new_command => {:aliases => ['create']}) )
        end
      end
    end
  end
end
