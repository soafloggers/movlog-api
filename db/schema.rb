# This schema file is automatically generated by `rake db:schema`.
# It will be overwritten periodically so do not make changes.
Sequel.migration do
  change do
    create_table(:locations) do
      primary_key :id
      Integer :movie_id
      String :name, :size=>255
    end
    
    create_table(:movies) do
      primary_key :id
      String :imdb_id, :size=>255
      String :title, :size=>255
      String :poster, :size=>255
      String :rating, :size=>255
      String :awards, :size=>255
      String :runtime, :size=>255
      String :director, :size=>255
      String :actors, :size=>255
      String :plot, :size=>255
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
  end
end
