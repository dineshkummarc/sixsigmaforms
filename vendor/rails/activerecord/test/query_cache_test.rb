require 'abstract_unit'
require 'fixtures/topic'
require 'fixtures/reply'
require 'fixtures/task'


class QueryCacheTest < Test::Unit::TestCase
  fixtures :tasks

  
  def test_find_queries
    assert_queries(2) {  Task.find(1); Task.find(1) }        
  end

  def test_find_queries_with_cache
    Task.cache do
      assert_queries(1) {  Task.find(1); Task.find(1) }    
    end
  end
  
  def test_find_queries_with_cache
    Task.cache do
      assert_queries(1) {  Task.find(1); Task.find(1) }    
    end
  end

  def test_cache_is_scoped_on_actual_class_only
    Task.cache do
      assert_queries(2) {  Topic.find(1); Topic.find(1) }    
    end
  end
end

uses_mocha('QueryCacheExpiryTest') do

class QueryCacheExpiryTest < Test::Unit::TestCase
  fixtures :tasks

  def test_find
    ActiveRecord::QueryCache.any_instance.expects(:clear_query_cache).times(0)
    
    Task.cache do 
      Task.find(1)
    end
  end

  def test_save
    ActiveRecord::QueryCache.any_instance.expects(:clear_query_cache).times(1)
    
    Task.cache do 
      Task.find(1).save
    end
  end

  def test_destroy
    ActiveRecord::QueryCache.any_instance.expects(:clear_query_cache).at_least_once
    
    Task.cache do 
      Task.find(1).destroy
    end
  end

  def test_create
    ActiveRecord::QueryCache.any_instance.expects(:clear_query_cache).times(1)
    
    Task.cache do 
      Task.create!
    end
  end

  def test_new_save
    ActiveRecord::QueryCache.any_instance.expects(:clear_query_cache).times(1)
    
    Task.cache do 
      Task.new.save
    end
  end
end

end